-- CREAZIONE SHARING
DROP PROCEDURE IF EXISTS insert_ridesharing;

DELIMITER $$
CREATE PROCEDURE insert_ridesharing(IN sh_v VARCHAR(50), IN sh_start DATETIME, IN sh_ind_start VARCHAR(255), IN sh_ind_end VARCHAR(255))
	BEGIN
		INSERT INTO sharing (Veicolo, TimestampPartenza, IndirizzoPartenza, IndirizzoArrivo)
		VALUES (sh_v, sh_start, sh_ind_start, sh_ind_end);
	END$$
DELIMITER ;