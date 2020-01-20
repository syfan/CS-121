-- [Problem 9]
DROP TABLE IF EXISTS cards_for_sale;
DROP TABLE IF EXISTS player_cards;
DROP TABLE IF EXISTS card_types;
DROP TABLE IF EXISTS players;

-- Keeps track of the information for players. Includes their ID, username,
-- email, date of registry, and ban status. Primary key is the player_id
CREATE TABLE players(
    player_id       INTEGER NOT NULL,
    username        VARCHAR(30) NOT NULL UNIQUE,
    email           VARCHAR(100) NOT NULL,
    register_date   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    player_status   CHAR(1) NOT NULL DEFAULT 'A',
    PRIMARY KEY (player_id)
);

-- Keeps track of the information for the different cards.  Includes the id of
-- the card type, name of card, description for card, value of card, and
-- total circulation of the card.  Primary key is the id of the card (type_id).
CREATE TABLE card_types (
    type_id             INTEGER NOT NULL,
    card_name           VARCHAR(100) NOT NULL UNIQUE,
    card_desc           VARCHAR(4000) NOT NULL,
    card_value          NUMERIC(5,1) NOT NULL,
    total_circulation   INTEGER,
    PRIMARY KEY (type_id)
);

-- Keeps track of who owns which cards.  Includes the card's IDs, the type of
-- card's IDs, and the players' IDs.  Primary key is card ID (card_id).
CREATE TABLE player_cards (
    card_id         INTEGER NOT NULL,
    type_id         INTEGER NOT NULL,
    player_id       INTEGER NOT NULL,
    PRIMARY KEY (card_id)
);

-- Keeps track of what cards are for sale.  Includes IDs of players, IDs of
-- cards, date of offer, and price.  Primary key is player_id, and has foreign
-- key on player_id and card_id from player_cards.
CREATE TABLE cards_for_sale (
    player_id       INTEGER NOT NULL,
    card_id         INTEGER NOT NULL,
    offer_date      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    card_price      NUMERIC(7,2) NOT NULL,
    PRIMARY KEY (player_id, card_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (card_id) REFERENCES player_cards(card_id)
);
