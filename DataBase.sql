-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1:3306
-- Üretim Zamanı: 21 Ara 2023, 14:40:03
-- Sunucu sürümü: 8.0.31
-- PHP Sürümü: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `burak_atac`
--

DELIMITER $$
--
-- Yordamlar
--
DROP PROCEDURE IF EXISTS ` Max Kol Ölçüm`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE ` Max Kol Ölçüm` ()   SELECT uyeler.Uye_Ad,uyeler.Uye_Soyad,olcumler.Kol
FROM uyeler
JOIN uye_olcumler on uyeler.Uye_ID=uye_olcumler.Uye_ID
JOIN olcumler on uye_olcumler.Olcum_ID=olcumler.Olcum_ID
ORDER by olcumler.kol Desc 
LIMIT 1$$

DROP PROCEDURE IF EXISTS `2 Boy Arası`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `2 Boy Arası` (IN `boy1` INT(255), IN `boy2` INT(255))   SELECT uyeler.Uye_Ad,uyeler.Uye_Soyad,olcumler.*
FROM uyeler,uye_olcumler,olcumler
WHERE uyeler.Uye_ID=uye_olcumler.Uye_ID
and olcumler.Olcum_ID=uye_olcumler.Olcum_ID
and olcumler.Boy BETWEEN boy1 and boy2$$

DROP PROCEDURE IF EXISTS `A Olan Olcum`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `A Olan Olcum` ()   SELECT uyeler.Uye_Ad,olcumler.*
FROM uyeler,uye_olcumler,olcumler
WHERE uyeler.Uye_ID=uye_olcumler.Uye_ID 
and olcumler.Olcum_ID=uye_olcumler.Olcum_ID
and uyeler.Uye_Ad LIKE '%a%'$$

DROP PROCEDURE IF EXISTS `Antrenor_Bulma`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Antrenor_Bulma` (IN `UyeAd` VARCHAR(255))   SELECT antrenorler.*
    FROM uyeler
    JOIN uye_antrenor ON uyeler.Uye_ID = uye_antrenor.Uye_ID
    JOIN antrenorler ON uye_antrenor.Antrenorler_ID = antrenorler.Antrenorler_ID
    WHERE uyeler.Uye_Ad = Uyead$$

DROP PROCEDURE IF EXISTS `İsim_Diyetisyen_Alma`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `İsim_Diyetisyen_Alma` (IN `isim` VARCHAR(55))   SELECT uyeler.Uye_Ad,diyetisyenler.Diyetisyen_Ad,diyetisyenler.Diyetisyen_Soyad
    FROM uyeler
    JOIN uye_diyetisyen ON uyeler.Uye_ID = uye_diyetisyen.Uye_ID
    JOIN diyetisyenler ON uye_diyetisyen.Diyetisyen_ID = diyetisyenler.Diyetisyen_ID
    WHERE uyeler.Uye_Ad = isim$$

DROP PROCEDURE IF EXISTS `İsim_Ekgıda_Alma`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `İsim_Ekgıda_Alma` (IN `isim` VARCHAR(255))   SELECT ek_gidalar.Gida_Ad
    FROM uyeler
    JOIN uye_ek_gida ON uyeler.Uye_ID = uye_ek_gida.Uye_ID
    JOIN ek_gidalar ON uye_ek_gida.Gida_ID = ek_gidalar.Gida_ID
    WHERE uyeler.Uye_Ad = isim$$

DROP PROCEDURE IF EXISTS `İsim_Olcum_Alma`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `İsim_Olcum_Alma` (IN `isim` VARCHAR(255))   SELECT olcumler.*
    FROM uyeler
    JOIN uye_olcumler ON uyeler.Uye_ID = uye_olcumler.Uye_ID
    JOIN olcumler ON uye_olcumler.Olcum_ID = olcumler.Olcum_ID
    WHERE uyeler.Uye_Ad = isim$$

DROP PROCEDURE IF EXISTS `Program_Bulma`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Program_Bulma` (IN `isim` VARCHAR(255))   SELECT programlar.Program_Ad
    FROM uyeler
    JOIN uye_program ON uyeler.Uye_ID = uye_program.Uye_ID
    JOIN programlar ON uye_program.Program_ID = programlar.Program_ID
    WHERE uyeler.Uye_Ad = isim$$

DROP PROCEDURE IF EXISTS `Tüm Antrenorler`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Tüm Antrenorler` ()   SELECT uyeler.Uye_Ad,antrenorler.Antrenorler_Ad
FROM uyeler,antrenorler,uye_antrenor
WHERE uyeler.Uye_ID=uye_antrenor.Uye_ID and antrenorler.Antrenorler_ID=uye_antrenor.Antrenorler_ID$$

DROP PROCEDURE IF EXISTS `Tüm Üye Ek Gıdaları`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Tüm Üye Ek Gıdaları` ()   SELECT uyeler.Uye_Ad,ek_gidalar.Gida_Ad
FROM uyeler,ek_gidalar,uye_ek_gida
WHERE uyeler.Uye_ID=uye_ek_gida.Uye_ID and ek_gidalar.Gida_ID=uye_ek_gida.Gida_ID$$

DROP PROCEDURE IF EXISTS `Yas Ortalama`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Yas Ortalama` ()   SELECT ROUND(AVG(DATEDIFF(CURDATE(), olcumler.DogumTarihi) / 365)) as ortalama_Yas
FROM olcumler$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `antrenorler`
--

DROP TABLE IF EXISTS `antrenorler`;
CREATE TABLE IF NOT EXISTS `antrenorler` (
  `Antrenorler_ID` int NOT NULL AUTO_INCREMENT,
  `Antrenorler_Ad` varchar(50) DEFAULT NULL,
  `Antrenorler_Soyad` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Antrenorler_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `antrenorler`
--

INSERT INTO `antrenorler` (`Antrenorler_ID`, `Antrenorler_Ad`, `Antrenorler_Soyad`) VALUES
(1, 'Burak', 'Ataç'),
(2, 'Fatih', 'Özdemir');

--
-- Tetikleyiciler `antrenorler`
--
DROP TRIGGER IF EXISTS `Eski_hocalar`;
DELIMITER $$
CREATE TRIGGER `Eski_hocalar` BEFORE DELETE ON `antrenorler` FOR EACH ROW INSERT INTO eski_antrenorler VALUES (old.Antrenorler_ID, old.Antrenorler_Ad, old.Antrenorler_Soyad,now())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `diyet`
--

DROP TABLE IF EXISTS `diyet`;
CREATE TABLE IF NOT EXISTS `diyet` (
  `Diyet_ID` int NOT NULL AUTO_INCREMENT,
  `Diyet_Ad` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Diyet_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `diyet`
--

INSERT INTO `diyet` (`Diyet_ID`, `Diyet_Ad`) VALUES
(1, 'Kilo Alma'),
(2, 'Kilo Verme'),
(3, 'Kilo Koruma');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `diyetisyenler`
--

DROP TABLE IF EXISTS `diyetisyenler`;
CREATE TABLE IF NOT EXISTS `diyetisyenler` (
  `Diyetisyen_ID` int NOT NULL AUTO_INCREMENT,
  `Diyetisyen_Ad` varchar(50) DEFAULT NULL,
  `Diyetisyen_Soyad` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Diyetisyen_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `diyetisyenler`
--

INSERT INTO `diyetisyenler` (`Diyetisyen_ID`, `Diyetisyen_Ad`, `Diyetisyen_Soyad`) VALUES
(1, 'Umut', 'Özdemir'),
(2, 'Çağla', 'Uygur'),
(3, 'Turan', 'İbrim');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `ek_gidalar`
--

DROP TABLE IF EXISTS `ek_gidalar`;
CREATE TABLE IF NOT EXISTS `ek_gidalar` (
  `Gida_ID` int NOT NULL AUTO_INCREMENT,
  `Gida_Ad` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Gida_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `ek_gidalar`
--

INSERT INTO `ek_gidalar` (`Gida_ID`, `Gida_Ad`) VALUES
(1, 'D3-Vitamini'),
(2, 'Ashwagandha'),
(3, 'Multivitamin'),
(4, 'Omega-3'),
(5, 'Kolojen'),
(6, 'Creatin');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `eski_antrenorler`
--

DROP TABLE IF EXISTS `eski_antrenorler`;
CREATE TABLE IF NOT EXISTS `eski_antrenorler` (
  `Antrenorler_ID` int DEFAULT NULL,
  `Antrenorler_Ad` varchar(50) DEFAULT NULL,
  `Antrenorler_Soyad` varchar(50) DEFAULT NULL,
  `Ayrilis_Tarihi` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `eski_antrenorler`
--

INSERT INTO `eski_antrenorler` (`Antrenorler_ID`, `Antrenorler_Ad`, `Antrenorler_Soyad`, `Ayrilis_Tarihi`) VALUES
(5, 'Savaş', 'Cebeci', '2023-12-19');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `güncel_uye_sayisi`
--

DROP TABLE IF EXISTS `güncel_uye_sayisi`;
CREATE TABLE IF NOT EXISTS `güncel_uye_sayisi` (
  `Uye_Sayisi` int DEFAULT NULL,
  `Tarih` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `güncel_uye_sayisi`
--

INSERT INTO `güncel_uye_sayisi` (`Uye_Sayisi`, `Tarih`) VALUES
(12, '2023-12-19'),
(11, '2023-12-19'),
(10, '2023-12-19'),
(11, '2023-12-19'),
(10, '2023-12-19');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `olcumler`
--

DROP TABLE IF EXISTS `olcumler`;
CREATE TABLE IF NOT EXISTS `olcumler` (
  `Olcum_ID` int NOT NULL AUTO_INCREMENT,
  `Boy` decimal(10,2) DEFAULT NULL,
  `Bacak` decimal(10,2) DEFAULT NULL,
  `Bel` decimal(10,2) DEFAULT NULL,
  `Kilo` decimal(10,2) DEFAULT NULL,
  `Kol` decimal(10,2) DEFAULT NULL,
  `DogumTarihi` date DEFAULT NULL,
  `OlcumTarih` date DEFAULT NULL,
  PRIMARY KEY (`Olcum_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `olcumler`
--

INSERT INTO `olcumler` (`Olcum_ID`, `Boy`, `Bacak`, `Bel`, `Kilo`, `Kol`, `DogumTarihi`, `OlcumTarih`) VALUES
(1, '180.00', '60.20', '80.00', '83.00', '38.00', '2003-08-11', '2023-12-17'),
(2, '170.00', '50.30', '72.00', '71.00', '32.50', '2003-05-17', '2023-12-17'),
(4, '178.00', '64.00', '88.00', '90.00', '42.30', '2001-02-01', '2023-12-17'),
(5, '180.00', '67.00', '88.00', '90.00', '37.00', '1999-08-23', '2023-12-18'),
(6, '180.00', '66.00', '78.00', '87.00', '43.00', '1998-08-23', '2023-12-18'),
(7, '155.00', '42.00', '58.00', '54.00', '26.00', '2002-05-15', '2023-12-19'),
(8, '165.00', '50.20', '60.00', '52.00', '23.00', '2001-02-12', '2023-12-19'),
(9, '172.00', '56.00', '65.00', '70.30', '30.00', '2000-05-11', '2023-12-19'),
(10, '180.00', '62.20', '67.50', '74.00', '30.00', '1992-05-14', '2023-12-19'),
(11, '150.00', '38.00', '44.00', '48.00', '22.50', '1997-05-27', '2023-12-19');

--
-- Tetikleyiciler `olcumler`
--
DROP TRIGGER IF EXISTS `Boy_Sorunu`;
DELIMITER $$
CREATE TRIGGER `Boy_Sorunu` BEFORE UPDATE ON `olcumler` FOR EACH ROW BEGIN
    IF NEW.Boy < 150 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Hatalı giriş: Boy değeri 150 den küçük olamaz.';
    END IF;
 END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `programlar`
--

DROP TABLE IF EXISTS `programlar`;
CREATE TABLE IF NOT EXISTS `programlar` (
  `Program_ID` int NOT NULL AUTO_INCREMENT,
  `Program_Ad` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Program_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `programlar`
--

INSERT INTO `programlar` (`Program_ID`, `Program_Ad`) VALUES
(1, 'Push Pull Legs'),
(2, 'Strong Man'),
(3, 'Hypertrophy'),
(4, 'HITT');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `uyeler`
--

DROP TABLE IF EXISTS `uyeler`;
CREATE TABLE IF NOT EXISTS `uyeler` (
  `Uye_ID` int NOT NULL AUTO_INCREMENT,
  `Uye_Ad` varchar(50) DEFAULT NULL,
  `Uye_Soyad` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Uye_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `uyeler`
--

INSERT INTO `uyeler` (`Uye_ID`, `Uye_Ad`, `Uye_Soyad`) VALUES
(1, 'Furkan', 'Kaplıca'),
(2, 'Mehmet', 'Dikkan'),
(3, 'Ali', 'Demir'),
(4, 'Beto', 'Aktaş'),
(5, 'Haktan', 'Aktaş'),
(6, 'Nesilhan', 'Özyılmaz'),
(7, 'Mustafa', 'Emir'),
(8, 'Hüma', 'Sinan'),
(9, 'Ceylin', 'Vardar'),
(10, 'Yağmur', 'Yağan');

--
-- Tetikleyiciler `uyeler`
--
DROP TRIGGER IF EXISTS `Uye_Sayisi(ekleme sonrasi)`;
DELIMITER $$
CREATE TRIGGER `Uye_Sayisi(ekleme sonrasi)` AFTER INSERT ON `uyeler` FOR EACH ROW INSERT INTO güncel_uye_sayisi VALUES((SELECT count(*) from uyeler),now())
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `uye_Sayisi(silinme sonrasi)`;
DELIMITER $$
CREATE TRIGGER `uye_Sayisi(silinme sonrasi)` AFTER DELETE ON `uyeler` FOR EACH ROW INSERT INTO güncel_uye_sayisi VALUES((SELECT count(*) from uyeler),now())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `uye_antrenor`
--

DROP TABLE IF EXISTS `uye_antrenor`;
CREATE TABLE IF NOT EXISTS `uye_antrenor` (
  `Uye_ID` int DEFAULT NULL,
  `Antrenorler_ID` int DEFAULT NULL,
  KEY `Uye_ID` (`Uye_ID`),
  KEY `Antrenorler_ID` (`Antrenorler_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `uye_antrenor`
--

INSERT INTO `uye_antrenor` (`Uye_ID`, `Antrenorler_ID`) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 1),
(5, 2),
(6, 1),
(7, 2),
(8, 2),
(9, 1),
(10, 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `uye_diyet`
--

DROP TABLE IF EXISTS `uye_diyet`;
CREATE TABLE IF NOT EXISTS `uye_diyet` (
  `Uye_ID` int DEFAULT NULL,
  `Diyet_ID` int DEFAULT NULL,
  KEY `Uye_ID` (`Uye_ID`),
  KEY `Diyet_ID` (`Diyet_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `uye_diyet`
--

INSERT INTO `uye_diyet` (`Uye_ID`, `Diyet_ID`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 2),
(5, 3),
(6, 1),
(7, 3),
(8, 3),
(9, 2),
(10, 3);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `uye_diyetisyen`
--

DROP TABLE IF EXISTS `uye_diyetisyen`;
CREATE TABLE IF NOT EXISTS `uye_diyetisyen` (
  `Uye_ID` int DEFAULT NULL,
  `Diyetisyen_ID` int DEFAULT NULL,
  KEY `Uye_ID` (`Uye_ID`),
  KEY `Diyetisyen_ID` (`Diyetisyen_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `uye_diyetisyen`
--

INSERT INTO `uye_diyetisyen` (`Uye_ID`, `Diyetisyen_ID`) VALUES
(1, 2),
(2, 1),
(3, 1),
(4, 1),
(5, 3),
(6, 1),
(7, 3),
(8, 2),
(9, 1),
(10, 3);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `uye_ek_gida`
--

DROP TABLE IF EXISTS `uye_ek_gida`;
CREATE TABLE IF NOT EXISTS `uye_ek_gida` (
  `Uye_ID` int DEFAULT NULL,
  `Gida_ID` int DEFAULT NULL,
  KEY `Uye_ID` (`Uye_ID`),
  KEY `Gida_ID` (`Gida_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `uye_ek_gida`
--

INSERT INTO `uye_ek_gida` (`Uye_ID`, `Gida_ID`) VALUES
(1, 3),
(2, 1),
(3, 4),
(1, 2),
(6, 1),
(7, 3),
(8, 3),
(9, 5),
(10, 4),
(6, 2);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `uye_olcumler`
--

DROP TABLE IF EXISTS `uye_olcumler`;
CREATE TABLE IF NOT EXISTS `uye_olcumler` (
  `Uye_ID` int DEFAULT NULL,
  `Olcum_ID` int DEFAULT NULL,
  KEY `Uye_ID` (`Uye_ID`),
  KEY `Olcum_ID` (`Olcum_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `uye_olcumler`
--

INSERT INTO `uye_olcumler` (`Uye_ID`, `Olcum_ID`) VALUES
(1, 1),
(2, 2),
(3, 4),
(4, 5),
(5, 6),
(6, 7),
(7, 8),
(8, 9),
(9, 10),
(10, 11);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `uye_program`
--

DROP TABLE IF EXISTS `uye_program`;
CREATE TABLE IF NOT EXISTS `uye_program` (
  `Uye_ID` int DEFAULT NULL,
  `Program_ID` int DEFAULT NULL,
  KEY `Uye_ID` (`Uye_ID`),
  KEY `Program_ID` (`Program_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `uye_program`
--

INSERT INTO `uye_program` (`Uye_ID`, `Program_ID`) VALUES
(1, 1),
(2, 1),
(3, 3),
(4, 4),
(5, 3),
(6, 3),
(7, 1),
(8, 3),
(9, 2),
(10, 1);

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `uye_antrenor`
--
ALTER TABLE `uye_antrenor`
  ADD CONSTRAINT `uye_antrenor_ibfk_1` FOREIGN KEY (`Uye_ID`) REFERENCES `uyeler` (`Uye_ID`),
  ADD CONSTRAINT `uye_antrenor_ibfk_2` FOREIGN KEY (`Antrenorler_ID`) REFERENCES `antrenorler` (`Antrenorler_ID`);

--
-- Tablo kısıtlamaları `uye_diyet`
--
ALTER TABLE `uye_diyet`
  ADD CONSTRAINT `uye_diyet_ibfk_1` FOREIGN KEY (`Uye_ID`) REFERENCES `uyeler` (`Uye_ID`),
  ADD CONSTRAINT `uye_diyet_ibfk_2` FOREIGN KEY (`Diyet_ID`) REFERENCES `diyet` (`Diyet_ID`);

--
-- Tablo kısıtlamaları `uye_diyetisyen`
--
ALTER TABLE `uye_diyetisyen`
  ADD CONSTRAINT `uye_diyetisyen_ibfk_1` FOREIGN KEY (`Uye_ID`) REFERENCES `uyeler` (`Uye_ID`),
  ADD CONSTRAINT `uye_diyetisyen_ibfk_2` FOREIGN KEY (`Diyetisyen_ID`) REFERENCES `diyetisyenler` (`Diyetisyen_ID`);

--
-- Tablo kısıtlamaları `uye_ek_gida`
--
ALTER TABLE `uye_ek_gida`
  ADD CONSTRAINT `uye_ek_gida_ibfk_1` FOREIGN KEY (`Uye_ID`) REFERENCES `uyeler` (`Uye_ID`),
  ADD CONSTRAINT `uye_ek_gida_ibfk_2` FOREIGN KEY (`Gida_ID`) REFERENCES `ek_gidalar` (`Gida_ID`);

--
-- Tablo kısıtlamaları `uye_olcumler`
--
ALTER TABLE `uye_olcumler`
  ADD CONSTRAINT `uye_olcumler_ibfk_1` FOREIGN KEY (`Uye_ID`) REFERENCES `uyeler` (`Uye_ID`),
  ADD CONSTRAINT `uye_olcumler_ibfk_2` FOREIGN KEY (`Olcum_ID`) REFERENCES `olcumler` (`Olcum_ID`);

--
-- Tablo kısıtlamaları `uye_program`
--
ALTER TABLE `uye_program`
  ADD CONSTRAINT `uye_program_ibfk_1` FOREIGN KEY (`Uye_ID`) REFERENCES `uyeler` (`Uye_ID`),
  ADD CONSTRAINT `uye_program_ibfk_2` FOREIGN KEY (`Program_ID`) REFERENCES `programlar` (`Program_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
