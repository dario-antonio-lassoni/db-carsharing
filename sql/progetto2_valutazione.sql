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
-- Table structure for table `valutazione`
--

DROP TABLE IF EXISTS `valutazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `valutazione` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Piacere` double NOT NULL DEFAULT '0',
  `Persona` double NOT NULL DEFAULT '0',
  `Serieta` double NOT NULL DEFAULT '0',
  `Comportamento` double NOT NULL DEFAULT '0',
  `Recensione` varchar(255) NOT NULL,
  `IndirizzoPartenza` varchar(255) NOT NULL,
  `IndirizzoArrivo` varchar(255) NOT NULL,
  `UtenteValutato` int(11) NOT NULL,
  `UtenteRecensore` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Valutazione_UtenteVal_idx` (`UtenteValutato`),
  KEY `FK_Valutazione_UtenteRecensore_idx` (`UtenteRecensore`),
  CONSTRAINT `FK_Valutazione_UtenteRecensore` FOREIGN KEY (`UtenteRecensore`) REFERENCES `utente` (`id`),
  CONSTRAINT `FK_Valutazione_UtenteValutato` FOREIGN KEY (`UtenteValutato`) REFERENCES `utente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `valutazione`
--

INSERT INTO `valutazione` VALUES (1,5,4,5,2,'Ottima compagnia','via Statale 12','Via della Corsa',2,5),(2,1,2,3,4,'Puntuale','via Statale 12','Via della Corsa',2,5),(3,1,2,3,4,'Silenzioso','via Statale 12','Via della Corsa',5,1),(6,4,2,3,4,'Puntuale','via Statale 12','Via della Corsa',6,7);
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `valutazione_insert_validation` BEFORE INSERT ON `valutazione` FOR EACH ROW BEGIN

		-- L’UtenteValutato deve essere diverso dall’UtenteRecensore nella tabella VALUTAZIONE 

		IF(NEW.UtenteValutato = NEW.UtenteRecensore) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Un utente non può autovalutarsi.';

		END IF;

		

		-- I valori delle valutazioni devono essere compresi tra 0 e 5.

		IF ((NEW.Piacere NOT BETWEEN 0 AND 5) OR

			(NEW.Persona NOT BETWEEN 0 AND 5) OR

			(NEW.Serieta NOT BETWEEN 0 AND 5) OR

			(NEW.Comportamento NOT BETWEEN 0 AND 5))

		THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'I valori delle valutazioni devono essere compresi tra 0 e 5.';

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

-- Dump completed on 2019-01-30 23:21:26
