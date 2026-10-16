-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema pet_daily_care
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pet_daily_care
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pet_daily_care` DEFAULT CHARACTER SET utf8 ;
USE `pet_daily_care` ;

-- -----------------------------------------------------
-- Table `pet_daily_care`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pet_daily_care`.`customer` ;

CREATE TABLE IF NOT EXISTS `pet_daily_care`.`customer` (
  `customerID` INT(11) NOT NULL,
  `fname` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `sname` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `phone` VARCHAR(10) CHARACTER SET 'utf8' NOT NULL,
  `address` VARCHAR(255) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  PRIMARY KEY (`customerID`),
  UNIQUE INDEX `phone` (`phone` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `pet_daily_care`.`positions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pet_daily_care`.`positions` ;

CREATE TABLE IF NOT EXISTS `pet_daily_care`.`positions` (
  `positionID` INT(11) NOT NULL,
  `positionName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`positionID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pet_daily_care`.`employee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pet_daily_care`.`employee` ;

CREATE TABLE IF NOT EXISTS `pet_daily_care`.`employee` (
  `employeeID` INT(11) NOT NULL,
  `fname` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `sname` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `phone` VARCHAR(10) CHARACTER SET 'utf8' NOT NULL,
  `positionID` INT(11) NOT NULL,
  `salary` DECIMAL(8,2) NOT NULL,
  `taxID` VARCHAR(13) NULL DEFAULT NULL,
  PRIMARY KEY (`employeeID`),
  INDEX `positionID_fk` (`positionID` ASC),
  CONSTRAINT `positionID_fk`
    FOREIGN KEY (`positionID`)
    REFERENCES `pet_daily_care`.`positions` (`positionID`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `pet_daily_care`.`pet`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pet_daily_care`.`pet` ;

CREATE TABLE IF NOT EXISTS `pet_daily_care`.`pet` (
  `petID` INT(11) NOT NULL,
  `petName` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `age` INT(11) NOT NULL,
  `species` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `breed` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `gender` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `customerID` INT(11) NOT NULL,
  PRIMARY KEY (`petID`),
  INDEX `customerID_fk` (`customerID` ASC),
  CONSTRAINT `customerID_fk`
    FOREIGN KEY (`customerID`)
    REFERENCES `pet_daily_care`.`customer` (`customerID`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `pet_daily_care`.`roomtype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pet_daily_care`.`roomtype` ;

CREATE TABLE IF NOT EXISTS `pet_daily_care`.`roomtype` (
  `roomTypeID` INT(11) NOT NULL,
  `roomTypeName` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `price` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`roomTypeID`),
  UNIQUE INDEX `roomTypeName` (`roomTypeName` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `pet_daily_care`.`room`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pet_daily_care`.`room` ;

CREATE TABLE IF NOT EXISTS `pet_daily_care`.`room` (
  `roomID` INT(11) NOT NULL,
  `roomName` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `roomTypeID` INT(11) NOT NULL,
  PRIMARY KEY (`roomID`),
  INDEX `roomTypeID_fk` (`roomTypeID` ASC),
  CONSTRAINT `roomTypeID_fk`
    FOREIGN KEY (`roomTypeID`)
    REFERENCES `pet_daily_care`.`roomtype` (`roomTypeID`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `pet_daily_care`.`operation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pet_daily_care`.`operation` ;

CREATE TABLE IF NOT EXISTS `pet_daily_care`.`operation` (
  `operationID` INT(11) NOT NULL,
  `checkInDateTime` DATETIME NOT NULL,
  `checkOutDateTime` DATETIME NULL DEFAULT NULL,
  `roomID` INT(11) NOT NULL,
  `petID` INT(11) NOT NULL,
  `employeeID` INT(11) NOT NULL,
  PRIMARY KEY (`operationID`),
  INDEX `op_roomID_fk` (`roomID` ASC),
  INDEX `op_petID_fk` (`petID` ASC),
  INDEX `empID_op_fk` (`employeeID` ASC),
  CONSTRAINT `empID_op_fk`
    FOREIGN KEY (`employeeID`)
    REFERENCES `pet_daily_care`.`employee` (`employeeID`)
    ON UPDATE CASCADE,
  CONSTRAINT `op_petID_fk`
    FOREIGN KEY (`petID`)
    REFERENCES `pet_daily_care`.`pet` (`petID`)
    ON UPDATE CASCADE,
  CONSTRAINT `op_roomID_fk`
    FOREIGN KEY (`roomID`)
    REFERENCES `pet_daily_care`.`room` (`roomID`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `pet_daily_care`.`service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pet_daily_care`.`service` ;

CREATE TABLE IF NOT EXISTS `pet_daily_care`.`service` (
  `serviceID` INT(11) NOT NULL,
  `serviceName` VARCHAR(70) CHARACTER SET 'utf8' NOT NULL,
  `serviceDetail` TEXT CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `price` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (`serviceID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `pet_daily_care`.`operation_service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pet_daily_care`.`operation_service` ;

CREATE TABLE IF NOT EXISTS `pet_daily_care`.`operation_service` (
  `operationID` INT(11) NOT NULL,
  `serviceID` INT(11) NOT NULL,
  `quantity` INT(11) NOT NULL,
  `status_op_service` TINYINT(1) NOT NULL,
  `serviceDateTime` DATETIME NOT NULL,
  `employeeID` INT(11) NOT NULL,
  PRIMARY KEY (`operationID`, `serviceID`),
  INDEX `OpService_Service_fk` (`serviceID` ASC),
  INDEX `empID_op_service_fk` (`employeeID` ASC),
  CONSTRAINT `OpService_Operation_fk`
    FOREIGN KEY (`operationID`)
    REFERENCES `pet_daily_care`.`operation` (`operationID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `OpService_Service_fk`
    FOREIGN KEY (`serviceID`)
    REFERENCES `pet_daily_care`.`service` (`serviceID`)
    ON UPDATE CASCADE,
  CONSTRAINT `empID_op_service_fk`
    FOREIGN KEY (`employeeID`)
    REFERENCES `pet_daily_care`.`employee` (`employeeID`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pet_daily_care`.`paymenttype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pet_daily_care`.`paymenttype` ;

CREATE TABLE IF NOT EXISTS `pet_daily_care`.`paymenttype` (
  `paymentTypeID` INT(11) NOT NULL,
  `paymentTypeName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`paymentTypeID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pet_daily_care`.`payment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pet_daily_care`.`payment` ;

CREATE TABLE IF NOT EXISTS `pet_daily_care`.`payment` (
  `paymentID` INT(11) NOT NULL,
  `price` DECIMAL(8,2) NOT NULL,
  `paymentDateTime` DATETIME NOT NULL,
  `paymentTypeID` INT(11) NOT NULL,
  `slipImage` VARCHAR(255) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `statusPayment` TINYINT(1) NOT NULL,
  `operationID` INT(11) NOT NULL,
  PRIMARY KEY (`paymentID`),
  INDEX `paymentTypeID_fk` (`paymentTypeID` ASC),
  UNIQUE INDEX `operationID_UNIQUE` (`operationID` ASC),
  CONSTRAINT `operationID_fk`
    FOREIGN KEY (`operationID`)
    REFERENCES `pet_daily_care`.`operation` (`operationID`)
    ON UPDATE CASCADE,
  CONSTRAINT `paymentTypeID_fk`
    FOREIGN KEY (`paymentTypeID`)
    REFERENCES `pet_daily_care`.`paymenttype` (`paymentTypeID`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `pet_daily_care`.`review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pet_daily_care`.`review` ;

CREATE TABLE IF NOT EXISTS `pet_daily_care`.`review` (
  `reviewID` INT(11) NOT NULL,
  `rating` DOUBLE NOT NULL,
  `commentReview` TEXT CHARACTER SET 'utf8' NOT NULL,
  `reviewDateTime` DATETIME NOT NULL,
  `operationID` INT(11) NOT NULL,
  PRIMARY KEY (`reviewID`),
  INDEX `review_op_fk` (`operationID` ASC),
  CONSTRAINT `review_op_fk`
    FOREIGN KEY (`operationID`)
    REFERENCES `pet_daily_care`.`operation` (`operationID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
