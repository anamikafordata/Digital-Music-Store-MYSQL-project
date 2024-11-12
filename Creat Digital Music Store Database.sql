SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema musicstore
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `musicstore` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
-- -----------------------------------------------------

USE `musicstore` ;

-- -----------------------------------------------------
-- Table `musicstore`.`artist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musicstore`.`artist` ;

CREATE TABLE IF NOT EXISTS `musicstore`.`artist` (
  `ArtistId` SMALLINT NOT NULL,
  `Name` VARCHAR(85) NULL DEFAULT NULL,
  PRIMARY KEY (`ArtistId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`album`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musicstore`.`album` ;

CREATE TABLE IF NOT EXISTS `musicstore`.`album` (
  `AlbumId` SMALLINT NOT NULL,
  `Title` VARCHAR(95) NULL DEFAULT NULL,
  `ArtistId` SMALLINT NULL DEFAULT NULL,
  PRIMARY KEY (`AlbumId`),
  INDEX `AetistId_idx` (`ArtistId` ASC) VISIBLE,
  CONSTRAINT `ArtistId`
    FOREIGN KEY (`ArtistId`)
    REFERENCES `musicstore`.`artist` (`ArtistId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`employee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musicstore`.`employee` ;

CREATE TABLE IF NOT EXISTS `musicstore`.`employee` (
  `employee_id` TINYINT NOT NULL,
  `last_name` CHAR(50) NULL DEFAULT NULL,
  `first_name` CHAR(50) NULL DEFAULT NULL,
  `title` VARCHAR(250) NULL DEFAULT NULL,
  `reports_to` TINYINT NULL DEFAULT NULL,
  `levels` VARCHAR(10) NULL DEFAULT NULL,
  `birth_date` DATETIME NULL DEFAULT NULL,
  `hire_date` DATETIME NULL DEFAULT NULL,
  `address` VARCHAR(120) NULL DEFAULT NULL,
  `city` VARCHAR(50) NULL DEFAULT NULL,
  `state` VARCHAR(50) NULL DEFAULT NULL,
  `country` VARCHAR(30) NULL DEFAULT NULL,
  `postal_code` VARCHAR(30) NULL DEFAULT NULL,
  `phone` VARCHAR(30) NULL DEFAULT NULL,
  `fax` VARCHAR(30) NULL DEFAULT NULL,
  `email` VARCHAR(30) NULL DEFAULT NULL,
  PRIMARY KEY (`employee_id`),
  INDEX `reports_to` (`reports_to` ASC) VISIBLE,
  CONSTRAINT `reports_to`
    FOREIGN KEY (`reports_to`)
    REFERENCES `musicstore`.`employee` (`employee_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musicstore`.`customer` ;

CREATE TABLE IF NOT EXISTS `musicstore`.`customer` (
  `CustomerId` TINYINT NOT NULL,
  `FirstName` VARCHAR(9) NULL DEFAULT NULL,
  `LastName` VARCHAR(12) NULL DEFAULT NULL,
  `Company` VARCHAR(48) NULL DEFAULT NULL,
  `Address` VARCHAR(40) NULL DEFAULT NULL,
  `City` VARCHAR(19) NULL DEFAULT NULL,
  `State` VARCHAR(6) NULL DEFAULT NULL,
  `Country` VARCHAR(14) NULL DEFAULT NULL,
  `PostalCode` VARCHAR(10) NULL DEFAULT NULL,
  `Phone` VARCHAR(19) NULL DEFAULT NULL,
  `Fax` VARCHAR(18) NULL DEFAULT NULL,
  `Email` VARCHAR(29) NULL DEFAULT NULL,
  `SupportRepId` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`CustomerId`),
  INDEX `employee_id_idx` (`SupportRepId` ASC) VISIBLE,
  CONSTRAINT `employee_id`
    FOREIGN KEY (`SupportRepId`)
    REFERENCES `musicstore`.`employee` (`employee_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musicstore`.`genre` ;

CREATE TABLE IF NOT EXISTS `musicstore`.`genre` (
  `GenreId` TINYINT NOT NULL,
  `Name` VARCHAR(18) NULL DEFAULT NULL,
  PRIMARY KEY (`GenreId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`invoice`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musicstore`.`invoice` ;

CREATE TABLE IF NOT EXISTS `musicstore`.`invoice` (
  `InvoiceId` SMALLINT NOT NULL,
  `CustomerId` TINYINT NULL DEFAULT NULL,
  `InvoiceDate` DATETIME NULL DEFAULT NULL,
  `BillingAddress` VARCHAR(40) NULL DEFAULT NULL,
  `BillingCity` VARCHAR(19) NULL DEFAULT NULL,
  `BillingState` VARCHAR(6) NULL DEFAULT NULL,
  `BillingCountry` VARCHAR(14) NULL DEFAULT NULL,
  `BillingPostalCode` VARCHAR(10) NULL DEFAULT NULL,
  `Total` DECIMAL(4,2) NULL DEFAULT NULL,
  PRIMARY KEY (`InvoiceId`),
  INDEX `CustomerId_idx` (`CustomerId` ASC) VISIBLE,
  CONSTRAINT `CustomerId`
    FOREIGN KEY (`CustomerId`)
    REFERENCES `digitalmusicstore`.`customer` (`CustomerId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`mediatype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musicstore`.`mediatype` ;

CREATE TABLE IF NOT EXISTS `musicstore`.`mediatype` (
  `MediaTypeId` TINYINT NOT NULL,
  `Name` VARCHAR(27) NULL DEFAULT NULL,
  PRIMARY KEY (`MediaTypeId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`track`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musicstore`.`track` ;

CREATE TABLE IF NOT EXISTS `musicstore`.`track` (
  `TrackId` SMALLINT NOT NULL,
  `Name` VARCHAR(123) NULL DEFAULT NULL,
  `AlbumId` SMALLINT NULL DEFAULT NULL,
  `MediaTypeId` TINYINT NULL DEFAULT NULL,
  `GenreId` TINYINT NULL DEFAULT NULL,
  `Composer` VARCHAR(188) NULL DEFAULT NULL,
  `Milliseconds` INT NULL DEFAULT NULL,
  `Bytes` BIGINT NULL DEFAULT NULL,
  `UnitPrice` DECIMAL(3,2) NULL DEFAULT NULL,
  PRIMARY KEY (`TrackId`),
  INDEX `AlbumId_idx` (`AlbumId` ASC) VISIBLE,
  INDEX `GenereTd_idx` (`GenreId` ASC) VISIBLE,
  INDEX `MeadiaTypeId_idx` (`MediaTypeId` ASC) VISIBLE,
  CONSTRAINT `AlbumId`
    FOREIGN KEY (`AlbumId`)
    REFERENCES `musicstore`.`album` (`AlbumId`),
  CONSTRAINT `GenereTd`
    FOREIGN KEY (`GenreId`)
    REFERENCES `musicstore`.`genre` (`GenreId`),
  CONSTRAINT `MeadiaTypeId`
    FOREIGN KEY (`MediaTypeId`)
    REFERENCES `musicstore`.`mediatype` (`MediaTypeId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`invoiceline`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musicstore`.`invoiceline` ;

CREATE TABLE IF NOT EXISTS `musicstore`.`invoiceline` (
  `InvoiceLineId` SMALLINT NOT NULL,
  `InvoiceId` SMALLINT NULL DEFAULT NULL,
  `TrackId` SMALLINT NULL DEFAULT NULL,
  `UnitPrice` DECIMAL(3,2) NULL DEFAULT NULL,
  `Quantity` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`InvoiceLineId`),
  INDEX `InvoiceId_idx` (`InvoiceId` ASC) VISIBLE,
  INDEX `TrackId_idx` (`TrackId` ASC) VISIBLE,
  CONSTRAINT `InvoiceId`
    FOREIGN KEY (`InvoiceId`)
    REFERENCES `musicstore`.`invoice` (`InvoiceId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `TrackId_for_invoiceline`
    FOREIGN KEY (`TrackId`)
    REFERENCES `musicstore`.`track` (`TrackId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`playlist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musicstore`.`playlist` ;

CREATE TABLE IF NOT EXISTS `musicstore`.`playlist` (
  `PlaylistId` TINYINT NOT NULL,
  `Name` VARCHAR(26) NULL DEFAULT NULL,
  PRIMARY KEY (`PlaylistId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`playlisttrack`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musicstore`.`playlisttrack` ;

CREATE TABLE IF NOT EXISTS `musicstore`.`playlisttrack` (
  `PlaylistId` TINYINT NOT NULL,
  `TrackId` SMALLINT NOT NULL,
  PRIMARY KEY (`PlaylistId`, `TrackId`),
  INDEX `PlaylistId_idx` (`PlaylistId` ASC) VISIBLE,
  INDEX `TrackId_idx` (`TrackId` ASC) VISIBLE,
  CONSTRAINT `PlaylistId`
    FOREIGN KEY (`PlaylistId`)
    REFERENCES `musicstore`.`playlist` (`PlaylistId`),
  CONSTRAINT `TrackId_for_playlisttrack`
    FOREIGN KEY (`TrackId`)
    REFERENCES `musicstore`.`track` (`TrackId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
