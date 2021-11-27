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
-- Table structure for table `pool`
--

DROP TABLE IF EXISTS `pool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `pool` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Veicolo` varchar(50) NOT NULL,
  `TimestampPartenza` timestamp NOT NULL,
  `TimestampArrivo` timestamp NOT NULL,
  `TimestampChiusura` timestamp NOT NULL,
  `IndirizzoPartenza` varchar(255) NOT NULL,
  `IndirizzoArrivo` varchar(255) NOT NULL,
  `Flessibilita` enum('bassa','media','alta') NOT NULL DEFAULT 'media',
  `CostoVariazione` double DEFAULT NULL,
  `Costo` double DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Pool_Veicolo_idx` (`Veicolo`),
  CONSTRAINT `FK_Pool_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`targa`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pool`
--

INSERT INTO `pool` VALUES (2,'BB12345','2018-02-15 12:00:00','2018-02-15 17:00:00','2018-02-12 17:00:00','Lungarno Gabriele D\'Annunzio','Via Deodato Orlandi 12','media',10,0),(3,'BB12345','2018-02-08 17:00:00','2018-02-08 19:00:00','2018-02-05 00:00:00','Via Statale 12','Via della Corsa','media',10,0),(4,'EA12313','2019-02-05 12:00:00','2019-02-08 19:00:00','2019-02-02 19:00:00','Lungarno Gabriele D\'Annunzio','Via Deodato Orlandi 12','media',10,0),(5,'BB12345','2019-02-08 19:00:00','2019-02-09 04:00:00','2019-02-05 11:00:00','Via Statale 12','Via della Corsa','media',10,0),(7,'BB12345','2019-02-08 09:00:00','2019-02-08 13:00:00','2019-02-05 10:00:00','Via Statale 12','Via della Corsa','media',10,0),(8,'BB12345','2019-02-11 09:00:00','2019-02-11 13:00:00','2019-02-08 20:00:00','Via Diotisalvi','Via Alighieri','bassa',5,0),(9,'EA12313','2019-02-12 12:00:00','2019-02-12 16:30:00','2019-02-09 10:00:00','Via Bonanno Pisano','Via Alighieri','bassa',10,0);
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `pool_insert_validation` BEFORE INSERT ON `pool` FOR EACH ROW BEGIN

		DECLARE proponente INT(11);

		DECLARE verificato TINYINT DEFAULT 0;

		SET proponente = (SELECT v.Utente

						FROM veicolo v

						WHERE v.Targa = NEW.Veicolo);

		SET verificato = (SELECT u.stato

							FROM utente u

							WHERE u.Id = proponente);

							

		IF(verificato = 0) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Prima di inserire un pool è necessaria la verifica dei documenti.';

		END IF;

		

		-- Un pool deve restare aperto almeno fino a due giorni prima della partenza.

		IF ((NEW.TimestampPartenza - INTERVAL 2 DAY) < NEW.TimestampChiusura) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Un pool deve restare aperto almeno fino a 48 ore prima della partenza.';

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

-- Dump completed on 2019-01-30 23:21:21
