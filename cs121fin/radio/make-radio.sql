-- [Problem 1.3]
-- DROP TABLE commands
DROP TABLE IF EXISTS company_emails;
DROP TABLE IF EXISTS advertisement;
DROP TABLE IF EXISTS company;
DROP TABLE IF EXISTS promotion;
DROP TABLE IF EXISTS song;
DROP TABLE IF EXISTS artist;
DROP TABLE IF EXISTS master_playlist;
DROP TABLE IF EXISTS audio;

-- contains information about the audio files, including the id, the name of the
-- path + filename, and length of the audio. Primary key is the audio id
CREATE TABLE audio(
    audio_id INTEGER NOT NULL AUTO_INCREMENT,
    file_pathname VARCHAR(1024) NOT NULL,
    length NUMERIC(7,2) NOT NULL,

    PRIMARY KEY (audio_id)
);

-- contains information on the playlist itself, including the ids of the audio,
-- whether the play was a request, and the datetime of the play. The audio id is
-- the primary key, which is referenced from audio
CREATE TABLE master_playlist(
    audio_id INTEGER NOT NULL,
    request BOOLEAN,
    play_datetime DATETIME UNIQUE NOT NULL,

    PRIMARY KEY (audio_id),
    FOREIGN KEY (audio_id) REFERENCES audio(audio_id)
);

-- contains information on artists, including the id and name. The id is the
-- primary key
CREATE TABLE artist(
    artist_id INTEGER NOT NULL AUTO_INCREMENT,
    artist_name VARCHAR(100) NOT NULL UNIQUE,

    PRIMARY KEY(artist_id)
);

-- contains information on songs, including the audio id, length of intro,
-- whether the song is explicit, the artist id, and tag. Primary key is audio id
-- which is referenced from audio, and artist id is referenced from artist
CREATE TABLE song(
    audio_id INTEGER NOT NULL,
    intro_length INTEGER NOT NULL,
    explicit BOOLEAN NOT NULL,
    artist_id INTEGER NOT NULL,
    tag VARCHAR(30),

    PRIMARY KEY (audio_id),
    FOREIGN KEY (audio_id) REFERENCES audio(audio_id),
    FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
);

-- contains information on promotions, including the audio id, the type of
-- promo, and the optional URL. Primary key is the audio id, which is from
-- the audio table
CREATE TABLE promotion(
    audio_id INTEGER NOT NULL,
    promo_type VARCHAR(30) NOT NULL,
    URL VARCHAR(1000),

    PRIMARY KEY (audio_id),
    FOREIGN KEY (audio_id) REFERENCES audio(audio_id)
);

-- contains information on companies, including the company's id and name. The
-- primary key is the company id
CREATE TABLE company(
    company_id INTEGER NOT NULL AUTO_INCREMENT,
    company_name VARCHAR(30) UNIQUE,

    PRIMARY KEY (company_id)
);

-- contains information on the emails of the companies, including the company
-- id and the emails. A company can have multiple emails. The primary key is
-- the company id, which is referenced from company
CREATE TABLE company_emails(
    company_id INTEGER NOT NULL,
    email VARCHAR(30) UNIQUE,

    PRIMARY KEY (company_id),
    FOREIGN KEY (company_id) REFERENCES company(company_id)
);

-- contains information on the advertisements, including the audio id, the id of
-- the company that comissioned the ad, start and end datetimes of the running
-- for the ad, and the price. Primary key is audio id from the audio table. The
-- company id is from company
CREATE TABLE advertisement(
    audio_id INTEGER NOT NULL,
    company_id INTEGER NOT NULL,
    start_datetime DATETIME NOT NULL,
    end_datetime DATETIME NOT NULL,
    price NUMERIC(6,2),

    PRIMARY KEY (audio_id),
    FOREIGN KEY (audio_id) REFERENCES audio(audio_id),
    FOREIGN KEY (company_id) REFERENCES company(company_id)
);
