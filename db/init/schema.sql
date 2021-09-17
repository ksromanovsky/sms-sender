-- MySQL dump 10.13  Distrib 8.0.26, for Linux (x86_64)
--
-- Host: localhost    Database: traf
-- ------------------------------------------------------
-- Server version	8.0.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `adm_id` int NOT NULL AUTO_INCREMENT,
  `adm_login` varchar(15) NOT NULL DEFAULT '',
  `adm_pwd` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`adm_id`),
  UNIQUE KEY `adm_login` (`adm_login`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'admin','21232f297a57a5a743894a0e4a801fc3');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objects`
--

DROP TABLE IF EXISTS `objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `objects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `street` int NOT NULL DEFAULT '0',
  `dom` varchar(5) NOT NULL DEFAULT '',
  `korp` varchar(5) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `object` (`street`,`dom`,`korp`),
  KEY `dom` (`dom`),
  KEY `korp` (`korp`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objects`
--

LOCK TABLES `objects` WRITE;
/*!40000 ALTER TABLE `objects` DISABLE KEYS */;
INSERT INTO `objects` VALUES (1,1,'1',''),(2,1,'2',''),(3,2,'1',''),(4,2,'2',''),(5,3,'1',''),(6,3,'2',''),(7,4,'1',''),(8,4,'2','');
/*!40000 ALTER TABLE `objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objects_city`
--

DROP TABLE IF EXISTS `objects_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `objects_city` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objects_city`
--

LOCK TABLES `objects_city` WRITE;
/*!40000 ALTER TABLE `objects_city` DISABLE KEYS */;
INSERT INTO `objects_city` VALUES (1,'City_one'),(2,'City_two');
/*!40000 ALTER TABLE `objects_city` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objects_streets`
--

DROP TABLE IF EXISTS `objects_streets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `objects_streets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `city` int NOT NULL DEFAULT '1',
  `street` varchar(255) NOT NULL DEFAULT '',
  `streettype` int NOT NULL DEFAULT '0',
  `street_fullname` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `streetinfo` (`city`,`street`,`streettype`),
  KEY `street` (`street`),
  FULLTEXT KEY `street_fullname` (`street_fullname`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objects_streets`
--

LOCK TABLES `objects_streets` WRITE;
/*!40000 ALTER TABLE `objects_streets` DISABLE KEYS */;
INSERT INTO `objects_streets` VALUES (1,1,'Street_one',0,'Street_one'),(2,1,'Street_two',0,'Street_two'),(3,2,'Street_one',0,'Street_one'),(4,2,'Street_two',0,'Street_two');
/*!40000 ALTER TABLE `objects_streets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `id` varchar(20) NOT NULL DEFAULT '',
  `servicetype` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `servicetype` (`servicetype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES ('1','Inet','Internet'),('2','TV','TV');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` int NOT NULL DEFAULT '0',
  `fullname` varchar(100) NOT NULL DEFAULT '',
  `balance` double DEFAULT '0',
  `phone1` varchar(20) NOT NULL DEFAULT '',
  `phone2` varchar(20) NOT NULL DEFAULT '',
  `phone3` varchar(20) NOT NULL DEFAULT '',
  `objid` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `phone1` (`phone1`),
  KEY `phone2` (`phone2`),
  KEY `phone3` (`phone3`),
  KEY `objid` (`objid`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'User1',1000,'','','+79999999999',1),(2,2,'User2',100,'','','+79999999999',1),(3,1,'User3',1000,'','','+79999999999',2),(4,2,'User4',100,'','','+79999999999',2),(5,1,'User5',1000,'','','+79999999999',3),(6,2,'User6',100,'','','+79999999999',3),(7,1,'User7',1000,'','','+79999999999',4),(8,2,'User8',100,'','','+79999999999',4),(9,1,'User9',1000,'','','+79999999999',5),(10,2,'User10',100,'','','+79999999999',5),(11,1,'User11',1000,'','','+79999999999',6),(12,2,'User12',100,'','','+79999999999',6),(13,1,'User13',1000,'','','+79999999999',7),(14,2,'User14',100,'','','+79999999999',7),(15,1,'User15',1000,'','','+79999999999',8),(16,2,'User16',100,'','','+79999999999',8);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_active_status`
--

DROP TABLE IF EXISTS `users_active_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_active_status` (
  `id` int NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_active_status`
--

LOCK TABLES `users_active_status` WRITE;
/*!40000 ALTER TABLE `users_active_status` DISABLE KEYS */;
INSERT INTO `users_active_status` VALUES (1,'Active'),(2,'Deactivated');
/*!40000 ALTER TABLE `users_active_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_services`
--

DROP TABLE IF EXISTS `users_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_services` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int NOT NULL DEFAULT '0',
  `service` varchar(20) NOT NULL DEFAULT '',
  `date_start` datetime NOT NULL DEFAULT '2000-01-01 00:00:01',
  `date_end` datetime NOT NULL DEFAULT '2999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `service` (`service`),
  KEY `date_start` (`date_start`),
  KEY `date_end` (`date_end`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_services`
--

LOCK TABLES `users_services` WRITE;
/*!40000 ALTER TABLE `users_services` DISABLE KEYS */;
INSERT INTO `users_services` VALUES (1,1,'1','2000-01-01 00:00:01','2999-12-31 23:59:59'),(2,2,'1','2000-01-01 00:00:01','2999-12-31 23:59:59'),(3,3,'1','2000-01-01 00:00:01','2999-12-31 23:59:59'),(4,4,'1','2000-01-01 00:00:01','2999-12-31 23:59:59'),(5,5,'1','2000-01-01 00:00:01','2999-12-31 23:59:59'),(6,6,'1','2000-01-01 00:00:01','2999-12-31 23:59:59'),(7,7,'1','2000-01-01 00:00:01','2999-12-31 23:59:59'),(8,8,'1','2000-01-01 00:00:01','2999-12-31 23:59:59'),(9,9,'2','2000-01-01 00:00:01','2999-12-31 23:59:59'),(10,10,'2','2000-01-01 00:00:01','2999-12-31 23:59:59'),(11,11,'2','2000-01-01 00:00:01','2999-12-31 23:59:59'),(12,12,'2','2000-01-01 00:00:01','2999-12-31 23:59:59'),(13,13,'2','2000-01-01 00:00:01','2999-12-31 23:59:59'),(14,14,'2','2000-01-01 00:00:01','2999-12-31 23:59:59'),(15,15,'2','2000-01-01 00:00:01','2999-12-31 23:59:59'),(16,16,'2','2000-01-01 00:00:01','2999-12-31 23:59:59');
/*!40000 ALTER TABLE `users_services` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-09-17 10:22:25
