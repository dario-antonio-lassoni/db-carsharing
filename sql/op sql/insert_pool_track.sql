-- INSERIMENTO PERCORSO POOL
DROP PROCEDURE IF EXISTS insert_pool_track;

DELIMITER $$
CREATE PROCEDURE insert_pool_track(IN p_id INT(11), track INT(11))
	BEGIN
		INSERT INTO percorsopool (Pool, Tratta)
		VALUES (p_id, p_track);
	END$$
DELIMITER ;

