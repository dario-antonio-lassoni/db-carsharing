-- Calcola distanza tra due punti geografici
DROP FUNCTION IF EXISTS get_distance;

DELIMITER $$
CREATE FUNCTION get_distance(latA FLOAT(10,6), lonA FLOAT(10,6), latB FLOAT(10,6), lonB FLOAT(10,6))
RETURNS DOUBLE DETERMINISTIC
	BEGIN
		RETURN (6372.795477598 * ACOS(SIN(RADIANS(latA)) * SIN(RADIANS(latB)) + COS(RADIANS(latA)) * COS(RADIANS(latB)) * COS(RADIANS(lonA)-RADIANS(lonB))));
	END$$
DELIMITER ;

-- Ricerca avanzata Pool

DROP PROCEDURE IF EXISTS pool_advanced_research;

DELIMITER $$
CREATE PROCEDURE pool_advanced_research(IN fless ENUM('bassa', 'media', 'alta'), IN latA FLOAT(10,6), IN lonA FLOAT(10,6), IN latB FLOAT(10,6), IN lonB FLOAT(10,6))
	BEGIN
		-- Prendo i pool aperti
		SELECT 
			p.*
		FROM
			pool p
		WHERE
			p.TimestampChiusura > NOW()
            AND	p.Flessibilita = fless
			-- RECORD IN PERCORSO POOL CON UNA DELLE TRATTE TARGET A
				AND EXISTS( SELECT 
					pp1.*
				FROM
					percorsopool pp1
				WHERE
					pp1.Pool = p.Id
						-- TRATTE TARGET A
						AND pp1.Tratta IN (SELECT 
							t1.Id
						FROM
							tratta t1
						WHERE
							GET_DISTANCE(latA,
									lonA,
									(t1.LatInizio + t1.LatFine) / 2,
									(t1.LongInizio + t1.LongFine) / 2) < 0.5))
				-- RECORD IN PERCORSO POOL CON UNA DELLE TRATTE TARGET B
				AND EXISTS( SELECT 
					pp2.*
				FROM
					percorsopool pp2
				WHERE
					pp2.Pool = p.Id
						-- TRATTE TARGET B
						AND pp2.Tratta IN (SELECT 
							t2.Id
						FROM
							tratta t2
						WHERE
							GET_DISTANCE(latB,
									lonB,
									(t2.LatInizio + t2.LatFine) / 2,
									(t2.LongInizio + t2.LongFine) / 2) < 0.5));
	END$$
DELIMITER ;

-- LIVELLO DI COMFORT

SET GLOBAL event_scheduler = ON;
SET SQL_SAFE_UPDATES = 0;
	
DROP EVENT IF EXISTS update_comfort_level;
CREATE EVENT update_comfort_level
ON SCHEDULE EVERY 1 DAY
STARTS '2019-01-17 23:55:00'
DO
	UPDATE Veicolo v
	SET LivelloComfort = (SELECT IFNULL(AVG(o.Peso), 0)
						FROM	optionalveicolo op
								INNER JOIN optional o
                                ON op.Optional = o.Id
						WHERE op.Veicolo = v.Targa)
	WHERE v.LivelloComfort = -1;
	

	
-- AFFIDABILITA' PROPONENTE
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

DROP VIEW IF EXISTS tratte_target_prop;
CREATE OR REPLACE VIEW tratte_target_prop AS
SELECT	*
FROM	trackingstorico ts
WHERE	EXISTS	(SELECT *
					FROM	trackingstorico ts1
					WHERE 	ts1.Veicolo = ts.Veicolo
								AND	ts1.TimestampUscita = ts.TimestampIngresso);

	-- fine funzioni riutilizzabili 
		
DROP FUNCTION IF EXISTS get_affidabilita_prop;

DELIMITER $$
CREATE FUNCTION get_affidabilita_prop(u_id INT(11))
RETURNS DOUBLE NOT DETERMINISTIC
	BEGIN
		-- MI SERVONO NUMERO DI INFRAZIONI, VALUTAZIONI
		DECLARE nInfrazioni INT DEFAULT 0;
		DECLARE avgValutazioni DOUBLE DEFAULT 0.0;
									
		SET nInfrazioni =	(SELECT	IFNULL(COUNT(*), 0)
							FROM	_rankingProponenti rp INNER JOIN tratte_target_prop ttp
									ON ttp.Veicolo = rp.Veicolo
									-- DISTANZA (IN KM) / Tempo di percorrenza in ore
							WHERE	get_distance(ttp.Lat, ttp.Long, get_Lat(ttp.Veicolo, ttp.TimestampIngresso), get_Lon(ttp.Veicolo, ttp.TimestampUscita))/((UNIX_TIMESTAMP(ttp.TimestampUscita) - UNIX_TIMESTAMP(ttp.TimestampIngresso))/3600) 
									>	(SELECT t.LimiteVelocita
										FROM Tratta t
										WHERE t.Id = ttp.Tratta));
		
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
		-- COSTRUISCO UNA TABELLA CONTENENTE I VEICOLI UTILIZZATI ED I PROPONENTI
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
	
-- AFFIDABILITA FRUITORE

DROP FUNCTION IF EXISTS get_last_timestamp;
DELIMITER $$
CREATE FUNCTION get_last_timestamp(t TIMESTAMP, v VARCHAR(50))
RETURNS TIMESTAMP DETERMINISTIC
	BEGIN
		RETURN 	(SELECT MIN(ts.TimestampUscita)
				FROM	trackingstorico ts
				WHERE	ts.Veicolo = v
						AND	ts.TimestampIngresso > t
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
							FROM	prenotazione p INNER JOIN tratte_target_prop tt
									ON	p.Veicolo = tt.Veicolo
							WHERE	p.Utente = u_id
									AND	(tt.TimestampIngresso >= p.Inizio
									AND tt.TimestampUscita <= get_last_timestamp(p.Inizio, p.Veicolo))
									-- TRATTE CON INFRAZIONI
									AND get_distance(tt.Lat, tt.Long, get_Lat(tt.Veicolo, tt.TimestampIngresso), get_Lon(tt.Veicolo, tt.TimestampUscita))/((UNIX_TIMESTAMP(tt.TimestampUscita) - UNIX_TIMESTAMP(tt.TimestampIngresso))/3600) 
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
	
-- AGGIORNAMENTO RIDONDANZA AVGPERCORRENZA
/*	RECUPERO I TRAGITTI DEL TRACKING STORICO GIORNALIERI
	CON UNA LAG CALCOLO LA DISTANZA PERCORSA SU OGNI TRATTA */
-- RAGGRUPPO PER TRATTA E CALCOLO UNA MEDIA PESATA, TENENDO CONTO DELLA MEDIA GIA CALCOLATA

DROP PROCEDURE IF EXISTS update_avg_percorrenza;

DELIMITER $$
CREATE PROCEDURE update_avg_percorrenza()
	BEGIN
	
		DECLARE finito TINYINT DEFAULT 0;
		DECLARE t_curr INT(11) DEFAULT 0;
		DECLARE x_curr DOUBLE DEFAULT 0.0;
		DECLARE p_curr	DOUBLE DEFAULT 0.0;
		
		/*	RECUPERO I TRAGITTI DEL TRACKING STORICO GIORNALIERI E
			CON UNA LAG CALCOLO LA DISTANZA PERCORSA SU OGNI TRATTA */
		-- RAGGRUPPO PER TRATTA E CALCOLO I FATTORI CHE MI SERVONO PER LA MEDIA PONDERATA, SULLA BASE DEI KM PERCORSI
		DECLARE tratte_target CURSOR FOR
		SELECT	D1.Tratta, SUM(kmPercorsi*(UNIX_TIMESTAMP(D1.TimestampUscita) - UNIX_TIMESTAMP(D1.TimestampIngresso))) AS x, SUM(D1.kmPercorsi) AS peso
		FROM	(SELECT 	D.*, IF(@v = D.Veicolo AND @old_tu = TO_DAYS(D.TimestampIngresso),
									get_distance(@old_lat, @old_lon, D.lat + LEAST(0, @old_lat := D.Lat), D.Long + LEAST(0, @old_lon := D.Long)) + LEAST(0, @v := D.Veicolo) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)),
									NULL + LEAST(0, @v := D.Veicolo) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)) + LEAST(0, @old_lat := D.Lat) + LEAST (0, @old_lon := D.Long)) AS kmPercorsi

				FROM	(SELECT 	*
						FROM	trackingstorico ts
						WHERE	ts.TimestampIngresso >= NOW() - INTERVAL 1 DAY
						ORDER BY	ts.Veicolo, ts.TimestampIngresso ASC) AS D,
						(SELECT (@v := '')) AS N, (SELECT (@old_tu := '')) AS N1, (SELECT (@old_lat := '')) AS N2, (SELECT (@old_lon := '')) AS N3) AS D1
		WHERE	D1.kmPercorsi IS NOT NULL
		GROUP BY	D1.Tratta;
		
		DECLARE CONTINUE HANDLER
			FOR NOT FOUND SET finito = 1;
		
		OPEN tratte_target;
		
		preleva: LOOP
			FETCH tratte_target INTO t_curr, x_curr, p_curr;
			IF finito = 1 THEN
				LEAVE preleva;
			END IF;
			
			UPDATE	tratta t
			SET		t.avgPercorrenza = ((t.avgPercorrenza*t.nPercorsi) + x_curr)/(t.nPercorsi + p_curr),
					t.nPercorsi = t.nPercorsi + p_curr
			WHERE	Id = t_curr;
		END LOOP preleva;
		CLOSE tratte_target;
		
	END$$
	
DELIMITER ;

DROP EVENT IF EXISTS update_avg_percorrenza;
CREATE EVENT update_avg_percorrenza
ON SCHEDULE EVERY 1 DAY
STARTS '2019-01-17 23:55:00'
DO
	CALL update_avg_percorrenza();
	
-- TRACKING ATTUALE E STORICO

-- Funzione che inserisce il nuovo record e aggiorna il vecchio se esiste. 
DROP PROCEDURE IF EXISTS insert_new_track;

DELIMITER $$
CREATE PROCEDURE insert_new_track(IN v VARCHAR(50), IN id_tratta INT(11), IN lat FLOAT(10,6), IN lon FLOAT(10,6),IN old_time TIMESTAMP, OUT t_percorrenza DOUBLE, OUT c_time TIMESTAMP)
	BEGIN
		SET c_time = CURRENT_TIMESTAMP;
		
		-- INSERISCO IL NUOVO RECORD
		INSERT
		INTO	trackingattuale
		VALUES	(v, c_time, NULL, lat, lon, id_tratta);
		
		-- AGGIORNO IL VECCHIO RECORD (SE ESISTE)
		IF (old_time IS NOT NULL) THEN
			SET SQL_SAFE_UPDATES = 0;
			UPDATE	trackingattuale 
			SET TimestampUscita = c_time
			WHERE	Veicolo = v
					AND TimestampIngresso = old_time;
		END IF;
		
		-- RESTITUISCO IL TEMPO MEDIO DI PERCORRENZA SULLA NUOVA TRATTA
		SET t_percorrenza = (SELECT t.avgPercorrenza
							FROM tratta t
							WHERE t.Id = id_tratta);
	END$$
DELIMITER ;

-- Funzione che aggiorna il record attuale
DROP PROCEDURE IF EXISTS update_track;

DELIMITER $$
CREATE PROCEDURE update_track(IN v VARCHAR(50), IN id_tratta INT(11), IN timestamp_ingresso TIMESTAMP, IN lat FLOAT(10, 6), IN lon FLOAT(10,6), IN t_percorrenza DOUBLE)
	BEGIN
		DECLARE crit TINYINT DEFAULT 0;
		
		-- Rilevamento criticità
		-- Controllo se è stata registrata una criticità su questa tratta nell'ultima ora (se è disponibile un tempo medio di percorrenza)
		IF(t_percorrenza > 0) THEN
			SET crit = (SELECT	IFNULL(COUNT(*), 0)
						FROM	criticita c
						WHERE	c.Tratta = id_tratta
								AND	c.Timestamp >= NOW() - INTERVAL 1 HOUR);
								
			IF crit = 0 THEN
				-- Se rilevo un ritardo corposo (1 minuto), lo segnalo
				
				IF((UNIX_TIMESTAMP(CURRENT_TIMESTAMP) - UNIX_TIMESTAMP(timestamp_ingresso)) > t_percorrenza + 60) THEN
					INSERT INTO criticita
					(Tratta, Timestamp)
					VALUES (id_tratta, CURRENT_TIMESTAMP);
				END IF;
			END IF;
		END IF;
		
		-- Aggiorno il record attuale
		UPDATE 	trackingattuale ta
		SET		ta.TimestampUscita = CURRENT_TIMESTAMP,
				ta.Lat = lat,
				ta.Long = lon
		WHERE	ta.Veicolo = v
				AND ta.TimestampIngresso = timestamp_ingresso;	
	END$$
DELIMITER ;

-- SPOSTAMENTO IN TRACKING STORICO
DROP TRIGGER IF EXISTS move_track_storico;

DELIMITER $$
CREATE TRIGGER move_track_storico AFTER DELETE ON trackingattuale
FOR EACH ROW
	BEGIN
		INSERT INTO trackingstorico
		VALUES (OLD.Veicolo, OLD.TimestampIngresso, OLD.TimestampUscita, OLD.Lat, OLD.Long, OLD.Tratta);
	END$$
DELIMITER ;

-- Funzione che chiude il tracking in corso
DROP PROCEDURE IF EXISTS close_track;

DELIMITER $$
CREATE PROCEDURE close_track(IN v VARCHAR(50), IN id_tratta INT(11), IN timestamp_ingresso TIMESTAMP, IN lat FLOAT(10,6), IN lon FLOAT(10,6))
	BEGIN
		-- Aggiorno l'ultimo record
		UPDATE trackingattuale ta
		SET	ta.Lat = lat,
			ta.Long = lon,
			ta.TimestampUscita = CURRENT_TIMESTAMP
		WHERE
			ta.Veicolo = v
			AND	ta.TimestampIngresso = timestamp_ingresso;
			
		-- ELIMINO I RECORD DAL TRACKING ATTUALE, IL TRIGGER LI RICOPIA NELLO STORICO
		DELETE
		FROM	trackingattuale
		WHERE	Veicolo = v;
	END$$
DELIMITER ;

-- CALCOLO SPESA POOL

DROP PROCEDURE IF EXISTS get_spesa_pool;

DELIMITER $$
CREATE PROCEDURE get_spesa_pool(IN id_pool INT(11))
	BEGIN
		DECLARE nVariazioni INT DEFAULT 0;
		DECLARE nFruitori INT DEFAULT 0;
		DECLARE kmPercorsi DOUBLE DEFAULT 0.0;
		DECLARE costoVar DOUBLE;
        DECLARE v_pool VARCHAR(50);
		
		SET v_pool		=	(SELECT p.Veicolo
							FROM 	pool p
							WHERE	p.Id = id_pool);
		SET costoVar 	= 	(SELECT	p1.CostoVariazione
							FROM	pool p1
							WHERE	p1.Id = id_pool);
		SET nVariazioni = 	(SELECT IFNULL(COUNT(*), 0)
							FROM 	variazione v
							WHERE 	v.Pool = id_pool);
		SET nFruitori 	= 	(SELECT IFNULL(COUNT(*), 0)
							FROM	partecipantipool pp
							WHERE	pp.Pool = id_pool);
		SET kmPercorsi 	=	(SELECT SUM(D1.kmPercorsi)
							FROM	(SELECT 	D.*, IF(@old_tu = TO_DAYS(D.TimestampIngresso),
													get_distance(@old_lat, @old_lon, D.lat + LEAST(0, @old_lat := D.Lat), D.Long + LEAST(0, @old_lon := D.Long)) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)),
													NULL + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)) + LEAST(0, @old_lat := D.Lat) + LEAST (0, @old_lon := D.Long)) AS kmPercorsi

									FROM	(SELECT 	*
											FROM	trackingattuale ta
											WHERE	ta.Veicolo = v_pool
											ORDER BY	ta.TimestampIngresso ASC) AS D,
											(SELECT	(@old_tu := '')) AS N,
											(SELECT (@old_lat := '')) AS N1,
											(SELECT (@old_lon := '')) AS N2) AS D1);
											
		-- Si potrebbe calcolare la spesa in base al costo del carburante, al tipo di alimentazione e al consumo.
		-- Per semplicità, si considera una spesa di 0.1 euro per km percorso ed un incremento di 0.05 euro al km per ogni fruitore.
		
		UPDATE	pool
		SET		Costo = ROUND((costoVar*nVariazioni + 0.05*nFruitori*kmPercorsi + 0.1*kmPercorsi), 2)
		WHERE	Id = id_pool;
	END$$
DELIMITER ;
-- ACCESSO UTENTE
DROP PROCEDURE IF EXISTS user_login_validation;

DELIMITER $$
CREATE PROCEDURE user_login_validation(IN u_name VARCHAR(50), IN u_password VARCHAR(50), OUT success BOOLEAN)
	BEGIN	
		DECLARE u_exists TINYINT DEFAULT 0;
		DECLARE	pass VARCHAR(64);
		
		-- Controllo se l'utente esiste
		SET success = FALSE;
		SET u_exists = (SELECT 	IFNULL(COUNT(*), 0)
						FROM	utente u
						WHERE	u.Nome = u_name);
				
		IF (u_exists <> 0) THEN
			-- Controllo se la password è corretta
			SET pass = 	(SELECT u.Password
						FROM 	utente u
						WHERE	u.Nome = u_name);
						
			IF (u_password = pass)	THEN
				SET success = TRUE;
			END IF;
		END IF;
	END$$
DELIMITER ;

-- PRENOTAZIONE VEICOLO
DROP PROCEDURE IF EXISTS insert_carsharing_reservation;

DELIMITER $$
CREATE PROCEDURE insert_carsharing_reservation(IN r_start DATETIME, IN r_end DATETIME, IN r_user INT(11), IN r_car VARCHAR(50), OUT success BOOLEAN)
	BEGIN
		DECLARE dateValidity TINYINT DEFAULT 0;
		
		SET success = FALSE;
		-- Controllo la disponibilità
		SET dateValidity = (SELECT 	IFNULL(COUNT(*), 0)
							FROM	prenotazione p
							WHERE	p.Stato = 'Accettata'
									AND (r_start BETWEEN p.Inizio AND p.Fine
										OR r_end BETWEEN	p.Inizio AND p.Fine
										OR	p.Inizio BETWEEN r_start AND r_end
										));
		IF(dateValidity = 0) THEN
			-- Controllo la fruibilita
			SET dateValidity = (SELECT 	IFNULL(COUNT(*), 0)
								FROM	fruibilita f
								WHERE	f.veicolo = r_car
										AND	(DAY(r_start) = DAY(f.TimestampInizio)
											AND
											DATE_FORMAT(f.TimestampInizio, '%T') <= DATE_FORMAT(r_start, '%T')
											AND DATE_FORMAT(f.TimestampFine, '%T') >= DATE_FORMAT(r_end, '%T')));
			
			
			IF(dateValidity <> 0) THEN
				-- Ci sono i presupposti per inserire la prenotazione
				INSERT INTO prenotazione
				(Inizio, Fine, Utente, Veicolo)
				VALUES (r_start, r_end, r_user, r_car);
				
				SET success = TRUE;
			END IF;
		END IF;
	END$$
DELIMITER ;

-- CREAZIONE POOL
DROP PROCEDURE IF EXISTS create_pool;

DELIMITER $$
CREATE PROCEDURE create_pool(IN p_car VARCHAR(50), IN p_start DATETIME, IN p_end DATETIME, IN p_close DATETIME, IN p_indirizzo_start VARCHAR(255), IN p_indirizzo_end VARCHAR(255), IN p_flessibilita ENUM('bassa', 'media', 'alta'), IN p_var_cost DOUBLE)
	BEGIN
		INSERT INTO pool
		(Veicolo, TimestampPartenza, TimestampArrivo, TimestampChiusura, IndirizzoPartenza, IndirizzoArrivo, Flessibilita, CostoVariazione)
		VALUES (p_car, p_start, p_end, p_close, p_indirizzo_start, p_indirizzo_end, p_flessibilita, p_var_cost);
	END$$
DELIMITER ;

-- INSERIMENTO PERCORSO POOL
DROP PROCEDURE IF EXISTS insert_pool_track;

DELIMITER $$
CREATE PROCEDURE insert_pool_track(IN p_id INT(11), track INT(11))
	BEGIN
		INSERT INTO percorsopool (Pool, Tratta)
		VALUES (p_id, p_track);
	END$$
DELIMITER ;

-- CREAZIONE SHARING
DROP PROCEDURE IF EXISTS insert_ridesharing;

DELIMITER $$
CREATE PROCEDURE insert_ridesharing(IN sh_v VARCHAR(50), IN sh_start DATETIME, IN sh_ind_start VARCHAR(255), IN sh_ind_end VARCHAR(255))
	BEGIN
		INSERT INTO sharing (Veicolo, TimestampPartenza, IndirizzoPartenza, IndirizzoArrivo)
		VALUES (sh_v, sh_start, sh_ind_start, sh_ind_end);
	END$$
DELIMITER ;

-- INSERIMENTO PERCORSO SHARING
DROP PROCEDURE IF EXISTS insert_ridesharing_track;

DELIMITER $$
CREATE PROCEDURE insert_ridesharing_track(IN sh_id INT(11), track INT(11))
	BEGIN
		INSERT INTO percorsoridesharing (Pool, Tratta)
		VALUES (sh_id, sh_track);
	END$$
DELIMITER ;

-- INSERIMENTO CHIAMATA
DROP PROCEDURE IF EXISTS insert_ridesharing_call;

DELIMITER $$
CREATE PROCEDURE insert_ridesharing_call(IN sh_id INT(11), IN u_id INT(11), IN pos_act INT(11), IN dest INT(11))
	BEGIN
		INSERT INTO chiamata (Sharing, Utente, PosizioneAttuale, Destinazione)
		VALUES (sh_id, u_id, pos_act, dest);
	END$$
DELIMITER ;

-- INSERIMENTO VALUTAZIONE
DROP PROCEDURE IF EXISTS insert_valutation;

DELIMITER $$
CREATE PROCEDURE insert_valutation(IN vl_piacere DOUBLE, IN vl_persona DOUBLE, IN vl_serieta DOUBLE, IN vl_comportamento DOUBLE, IN vl_rec VARCHAR(255), IN vl_ind_start VARCHAR(255), IN vl_ind_end VARCHAR(255), IN vl_u_val INT(11), IN vl_u_rec INT(11))
	BEGIN
		INSERT INTO valutazione (Piacere, Persona, Serieta, Comportamento, Recensione, IndirizzoPartenza, IndirizzoArrivo, UtenteValutato, UtenteRecensore)
		VALUES (vl_piacere, vl_persona, vl_serieta, vl_comportamento, vl_rec, vl_ind_start, vl_ind_end, vl_u_val, vl_u_rec);
	END$$
DELIMITER ;

-- CONSEGNA VEICOLO
DROP PROCEDURE IF EXISTS update_v_state;

DELIMITER $$
CREATE PROCEDURE update_v_state(IN v VARCHAR(50), IN km INT(11), IN aut INT(11))
	BEGIN
		UPDATE 	stato
		SET	 	Chilometraggio = km, Autonomia = aut
		WHERE 	Veicolo = v;
	END$$
DELIMITER ;