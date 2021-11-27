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
										AND	(DAYOFWEEK(r_start) = DAYOFWEEK(f.TimestampInizio)
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

/*

DELETE FROM Prenotazione
WHERE Stato = 'Pending';

DELETE FROM fruibilita      
WHERE Veicolo = 'EA12313'; 

INSERT INTO fruibilita
VALUES('EA12313', '2019-10-01 10:00:00', '2019-10-01 21:00:00'); 

CALL insert_carsharing_reservation('2019-10-01 11:00:00', '2019-10-01 20:00:00', 6, 'EA12313', @res);
SELECT @res;

*/