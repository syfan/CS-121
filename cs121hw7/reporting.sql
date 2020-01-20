-- [Problem 6a]
SELECT protocol, COUNT(method) AS tot_requests
    FROM raw_web_log WHERE protocol LIKE 'HTTP%'
    GROUP BY protocol ORDER BY tot_requests DESC LIMIT 10;


-- [Problem 6b]
SELECT resource, response, COUNT(response) AS errors FROM raw_web_log
    WHERE response >= 400 GROUP BY resource, response
    ORDER BY errors DESC LIMIT 20;


-- [Problem 6c]
SELECT ip_addr, COUNT(visit_val) AS tot_visits, COUNT(method) AS tot_requests,
    SUM(bytes_sent) AS tot_bytes FROM raw_web_log GROUP BY ip_addr
    ORDER BY tot_bytes DESC LIMIT 20;


-- [Problem 6d]
SELECT COUNT(t1.method) AS tot_requests, SUM(bytes_sent) AS tot_bytes, t2.date_val
    AS date_request FROM raw_web_log t1 JOIN datetime_dim t2
    ON DATE(t1.logtime) <=> t2.date_val AND HOUR(t1.logtime) <=> t2.hour_val
    GROUP BY DAY(t1.logtime), t2.date_val;


-- [Problem 6e]
SELECT DATE(logtime), resource, COUNT(method) AS tot_requests, SUM(bytes_sent) AS tot_max_bytes
    FROM raw_web_log GROUP BY resource, DATE(logtime)
    ORDER BY logtime ASC;

-- [Problem 6f]   
SELECT DATE(logtime) AS hour_val, COUNT(visit_val) AS avg_weekday_visits,
    COUNT(visit_val) AS avg_weekend_visits
    FROM raw_web_log WHERE NOT IS_WEEKEND(logtime) GROUP BY DATE(logtime);