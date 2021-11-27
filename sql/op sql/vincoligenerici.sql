-- Un utente può offrire servizi solo se il suo account è stato verificato
-- Car Pooling
DROP TRIGGER IF EXISTS pool_insert_validation;
DELIMITER $$
CREATE TRIGGER pool_insert_validation
BEFORE INSERT ON Pool
FOR EACH ROW
	BEGIN
		DECLARE proponente INT(11);
		DECLARE verificato TINYINT DEFAULT 0;
		SET proponente = (SELECT v.Utente
						FROM veicolo v
						WHERE v.Targa = NEW.Veicolo);
		SET verificato = (SELECT u.stato
							FROM utente u
							WHERE u.Id = proponente);
							
		IF(verificato = 0) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Prima di inserire un pool è necessaria la verifica dei documenti.';
		END IF;
		
		-- Un pool deve restare aperto almeno fino a due giorni prima della partenza.
		IF ((NEW.TimestampPartenza - INTERVAL 2 DAY) < NEW.TimestampChiusura) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Un pool deve restare aperto almeno fino a 48 ore prima della partenza.';
		END IF;
	END$$
DELIMITER ;

-- Ride Sharing
DROP TRIGGER IF EXISTS rs_insert_validation;
DELIMITER $$
CREATE TRIGGER rs_insert_validation
BEFORE INSERT ON Sharing
FOR EACH ROW
	BEGIN
		DECLARE proponente INT(11);
		DECLARE verificato TINYINT DEFAULT 0;
		SET proponente = (SELECT v.Utente
						FROM veicolo v
						WHERE v.Targa = NEW.Veicolo);
		SET verificato = (SELECT u.Stato
							FROM utente u
							WHERE u.Id = proponente);
							
		IF(verificato = 0) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Prima di offrire un servizio di ride sharing è necessaria la verifica dei documenti.';
		END IF;
	END$$
DELIMITER ;

-- Car Sharing (comprende anche controllo fruitore)
DROP TRIGGER IF EXISTS cs_insert_validation;
DELIMITER $$
CREATE TRIGGER cs_insert_validation
BEFORE INSERT ON Prenotazione
FOR EACH ROW
	BEGIN
		DECLARE stato_fruitore TINYINT DEFAULT 0;
		DECLARE proponente INT(11);
		DECLARE stato_proponente TINYINT DEFAULT 0;
		
		-- Controllo sul fruitore
		SET stato_fruitore =	(SELECT u.Stato
								FROM utente u
								WHERE u.Id = NEW.Utente);
		IF(stato_fruitore = 0) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Prima di effettuare una prenotazione è necessaria la verifica dei documenti.';
		END IF;
		
		-- Controllo sul proponente
		SET proponente =	(SELECT v.Utente
							FROM veicolo v
							WHERE v.Targa = NEW.Veicolo);
		SET stato_proponente =	(SELECT u.Stato
								FROM utente u
								WHERE u.Id = proponente);
		IF (stato_proponente = 0) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Il veicolo non può essere prenotato in quanto il proponente non è ancora stato verificato.';
		END IF;
	END $$
DELIMITER ;

-- Un utente può usufruire di un servizio solo se il suo account è stato verificato
-- Car Pooling
DROP TRIGGER IF EXISTS pp_insert_validation;
DELIMITER $$
CREATE TRIGGER pp_insert_validation
BEFORE INSERT ON partecipantipool
FOR EACH ROW
	BEGIN
		DECLARE stato_fruitore TINYINT DEFAULT 0;
		DECLARE chiusura_pool DATETIME;
		
		SET stato_fruitore =	(SELECT u.Stato
								FROM utente u
								WHERE u.Id = NEW.Utente);
		
		IF (stato_fruitore = 0) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Prima di prendere parte ad un pool è necessaria la verifica dei documenti.';
		END IF;
		
		-- Un utente può prendere parte ad un pool solo se il pool è aperto
		SET chiusura_pool =	(SELECT p.TimestampChiusura
							FROM pool p
							WHERE p.Id = NEW.Pool);
		
		IF(NOW() > chiusura_pool) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Non puoi prendere parte ad un pool non aperto.';
		END IF;
	END$$
DELIMITER ;

-- Variazione Pool
DROP TRIGGER IF EXISTS variazione_insert_validation;
DELIMITER $$
CREATE TRIGGER variazione_insert_validation
BEFORE INSERT ON variazione
FOR EACH ROW
	BEGIN
		DECLARE stato_fruitore TINYINT DEFAULT 0;
		DECLARE chiusura_pool DATETIME;
		
		SET stato_fruitore =	(SELECT u.Stato
								FROM utente u
								WHERE u.Id = NEW.Utente);
		
		IF (stato_fruitore = 0) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Prima di richiedere una variazione per un pool è necessaria la verifica dei documenti.';
		END IF;
		
		-- Un utente può prendere parte ad un pool solo se il pool è aperto
		SET chiusura_pool =	(SELECT p.TimestampChiusura
							FROM pool p
							WHERE p.Id = NEW.Pool);
		
		IF(NOW() > chiusura_pool) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Non puoi richiedere una variazione per un pool non aperto.';
		END IF;
	END$$
DELIMITER ;

-- Ride Sharing
DROP TRIGGER IF EXISTS chiamata_insert_validation;
DELIMITER $$
CREATE TRIGGER chiamata_insert_validation
BEFORE INSERT ON chiamata
FOR EACH ROW
	BEGIN
		DECLARE stato_fruitore TINYINT DEFAULT 0;
		
		SET stato_fruitore =	(SELECT u.Stato
								FROM utente u
								WHERE u.Id = NEW.Utente);
		
		IF (stato_fruitore = 0) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Prima di inserire una chiamata per un ride sharing è necessaria la verifica dei documenti.';
		END IF;
	END$$
DELIMITER ;

-- Un veicolo può essere noleggiato solo se è disponibile
DROP TRIGGER IF EXISTS prenotazione_update_validation;
DELIMITER $$
CREATE TRIGGER prenotazione_update_validation
BEFORE UPDATE ON prenotazione
FOR EACH ROW
	BEGIN
		DECLARE disponibilita INT DEFAULT 0;
		
		-- Se si sta accettando la prenotazione
		IF(NEW.Stato = 'Accettata') THEN
			-- Controllo se esiste una prenotazione accettata per quel veicolo in quell'intervallo di tempo
			SET disponibilita =	(SELECT COUNT(*)
								FROM prenotazione p
								WHERE p.Veicolo = OLD.Veicolo
								AND p.Stato = 'Accettata'
								AND p.Id <> OLD.Id
								AND (OLD.Inizio BETWEEN p.Inizio AND p.Fine
									OR OLD.Fine BETWEEN p.Inizio AND p.Fine
									OR p.Inizio BETWEEN OLD.Inizio AND OLD.Fine));
			IF(disponibilita <> 0) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Esiste una prenotazione accettata per quel veicolo nel periodo selezionato.';
			END IF;
		END IF;
	END$$
DELIMITER ;

-- Un veicolo può essere restituito solo se il livello di carburante è adeguato
DROP TRIGGER IF EXISTS stato_update_validation;
DELIMITER $$
CREATE TRIGGER stato_update_validation
BEFORE UPDATE ON stato
FOR EACH ROW
	BEGIN
		DECLARE validita TINYINT DEFAULT 0;
		
		IF((OLD.Autonomia - NEW.Autonomia) > 20) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Impossibile restituire il veicolo. Livello di carburante troppo basso.';
		END IF;
	END$$
DELIMITER ;

-- Una tratta rappresenta un determinato km di una strada. Se la strada è lunga 7 km non può esistere una tratta che ne rappresenta il km 8.
DROP TRIGGER IF EXISTS tratta_insert_validation;
DELIMITER $$
CREATE TRIGGER tratta_insert_validation
BEFORE INSERT ON tratta
FOR EACH ROW
	BEGIN
		DECLARE lunghezza INT;
		
		SET lunghezza =	(SELECT FLOOR(s.Lunghezza)
						FROM strada s
						WHERE s.Id = NEW.Strada);
						
		IF(NEW.Chilometro > lunghezza) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Impossibile inserire la tratta.';
		END IF;
		
		-- Controllo latitudine e longitudine
		IF ((NEW.LatInizio NOT BETWEEN -90 AND 90) OR
			(NEW.LatFine NOT BETWEEN -90 AND 90) OR
			(NEW.LongInizio NOT BETWEEN -180 AND 180) OR
			(NEW.LongFine NOT BETWEEN -180 AND 180))
		THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Impossibile inserire la tratta, controllare le coordinate.';
		END IF;
	END$$
DELIMITER ;

-- Se una variazione di pool è accettata, l’utente è inserito tra i partecipanti. 
DROP TRIGGER IF EXISTS variazione_update_operation;
DELIMITER $$
CREATE TRIGGER variazione_update_operation
AFTER UPDATE ON variazione
FOR EACH ROW
	BEGIN
		IF(NEW.Stato = 'Accettata') THEN
			INSERT INTO partecipantipool
			VALUES (OLD.Utente, OLD.Pool);
		END IF;
	END$$
DELIMITER ;

-- Quando una chiamata è accettata, viene inserita una corsa. 
DROP TRIGGER IF EXISTS chiamata_update_operation;
DELIMITER $$
CREATE TRIGGER chiamata_update_operation
AFTER UPDATE ON chiamata
FOR EACH ROW
	BEGIN
		IF(NEW.Stato = 'Accettata') THEN
			INSERT INTO corsa (Chiamata)
			VALUES (OLD.Id);
		END IF;
	END$$
DELIMITER ;

DROP TRIGGER IF EXISTS valutazione_insert_validation
DELIMITER $$
CREATE TRIGGER valutazione_insert_validation
BEFORE INSERT ON valutazione
FOR EACH ROW
	BEGIN
		-- L’UtenteValutato deve essere diverso dall’UtenteRecensore nella tabella VALUTAZIONE 
		IF(NEW.UtenteValutato = NEW.UtenteRecensore) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Un utente non può autovalutarsi.';
		END IF;
		
		-- I valori delle valutazioni devono essere compresi tra 0 e 5.
		IF ((NEW.Piacere NOT BETWEEN 0 AND 5) OR
			(NEW.Persona NOT BETWEEN 0 AND 5) OR
			(NEW.Serieta NOT BETWEEN 0 AND 5) OR
			(NEW.Comportamento NOT BETWEEN 0 AND 5))
		THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'I valori delle valutazioni devono essere compresi tra 0 e 5.';
		END IF;
	END$$
DELIMITER ;

-- LATITUDINE E LONGITUDINE IN INTERSEZIONE
DROP TRIGGER IF EXISTS intersezione_insert_validation;
DELIMITER $$
CREATE TRIGGER intersezione_insert_validation
BEFORE INSERT ON intersezione
FOR EACH ROW
BEGIN
	IF ((NEW.Lat NOT BETWEEN -90 AND 90) OR
		(NEW.Long NOT BETWEEN -180 AND 180))
	THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Impossibile inserire il record, controllare le coordinate.';
	END IF;
END$$
DELIMITER ;

-- LATITUDINE E LONGITUDINE IN TRACKING
DROP TRIGGER IF EXISTS tract_insert_validation;
DELIMITER $$
CREATE TRIGGER tract_insert_validation
BEFORE INSERT ON trackingattuale
FOR EACH ROW
BEGIN
	IF ((NEW.Lat NOT BETWEEN -90 AND 90) OR
		(NEW.Long NOT BETWEEN -180 AND 180))
	THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Coordinate non valide.';
	END IF;
END$$
DELIMITER ;

-- LATITUDINE E LONGITUDINE IN TRACKING
DROP TRIGGER IF EXISTS tract_update_validation;
DELIMITER $$
CREATE TRIGGER tract_update_validation
BEFORE UPDATE ON trackingattuale
FOR EACH ROW
BEGIN
	IF ((NEW.Lat NOT BETWEEN -90 AND 90) OR
		(NEW.Long NOT BETWEEN -180 AND 180))
	THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Coordinate non valide.';
	END IF;
END$$
DELIMITER ;