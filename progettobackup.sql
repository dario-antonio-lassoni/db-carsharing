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
-- Table structure for table `anagrafica`
--

DROP TABLE IF EXISTS `anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `anagrafica` (
  `CodFiscale` varchar(50) NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Cognome` varchar(50) NOT NULL,
  `Telefono` varchar(50) NOT NULL,
  `Utente` int(11) NOT NULL,
  `Indirizzo` int(11) NOT NULL,
  PRIMARY KEY (`CodFiscale`),
  KEY `FK_Anagrafica_Utente_idx` (`Utente`),
  KEY `FK_Anagrafica_Indirizzo_idx` (`Indirizzo`),
  CONSTRAINT `FK_Anagrafica_Indirizzo` FOREIGN KEY (`Indirizzo`) REFERENCES `indirizzo` (`id`),
  CONSTRAINT `FK_Anagrafica_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anagrafica`
--

INSERT INTO `anagrafica` VALUES ('FRNMFR09D21C351V','Manfredi','Franceschi','3490123456',1,1),('GNTMLN05T56A944P','Marilina','Gentile','3481012345',2,5),('LCCLNU06M71A662Q','Luna','Lucci','3201243123',6,4),('LVOJML05B48F205W','Jamila','Oliva','3321234123',5,3),('MNCDRS06A45A944U','Damaris','Manca','3490987654',4,5),('MSCGSM04L71L736D','Gelsomina','Mascia','3481230984',7,1);

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

--
-- Table structure for table `coinvolgimento`
--

DROP TABLE IF EXISTS `coinvolgimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `coinvolgimento` (
  `Sinistro` int(11) NOT NULL,
  `Utente` int(11) NOT NULL,
  PRIMARY KEY (`Sinistro`,`Utente`),
  KEY `FK_coinvolgimento_utente_idx` (`Utente`),
  CONSTRAINT `FK_coinvolgimento_sinistro` FOREIGN KEY (`Sinistro`) REFERENCES `sinistro` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_coinvolgimento_utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coinvolgimento`
--

INSERT INTO `coinvolgimento` VALUES (1,6);

--
-- Table structure for table `coinvolgimentoesterno`
--

DROP TABLE IF EXISTS `coinvolgimentoesterno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `coinvolgimentoesterno` (
  `Sinistro` int(11) NOT NULL,
  `VeicoloEsterno` varchar(50) NOT NULL,
  PRIMARY KEY (`Sinistro`,`VeicoloEsterno`),
  KEY `FK_CE_VeicoloEsterno_idx` (`VeicoloEsterno`),
  CONSTRAINT `FK_CE_Sinistro` FOREIGN KEY (`Sinistro`) REFERENCES `sinistro` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_CE_VeicoloEsterno` FOREIGN KEY (`VeicoloEsterno`) REFERENCES `veicoloesterno` (`targa`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coinvolgimentoesterno`
--

INSERT INTO `coinvolgimentoesterno` VALUES (1,'AC43232'),(1,'AD14323');

--
-- Table structure for table `corsa`
--

DROP TABLE IF EXISTS `corsa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `corsa` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Chiamata` int(11) NOT NULL,
  `TimestampInizio` timestamp NULL DEFAULT NULL,
  `TimestampFine` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Corsa_Chiamata_idx` (`Chiamata`),
  CONSTRAINT `FK_Corsa_Chiamata` FOREIGN KEY (`Chiamata`) REFERENCES `chiamata` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `corsa`
--

INSERT INTO `corsa` VALUES (1,1,'2019-01-29 16:30:00','2019-01-29 18:00:00'),(2,2,'2019-02-07 16:30:00','2019-02-07 18:00:00');

--
-- Table structure for table `criticita`
--

DROP TABLE IF EXISTS `criticita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `criticita` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Tratta` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`),
  KEY `FK_Criticita_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_Criticita_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `criticita`
--

INSERT INTO `criticita` VALUES (1,3,'2019-01-19 16:42:11'),(2,3,'2019-01-20 21:57:32');

--
-- Table structure for table `documento`
--

DROP TABLE IF EXISTS `documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `documento` (
  `Numero` varchar(10) NOT NULL,
  `Tipologia` enum('patente','cartaidentita') NOT NULL,
  `Ente` varchar(255) NOT NULL,
  `Scadenza` date NOT NULL,
  `Utente` int(11) NOT NULL,
  PRIMARY KEY (`Numero`,`Tipologia`),
  KEY `FK_Documento_Utente_idx` (`Utente`),
  CONSTRAINT `FK_Documento_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documento`
--

INSERT INTO `documento` VALUES ('AG 0301234','patente','Comune di Pisa','2021-06-21',4),('AJ 4323434','cartaidentita','Comune di Pisa','2021-08-12',2),('AQ 3134654','patente','Comune di Pisa','2025-01-21',7),('AR 2034323','patente','Comune di Pisa','2025-02-23',5),('AT 2123434','cartaidentita','Comune di Pisa','2023-02-12',6),('AY 5743223','cartaidentita','Comune di Pisa','2022-10-22',1);

--
-- Table structure for table `domandasicurezza`
--

DROP TABLE IF EXISTS `domandasicurezza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `domandasicurezza` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Testo` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domandasicurezza`
--

INSERT INTO `domandasicurezza` VALUES (1,'Il nome del tuo primo animale domestico'),(2,'La città di nascita di tua madre'),(3,'La città di nascita di tuo padre'),(4,'La data di nascita di tua madre'),(5,'La data di nascita di tuo padre'),(6,'Il modello della tua prima auto');

--
-- Table structure for table `fruibilita`
--

DROP TABLE IF EXISTS `fruibilita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `fruibilita` (
  `Veicolo` varchar(50) NOT NULL,
  `TimestampInizio` timestamp NOT NULL,
  `TimestampFine` timestamp NOT NULL,
  PRIMARY KEY (`Veicolo`,`TimestampInizio`),
  CONSTRAINT `FK_Fruibilita_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`targa`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fruibilita`
--

INSERT INTO `fruibilita` VALUES ('AB12345','2019-10-01 10:00:00','2019-10-01 21:00:00'),('AB12345','2019-10-03 10:00:00','2019-01-03 21:30:00'),('AB12345','2019-10-05 10:00:00','2019-01-05 21:30:00'),('BB12345','2019-01-21 16:00:00','2019-01-21 23:00:00');

--
-- Table structure for table `indirizzo`
--

DROP TABLE IF EXISTS `indirizzo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `indirizzo` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Via` varchar(255) NOT NULL,
  `Civico` int(11) NOT NULL,
  `Citta` varchar(50) NOT NULL,
  `Provincia` varchar(50) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `indirizzo`
--

INSERT INTO `indirizzo` VALUES (1,'Viale Francesco Bonaini',12,'Pisa','PI'),(2,'Via Benedetto Croce',2,'Pisa','PI'),(3,'Via Giordano Bruno',17,'Pisa','PI'),(4,'Via Quarantola',3,'Pisa','PI'),(5,'Via Fiorentina',9,'Pisa','PI');

--
-- Table structure for table `intersezione`
--

DROP TABLE IF EXISTS `intersezione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `intersezione` (
  `Id` int(11) NOT NULL,
  `Lat` float(10,6) NOT NULL,
  `Long` float(10,6) NOT NULL,
  `Tipo` enum('Incrocio','Raccordo','Imbocco/Uscita') NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Lat_Long_UNIQUE` (`Lat`,`Long`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intersezione`
--

INSERT INTO `intersezione` VALUES (1,43.234543,10.453533,'Incrocio'),(2,43.122341,10.443544,'Incrocio'),(3,43.544662,10.554645,'Raccordo'),(4,43.234234,10.767668,'Imbocco/Uscita'),(5,43.465446,10.434535,'Raccordo');
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `intersezione_insert_validation` BEFORE INSERT ON `intersezione` FOR EACH ROW BEGIN

	IF ((NEW.Lat NOT BETWEEN -90 AND 90) OR

		(NEW.Long NOT BETWEEN -180 AND 180))

	THEN

		SIGNAL SQLSTATE '45000'

		SET MESSAGE_TEXT = 'Impossibile inserire il record, controllare le coordinate.';

	END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `intersezionitratte`
--

DROP TABLE IF EXISTS `intersezionitratte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `intersezionitratte` (
  `Tratta` int(11) NOT NULL,
  `Intersezione` int(11) NOT NULL,
  PRIMARY KEY (`Tratta`,`Intersezione`),
  KEY `FK_IT_Intersezione_idx` (`Intersezione`),
  CONSTRAINT `FK_IT_Intersezione` FOREIGN KEY (`Intersezione`) REFERENCES `intersezione` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_IT_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intersezionitratte`
--

INSERT INTO `intersezionitratte` VALUES (1,1),(2,1),(3,1),(5,1),(1,2),(3,2),(2,3),(4,5),(9,5),(11,5);

--
-- Table structure for table `modello`
--

DROP TABLE IF EXISTS `modello`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `modello` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CasaProduttrice` varchar(50) NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Cilindrata` varchar(50) NOT NULL,
  `Alimentazione` enum('Benzina','Diesel','GPL','Elettrica') NOT NULL,
  `SchedaTecnica` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Modello_SchedaTecnica_idx` (`SchedaTecnica`),
  CONSTRAINT `FK_Modello_SchedaTecnica` FOREIGN KEY (`SchedaTecnica`) REFERENCES `schedatecnica` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modello`
--

INSERT INTO `modello` VALUES (1,'Abarth','595 1.4 Turbo T-Jet','145','Benzina',1),(2,'Alfa Romeo','Giulietta 1.4T','170','Benzina',2),(3,'Fiat','Punto','170','GPL',3),(4,'Volkswagen','Golf','170','Diesel',4);

--
-- Table structure for table `optional`
--

DROP TABLE IF EXISTS `optional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `optional` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nome` varchar(50) NOT NULL,
  `Peso` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `optional`
--

INSERT INTO `optional` VALUES (1,'Connettività',5),(2,'Bluetooth',3),(3,'Tettuccio in vetro',3),(4,'Tavolini',2),(5,'TV',2),(6,'Navigatore',5),(7,'Vetri oscurati',1),(8,'Rampa disabili',3),(9,'Radio',3),(10,'Lettore CD',4),(11,'Lettore USB',4);

--
-- Table structure for table `optionalveicolo`
--

DROP TABLE IF EXISTS `optionalveicolo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `optionalveicolo` (
  `Veicolo` varchar(50) NOT NULL,
  `Optional` int(11) NOT NULL,
  PRIMARY KEY (`Veicolo`,`Optional`),
  KEY `FK_OpV_Optional_idx` (`Optional`),
  CONSTRAINT `FK_OpV_Optional` FOREIGN KEY (`Optional`) REFERENCES `optional` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_OpV_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`targa`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `optionalveicolo`
--

INSERT INTO `optionalveicolo` VALUES ('CL12213',1),('EA12313',1),('CL12213',2),('EA12313',2),('AB12345',3),('BB12345',3),('AB12345',4),('AB12345',5),('CL12213',5),('EA12313',5),('AB12345',7),('CL12213',7),('EA12313',7),('AB12345',9),('BB12345',9),('CL12213',9),('EA12313',10),('AB12345',11);

--
-- Table structure for table `partecipantipool`
--

DROP TABLE IF EXISTS `partecipantipool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `partecipantipool` (
  `Utente` int(11) NOT NULL,
  `Pool` int(11) NOT NULL,
  PRIMARY KEY (`Utente`,`Pool`),
  KEY `FK_PP_Pool_idx` (`Pool`),
  CONSTRAINT `FK_PP_Pool` FOREIGN KEY (`Pool`) REFERENCES `pool` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_PP_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partecipantipool`
--

INSERT INTO `partecipantipool` VALUES (5,8),(6,8),(5,9),(6,9);
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `pp_insert_validation` BEFORE INSERT ON `partecipantipool` FOR EACH ROW BEGIN

		DECLARE stato_fruitore TINYINT DEFAULT 0;

		DECLARE chiusura_pool DATETIME;

		

		SET stato_fruitore =	(SELECT u.Stato

								FROM utente u

								WHERE u.Id = NEW.Utente);

		

		IF (stato_fruitore = 0) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Prima di prendere parte ad un pool è necessaria la verifica dei documenti.';

		END IF;

		

		-- Un utente può prendere parte ad un pool solo se il pool è aperto

		SET chiusura_pool =	(SELECT p.TimestampChiusura

							FROM pool p

							WHERE p.Id = NEW.Pool);

		

		IF(NOW() > chiusura_pool) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Non puoi prendere parte ad un pool non aperto.';

		END IF;

	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `percorsopool`
--

DROP TABLE IF EXISTS `percorsopool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `percorsopool` (
  `Pool` int(11) NOT NULL,
  `Tratta` int(11) NOT NULL,
  PRIMARY KEY (`Pool`,`Tratta`),
  KEY `FK_PP_Pool_idx` (`Pool`),
  KEY `FK_PP_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_PP_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`id`),
  CONSTRAINT `FK_PP_poo` FOREIGN KEY (`Pool`) REFERENCES `pool` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `percorsopool`
--

INSERT INTO `percorsopool` VALUES (3,5),(3,8),(4,5),(4,8),(5,5),(5,8),(8,9),(8,11),(9,10),(9,11);

--
-- Table structure for table `percorsoridesharing`
--

DROP TABLE IF EXISTS `percorsoridesharing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `percorsoridesharing` (
  `Sharing` int(11) NOT NULL,
  `Tratta` int(11) NOT NULL,
  PRIMARY KEY (`Sharing`,`Tratta`),
  KEY `FK_PS_Sharing_idx` (`Sharing`),
  KEY `FK_PS_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_PS_Sharing` FOREIGN KEY (`Sharing`) REFERENCES `sharing` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_PS_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `percorsoridesharing`
--

INSERT INTO `percorsoridesharing` VALUES (1,3),(1,5),(1,6),(2,2),(2,4),(2,7);

--
-- Table structure for table `percorsovariazione`
--

DROP TABLE IF EXISTS `percorsovariazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `percorsovariazione` (
  `Variazione` int(11) NOT NULL,
  `Tratta` int(11) NOT NULL,
  PRIMARY KEY (`Variazione`,`Tratta`),
  KEY `FK_PV_Variazione_idx` (`Variazione`),
  KEY `FK_PV_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_PV_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`id`),
  CONSTRAINT `FK_PV_Variazione` FOREIGN KEY (`Variazione`) REFERENCES `variazione` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `percorsovariazione`
--

INSERT INTO `percorsovariazione` VALUES (1,3),(2,6);

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

--
-- Table structure for table `schedatecnica`
--

DROP TABLE IF EXISTS `schedatecnica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `schedatecnica` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CostoOperativo` double NOT NULL,
  `CostoUsura` double NOT NULL,
  `VelocitaMax` int(11) NOT NULL,
  `Posti` tinyint(4) NOT NULL,
  `ConsumoMedio` int(11) NOT NULL,
  `ConsumoExtraurbano` int(11) NOT NULL,
  `ConsumoMisto` int(11) NOT NULL,
  `CapacitaSerbatoio` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedatecnica`
--

INSERT INTO `schedatecnica` VALUES (1,344,450,140,4,11,8,9,50),(2,565,700,180,4,10,7,8,60),(3,545,750,180,4,10,7,8,60),(4,567,760,189,4,10,7,8,60);

--
-- Table structure for table `sharing`
--

DROP TABLE IF EXISTS `sharing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `sharing` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Veicolo` varchar(50) NOT NULL,
  `TimestampPartenza` timestamp NOT NULL,
  `IndirizzoPartenza` varchar(255) NOT NULL,
  `IndirizzoArrivo` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Sharing_Veicolo_idx` (`Veicolo`),
  CONSTRAINT `FK_Sharing_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`targa`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sharing`
--

INSERT INTO `sharing` VALUES (1,'BB12345','2019-02-04 16:00:00','Via Alighieri','Lungarno Pacinotti 3'),(2,'EA12313','2019-02-07 16:00:00','Via Diotisalvi','Piazza dei Miracoli');
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `rs_insert_validation` BEFORE INSERT ON `sharing` FOR EACH ROW BEGIN

		DECLARE proponente INT(11);

		DECLARE verificato TINYINT DEFAULT 0;

		SET proponente = (SELECT v.Utente

						FROM veicolo v

						WHERE v.Targa = NEW.Veicolo);

		SET verificato = (SELECT u.Stato

							FROM utente u

							WHERE u.Id = proponente);

							

		IF(verificato = 0) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Prima di offrire un servizio di ride sharing è necessaria la verifica dei documenti.';

		END IF;

	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sinistro`
--

DROP TABLE IF EXISTS `sinistro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `sinistro` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Tratta` int(11) NOT NULL,
  `Dinamica` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Sinistro_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_Sinistro_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sinistro`
--

INSERT INTO `sinistro` VALUES (1,'2019-01-21 18:32:05',2,'Il veicolo esterno non ha rispettato lo stop');

--
-- Table structure for table `stato`
--

DROP TABLE IF EXISTS `stato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `stato` (
  `Veicolo` varchar(50) NOT NULL,
  `Chilometraggio` int(11) NOT NULL,
  `Autonomia` int(11) NOT NULL,
  PRIMARY KEY (`Veicolo`),
  CONSTRAINT `FK_Stato_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`targa`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stato`
--

INSERT INTO `stato` VALUES ('AB12345',20000,400),('BB12345',18034,400);
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `stato_update_validation` BEFORE UPDATE ON `stato` FOR EACH ROW BEGIN

		DECLARE validita TINYINT DEFAULT 0;

		

		IF((OLD.Autonomia - NEW.Autonomia) > 20) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Impossibile restituire il veicolo. Livello di carburante troppo basso.';

		END IF;

	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `strada`
--

DROP TABLE IF EXISTS `strada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `strada` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Tipo` enum('SS','SR','SP','SC','SV') NOT NULL,
  `Lunghezza` double NOT NULL,
  `Numero` int(11) NOT NULL,
  `Categorizzazione` enum('dir','var','racc','radd','bis','ter','quater') DEFAULT NULL,
  `Nome` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `strada`
--

INSERT INTO `strada` VALUES (1,'SS',45,5,'dir','Viale delle Cascine'),(2,'SP',45,224,'dir','Strada Provinciale 224 - Marina di Pisa'),(3,'SS',15,3,'racc','Via Statale 12'),(9,'SP',13,2,'dir','Via Alighieri'),(10,'SC',40,4,'dir','Via Diotisalvi'),(11,'SC',40,4,'dir','Via Bonanno Pisano');

--
-- Table structure for table `trackingattuale`
--

DROP TABLE IF EXISTS `trackingattuale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `trackingattuale` (
  `Veicolo` varchar(50) NOT NULL,
  `TimestampIngresso` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TimestampUscita` timestamp NULL DEFAULT NULL,
  `Lat` float(10,6) NOT NULL,
  `Long` float(10,6) NOT NULL,
  `Tratta` int(11) NOT NULL,
  PRIMARY KEY (`Veicolo`,`TimestampIngresso`),
  KEY `FK_AT_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_AT_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`id`),
  CONSTRAINT `FK_TA_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`targa`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trackingattuale`
--

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tract_insert_validation` BEFORE INSERT ON `trackingattuale` FOR EACH ROW BEGIN

	IF ((NEW.Lat NOT BETWEEN -90 AND 90) OR

		(NEW.Long NOT BETWEEN -180 AND 180))

	THEN

		SIGNAL SQLSTATE '45000'

		SET MESSAGE_TEXT = 'Coordinate non valide.';

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tract_update_validation` BEFORE UPDATE ON `trackingattuale` FOR EACH ROW BEGIN

	IF ((NEW.Lat NOT BETWEEN -90 AND 90) OR

		(NEW.Long NOT BETWEEN -180 AND 180))

	THEN

		SIGNAL SQLSTATE '45000'

		SET MESSAGE_TEXT = 'Coordinate non valide.';

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `move_track_storico` AFTER DELETE ON `trackingattuale` FOR EACH ROW BEGIN
		INSERT INTO trackingstorico
		VALUES (OLD.Veicolo, OLD.TimestampIngresso, OLD.TimestampUscita, OLD.Lat, OLD.Long, OLD.Tratta);
	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `trackingstorico`
--

DROP TABLE IF EXISTS `trackingstorico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `trackingstorico` (
  `Veicolo` varchar(50) NOT NULL,
  `TimestampIngresso` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TimestampUscita` timestamp NULL DEFAULT NULL,
  `Lat` float(10,6) NOT NULL,
  `Long` float(10,6) NOT NULL,
  `Tratta` int(11) NOT NULL,
  PRIMARY KEY (`Veicolo`,`TimestampIngresso`),
  KEY `FK_TS_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_TS_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`id`),
  CONSTRAINT `FK_TS_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`targa`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trackingstorico`
--

INSERT INTO `trackingstorico` VALUES ('AB12345','2019-02-04 11:47:04','2019-02-04 11:47:52',43.523247,44.512432,2),('AB12345','2019-02-04 11:58:27','2019-02-04 11:58:53',43.304565,44.521122,2),('AB12345','2019-02-04 11:58:53','2019-02-04 11:59:02',43.523247,44.512432,1),('AB12345','2019-02-05 13:31:18','2019-02-05 13:31:29',43.323246,44.512432,1),('AB12345','2019-02-05 14:16:45','2019-02-05 14:16:53',43.120457,44.631123,1),('AB12345','2019-02-05 14:16:53','2019-02-05 14:17:54',43.323246,44.512432,3),('AB12345','2019-02-05 14:22:53','2019-02-05 14:23:24',43.204567,44.121124,1),('AB12345','2019-02-05 14:23:24','2019-02-05 14:25:13',43.323246,44.512432,3),('EA12313','2019-02-01 17:01:00','2019-02-01 18:01:00',43.103424,45.102428,1),('EA12313','2019-02-01 18:01:00','2019-02-01 19:00:00',43.413422,45.202431,1),('EA12313','2019-02-01 19:00:00','2019-02-04 11:22:39',43.513424,45.102428,1),('EA12313','2019-02-04 11:22:39','2019-02-04 11:23:08',43.523247,44.512432,1),('EA12313','2019-02-04 11:23:08','2019-02-04 11:23:58',43.523247,44.512432,1),('EA12313','2019-02-04 11:48:40','2019-02-04 11:48:46',43.304565,44.521122,2),('EA12313','2019-02-04 11:48:46','2019-02-04 11:48:53',43.523247,44.512432,2),('EA12313','2019-02-04 11:49:28','2019-02-04 11:49:35',43.523247,44.512432,1),('EA12313','2019-02-04 11:49:51','2019-02-04 11:49:59',43.523247,44.512432,1);

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

--
-- Table structure for table `utente`
--

DROP TABLE IF EXISTS `utente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `utente` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nome` varchar(50) NOT NULL,
  `Password` varchar(64) NOT NULL,
  `DataIscrizione` date NOT NULL,
  `Stato` tinyint(1) DEFAULT '0',
  `Ruolo` enum('proponente','fruitore') NOT NULL,
  `DomandaSicurezza` int(11) NOT NULL,
  `Risposta` varchar(255) NOT NULL,
  `Affidabilita` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Nome_UNIQUE` (`Nome`),
  KEY `FK_Utente_DomandaSicurezza_idx` (`DomandaSicurezza`),
  CONSTRAINT `FK_Utente_DomandaSicurezza` FOREIGN KEY (`DomandaSicurezza`) REFERENCES `domandasicurezza` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

INSERT INTO `utente` VALUES (1,'aaa','abc','2017-01-18',0,'proponente',4,'risposta1',0),(2,'bbb','abcd','2017-01-18',1,'proponente',1,'risposta1',0),(4,'nnn','abc','2017-01-18',0,'fruitore',1,'risposta1',0),(5,'nnv','abc','2017-01-18',1,'fruitore',1,'risposta1',0),(6,'nnbb','abc','2017-01-18',1,'fruitore',1,'risposta1',0),(7,'gra','123456','2018-01-04',1,'proponente',6,'rispDom1',0);

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

--
-- Table structure for table `variazione`
--

DROP TABLE IF EXISTS `variazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `variazione` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Utente` int(11) NOT NULL,
  `Pool` int(11) NOT NULL,
  `Stato` enum('Accettata','Rifiutata','Pending') NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`Id`),
  KEY `FK_Variazione_Utente_idx` (`Utente`),
  KEY `FK_Variazione_Pool_idx` (`Pool`),
  CONSTRAINT `FK_Variazione_Pool` FOREIGN KEY (`Pool`) REFERENCES `pool` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_Variazione_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variazione`
--

INSERT INTO `variazione` VALUES (1,5,8,'Accettata'),(2,6,9,'Rifiutata');
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `variazione_insert_validation` BEFORE INSERT ON `variazione` FOR EACH ROW BEGIN

		DECLARE stato_fruitore TINYINT DEFAULT 0;

		DECLARE chiusura_pool DATETIME;

		

		SET stato_fruitore =	(SELECT u.Stato

								FROM utente u

								WHERE u.Id = NEW.Utente);

		

		IF (stato_fruitore = 0) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Prima di richiedere una variazione per un pool è necessaria la verifica dei documenti.';

		END IF;

		

		-- Un utente può prendere parte ad un pool solo se il pool è aperto

		SET chiusura_pool =	(SELECT p.TimestampChiusura

							FROM pool p

							WHERE p.Id = NEW.Pool);

		

		IF(NOW() > chiusura_pool) THEN

			SIGNAL SQLSTATE '45000'

			SET MESSAGE_TEXT = 'Non puoi richiedere una variazione per un pool non aperto.';

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `variazione_update_operation` AFTER UPDATE ON `variazione` FOR EACH ROW BEGIN

		IF(NEW.Stato = 'Accettata') THEN

			INSERT INTO partecipantipool

			VALUES (OLD.Utente, OLD.Pool);

		END IF;

	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `veicolo`
--

DROP TABLE IF EXISTS `veicolo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `veicolo` (
  `Targa` varchar(50) NOT NULL,
  `LivelloComfort` double NOT NULL DEFAULT '-1',
  `Immatricolazione` date NOT NULL,
  `Modello` int(11) NOT NULL,
  `Utente` int(11) NOT NULL,
  PRIMARY KEY (`Targa`),
  KEY `FK_Veicolo_Modello_idx` (`Modello`),
  KEY `FK_Veicolo_Utente_idx` (`Utente`),
  CONSTRAINT `FK_Veicolo_Modello` FOREIGN KEY (`Modello`) REFERENCES `modello` (`id`),
  CONSTRAINT `FK_Veicolo_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `veicolo`
--

INSERT INTO `veicolo` VALUES ('AB12345',2.5,'2017-02-09',1,1),('BB12345',3,'2017-02-09',1,2),('CL12213',2.8,'2017-02-09',1,1),('EA12313',3,'2017-08-19',2,7);

--
-- Table structure for table `veicoloesterno`
--

DROP TABLE IF EXISTS `veicoloesterno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `veicoloesterno` (
  `Targa` varchar(50) NOT NULL,
  `Modello` varchar(50) NOT NULL,
  PRIMARY KEY (`Targa`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `veicoloesterno`
--

INSERT INTO `veicoloesterno` VALUES ('AC43232','2'),('AD14323','1');

--
-- Dumping events for database 'progetto2'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `update_affidabilita_fruitore` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `update_affidabilita_fruitore` ON SCHEDULE EVERY 1 DAY STARTS '2019-01-17 23:55:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL update_aff_fruit() */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `update_affidabilita_proponente` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `update_affidabilita_proponente` ON SCHEDULE EVERY 1 DAY STARTS '2019-01-17 23:55:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL update_aff_prop() */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `update_avg_percorrenza` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `update_avg_percorrenza` ON SCHEDULE EVERY 1 DAY STARTS '2019-01-17 23:55:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL update_avg_percorrenza() */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `update_comfort_level` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `update_comfort_level` ON SCHEDULE EVERY 1 DAY STARTS '2019-01-17 23:55:00' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE Veicolo v
	SET LivelloComfort = (SELECT IFNULL(AVG(o.Peso), 0)
						FROM	optionalveicolo op
								INNER JOIN optional o
                                ON op.Optional = o.Id
						WHERE op.Veicolo = v.Targa)
	WHERE v.LivelloComfort = -1 */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'progetto2'
--
/*!50003 DROP FUNCTION IF EXISTS `get_affidabilita_fruit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_affidabilita_fruit`(u_id INT(11)) RETURNS double
BEGIN
		-- MI SERVONO NUMERO DI SINISTRI, NUMERO DI INFRAZIONI, NUMERO DI RITARDI E VALUTAZIONE MEDIA
		DECLARE nSinistri INT DEFAULT 0;
		DECLARE nInfrazioni INT DEFAULT 0;
		DECLARE nRitardi INT DEFAULT 0;
		DECLARE avgValutazioni DOUBLE DEFAULT 0.0;
		
		SET nSinistri =	(SELECT	IFNULL(COUNT(*), 0)
						FROM	coinvolgimento c
						WHERE	c.Utente = u_id);
						
		SET	avgValutazioni = 	(SELECT	IFNULL(AVG((v.Piacere + v.Persona + v.Serieta + v.Comportamento)/4), 0)
								FROM	valutazione v
								WHERE	v.UtenteValutato = u_id);
		
		SET nRitardi =	(SELECT IFNULL(COUNT(*), 0)
						FROM	prenotazione p
						WHERE	p.Utente = u_id
								AND DATE(p.Inizio) = DATE(NOW())
								AND p.Fine + INTERVAL 30 MINUTE < get_last_timestamp(p.Inizio, p.Veicolo));	
								
		SET nInfrazioni =	(SELECT IFNULL(COUNT(*), 0)
							FROM	prenotazione p INNER JOIN 
									(SELECT 	D.*, IF(@v = D.Veicolo AND @old_tu = TO_DAYS(D.TimestampIngresso),
														get_distance(@old_lat, @old_lon, D.lat + LEAST(0, @old_lat := D.Lat), D.Long + LEAST(0, @old_lon := D.Long)) + LEAST(0, @v := D.Veicolo) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)),
														NULL + LEAST(0, @v := D.Veicolo) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)) + LEAST(0, @old_lat := D.Lat) + LEAST (0, @old_lon := D.Long)) AS kmPercorsi

									FROM	(SELECT 	*
											FROM	trackingstorico ts
											ORDER BY	ts.Veicolo, ts.TimestampIngresso ASC) AS D,
											(SELECT (@v := '')) AS N, (SELECT (@old_tu := '')) AS N1, (SELECT (@old_lat := '')) AS N2, (SELECT (@old_lon := '')) AS N3) AS tt
									ON	p.Veicolo = tt.Veicolo
							WHERE	p.Stato = 'Accettata'
									AND p.Utente = u_id
									AND	(tt.TimestampIngresso >= p.Inizio
									AND tt.TimestampUscita <= get_last_timestamp(p.Inizio, p.Veicolo))
									-- TRATTE CON INFRAZIONI
									AND tt.kmPercorsi/((UNIX_TIMESTAMP(tt.TimestampUscita) - UNIX_TIMESTAMP(tt.TimestampIngresso))/3600) 
									>	(SELECT t.LimiteVelocita
										FROM Tratta t
										WHERE t.Id = tt.Tratta));
                                        
		RETURN	IF((avgValutazioni - 0.025*nInfrazioni - 0.025*nRitardi - 0.025*nSinistri) < 0,
					0.1,
					avgValutazioni - 0.025*nInfrazioni - 0.025*nRitardi - 0.025*nSinistri);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_affidabilita_prop` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_affidabilita_prop`(u_id INT(11)) RETURNS double
BEGIN
		-- MI SERVONO NUMERO DI INFRAZIONI, VALUTAZIONI
		DECLARE nInfrazioni INT DEFAULT 0;
		DECLARE avgValutazioni DOUBLE DEFAULT 0.0;
									
		SET nInfrazioni =	(SELECT	COUNT(*)
							FROM	_rankingProponenti rp INNER JOIN 
									(SELECT 	D.*, IF(@v = D.Veicolo AND @old_tu = TO_DAYS(D.TimestampIngresso),
									get_distance(@old_lat, @old_lon, D.lat + LEAST(0, @old_lat := D.Lat), D.Long + LEAST(0, @old_lon := D.Long)) + LEAST(0, @v := D.Veicolo) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)),
									NULL + LEAST(0, @v := D.Veicolo) + LEAST(0, @old_tu := TO_DAYS(D.TimestampUscita)) + LEAST(0, @old_lat := D.Lat) + LEAST (0, @old_lon := D.Long)) AS kmPercorsi

									FROM	(SELECT 	*
											FROM	trackingstorico ts
											ORDER BY	ts.Veicolo, ts.TimestampIngresso ASC) AS D,
											(SELECT (@v := '')) AS N, (SELECT (@old_tu := '')) AS N1, (SELECT (@old_lat := '')) AS N2, (SELECT (@old_lon := '')) AS N3) AS D1
									ON D1.Veicolo = rp.Veicolo
                                    
									-- DISTANZA (IN KM) / Tempo di percorrenza in ore
							WHERE	D1.kmPercorsi IS NOT NULL AND
									D1.kmPercorsi/((UNIX_TIMESTAMP(D1.TimestampUscita) - UNIX_TIMESTAMP(D1.TimestampIngresso))/3600) 
									>	(SELECT t.LimiteVelocita
										FROM Tratta t
										WHERE t.Id = D1.Tratta));
		
		SET avgValutazioni =	(SELECT	IFNULL(AVG((v.Piacere + v.Persona + v.Serieta + v.Comportamento)/4), 0)
								FROM	valutazione v
								WHERE	v.UtenteValutato = u_id);		
								
		RETURN IF((avgValutazioni - 0.025*nInfrazioni) < 0,
					0.1,
					avgValutazioni - 0.025*nInfrazioni);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_distance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_distance`(latA FLOAT(10,6), lonA FLOAT(10,6), latB FLOAT(10,6), lonB FLOAT(10,6)) RETURNS double
    DETERMINISTIC
BEGIN
		RETURN (6372.795477598 * ACOS(SIN(RADIANS(latA)) * SIN(RADIANS(latB)) + COS(RADIANS(latA)) * COS(RADIANS(latB)) * COS(RADIANS(lonA)-RADIANS(lonB))));
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_last_timestamp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_last_timestamp`(t DATETIME, v VARCHAR(50)) RETURNS timestamp
    DETERMINISTIC
BEGIN
		RETURN 	(SELECT MIN(ts.TimestampUscita)
				FROM	trackingstorico ts
				WHERE	ts.Veicolo = v
						AND	ts.TimestampIngresso > t -- t inizio prenotazione
						AND NOT EXISTS (SELECT 	*
										FROM	trackingstorico ts1
										WHERE	ts1.Veicolo = v
											AND ts1.TimestampIngresso = ts.TimestampUscita));
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_Lat` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_Lat`(v VARCHAR(50), t TIMESTAMP) RETURNS float(10,6)
    DETERMINISTIC
BEGIN
		RETURN (SELECT	ts.Lat
				FROM	trackingstorico ts
				WHERE	ts.Veicolo = v
						AND ts.TimestampUscita = t);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_Lon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_Lon`(v VARCHAR(50), t TIMESTAMP) RETURNS float(10,6)
    DETERMINISTIC
BEGIN
		RETURN (SELECT	ts.Long
				FROM	trackingstorico ts
				WHERE	ts.Veicolo = v
						AND ts.TimestampUscita = t);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `close_track` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `close_track`(IN v VARCHAR(50), IN id_tratta INT(11), IN timestamp_ingresso TIMESTAMP, IN lat FLOAT(10,6), IN lon FLOAT(10,6))
BEGIN
		-- Aggiorno l'ultimo record
		UPDATE trackingattuale ta
		SET	ta.Lat = lat,
			ta.Long = lon,
			ta.TimestampUscita = CURRENT_TIMESTAMP
		WHERE
			ta.Veicolo = v
			AND	ta.TimestampIngresso = timestamp_ingresso;
			
		-- ELIMINO I RECORD DAL TRACKING ATTUALE, IL TRIGGER LI RICOPIA NELLO STORICO
		DELETE
		FROM	trackingattuale
		WHERE	Veicolo = v;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_pool` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_pool`(IN p_car VARCHAR(50), IN p_start DATETIME, IN p_end DATETIME, IN p_close DATETIME, IN p_indirizzo_start VARCHAR(255), IN p_indirizzo_end VARCHAR(255), IN p_flessibilita ENUM('bassa', 'media', 'alta'), IN p_var_cost DOUBLE)
BEGIN
		INSERT INTO pool
		(Veicolo, TimestampPartenza, TimestampArrivo, TimestampChiusura, IndirizzoPartenza, IndirizzoArrivo, Flessibilita, CostoVariazione)
		VALUES (p_car, p_start, p_end, p_close, p_indirizzo_start, p_indirizzo_end, p_flessibilita, p_var_cost);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_spesa_pool` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_spesa_pool`(IN id_pool INT(11))
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
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_carsharing_reservation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_carsharing_reservation`(IN r_start DATETIME, IN r_end DATETIME, IN r_user INT(11), IN r_car VARCHAR(50), OUT success BOOLEAN)
BEGIN
		DECLARE dateValidity TINYINT DEFAULT 0;
		
		SET success = FALSE;
		-- Controllo la disponibilità
		SET dateValidity = (SELECT 	IFNULL(COUNT(*), 0)
							FROM	prenotazione p
							WHERE	p.Stato = 'Accettata'
									AND (r_start BETWEEN p.Inizio AND p.Fine
										OR r_end BETWEEN	p.Inizio AND p.Fine
										OR	p.Inizio BETWEEN r_start AND r_end
										));
		IF(dateValidity = 0) THEN
			-- Controllo la fruibilita
			SET dateValidity = (SELECT 	IFNULL(COUNT(*), 0)
								FROM	fruibilita f
								WHERE	f.veicolo = r_car
										AND	(DAYOFWEEK(r_start) = DAYOFWEEK(f.TimestampInizio)
											AND
											DATE_FORMAT(f.TimestampInizio, '%T') <= DATE_FORMAT(r_start, '%T')
											AND DATE_FORMAT(f.TimestampFine, '%T') >= DATE_FORMAT(r_end, '%T')));
			
			
			IF(dateValidity <> 0) THEN
				-- Ci sono i presupposti per inserire la prenotazione
				INSERT INTO prenotazione
				(Inizio, Fine, Utente, Veicolo)
				VALUES (r_start, r_end, r_user, r_car);
				
				SET success = TRUE;
			END IF;
		END IF;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_new_track` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_new_track`(IN v VARCHAR(50), IN id_tratta INT(11), IN lat FLOAT(10,6), IN lon FLOAT(10,6),IN old_time TIMESTAMP, OUT t_percorrenza DOUBLE, OUT c_time TIMESTAMP)
BEGIN
		SET c_time = CURRENT_TIMESTAMP;
		
		-- INSERISCO IL NUOVO RECORD
		INSERT
		INTO	trackingattuale
		VALUES	(v, c_time, NULL, lat, lon, id_tratta);
		
		-- AGGIORNO IL VECCHIO RECORD (SE ESISTE)
		IF (old_time IS NOT NULL) THEN
			SET SQL_SAFE_UPDATES = 0;
			UPDATE	trackingattuale 
			SET TimestampUscita = c_time
			WHERE	Veicolo = v
					AND TimestampIngresso = old_time;
		END IF;
		
		-- RESTITUISCO IL TEMPO MEDIO DI PERCORRENZA SULLA NUOVA TRATTA
		SET t_percorrenza = (SELECT t.avgPercorrenza
							FROM tratta t
							WHERE t.Id = id_tratta);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_pool_track` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pool_track`(IN p_id INT(11), track INT(11))
BEGIN
		INSERT INTO percorsopool (Pool, Tratta)
		VALUES (p_id, p_track);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_ridesharing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_ridesharing`(IN sh_v VARCHAR(50), IN sh_start DATETIME, IN sh_ind_start VARCHAR(255), IN sh_ind_end VARCHAR(255))
BEGIN
		INSERT INTO sharing (Veicolo, TimestampPartenza, IndirizzoPartenza, IndirizzoArrivo)
		VALUES (sh_v, sh_start, sh_ind_start, sh_ind_end);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_ridesharing_call` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_ridesharing_call`(IN sh_id INT(11), IN u_id INT(11), IN pos_act INT(11), IN dest INT(11))
BEGIN
		INSERT INTO chiamata (Sharing, Utente, PosizioneAttuale, Destinazione)
		VALUES (sh_id, u_id, pos_act, dest);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_ridesharing_track` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_ridesharing_track`(IN sh_id INT(11), track INT(11))
BEGIN
		INSERT INTO percorsoridesharing (Pool, Tratta)
		VALUES (sh_id, sh_track);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_valutation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_valutation`(IN vl_piacere DOUBLE, IN vl_persona DOUBLE, IN vl_serieta DOUBLE, IN vl_comportamento DOUBLE, IN vl_rec VARCHAR(255), IN vl_ind_start VARCHAR(255), IN vl_ind_end VARCHAR(255), IN vl_u_val INT(11), IN vl_u_rec INT(11))
BEGIN
		INSERT INTO valutazione (Piacere, Persona, Serieta, Comportamento, Recensione, IndirizzoPartenza, IndirizzoArrivo, UtenteValutato, UtenteRecensore)
		VALUES (vl_piacere, vl_persona, vl_serieta, vl_comportamento, vl_rec, vl_ind_start, vl_ind_end, vl_u_val, vl_u_rec);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pool_advanced_research` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `pool_advanced_research`(IN fless ENUM('bassa', 'media', 'alta'), IN latA FLOAT(10,6), IN lonA FLOAT(10,6), IN latB FLOAT(10,6), IN lonB FLOAT(10,6))
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
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_aff_fruit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_aff_fruit`()
BEGIN
	-- COSTRUISCO UNA TABELLA CONTENENTE I VEICOLI UTILIZZATI ED I FRUITORI
	-- MI SERVONO LE PRENOTAZIONI DI CAR SHARING, I PARTECIPANTI POOL E LE CHIAMATE RIDE SHARING
			
		UPDATE Utente u
		SET Affidabilita = get_affidabilita_fruit(u.Id)
		WHERE u.Id IN 	( -- FRUITORI GIORNATA
						-- FRUITORI CAR SHARING
						SELECT 	DISTINCT(p.Utente)
						FROM 	Prenotazione p
						WHERE 	p.Stato = 'Accettata'
								AND DATE(p.Inizio) = DATE(NOW())
						UNION
						-- FRUITORI POOL
						SELECT 	DISTINCT(pp.Utente)
						FROM	partecipantipool pp
						WHERE	pp.Pool IN 	(SELECT p1.Id
											FROM 	pool p1
											WHERE 	DATE(p1.TimestampPartenza) = DATE(NOW()))
						UNION
						-- FRUITORI RIDE SHARING
						SELECT 	DISTINCT(c.Utente)
						FROM	chiamata c
						WHERE	c.Sharing IN 	(SELECT s.Id
												FROM	sharing s
												WHERE 	DATE(s.TimestampPartenza) = DATE(NOW()))
						);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_aff_prop` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_aff_prop`()
BEGIN
		-- COSTRUISCO UNA TABELLA CONTENENTE I VEICOLI UTILIZZATI ED I PROPRIETARI
		CREATE TEMPORARY TABLE IF NOT EXISTS _rankingProponenti (
			Utente INT(11) NOT NULL,
			Veicolo VARCHAR(50) NOT NULL,
			PRIMARY KEY(Utente, Veicolo)
		)ENGINE=InnoDb DEFAULT CHARSET=latin1;

		TRUNCATE TABLE _rankingProponenti;

		INSERT INTO _rankingProponenti
			(SELECT DISTINCT v.Utente, v.Targa
			FROM	pool p INNER JOIN veicolo v
					ON p.Veicolo = v.Targa
			WHERE	DATE(p.TimestampPartenza)= DATE(NOW()))
			UNION
			(SELECT DISTINCT v1.Utente, v1.Targa
			FROM	sharing s INNER JOIN veicolo v1
					ON s.Veicolo = v1.Targa
			WHERE 	DATE(s.TimestampPartenza) = DATE(NOW()));

		-- Aggiorno l'affidabilità degli utenti finiti nella tabella
        
		UPDATE Utente u
		SET Affidabilita = get_affidabilita_prop(u.Id) 
		WHERE u.Id IN (	-- PROPONENTI GIORNATA
						SELECT DISTINCT v.Utente
						FROM	pool p INNER JOIN veicolo v
								ON p.Veicolo = v.Targa
						WHERE	DATE(p.TimestampPartenza) = DATE(NOW())
						
						UNION
						
						SELECT DISTINCT v1.Utente
						FROM	sharing s INNER JOIN veicolo v1
								ON s.Veicolo = v1.Targa
						WHERE 	DATE(s.TimestampPartenza) = DATE(NOW()));
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_avg_percorrenza` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_avg_percorrenza`()
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
		
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_track` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_track`(IN v VARCHAR(50), IN id_tratta INT(11), IN timestamp_ingresso TIMESTAMP, IN lat FLOAT(10, 6), IN lon FLOAT(10,6), IN t_percorrenza DOUBLE)
BEGIN
		DECLARE crit TINYINT DEFAULT 0;
		
		-- Rilevamento criticità
		-- Controllo se è stata registrata una criticità su questa tratta nell'ultima ora (se è disponibile un tempo medio di percorrenza)
		IF(t_percorrenza > 0) THEN
			SET crit = (SELECT	IFNULL(COUNT(*), 0)
						FROM	criticita c
						WHERE	c.Tratta = id_tratta
								AND	c.Timestamp >= NOW() - INTERVAL 1 HOUR);
								
			IF crit = 0 THEN
				-- Se rilevo un ritardo corposo (1 minuto), lo segnalo
				
				IF((UNIX_TIMESTAMP(CURRENT_TIMESTAMP) - UNIX_TIMESTAMP(timestamp_ingresso)) > t_percorrenza + 60) THEN
					INSERT INTO criticita
					(Tratta, Timestamp)
					VALUES (id_tratta, CURRENT_TIMESTAMP);
				END IF;
			END IF;
		END IF;
		
		-- Aggiorno il record attuale
		UPDATE 	trackingattuale ta
		SET		ta.TimestampUscita = CURRENT_TIMESTAMP,
				ta.Lat = lat,
				ta.Long = lon
		WHERE	ta.Veicolo = v
				AND ta.TimestampIngresso = timestamp_ingresso;	
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_v_state` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_v_state`(IN v VARCHAR(50), IN km INT(11), IN aut INT(11))
BEGIN
		UPDATE 	stato
		SET	 	Chilometraggio = km, Autonomia = aut
		WHERE 	Veicolo = v;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_login_validation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_login_validation`(IN u_name VARCHAR(50), IN u_password VARCHAR(50), OUT success BOOLEAN)
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
	END ;;
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

-- Dump completed
