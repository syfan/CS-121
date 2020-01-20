-- PLEASE DO NOT INCLUDE date-udfs HERE!!!

-- [Problem 4a]
INSERT IGNORE INTO resource_dim (resource, method, protocol, response)
    SELECT resource, method, protocol, response
    FROM raw_web_log;

-- [Problem 4b]
INSERT IGNORE INTO visitor_dim (ip_addr, visit_val)
    SELECT ip_addr, visit_val
    FROM raw_web_log;


-- [Problem 4c]
DELIMITER !

-- populates the datetime_dim table
CREATE PROCEDURE populate_dates(d_start DATE, d_end DATE)
BEGIN
    DECLARE d DATE;
    DECLARE h INTEGER;
    DELETE FROM datetime_dim WHERE date_val >= d_start AND date_val <= d_end;
    SET d = d_start;
    WHILE d <= d_end DO
        SET h = 0;
        WHILE h <= 23 DO
            INSERT INTO datetime_dim (date_val, hour_val, weekend, holiday)
                VALUES (d, h, IS_WEEKEND(d), IS_HOLIDAY(d));
            SET h = h + 1;
        END WHILE;
        SET d = DATE_ADD(d, INTERVAL 1 DAY);
    END WHILE;

END!

DELIMITER ;


-- [Problem 5a]
-- populate resource_fact
INSERT INTO resource_fact (date_id, resource_id, num_requests, total_bytes)
    SELECT date_id, resource_id, COUNT(t1.resource) AS tot_requests,
        SUM(bytes_sent) AS tot_bytes
    FROM raw_web_log t1 JOIN datetime_dim t2 ON DATE(t1.logtime) <=> t2.date_val
                                            AND HOUR(t1.logtime) <=> t2.hour_val
        JOIN resource_dim t3 ON t1.resource <=> t3.resource
    GROUP BY date_id, resource_id;


-- [Problem 5b]
-- populate visitor_fact
INSERT INTO visitor_fact (date_id, visitor_id, num_requests, total_bytes)
    SELECT date_id, visitor_id, COUNT(t1.resource) AS tot_requests,
        SUM(bytes_sent) AS tot_bytes
    FROM raw_web_log t1 JOIN datetime_dim t2 ON DATE(t1.logtime) <=> t2.date_val
                                            AND HOUR(t1.logtime) <=> t2.hour_val
        JOIN visitor_dim t3 ON t1.visit_val <=> t3.visit_val
    GROUP BY date_id, visitor_id;
