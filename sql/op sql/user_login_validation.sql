DROP PROCEDURE IF EXISTS user_login_validation;

DELIMITER $$
CREATE PROCEDURE user_login_validation(IN u_name VARCHAR(50), IN u_password VARCHAR(50), OUT success BOOLEAN)
	BEGIN	
		DECLARE u_exists TINYINT DEFAULT 0;
		DECLARE	pass VARCHAR(64);
		
		-- Controllo se l'utente esiste
		SET success = FALSE;
		SET u_exists = (SELECT 	IFNULL(COUNT(*), 0)
						FROM	utente u
						WHERE	u.Nome = u_name);
				
		IF (u_exists <> 0) THEN
			-- Controllo se la password è corretta
			SET pass = 	(SELECT u.Password
						FROM 	utente u
						WHERE	u.Nome = u_name);
						
			IF (u_password = pass)	THEN
				SET success = TRUE;
			END IF;
		END IF;
	END$$
DELIMITER ;

/*

CALL user_login_validation('aaa', 'abc', @res);
select @res;

*/