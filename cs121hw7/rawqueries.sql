-- [Problem 2a]
SELECT COUNT(*) FROM raw_web_log;


-- [Problem 2b]
SELECT ip_addr, COUNT(*) as total FROM raw_web_log GROUP BY ip_addr
    ORDER BY total DESC LIMIT 20;

-- [Problem 2c]
SELECT resource, COUNT(resource) AS tot_requests, SUM(bytes_sent) AS tot_bytes
    FROM raw_web_log GROUP BY resource ORDER BY tot_bytes DESC LIMIT 20;

-- [Problem 2d]
SELECT visit_val, ip_addr, COUNT(resource) AS tot_requests,
    MAX(logtime) AS start_time, MIN(logtime) AS end_time
    FROM raw_web_log
    GROUP BY ip_addr, visit_val ORDER BY tot_requests DESC LIMIT 20;
