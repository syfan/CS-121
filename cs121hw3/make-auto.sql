-- [Problem 1]
DROP TABLE IF EXISTS participated;
DROP TABLE IF EXISTS owns;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS accident;

-- Keeps track of the information for people. Includes the driver's ID, name,
-- and address.  Primary key is the driver ID (driver_id).
CREATE TABLE person (
    driver_id   CHAR(10) NOT NULL,
    name        VARCHAR(15) NOT NULL,
    address     VARCHAR(20) NOT NULL,
    PRIMARY KEY (driver_id)
);

-- Keeps track of the information for cars.  Includes the license plate code,
-- model, and year of the car. Primary key is the license plat (license).
CREATE TABLE car (
    license     CHAR(7) NOT NULL,
    model       VARCHAR(15),
    year        YEAR,
    PRIMARY KEY (license)
);

-- Keeps track of information for accidents.  Includes the report number, which
-- increments automatically, date, location, and description. Primary key is
-- the report number (report_number)
CREATE TABLE accident (
    report_number   INT NOT NULL AUTO_INCREMENT,
    date_occurred   TIMESTAMP NOT NULL,
    location        VARCHAR(200) NOT NULL,
    description     VARCHAR(20000),
    PRIMARY KEY (report_number)
);

-- Keeps track of information for relationships of ownership.  Includes the
-- ID of the driver and license of the car.  Primary key is ID (driver_id) and
-- the license plate (license).  This table references the person table and
-- car table for these two elements, respectively.  Cascades deletions and 
-- updates.
CREATE TABLE owns (
    driver_id     CHAR(10) NOT NULL,
    license       CHAR(7) NOT NULL,
    PRIMARY KEY (driver_id, license),
    FOREIGN KEY (driver_id) REFERENCES person(driver_id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE,
    FOREIGN KEY (license) REFERENCES car(license)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE
);

-- Keep information on the participant in an accident.  Contains the driver's
-- ID, the car's license, the accident's report number, and the cost of damages.
-- Primary key is driver_id, license, and report_number.  References the person
-- table, car table, and accident table for these elements, respectively.
-- Cascades updates, but not deletions.
CREATE TABLE participated (
    driver_id     CHAR(10) NOT NULL,
    license       CHAR(7) NOT NULL,
    report_number INT NOT NULL AUTO_INCREMENT,
    damage_amount NUMERIC(10,2),
    PRIMARY KEY (driver_id, license, report_number),
    FOREIGN KEY (driver_id) REFERENCES person(driver_id)
                            ON UPDATE CASCADE,
    FOREIGN KEY (license) REFERENCES car(license)
                            ON UPDATE CASCADE,
    FOREIGN KEY (report_number) REFERENCES accident(report_number)
                            ON UPDATE CASCADE
);
