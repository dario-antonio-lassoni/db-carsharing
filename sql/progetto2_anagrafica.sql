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

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-01-30 23:21:30
