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

/*

CALL create_pool('BB12345', '2019-01-24 10:00:00', '2019-01-26 11:00:00', '2019-01-22 09:00:00', 'Via Diotisalvi', 'Via Alighieri', 'bassa', 15);

SELECT *
FROM pool;

*/