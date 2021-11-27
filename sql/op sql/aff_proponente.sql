-- AFFIDABILITA PROPONENTE
DROP FUNCTION IF EXISTS get_Lat;
DELIMITER $$
CREATE FUNCTION get_Lat(v VARCHAR(50), t TIMESTAMP)
RETURNS FLOAT(10,6) DETERMINISTIC
	BEGIN
		RETURN (SELECT	ts.Lat
				FROM	trackingstorico ts
				WHERE	ts.Veicolo = v
						AND ts.TimestampUscita = t);
	END$$
DELIMITER ;

DROP FUNCTION IF EXISTS get_Lon;
DELIMITER $$
CREATE FUNCTION get_Lon(v VARCHAR(50), t TIMESTAMP)
RETURNS FLOAT(10,6) DETERMINISTIC
	BEGIN
		RETURN (SELECT	ts.Long
				FROM	trackingstorico ts
				WHERE	ts.Veicolo = v
						AND ts.TimestampUscita = t);
	END$$
DELIMITER ;

	-- fine funzioni riutilizzabili 
	
DROP FUNCTION IF EXISTS get_affidabilita_prop;

DELIMITER $$
CREATE FUNCTION get_affidabilita_prop(u_id INT(11))
RETURNS DOUBLE NOT DETERMINISTIC
	BEGIN
		-- MI SERVONO NUMERO DI INFRAZIONI, VALUTAZIONI
		DECLARE nInfrazioni INT DEFAULT 0;
		DECLARE avgValutazioni DOUBLE DEFAULT 0.0;
									
		SET nInfrazioni =	(SELECT	COUNT(*)
							FROM	_rankingProponenti rp INNER JOIN 
									(SELECT 	D.*, IF(@v = D.Veicolo AND @old_tu = TO_DAYS(D.TimestampIngresso),
									get_distance(@old_lat, @old_lon, D.lat + LEAST(0, @old_lat := D.Lat), D.Long + LEAST(0, @old_lon := D.Long)) + LEAST(0, @v := D.Veicolo) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)),
									NULL + LEAST(0, @v := D.Veicolo) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)) + LEAST(0, @old_lat := D.Lat) + LEAST (0, @old_lon := D.Long)) AS kmPercorsi

									FROM	(SELECT 	*
											FROM	trackingstorico ts
											ORDER BY	ts.Veicolo, ts.TimestampIngresso ASC) AS D,
											(SELECT (@v := '')) AS N, (SELECT (@old_tu := '')) AS N1, (SELECT (@old_lat := '')) AS N2, (SELECT (@old_lon := '')) AS N3) AS D1
									ON D1.Veicolo = rp.Veicolo
                                    
									-- DISTANZA (IN KM) / Tempo di percorrenza in ore
							WHERE	D1.kmPercorsi IS NOT NULL AND
									D1.kmPercorsi/((UNIX_TIMESTAMP(D1.TimestampUscita) - UNIX_TIMESTAMP(D1.TimestampIngresso))/3600) 
									>	(SELECT t.LimiteVelocita
										FROM Tratta t
										WHERE t.Id = D1.Tratta));
		
		SET avgValutazioni =	(SELECT	IFNULL(AVG((v.Piacere + v.Persona + v.Serieta + v.Comportamento)/4), 0)
								FROM	valutazione v
								WHERE	v.UtenteValutato = u_id);		
								
		RETURN IF((avgValutazioni - 0.025*nInfrazioni) < 0,
					0.1,
					avgValutazioni - 0.025*nInfrazioni);
	END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS update_aff_prop;

DELIMITER $$
CREATE PROCEDURE update_aff_prop()
	BEGIN
		-- COSTRUISCO UNA TABELLA CONTENENTE I VEICOLI UTILIZZATI ED I PROPRIETARI
		CREATE TEMPORARY TABLE IF NOT EXISTS _rankingProponenti (
			Utente INT(11) NOT NULL,
			Veicolo VARCHAR(50) NOT NULL,
			PRIMARY KEY(Utente, Veicolo)
		)ENGINE=InnoDb DEFAULT CHARSET=latin1;

		TRUNCATE TABLE _rankingProponenti;

		INSERT INTO _rankingProponenti
			(SELECT DISTINCT v.Utente, v.Targa
			FROM	pool p INNER JOIN veicolo v
					ON p.Veicolo = v.Targa
			WHERE	DATE(p.TimestampPartenza)= DATE(NOW()))
			UNION
			(SELECT DISTINCT v1.Utente, v1.Targa
			FROM	sharing s INNER JOIN veicolo v1
					ON s.Veicolo = v1.Targa
			WHERE 	DATE(s.TimestampPartenza) = DATE(NOW()));

		-- Aggiorno l'affidabilità degli utenti finiti nella tabella
        
		UPDATE Utente u
		SET Affidabilita = get_affidabilita_prop(u.Id) 
		WHERE u.Id IN (	-- PROPONENTI GIORNATA
						SELECT DISTINCT v.Utente
						FROM	pool p INNER JOIN veicolo v
								ON p.Veicolo = v.Targa
						WHERE	DATE(p.TimestampPartenza) = DATE(NOW())
						
						UNION
						
						SELECT DISTINCT v1.Utente
						FROM	sharing s INNER JOIN veicolo v1
								ON s.Veicolo = v1.Targa
						WHERE 	DATE(s.TimestampPartenza) = DATE(NOW()));
	END$$
DELIMITER ;

DROP EVENT IF EXISTS update_affidabilita_proponente;
CREATE EVENT update_affidabilita_proponente
ON SCHEDULE EVERY 1 DAY
STARTS '2019-01-17 23:55:00'
DO
	CALL update_aff_prop();   

/*

UPDATE utente
SET Affidabilita = 0;

*/
