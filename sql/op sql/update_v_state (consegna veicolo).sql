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