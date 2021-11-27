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
-- Table structure for table `tratta`
--

DROP TABLE IF EXISTS `tratta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `tratta` (
  `Id` int(11) NOT NULL,
  `Strada` int(11) NOT NULL,
  `Chilometro` int(11) NOT NULL,
  `Pedaggio` double DEFAULT NULL,
  `LimiteVelocita` int(11) NOT NULL,
  `LatInizio` float(10,6) NOT NULL,
  `LongInizio` float(10,6) NOT NULL,
  `LatFine` float(10,6) NOT NULL,
  `LongFine` float(10,6) NOT NULL,
  `AvgPercorrenza` double NOT NULL DEFAULT '0',
  `NPercorsi` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  KEY `FK_Tratta_Strada_idx` (`Strada`),
  CONSTRAINT `FK_Tratta_Strada` FOREIGN KEY (`Strada`) REFERENCES `strada` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin5;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tratta`
--

INSERT INTO `tratta` VALUES (1,1,13,NULL,60,43.724365,10.384825,43.724983,10.385480,0,0),(2,1,3,NULL,60,43.657871,10.355366,43.695503,10.385480,0,0),(3,1,3,NULL,60,43.678112,10.299867,43.674423,10.340019,0,0),(4,2,3,3.5,60,43.703598,10.341826,43.716053,10.383434,0,0),(5,3,3,NULL,60,43.724472,10.408491,43.724262,10.410999,0,0),(6,3,4,NULL,60,43.724262,10.410999,43.726517,10.413984,0,0),(7,3,5,2.5,60,43.685726,10.343653,43.686195,10.343953,0,0),(8,3,6,NULL,60,43.686195,10.343953,43.688274,10.345473,0,0),(9,10,1,NULL,50,43.686195,10.343953,43.720375,10.390824,0,0),(10,11,5,NULL,50,43.721695,10.391769,43.719742,10.390406,0,0),(11,9,1,NULL,50,43.721420,10.423150,43.719776,10.425870,0,0);
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tratta_insert_validation` BEFORE INSERT ON `tratta` FOR EACH ROW BEGIN

		DECLARE lunghezza INT;

		

		SET lunghezza =	(SELECT FLOOR(s.Lunghezza)

						FROM strada s

						WHERE s.Id = NEW.Strada);

						

		IF(NEW.Chilometro > lunghezza) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Impossibile inserire la tratta.';

		END IF;

		

		-- Controllo latitudine e longitudine

		IF ((NEW.LatInizio NOT BETWEEN -90 AND 90) OR

			(NEW.LatFine NOT BETWEEN -90 AND 90) OR

			(NEW.LongInizio NOT BETWEEN -180 AND 180) OR

			(NEW.LongFine NOT BETWEEN -180 AND 180))

		THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Impossibile inserire la tratta, controllare le coordinate.';

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

-- Dump completed on 2019-01-30 23:21:29
