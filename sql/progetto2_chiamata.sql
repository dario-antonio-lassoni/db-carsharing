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
-- Table structure for table `chiamata`
--

DROP TABLE IF EXISTS `chiamata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `chiamata` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Sharing` int(11) NOT NULL,
  `Utente` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `PosizioneAttuale` int(11) NOT NULL,
  `Destinazione` int(11) NOT NULL,
  `Stato` enum('Accettata','Rifiutata','Pending') NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`Id`),
  KEY `FK_Chiamata_Sharing_idx` (`Sharing`),
  KEY `FK_Chiamata_PosAttuale_idx` (`PosizioneAttuale`),
  KEY `FK_Chiamata_Destinazione_idx` (`Destinazione`),
  KEY `FK_Chiamata_Utente_idx` (`Utente`),
  CONSTRAINT `FK_Chiamata_Destinazione` FOREIGN KEY (`Destinazione`) REFERENCES `tratta` (`id`),
  CONSTRAINT `FK_Chiamata_PosAttuale` FOREIGN KEY (`PosizioneAttuale`) REFERENCES `tratta` (`id`),
  CONSTRAINT `FK_Chiamata_Sharing` FOREIGN KEY (`Sharing`) REFERENCES `sharing` (`id`),
  CONSTRAINT `FK_Chiamata_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chiamata`
--

INSERT INTO `chiamata` VALUES (1,1,5,'2019-01-21 15:00:00',7,2,'Accettata'),(2,2,6,'2019-01-07 15:00:00',4,3,'Accettata');
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `chiamata_insert_validation` BEFORE INSERT ON `chiamata` FOR EACH ROW BEGIN

		DECLARE stato_fruitore TINYINT DEFAULT 0;

		

		SET stato_fruitore =	(SELECT u.Stato

								FROM utente u

								WHERE u.Id = NEW.Utente);

		

		IF (stato_fruitore = 0) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Prima di inserire una chiamata per un ride sharing è necessaria la verifica dei documenti.';

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `chiamata_update_operation` AFTER UPDATE ON `chiamata` FOR EACH ROW BEGIN

		IF(NEW.Stato = 'Accettata') THEN

			INSERT INTO corsa (Chiamata)

			VALUES (OLD.Id);

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

-- Dump completed on 2019-01-30 23:21:27
