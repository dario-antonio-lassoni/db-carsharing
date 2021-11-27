CREATE DATABASE  IF NOT EXISTS `progetto` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `progetto`;
-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: progetto
-- ------------------------------------------------------
-- Server version	5.7.21-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `anagrafica`
--

DROP TABLE IF EXISTS `anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  CONSTRAINT `FK_Anagrafica_Indirizzo` FOREIGN KEY (`Indirizzo`) REFERENCES `indirizzo` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Anagrafica_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anagrafica`
--


--
-- Table structure for table `chiamata`
--

DROP TABLE IF EXISTS `chiamata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  CONSTRAINT `FK_Chiamata_Destinazione` FOREIGN KEY (`Destinazione`) REFERENCES `tratta` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Chiamata_PosAttuale` FOREIGN KEY (`PosizioneAttuale`) REFERENCES `tratta` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Chiamata_Sharing` FOREIGN KEY (`Sharing`) REFERENCES `sharing` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Chiamata_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chiamata`
--

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER chiamata_insert_validation
BEFORE INSERT ON chiamata
FOR EACH ROW
	BEGIN
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
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER chiamata_update_operation
AFTER UPDATE ON chiamata
FOR EACH ROW
	BEGIN
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coinvolgimento` (
  `Sinistro` int(11) NOT NULL,
  `Utente` int(11) NOT NULL,
  PRIMARY KEY (`Sinistro`,`Utente`),
  KEY `FK_coinvolgimento_utente_idx` (`Utente`),
  CONSTRAINT `FK_coinvolgimento_sinistro` FOREIGN KEY (`Sinistro`) REFERENCES `sinistro` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_coinvolgimento_utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coinvolgimento`
--


--
-- Table structure for table `coinvolgimentoesterno`
--

DROP TABLE IF EXISTS `coinvolgimentoesterno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coinvolgimentoesterno` (
  `Sinistro` int(11) NOT NULL,
  `VeicoloEsterno` varchar(50) NOT NULL,
  PRIMARY KEY (`Sinistro`,`VeicoloEsterno`),
  KEY `FK_CE_VeicoloEsterno_idx` (`VeicoloEsterno`),
  CONSTRAINT `FK_CE_Sinistro` FOREIGN KEY (`Sinistro`) REFERENCES `sinistro` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_CE_VeicoloEsterno` FOREIGN KEY (`VeicoloEsterno`) REFERENCES `veicoloesterno` (`Targa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coinvolgimentoesterno`
--


--
-- Table structure for table `corsa`
--

DROP TABLE IF EXISTS `corsa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `corsa` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Chiamata` int(11) NOT NULL,
  `TimestampInizio` timestamp NULL DEFAULT NULL,
  `TimestampFine` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Corsa_Chiamata_idx` (`Chiamata`),
  CONSTRAINT `FK_Corsa_Chiamata` FOREIGN KEY (`Chiamata`) REFERENCES `chiamata` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `corsa`
--


--
-- Table structure for table `criticita`
--

DROP TABLE IF EXISTS `criticita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `criticita` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Tratta` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`),
  KEY `FK_Criticita_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_Criticita_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `criticita`
--


--
-- Table structure for table `documento`
--

DROP TABLE IF EXISTS `documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `documento` (
  `Numero` varchar(10) NOT NULL,
  `Tipologia` enum('patente','cartaidentita') NOT NULL,
  `Ente` varchar(255) NOT NULL,
  `Scadenza` date NOT NULL,
  `Utente` int(11) NOT NULL,
  PRIMARY KEY (`Numero`,`Tipologia`),
  KEY `FK_Documento_Utente_idx` (`Utente`),
  CONSTRAINT `FK_Documento_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documento`
--


--
-- Table structure for table `domandasicurezza`
--

DROP TABLE IF EXISTS `domandasicurezza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domandasicurezza` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Testo` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domandasicurezza`
--


--
-- Table structure for table `fruibilita`
--

DROP TABLE IF EXISTS `fruibilita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fruibilita` (
  `Veicolo` varchar(50) NOT NULL,
  `TimestampInizio` datetime NOT NULL,
  `TimestampFine` datetime NOT NULL,
  PRIMARY KEY (`Veicolo`,`TimestampInizio`),
  CONSTRAINT `FK_Fruibilita_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`Targa`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fruibilita`
--


--
-- Table structure for table `indirizzo`
--

DROP TABLE IF EXISTS `indirizzo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `indirizzo` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Via` varchar(255) NOT NULL,
  `Civico` int(11) NOT NULL,
  `Citta` varchar(50) NOT NULL,
  `Provincia` varchar(50) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `indirizzo`
--


--
-- Table structure for table `intersezione`
--

DROP TABLE IF EXISTS `intersezione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER intersezione_insert_validation
BEFORE INSERT ON intersezione
FOR EACH ROW
BEGIN
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `intersezionitratte` (
  `Tratta` int(11) NOT NULL,
  `Intersezione` int(11) NOT NULL,
  PRIMARY KEY (`Tratta`,`Intersezione`),
  KEY `FK_IT_Intersezione_idx` (`Intersezione`),
  CONSTRAINT `FK_IT_Intersezione` FOREIGN KEY (`Intersezione`) REFERENCES `intersezione` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_IT_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intersezionitratte`
--


--
-- Table structure for table `modello`
--

DROP TABLE IF EXISTS `modello`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modello` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CasaProduttrice` varchar(50) NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Cilindrata` varchar(50) NOT NULL,
  `Alimentazione` enum('Benzina','Diesel','GPL','Elettrica') NOT NULL,
  `SchedaTecnica` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Modello_SchedaTecnica_idx` (`SchedaTecnica`),
  CONSTRAINT `FK_Modello_SchedaTecnica` FOREIGN KEY (`SchedaTecnica`) REFERENCES `schedatecnica` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modello`
--


--
-- Table structure for table `optional`
--

DROP TABLE IF EXISTS `optional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `optional` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nome` varchar(50) NOT NULL,
  `Peso` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `optional`
--


--
-- Table structure for table `optionalveicolo`
--

DROP TABLE IF EXISTS `optionalveicolo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `optionalveicolo` (
  `Veicolo` varchar(50) NOT NULL,
  `Optional` int(11) NOT NULL,
  PRIMARY KEY (`Veicolo`,`Optional`),
  KEY `FK_OpV_Optional_idx` (`Optional`),
  CONSTRAINT `FK_OpV_Optional` FOREIGN KEY (`Optional`) REFERENCES `optional` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_OpV_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`Targa`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `optionalveicolo`
--


--
-- Table structure for table `partecipantipool`
--

DROP TABLE IF EXISTS `partecipantipool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partecipantipool` (
  `Utente` int(11) NOT NULL,
  `Pool` int(11) NOT NULL,
  PRIMARY KEY (`Utente`,`Pool`),
  KEY `FK_PP_Pool_idx` (`Pool`),
  CONSTRAINT `FK_PP_Pool` FOREIGN KEY (`Pool`) REFERENCES `pool` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_PP_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partecipantipool`
--

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER pp_insert_validation
BEFORE INSERT ON partecipantipool
FOR EACH ROW
	BEGIN
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `percorsopool` (
  `Pool` int(11) NOT NULL,
  `Tratta` int(11) NOT NULL,
  PRIMARY KEY (`Pool`,`Tratta`),
  KEY `FK_PerPool_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_PerPool_Pool` FOREIGN KEY (`Pool`) REFERENCES `pool` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_PerPool_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `percorsopool`
--


--
-- Table structure for table `percorsoridesharing`
--

DROP TABLE IF EXISTS `percorsoridesharing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `percorsoridesharing` (
  `Sharing` int(11) NOT NULL,
  `Tratta` int(11) NOT NULL,
  PRIMARY KEY (`Sharing`,`Tratta`),
  KEY `FK_PS_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_PS_Sharing` FOREIGN KEY (`Sharing`) REFERENCES `sharing` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_PS_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `percorsoridesharing`
--


--
-- Table structure for table `percorsovariazione`
--

DROP TABLE IF EXISTS `percorsovariazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `percorsovariazione` (
  `Variazione` int(11) NOT NULL,
  `Tratta` int(11) NOT NULL,
  PRIMARY KEY (`Variazione`,`Tratta`),
  KEY `FK_PV_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_PV_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_PV_Variazione` FOREIGN KEY (`Variazione`) REFERENCES `variazione` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `percorsovariazione`
--


--
-- Table structure for table `pool`
--

DROP TABLE IF EXISTS `pool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pool` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Veicolo` varchar(50) NOT NULL,
  `TimestampPartenza` datetime NOT NULL,
  `TimestampArrivo` datetime NOT NULL,
  `TimestampChiusura` datetime NOT NULL,
  `IndirizzoPartenza` varchar(255) NOT NULL,
  `IndirizzoArrivo` varchar(255) NOT NULL,
  `Flessibilita` enum('bassa','media','alta') NOT NULL DEFAULT 'media',
  `CostoVariazione` double DEFAULT NULL,
  `Costo` double DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Pool_Veicolo_idx` (`Veicolo`),
  CONSTRAINT `FK_Pool_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`Targa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pool`
--

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER pool_insert_validation
BEFORE INSERT ON Pool
FOR EACH ROW
	BEGIN
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
		
		-- Un pool deve restare aperto almeno fino a due ore prima della partenza.
		IF ((NEW.TimestampPartenza - INTERVAL 2 HOUR) < NEW.TimestampChiusura) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Un pool deve restare aperto almeno fino a due ore prima della partenza.';
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prenotazione` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Stato` enum('Accettata','Rifiutata','Pending') NOT NULL DEFAULT 'Pending',
  `Inizio` datetime NOT NULL,
  `Fine` datetime NOT NULL,
  `Utente` int(11) DEFAULT NULL,
  `Veicolo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Prenotazione_Utente_idx` (`Utente`),
  KEY `FK_Prenotazione_Veicolo_idx` (`Veicolo`),
  CONSTRAINT `FK_Prenotazione_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`Id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_Prenotazione_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`Targa`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prenotazione`
--

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER cs_insert_validation
BEFORE INSERT ON Prenotazione
FOR EACH ROW
	BEGIN
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
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER prenotazione_update_validation
BEFORE UPDATE ON prenotazione
FOR EACH ROW
	BEGIN
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
									OR OLD.Fine BETWEEN p.Inizio AND p.Fine));
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
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedatecnica`
--


--
-- Table structure for table `sharing`
--

DROP TABLE IF EXISTS `sharing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sharing` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Veicolo` varchar(50) NOT NULL,
  `TimestampPartenza` datetime NOT NULL,
  `IndirizzoPartenza` varchar(255) NOT NULL,
  `IndirizzoArrivo` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Sharing_Veicolo_idx` (`Veicolo`),
  CONSTRAINT `FK_Sharing_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`Targa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sharing`
--

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER rs_insert_validation
BEFORE INSERT ON Sharing
FOR EACH ROW
	BEGIN
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sinistro` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Tratta` int(11) NOT NULL,
  `Dinamica` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_Sinistro_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_Sinistro_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sinistro`
--


--
-- Table structure for table `stato`
--

DROP TABLE IF EXISTS `stato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stato` (
  `Veicolo` varchar(50) NOT NULL,
  `Chilometraggio` int(11) NOT NULL,
  `Autonomia` int(11) NOT NULL,
  PRIMARY KEY (`Veicolo`,`Chilometraggio`,`Autonomia`),
  CONSTRAINT `FK_Stato_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`Targa`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stato`
--

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER stato_update_validation
BEFORE UPDATE ON stato
FOR EACH ROW
	BEGIN
		DECLARE validita TINYINT DEFAULT 0;
		
		IF((NEW.Autonomia - OLD.Autonomia) > 5) THEN
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `strada` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Tipo` enum('SS','SR','SP','SC','SV') NOT NULL,
  `Lunghezza` double NOT NULL,
  `Numero` int(11) NOT NULL,
  `Categorizzazione` enum('dir','var','racc','radd','bis','ter','quater') DEFAULT NULL,
  `Nome` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `strada`
--


--
-- Table structure for table `trackingattuale`
--

DROP TABLE IF EXISTS `trackingattuale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trackingattuale` (
  `Veicolo` varchar(50) NOT NULL,
  `TimestampIngresso` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TimestampUscita` timestamp NULL DEFAULT NULL,
  `Lat` float(10,6) NOT NULL,
  `Long` float(10,6) NOT NULL,
  `Tratta` int(11) NOT NULL,
  PRIMARY KEY (`Veicolo`,`TimestampIngresso`),
  KEY `FK_AT_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_AT_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_TA_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`Targa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trackingattuale`
--

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tract_insert_validation
BEFORE INSERT ON trackingattuale
FOR EACH ROW
BEGIN
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
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tract_update_validation
BEFORE UPDATE ON trackingattuale
FOR EACH ROW
BEGIN
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

--
-- Table structure for table `trackingstorico`
--

DROP TABLE IF EXISTS `trackingstorico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trackingstorico` (
  `Veicolo` varchar(50) NOT NULL,
  `TimestampIngresso` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TimestampUscita` timestamp NULL DEFAULT NULL,
  `Lat` float(10,6) NOT NULL,
  `Long` float(10,6) NOT NULL,
  `Tratta` int(11) NOT NULL,
  PRIMARY KEY (`Veicolo`,`TimestampIngresso`),
  KEY `FK_TS_Tratta_idx` (`Tratta`),
  CONSTRAINT `FK_TS_Tratta` FOREIGN KEY (`Tratta`) REFERENCES `tratta` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_TS_Veicolo` FOREIGN KEY (`Veicolo`) REFERENCES `veicolo` (`Targa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trackingstorico`
--


--
-- Table structure for table `tratta`
--

DROP TABLE IF EXISTS `tratta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `NPercorsi` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  KEY `FK_Tratta_Strada_idx` (`Strada`),
  CONSTRAINT `FK_Tratta_Strada` FOREIGN KEY (`Strada`) REFERENCES `strada` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tratta`
--

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tratta_insert_validation
BEFORE INSERT ON tratta
FOR EACH ROW
	BEGIN
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
/*!40101 SET character_set_client = utf8 */;
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
  CONSTRAINT `FK_Utente_DomandaSicurezza` FOREIGN KEY (`DomandaSicurezza`) REFERENCES `domandasicurezza` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--


--
-- Table structure for table `valutazione`
--

DROP TABLE IF EXISTS `valutazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  CONSTRAINT `FK_Valutazione_UtenteRecensore` FOREIGN KEY (`UtenteRecensore`) REFERENCES `utente` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Valutazione_UtenteValutato` FOREIGN KEY (`UtenteValutato`) REFERENCES `utente` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `valutazione`
--

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER valutazione_insert_validation
BEFORE INSERT ON valutazione
FOR EACH ROW
	BEGIN
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variazione` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Utente` int(11) NOT NULL,
  `Pool` int(11) NOT NULL,
  `Stato` enum('Accettata','Rifiutata','Pending') NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`Id`),
  KEY `FK_Variazione_Utente_idx` (`Utente`),
  KEY `FK_Variazione_Pool_idx` (`Pool`),
  CONSTRAINT `FK_Variazione_Pool` FOREIGN KEY (`Pool`) REFERENCES `pool` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_Variazione_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variazione`
--

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER variazione_insert_validation
BEFORE INSERT ON variazione
FOR EACH ROW
	BEGIN
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
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER variazione_update_operation
AFTER UPDATE ON variazione
FOR EACH ROW
	BEGIN
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `veicolo` (
  `Targa` varchar(50) NOT NULL,
  `LivelloComfort` double NOT NULL DEFAULT '0',
  `Immatricolazione` date NOT NULL,
  `Modello` int(11) NOT NULL,
  `Utente` int(11) NOT NULL,
  PRIMARY KEY (`Targa`),
  KEY `FK_Veicolo_Modello_idx` (`Modello`),
  KEY `FK_Veicolo_Utente_idx` (`Utente`),
  CONSTRAINT `FK_Veicolo_Modello` FOREIGN KEY (`Modello`) REFERENCES `modello` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Veicolo_Utente` FOREIGN KEY (`Utente`) REFERENCES `utente` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `veicolo`
--


--
-- Table structure for table `veicoloesterno`
--

DROP TABLE IF EXISTS `veicoloesterno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `veicoloesterno` (
  `Targa` varchar(50) NOT NULL,
  `Modello` int(11) NOT NULL,
  PRIMARY KEY (`Targa`),
  KEY `FK_VE_Modello_idx` (`Modello`),
  CONSTRAINT `FK_VE_Modello` FOREIGN KEY (`Modello`) REFERENCES `modello` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `veicoloesterno`
--


--
-- Dumping events for database 'progetto'
--

--
-- Dumping routines for database 'progetto'
--

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
