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

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-01-30 23:21:30
