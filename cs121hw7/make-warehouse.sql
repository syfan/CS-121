-- [Problem 3]
-- DROP TABLE commands:
DROP TABLE IF EXISTS visitor_fact;
DROP TABLE IF EXISTS resource_fact;
DROP TABLE IF EXISTS visitor_dim;
DROP TABLE IF EXISTS resource_dim;
DROP TABLE IF EXISTS datetime_dim;

-- CREATE TABLE commands:
-- information for dimension of resources, including its id, the resource,
-- methods, protocols, and responses.  Primary key is resource_id.
CREATE TABLE resource_dim(
    resource_id INTEGER NOT NULL AUTO_INCREMENT,
    resource VARCHAR(200) NOT NULL UNIQUE,
    method VARCHAR(15) UNIQUE,
    protocol VARCHAR(200) NOT NULL UNIQUE,
    response INTEGER NOT NULL UNIQUE,

    PRIMARY KEY (resource_id)
);

-- information for dimension of datetime, including the id, value, hour value,
-- whether its a weekend, and name of holiday. Primary key is date_id.
CREATE TABLE datetime_dim(
    date_id INTEGER NOT NULL AUTO_INCREMENT,
    date_val DATE NOT NULL UNIQUE,
    hour_val INTEGER NOT NULL UNIQUE,
    weekend BOOLEAN NOT NULL,
    holiday varchar(20),

    PRIMARY KEY (date_id)
);

-- information for visitor dimension, including the id, ip address, and visit
-- value.  Primary key is visitor_id.
CREATE TABLE visitor_dim(
    visitor_id INTEGER NOT NULL AUTO_INCREMENT,
    ip_addr VARCHAR(200) NOT NULL,
    visit_val INTEGER NOT NULL UNIQUE,

    PRIMARY KEY (visitor_id)
);

-- information for resources (facts). Includes date id, resource id, number of
-- requests, and total number of bytes processed.  Primary key is the combo of
-- date_id and resource_id.
CREATE TABLE resource_fact(
    date_id  INTEGER NOT NULL,
    resource_id INTEGER NOT NULL,
    num_requests INTEGER NOT NULL,
    total_bytes BIGINT(19),

    PRIMARY KEY (date_id, resource_id),
    FOREIGN KEY (resource_id) REFERENCES resource_dim(resource_id),
    FOREIGN KEY (date_id) REFERENCES datetime_dim(date_id)
);

-- information on visitors (fact) Includes the date id, visitor id, number of
-- requests, and total bytes processed.
CREATE TABLE visitor_fact(
    date_id  INTEGER NOT NULL,
    visitor_id INTEGER NOT NULL,
    num_requests INTEGER NOT NULL,
    total_bytes INTEGER,

    PRIMARY KEY (date_id, visitor_id),
    FOREIGN KEY (date_id) REFERENCES datetime_dim(date_id),
    FOREIGN KEY (visitor_id) REFERENCES visitor_dim(visitor_id)
);
