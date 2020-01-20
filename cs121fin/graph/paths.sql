-- [Problem 2a]
DROP PROCEDURE IF EXISTS sp_compute_shortest_paths;
-- procedure for populating shortest_paths
-- Uses JOIN... ON to connect paths and get the total distance in a 2-leg route.
-- Then inserts the minimums into shortest_paths
DELIMITER !
CREATE PROCEDURE sp_compute_shortest_paths()
BEGIN
    -- clear the current version of shortest_paths
    DELETE FROM shortest_paths;
    DROP TEMPORARY TABLE IF EXISTS joined_dup;
    -- temporary table that will store the distances of the extended paths
    CREATE TEMPORARY TABLE joined_dup AS (
        SELECT t1.from_node_id AS from_node_id,
        t2.to_node_id AS dest_node_id,
        (t1.distance + t2.distance) AS total_distance
        FROM node_adjacency t1
        JOIN node_adjacency t2 ON t1.to_node_id = t2.from_node_id
            WHERE t1.distance > 0
    );
    -- select the minimum paths and put them into shortest_paths
    INSERT INTO shortest_paths
        SELECT from_node_id, to_node_id, MIN(total_distance) AS total_distance
        FROM joined_dup
        WHERE total_distance > 0
        GROUP BY from_node_id;
END !
DELIMITER ;

-- [Problem 2b]
SELECT from_node_id AS node_id, node_name, SUM(inv_dist) AS centrality FROM
    (SELECT from_node_id, node_name, 1 / total_distance AS inv_dist FROM
        shortest_paths JOIN nodes ON from_node_id = node_id) AS t2
        GROUP BY from_node_id ORDER BY centrality DESC LIMIT 5;
