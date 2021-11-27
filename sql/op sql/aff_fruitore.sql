DROP FUNCTION IF EXISTS get_last_timestamp;
DELIMITER $$
CREATE FUNCTION get_last_timestamp(t DATETIME, v VARCHAR(50))
RETURNS TIMESTAMP DETERMINISTIC
	BEGIN
		RETURN 	(SELECT MIN(ts.TimestampUscita)
				FROM	trackingstorico ts
				WHERE	ts.Veicolo = v
						AND	ts.TimestampIngresso > t -- t inizio prenotazione
						AND NOT EXISTS (SELECT 	*
										FROM	trackingstorico ts1
										WHERE	ts1.Veicolo = v
											AND ts1.TimestampIngresso = ts.TimestampUscita));
	END$$
DELIMITER ;

DROP FUNCTION IF EXISTS get_affidabilita_fruit;
DELIMITER $$
CREATE FUNCTION get_affidabilita_fruit(u_id INT(11))
RETURNS DOUBLE NOT DETERMINISTIC
	BEGIN
		-- MI SERVONO NUMERO DI SINISTRI, NUMERO DI INFRAZIONI, NUMERO DI RITARDI E VALUTAZIONE MEDIA
		DECLARE nSinistri INT DEFAULT 0;
		DECLARE nInfrazioni INT DEFAULT 0;
		DECLARE nRitardi INT DEFAULT 0;
		DECLARE avgValutazioni DOUBLE DEFAULT 0.0;
		
		SET nSinistri =	(SELECT	IFNULL(COUNT(*), 0)
						FROM	coinvolgimento c
						WHERE	c.Utente = u_id);
						
		SET	avgValutazioni = 	(SELECT	IFNULL(AVG((v.Piacere + v.Persona + v.Serieta + v.Comportamento)/4), 0)
								FROM	valutazione v
								WHERE	v.UtenteValutato = u_id);
		
		SET nRitardi =	(SELECT IFNULL(COUNT(*), 0)
						FROM	prenotazione p
						WHERE	p.Utente = u_id
								AND DATE(p.Inizio) = DATE(NOW())
								AND p.Fine + INTERVAL 30 MINUTE < get_last_timestamp(p.Inizio, p.Veicolo));	
								
		SET nInfrazioni =	(SELECT IFNULL(COUNT(*), 0)
							FROM	prenotazione p INNER JOIN 
									(SELECT 	D.*, IF(@v = D.Veicolo AND @old_tu = TO_DAYS(D.TimestampIngresso),
														get_distance(@old_lat, @old_lon, D.lat + LEAST(0, @old_lat := D.Lat), D.Long + LEAST(0, @old_lon := D.Long)) + LEAST(0, @v := D.Veicolo) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)),
														NULL + LEAST(0, @v := D.Veicolo) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)) + LEAST(0, @old_lat := D.Lat) + LEAST (0, @old_lon := D.Long)) AS kmPercorsi

									FROM	(SELECT 	*
											FROM	trackingstorico ts
											ORDER BY	ts.Veicolo, ts.TimestampIngresso ASC) AS D,
											(SELECT (@v := '')) AS N, (SELECT (@old_tu := '')) AS N1, (SELECT (@old_lat := '')) AS N2, (SELECT (@old_lon := '')) AS N3) AS tt
									ON	p.Veicolo = tt.Veicolo
							WHERE	p.Stato = 'Accettata'
									AND p.Utente = u_id
									AND	(tt.TimestampIngresso >= p.Inizio
									AND tt.TimestampUscita <= get_last_timestamp(p.Inizio, p.Veicolo))
									-- TRATTE CON INFRAZIONI
									AND tt.kmPercorsi/((UNIX_TIMESTAMP(tt.TimestampUscita) - UNIX_TIMESTAMP(tt.TimestampIngresso))/3600) 
									>	(SELECT t.LimiteVelocita
										FROM Tratta t
										WHERE t.Id = tt.Tratta));
                                        
		RETURN	IF((avgValutazioni - 0.025*nInfrazioni - 0.025*nRitardi - 0.025*nSinistri) < 0,
					0.1,
					avgValutazioni - 0.025*nInfrazioni - 0.025*nRitardi - 0.025*nSinistri);
	END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS update_aff_fruit;
DELIMITER $$
CREATE PROCEDURE update_aff_fruit()
	BEGIN
	-- COSTRUISCO UNA TABELLA CONTENENTE I VEICOLI UTILIZZATI ED I FRUITORI
	-- MI SERVONO LE PRENOTAZIONI DI CAR SHARING, I PARTECIPANTI POOL E LE CHIAMATE RIDE SHARING
			
		UPDATE Utente u
		SET Affidabilita = get_affidabilita_fruit(u.Id)
		WHERE u.Id IN 	( -- FRUITORI GIORNATA
						-- FRUITORI CAR SHARING
						SELECT 	DISTINCT(p.Utente)
						FROM 	Prenotazione p
						WHERE 	p.Stato = 'Accettata'
								AND DATE(p.Inizio) = DATE(NOW())
						UNION
						-- FRUITORI POOL
						SELECT 	DISTINCT(pp.Utente)
						FROM	partecipantipool pp
						WHERE	pp.Pool IN 	(SELECT p1.Id
											FROM 	pool p1
											WHERE 	DATE(p1.TimestampPartenza) = DATE(NOW()))
						UNION
						-- FRUITORI RIDE SHARING
						SELECT 	DISTINCT(c.Utente)
						FROM	chiamata c
						WHERE	c.Sharing IN 	(SELECT s.Id
												FROM	sharing s
												WHERE 	DATE(s.TimestampPartenza) = DATE(NOW()))
						);
	END$$
DELIMITER ;

DROP EVENT IF EXISTS update_affidabilita_fruitore;
CREATE EVENT update_affidabilita_fruitore
ON SCHEDULE EVERY 1 DAY
STARTS '2019-01-17 23:55:00'
DO
	CALL update_aff_fruit();

/*
UPDATE utente
SET Affidabilita = 0;

*/