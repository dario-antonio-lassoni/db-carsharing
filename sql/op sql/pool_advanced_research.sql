DROP PROCEDURE IF EXISTS pool_advanced_research;

DELIMITER $$
CREATE PROCEDURE pool_advanced_research(IN fless ENUM('bassa', 'media', 'alta'), IN latA FLOAT(10,6), IN lonA FLOAT(10,6), IN latB FLOAT(10,6), IN lonB FLOAT(10,6))
	BEGIN
		-- Prendo i pool aperti
		SELECT 
			p.*
		FROM
			pool p
		WHERE
			p.TimestampChiusura > NOW()
            AND	p.Flessibilita = fless
			-- RECORD IN PERCORSO POOL CON UNA DELLE TRATTE TARGET A
				AND EXISTS( SELECT 
					pp1.*
				FROM
					percorsopool pp1
				WHERE
					pp1.Pool = p.Id
						-- TRATTE TARGET A
						AND pp1.Tratta IN (SELECT 
												t1.Id
											FROM
												tratta t1
											WHERE
												GET_DISTANCE(latA,
														lonA,
														(t1.LatInizio + t1.LatFine) / 2,
														(t1.LongInizio + t1.LongFine) / 2) < 0.5))
						-- RECORD IN PERCORSO POOL CON UNA DELLE TRATTE TARGET B
						AND EXISTS( SELECT 
							pp2.*
						FROM
							percorsopool pp2
						WHERE
							pp2.Pool = p.Id
								-- TRATTE TARGET B
								AND pp2.Tratta IN (SELECT 
									t2.Id
								FROM
									tratta t2
								WHERE
									GET_DISTANCE(latB,
											lonB,
											(t2.LatInizio + t2.LatFine) / 2,
											(t2.LongInizio + t2.LongFine) / 2) < 0.5));
	END$$
DELIMITER ;


/*
-- Tratta 9 di Via Diotisalvi
-- Tratta 10 di Via Bonanno Pisano
-- Tratta 11 di Via Alighieri

-- Coordinate in prossimità di via Diotisalvi e via Bonanno Pisano 
--  43.720000, 10.390879 
-- Coordinate in prossimità di via Alighieri (Ghezzano)
--  43.719297, 10.427120 
 
SELECT *
FROM pool;

 CALL pool_advanced_research('bassa', 43.720871, 10.389070, 43.719297, 10.427120);
*/