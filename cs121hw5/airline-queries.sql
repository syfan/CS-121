-- [Problem 6a]
SELECT ticket_id, purchase_id, time_of_purchase, price, last_name, first_name,
    IATA, flight_number, date_of_flight
    FROM (customers NATURAL JOIN purchasers NATURAL JOIN purchases
        NATURAL JOIN tickets)
    WHERE customer_id = 54321 ORDER BY time_of_purchase, date_of_flight,
                                    last_name, first_name DESC;

-- [Problem 6b]
SELECT SUM(price) FROM tickets NATURAL JOIN flights NATURAL JOIN airplanes
    WHERE UNIX_TIMESTAMP() - time_of_flight < 1210000 GROUP BY model;


-- [Problem 6c]
SELECT last_name, first_name, customer_id FROM travelers NATURAL JOIN customers
    NATURAL JOIN tickets NATURAL JOIN flights 
    WHERE domestic IS FALSE AND passport IS NULL;
