-- [Problem 10]
SELECT * FROM card_types WHERE total_circulation IS NULL AND card_value > 10;


-- [Problem 11]
UPDATE card_types NATURAL JOIN player_cards NATURAL JOIN players
    SET card_value = (card_value + 10) WHERE username = 'ted_codd';


-- [Problem 12]
DELETE c FROM players AS p NATURAL LEFT JOIN cards_for_sale AS c
    WHERE username = 'smith';
DELETE t1, t2, t3 FROM players AS t1 NATURAL JOIN card_types as t2
    NATURAL JOIN player_cards AS t3 WHERE username = 'smith';


-- [Problem 13]
SELECT SUM(card_value) as sums FROM players NATURAL JOIN card_types
    NATURAL JOIN player_cards GROUP BY player_id ORDER BY sums DESC LIMIT 5;


-- [Problem 14a]
SELECT COUNT(player_id) FROM player_cards NATURAL JOIN card_types
    WHERE player_cards.type_id = card_types.type_id GROUP BY type_id;


-- [Problem 14b]
CREATE VIEW bad_cards AS
    SELECT COUNT(player_id) FROM player_cards NATURAL JOIN card_types
    WHERE player_cards.type_id = card_types.type_id GROUP BY type_id;


-- [Problem 15]
SELECT player_id FROM players NATURAL JOIN card_types NATURAL JOIN player_cards
    WHERE (SELECT COUNT(card_id) FROM player_cards
        WHERE player_cards.player_id = players.player_id ) > 0
        AND total_circulation <= 10;


-- [Problem 16]
CREATE VIEW newbie_card_types AS
    SELECT type_id, card_name, card_desc FROM (players NATURAL JOIN card_types
    NATURAL JOIN player_cards) WHERE WEEK(CURRENT_TIMESTAMP()) - WEEK(register_date) <= 1;

-- [Problem 17]
CREATE VIEW user_types AS
    SELECT username, email, (
        SELECT CASE (SELECT COUNT(card_id) FROM cards_for_sale 
        WHERE cards_for_sale.player_id = players.player_id GROUP BY player_id) 
        WHEN 1 THEN 'player'  ELSE 'seller' END
    ) FROM players;
    
