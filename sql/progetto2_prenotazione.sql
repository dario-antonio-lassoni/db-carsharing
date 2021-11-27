CREATE DATABASE  IF NOT EXISTS `progetto2` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `progetto2`;
-- MySQL dump 10.13  Distrib 8.0.13, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: progetto2
-- ------------------------------------------------------
-- Server version	8.0.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `prenotazione`
--

DROP TABLE IF EXISTS `prenotazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `prenotazione` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Stato` enum('Accettata','Rifiutata','Pending') NOT NULL DEFAULT 'Pending',
  `Inizio` timestamp NOT NULL,
  `Fine` timestamp NOT NULL,
  `Utente` int(11) DEFAULT NULL,
  `Veicolo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Prenotazione_Utente_idx` (`Utente`),
  KEY `FK_Prenotazione_Veicolo_idx` (`Veicolo`),
  CONSTRAINT `FK_Prenotazione_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_Prenotazione_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`targa`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prenotazione`
--

INSERT INTO `prenotazione` VALUES (1,'Rifiutata','2017-01-15 00:00:00','2017-06-15 00:00:00',5,'BB12345'),(2,'Rifiutata','2017-05-15 00:00:00','2017-05-16 00:00:00',5,'BB12345'),(3,'Accettata','2017-05-16 00:00:00','2017-05-16 00:00:00',5,'BB12345'),(4,'Accettata','2019-02-01 16:00:00','2019-02-02 14:00:00',6,'EA12313'),(5,'Accettata','2019-02-02 16:00:00','2019-02-03 14:00:00',6,'EA12313'),(6,'Accettata','2019-03-05 16:00:00','2019-02-03 14:00:00',6,'EA12313'),(11,'Accettata','2019-02-04 17:30:00','2019-02-04 20:00:00',6,'BB12345');
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cs_insert_validation` BEFORE INSERT ON `prenotazione` FOR EACH ROW BEGIN

		DECLARE stato_fruitore TINYINT DEFAULT 0;

		DECLARE proponente INT(11);

		DECLARE stato_proponente TINYINT DEFAULT 0;

		

		-- Controllo sul fruitore

		SET stato_fruitore =	(SELECT u.Stato

								FROM utente u

								WHERE u.Id = NEW.Utente);

		IF(stato_fruitore = 0) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Prima di effettuare una prenotazione è necessaria la verifica dei documenti.';

		END IF;

		

		-- Controllo sul proponente

		SET proponente =	(SELECT v.Utente

							FROM veicolo v

							WHERE v.Targa = NEW.Veicolo);

		SET stato_proponente =	(SELECT u.Stato

								FROM utente u

								WHERE u.Id = proponente);

		IF (stato_proponente = 0) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Il veicolo non può essere prenotato in quanto il proponente non è ancora stato verificato.';

		END IF;

	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prenotazione_update_validation` BEFORE UPDATE ON `prenotazione` FOR EACH ROW BEGIN

		DECLARE disponibilita INT DEFAULT 0;

		

		-- Se si sta accettando la prenotazione

		IF(NEW.Stato = 'Accettata') THEN

			-- Controllo se esiste una prenotazione accettata per quel veicolo in quell'intervallo di tempo

			SET disponibilita =	(SELECT COUNT(*)

								FROM prenotazione p

								WHERE p.Veicolo = OLD.Veicolo

								AND p.Stato = 'Accettata'

								AND p.Id <> OLD.Id

								AND (OLD.Inizio BETWEEN p.Inizio AND p.Fine

									OR OLD.Fine BETWEEN p.Inizio AND p.Fine

									OR p.Inizio BETWEEN OLD.Inizio AND OLD.Fine));

			IF(disponibilita <> 0) THEN

				SIGNAL SQLSTATE '45000'

				SET MESSAGE_TEXT = 'Esiste una prenotazione accettata per quel veicolo nel periodo selezionato.';

			END IF;

		END IF;

	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-01-30 23:21:22
