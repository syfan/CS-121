-- [Problem 5]

-- DROP TABLE commands:
DROP TABLE IF EXISTS purchasers;
DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS airplanes;
DROP TABLE IF EXISTS phone_numbers;
DROP TABLE IF EXISTS travelers;
DROP TABLE IF EXISTS customers;

-- CREATE TABLE commands:

-- Contains data for the company of manufacture, model, and unique IATA.
-- Primary key is the IATA
CREATE TABLE airplanes(
    company     VARCHAR(20) NOT NULL,
    model       VARCHAR(20) NOT NULL,
    IATA        CHAR(3) NOT NULL,

    PRIMARY KEY (IATA)
);

-- Contains data for flights, including the flight number, date, time, source,
-- destination, domestic/international status, and IATA of the plane.  Primary
-- key is both the flight number and date; flight numbers are recycled.  IATA
-- is referenced from the airplanes table.
CREATE TABLE flights(
    flight_number   VARCHAR(10) NOT NULL,
    date_of_flight  DATE NOT NULL,
    time_of_flight  DATETIME NOT NULL,
    src             CHAR(3)  NOT NULL,
    dest            CHAR(3) NOT NULL,
    domestic        BOOLEAN NOT NULL,
    IATA            CHAR(3) NOT NULL,

    PRIMARY KEY (flight_number, date_of_flight),
    FOREIGN KEY (IATA) REFERENCES airplanes(IATA) ON DELETE CASCADE
                                                  ON UPDATE CASCADE
);

-- Keeps track of seatign information. Includes the IATA for the plane, the
-- seat numbers, classes, types, and exit rows.  Primary key is the combination
-- of IATA and seat number; seats are unique on each plane, but seat numbers
-- aren't necessarily unique.  IATA references IATA from airplanes table.
CREATE TABLE seats(
    IATA            CHAR(3) NOT NULL,
    seat_number     CHAR(3) NOT NULL,
    seat_class      VARCHAR(20) NOT NULL,
    seat_type       VARCHAR(20) NOT NULL,
    exit_row        BOOLEAN NOT NULL,

    PRIMARY KEY (IATA, seat_number),
    FOREIGN KEY (IATA) REFERENCES airplanes(IATA) ON DELETE CASCADE
                                                  ON UPDATE CASCADE
);

-- Contains information for customers.  Includes first and last name, email,
-- and customer_id.  Primary key is customer id instead of name because names
-- aren't necessarily unique.
CREATE TABLE customers(
    first_name      VARCHAR(25) NOT NULL,
    last_name       VARCHAR(25) NOT NULL,
    email           VARCHAR(30) NOT NULL,
    customer_id     INT NOT NULL AUTO_INCREMENT,

    PRIMARY KEY (customer_id)
);

-- Table of phone numbers; created because customers can have multiple phone
-- numbers.  To have this functionality, the primary is both the customer id and
-- the phone number.  The customer id references the customers table.
CREATE TABLE phone_numbers(
    customer_id     INT NOT NULL,
    numbers         VARCHAR(11),

    PRIMARY KEY(customer_id, numbers),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
                                            ON DELETE CASCADE
                                            ON UPDATE CASCADE
);

-- Contains information on the travelers, including the customer id, frequent
-- flyer number, and some option al information regarding passport number,
-- country, emergency contact name, and emergency contact phone number.
-- Primary key is customer id, which is referenced from the customers table.
CREATE TABLE travelers(
    customer_id         INT NOT NULL,
    freq_flyer          CHAR(7),
    passport            VARCHAR(40),
    country             VARCHAR(30),
    emergency_contact   VARCHAR(40),
    emergency_phone     VARCHAR(11),

    PRIMARY KEY(customer_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
                                            ON DELETE CASCADE
                                            ON UPDATE CASCADE
);

-- Contains information of for the tickets, including the unique ticket id,
-- price, customer id, IATA of the plane, seat number, flight number, and date.
-- Primary key is the ticket id, and the other elements are referenced from
-- elsewhere.
CREATE TABLE tickets(
    ticket_id           INT NOT NULL AUTO_INCREMENT,
    price               NUMERIC(7, 2) NOT NULL,
    customer_id         INT NOT NULL,
    IATA                CHAR(3) NOT NULL,
    seat_number         CHAR(3) NOT NULL,
    flight_number       VARCHAR(10) NOT NULL,
    date_of_flight      DATE NOT NULL,

    PRIMARY KEY (ticket_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
                                                ON DELETE CASCADE
                                                ON UPDATE CASCADE,
    FOREIGN KEY (IATA, seat_number) REFERENCES seats(IATA, seat_number)
                                                ON DELETE CASCADE
                                                ON UPDATE CASCADE,
    FOREIGN KEY(flight_number, date_of_flight)
        REFERENCES flights(flight_number, date_of_flight) ON DELETE CASCADE
                                                          ON UPDATE CASCADE
);

-- Stores information for purchases, including the purchase id, time,
-- confirmation number, and ticket id. Primary key is the unique purchase id.
-- Ticket id is referenced from the tickets table.
CREATE TABLE purchases(
    purchase_id         INT NOT NULL AUTO_INCREMENT,
    time_of_purchase    TIMESTAMP NOT NULL,
    confirmation        CHAR(6) UNIQUE,
    ticket_id           INT NOT NULL,

    PRIMARY KEY (purchase_id),
    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id) ON DELETE CASCADE
                                                          ON UPDATE CASCADE
);

CREATE TABLE purchasers(
    customer_id     INT NOT NULL,
    card_number     NUMERIC(16),
    expiration      DATE,
    verification    NUMERIC(3),
    puchase_id      INT NOT NULL,

    PRIMARY KEY (customer_id),
    FOREIGN KEY (puchase_id) REFERENCES purchases(purchase_id) ON DELETE CASCADE
                                                               ON UPDATE CASCADE
);
