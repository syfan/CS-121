-- [Problem 1.4a]
SELECT artist_name, tot_request
    FROM 
        (
            SELECT audio_id, COUNT(audio_id) AS tot_request FROM master_playlist
            WHERE request IS TRUE 
            GROUP BY audio_id
            ORDER BY tot_request DESC
        ) AS counts
    JOIN song ON counts.audio_id = song.audio_id
    JOIN artist ON song.artist_id = artist.artist_id;
    

-- [Problem 1.4b]
SELECT company_name, SUM(price) AS total_amount FROM
    (
        SELECT * FROM master_playlist
        WHERE play_datetime BETWEEN CURDATE() - INTERVAL 30 DAY and CURDATE()
    ) AS in_interval
    JOIN audio ON in_interval.audio_id = audio.audio_id
    JOIN advertisement ON advertisement.audio_id = audio.audio_id
    JOIN company ON company.company_id = advertisement.company_id
    GROUP BY company_name;
    




