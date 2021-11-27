DROP PROCEDURE IF EXISTS get_spesa_pool;

DELIMITER $$
CREATE PROCEDURE get_spesa_pool(IN id_pool INT(11))
	BEGIN
		DECLARE nVariazioni INT DEFAULT 0;
		DECLARE nFruitori INT DEFAULT 0;
		DECLARE kmPercorsi DOUBLE DEFAULT 0.0;
		DECLARE costoVar DOUBLE;
        DECLARE v_pool VARCHAR(50);
		
		SET v_pool		=	(SELECT p.Veicolo
							FROM 	pool p
							WHERE	p.Id = id_pool);
		SET costoVar 	= 	(SELECT	p1.CostoVariazione
							FROM	pool p1
							WHERE	p1.Id = id_pool);
		SET nVariazioni = 	(SELECT IFNULL(COUNT(*), 0)
							FROM 	variazione v
							WHERE 	v.Pool = id_pool);
		SET nFruitori 	= 	(SELECT IFNULL(COUNT(*), 0)
							FROM	partecipantipool pp
							WHERE	pp.Pool = id_pool);
		SET kmPercorsi 	=	(SELECT SUM(D1.kmPercorsi)
							FROM	(SELECT 	D.*, IF(@old_tu = TO_DAYS(D.TimestampIngresso),
													get_distance(@old_lat, @old_lon, D.lat + LEAST(0, @old_lat := D.Lat), D.Long + LEAST(0, @old_lon := D.Long)) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)),
													NULL + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)) + LEAST(0, @old_lat := D.Lat) + LEAST (0, @old_lon := D.Long)) AS kmPercorsi

									FROM	(SELECT 	*
											FROM	trackingattuale ta
											WHERE	ta.Veicolo = v_pool
											ORDER BY	ta.TimestampIngresso ASC) AS D,
											(SELECT	(@old_tu := '')) AS N,
											(SELECT (@old_lat := '')) AS N1,
											(SELECT (@old_lon := '')) AS N2) AS D1);
											
		-- Si potrebbe calcolare la spesa in base al costo del carburante, al tipo di alimentazione e al consumo.
		-- Per semplicità, si considera una spesa di 0.1 euro per km percorso ed un incremento di 0.05 euro al km per ogni fruitore.
		
		UPDATE	pool
		SET		Costo = ROUND((costoVar*nVariazioni + 0.05*nFruitori*kmPercorsi + 0.1*kmPercorsi), 2)
		WHERE	Id = id_pool;
	END$$
DELIMITER ;
/*
INSERT INTO pool (Id, Veicolo, TimestampPartenza, TimestampArrivo, TimestampChiusura, IndirizzoPartenza, IndirizzoArrivo, Flessibilita, CostoVariazione)
VALUES (10, 'BB12345', '2019-02-11 10:00:00', '2019-02-11 15:00:00', '2019-02-08 20:00:00', 'Via Diotisalvi', 'Via Alighieri', 'bassa', 5);



INSERT INTO partecipantipool (Utente, Pool)
VALUES (5, 10), (6,10);


INSERT INTO variazione (Id, Utente, Pool, Stato)
VALUES (3, 5, 10, 1);

CALL insert_new_track('BB12345', 3, 43.14356, 52.65654, NULL, @tperc, @ctime);
CALL update_track('BB12345', 3, @ctime, 43.678976, 51.545675, @tperc);

CALL insert_new_track('BB12345', 4, 42.14356, 52.65654, @ctime, @tperc, @ctime);
CALL update_track('BB12345', 4, @ctime, 42.678976, 51.545675, @tperc);

SELECT *
FROM trackingattuale;

CALL get_spesa_pool(10);

*/