-- Calcola distanza tra due punti geografici
DROP FUNCTION IF EXISTS get_distance;

DELIMITER $$
CREATE FUNCTION get_distance(latA FLOAT(10,6), lonA FLOAT(10,6), latB FLOAT(10,6), lonB FLOAT(10,6))
RETURNS DOUBLE DETERMINISTIC
	BEGIN
		RETURN (6372.795477598 * ACOS(SIN(RADIANS(latA)) * SIN(RADIANS(latB)) + COS(RADIANS(latA)) * COS(RADIANS(latB)) * COS(RADIANS(lonA)-RADIANS(lonB))));
	END$$
DELIMITER ;

/*
Esempio calcolo (segmento di minima) distanza da
Pisa, Via Diotisalvi: 43.7202389,10.3915873
Pisa, Stazione Centrale:  43.708874, 10.398186

SELECT get_distance(43.7202389,10.3915873,43.708874, 10.398186);

-- 1.3709 km 
*/