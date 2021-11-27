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
CREATE PROCEDURE insert_carsharing_reservatio(IN r_start DATETIME, IN r_end DATETIME, IN r_user INT(11), IN r_car VARCHAR(50), OUT success BOOLEAN)
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