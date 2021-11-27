-- INSERIMENTO PERCORSO SHARING
DROP PROCEDURE IF EXISTS insert_ridesharing_track;

DELIMITER $$
CREATE PROCEDURE insert_ridesharing_track(IN sh_id INT(11), track INT(11))
	BEGIN
		INSERT INTO percorsoridesharing (Pool, Tratta)
		VALUES (sh_id, sh_track);
	END$$
DELIMITER ;