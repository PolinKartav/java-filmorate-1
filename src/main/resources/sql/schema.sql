CREATE TABLE IF NOT EXISTS users
(
    id        int4         NOT NULL generated BY DEFAULT AS identity,
    email     VARCHAR(50)  NOT NULL,
    login     VARCHAR(50)  NULL,
    user_name VARCHAR(100) NOT NULL,
    birthday  DATE         NOT NULL,
    UNIQUE (email),
    primary key (id)
);

CREATE TABLE IF NOT EXISTS user_friends
(
    user_id   int4 NOT NULL references users (id) ON DELETE CASCADE,
    friend_id int4 NOT NULL references users (id) ON DELETE CASCADE,
    constraint user_friends_pkey primary key (user_id, friend_id)
);

CREATE TABLE IF NOT EXISTS mpa_film_ratings
(
    id                   int4        NOT NULL generated BY DEFAULT AS identity,
    mpa_film_rating_name VARCHAR(50) NOT NULL,
    primary key (id)
);

CREATE TABLE IF NOT EXISTS genres
(
    id         int4         NOT NULL generated BY DEFAULT AS identity,
    genre_name VARCHAR(100) NOT NULL,
    primary key (id)
);

CREATE TABLE IF NOT EXISTS films
(
    id                 int4         NOT NULL generated BY DEFAULT AS identity,
    film_name          VARCHAR(100) NULL,
    description        VARCHAR(200) NULL,
    release_date       TIMESTAMP    NOT NULL,
    duration           int4         NOT NULL,
    mpa_film_rating_id int4         NULL references mpa_film_ratings (id),
    constraint films_description_max_length_ck CHECK (char_length(description) <= 200),
    constraint films_duration_ck CHECK (DURATION > 0),
    primary key (id)
);

CREATE TABLE IF NOT EXISTS film_likes
(
    film_id int4 NOT NULL references films (id) ON DELETE CASCADE,
    user_id int4 NOT NULL references users (id) ON
        DELETE
        CASCADE,
    primary key (film_id, user_id)
);

CREATE TABLE IF NOT EXISTS film_genres
(
    film_id  int4 NOT NULL references films (id) ON DELETE CASCADE,
    genre_id int4 NOT NULL references genres (id),
    primary key (film_id, genre_id)
);
CREATE TABLE IF NOT EXISTS directors
(
    id            int4    NOT NULL generated BY DEFAULT AS identity,
    director_name VARCHAR NOT NULL,
    primary key (id)
);
CREATE TABLE IF NOT EXISTS directors_films
(
    film_id      int4 NOT NULL references films (id) on delete cascade,
    director_id int4 NOT NULL references directors (id) on delete cascade,
    primary key (film_id, director_id)
);

CREATE TABLE IF NOT EXISTS REVIEWS (
   ID int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY,
   CONTENT VARCHAR(200) NOT NULL,
   IS_POSITIVE BOOLEAN NOT NULL,
   USER_ID int4 NOT NULL REFERENCES USERS (ID) ON
       DELETE
       CASCADE,
   FILM_ID int4 NOT NULL REFERENCES FILMS (ID) ON
       DELETE
       CASCADE,
   PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS REVIEW_LIKES (
    REVIEW_ID int4 NOT NULL REFERENCES REVIEWS (ID) ON
        DELETE
        CASCADE,
    USER_ID int4 NOT NULL REFERENCES USERS (ID) ON
        DELETE
        CASCADE,
    IS_LIKE BOOLEAN,
    PRIMARY KEY (REVIEW_ID, USER_ID)
);

CREATE TABLE IF NOT EXISTS EVENTS(
     EVENT_ID INT4 NOT NULL GENERATED BY DEFAULT AS IDENTITY,
     EVENT_TIMESTAMP TIMESTAMP NOT NULL,
     EVENT_TYPE ENUM('LIKE', 'REVIEW', 'FRIEND') NOT NULL,
     OPERATION ENUM('REMOVE', 'ADD', 'UPDATE') NOT NULL,
     ENTITY_ID INT4 NOT NULL,
     USER_ID INT4 NOT NULL
);

CREATE TRIGGER USER_FRIENDS_INSERT AFTER
    INSERT
    ON USER_FRIENDS FOR EACH ROW CALL "ru.yandex.practicum.filmorate.trigger.AddFriendTrigger";

CREATE TRIGGER FILM_LIKES_INSERT AFTER
    INSERT
    ON FILM_LIKES FOR EACH ROW CALL "ru.yandex.practicum.filmorate.trigger.AddFilmLikeTrigger";

CREATE TRIGGER FILM_LIKES_UPDATE AFTER
    UPDATE
    ON FILM_LIKES FOR EACH ROW CALL "ru.yandex.practicum.filmorate.trigger.AddFilmLikeTrigger";

CREATE TRIGGER REVIEWS_INSERT AFTER
    INSERT
    ON REVIEWS FOR EACH ROW CALL "ru.yandex.practicum.filmorate.trigger.AddReviewTrigger";

CREATE TRIGGER REVIEWS_UPDATE AFTER
    UPDATE
    ON REVIEWS FOR EACH ROW CALL "ru.yandex.practicum.filmorate.trigger.UpdateReviewTrigger";

CREATE TRIGGER REVIEWS_DELETE AFTER
    DELETE
    ON REVIEWS FOR EACH ROW CALL "ru.yandex.practicum.filmorate.trigger.RemoveReviewTrigger";