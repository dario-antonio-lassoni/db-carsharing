-- AGGIORNAMENTO RIDONDANZA AVGPERCORRENZA
/*	RECUPERO I TRAGITTI DEL TRACKING STORICO GIORNALIERI
	CON UNA LAG CALCOLO LA DISTANZA PERCORSA SU OGNI TRATTA */
-- RAGGRUPPO PER TRATTA E CALCOLO UNA MEDIA PESATA, TENENDO CONTO DELLA MEDIA GIA CALCOLATA

DROP PROCEDURE IF EXISTS update_avg_percorrenza;

DELIMITER $$
CREATE PROCEDURE update_avg_percorrenza()
	BEGIN
	
		DECLARE finito TINYINT DEFAULT 0;
		DECLARE t_curr INT(11) DEFAULT 0;
		DECLARE x_curr DOUBLE DEFAULT 0.0;
		DECLARE p_curr	DOUBLE DEFAULT 0.0;
		
		/*	RECUPERO I TRAGITTI DEL TRACKING STORICO GIORNALIERI E
			CON UNA LAG CALCOLO LA DISTANZA PERCORSA SU OGNI TRATTA */
		-- RAGGRUPPO PER TRATTA E CALCOLO I FATTORI CHE MI SERVONO PER LA MEDIA PONDERATA, SULLA BASE DEI KM PERCORSI
		DECLARE tratte_target CURSOR FOR
		SELECT	D1.Tratta, SUM(kmPercorsi*(UNIX_TIMESTAMP(D1.TimestampUscita) - UNIX_TIMESTAMP(D1.TimestampIngresso))) AS x, SUM(D1.kmPercorsi) AS peso
		FROM	(SELECT 	D.*, IF(@v = D.Veicolo AND @old_tu = TO_DAYS(D.TimestampIngresso),
									get_distance(@old_lat, @old_lon, D.lat + LEAST(0, @old_lat := D.Lat), D.Long + LEAST(0, @old_lon := D.Long)) + LEAST(0, @v := D.Veicolo) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)),
									NULL + LEAST(0, @v := D.Veicolo) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)) + LEAST(0, @old_lat := D.Lat) + LEAST (0, @old_lon := D.Long)) AS kmPercorsi

				FROM	(SELECT 	*
						FROM	trackingstorico ts
						WHERE	ts.TimestampIngresso >= NOW() - INTERVAL 1 DAY
						ORDER BY	ts.Veicolo, ts.TimestampIngresso ASC) AS D,
						(SELECT (@v := '')) AS N, (SELECT (@old_tu := '')) AS N1, (SELECT (@old_lat := '')) AS N2, (SELECT (@old_lon := '')) AS N3) AS D1
		WHERE	D1.kmPercorsi IS NOT NULL
		GROUP BY	D1.Tratta;
		
		DECLARE CONTINUE HANDLER
			FOR NOT FOUND SET finito = 1;
		
		OPEN tratte_target;
		
		preleva: LOOP
			FETCH tratte_target INTO t_curr, x_curr, p_curr;
			IF finito = 1 THEN
				LEAVE preleva;
			END IF;
			
			UPDATE	tratta t
			SET		t.avgPercorrenza = ((t.avgPercorrenza*t.nPercorsi) + x_curr)/(t.nPercorsi + p_curr),
					t.nPercorsi = t.nPercorsi + p_curr
			WHERE	Id = t_curr;
		END LOOP preleva;
		CLOSE tratte_target;
		
	END$$
	
DELIMITER ;

DROP EVENT IF EXISTS update_avg_percorrenza;
CREATE EVENT update_avg_percorrenza
ON SCHEDULE EVERY 1 DAY
STARTS '2019-01-17 23:55:00'
DO
	CALL update_avg_percorrenza();

/*
UPDATE tratta
SET AvgPercorrenza = 0, NPercorsi = 0;

*/