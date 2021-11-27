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
/*
TRUNCATE trackingattuale;
SELECT *
FROM trackingattuale;

CALL insert_new_track('AB12345', 1, 43.120456, 44.631122, NULL, @tperc, @ctime);
CALL update_track('AB12345', 1, @ctime, 43.204566, 44.121123, @tperc);
CALL insert_new_track('AB12345', 3, 43.120456, 44.631122, @ctime, @tperc, @ctime);
CALL close_track('AB12345', 3, @ctime, 43.323245, 44.512433);

SELECT *
FROM trackingstorico;


*/