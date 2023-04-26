CREATE TABLE IF NOT EXISTS users (
    id int4 NOT NULL generated BY DEFAULT AS identity,
    email VARCHAR(50) NOT NULL,
    login VARCHAR(50) NULL,
    "name" VARCHAR(100) NOT NULL,
    birthday DATE NOT NULL,
    UNIQUE (email),
    primary key (id)
);

CREATE TABLE IF NOT EXISTS user_friends (
    user_id int4 NOT NULL references users(id),
    friend_id int4 NOT NULL references users(id),
    constraint user_friends_pkey primary key (user_id, friend_id)
);

CREATE TABLE IF NOT EXISTS mpa_film_ratings (
    id int4 NOT NULL generated BY DEFAULT AS identity,
    NAME VARCHAR(50) NOT NULL,
    primary key (id)
);

CREATE TABLE IF NOT EXISTS genres (
    id int4 NOT NULL generated BY DEFAULT AS identity,
    "name" VARCHAR(100) NOT NULL,
    primary key (id)
);

CREATE TABLE IF NOT EXISTS films (
    id int4 NOT NULL generated BY DEFAULT AS identity,
    "name" VARCHAR(100) NULL,
    description VARCHAR(200) NULL,
    release_date TIMESTAMP NOT NULL,
    DURATION int4 NOT NULL,
    mpa_film_rating_id int4 NULL references mpa_film_ratings(id),
    constraint films_description_max_length_ck CHECK(char_length(description) <= 200),
    constraint films_duration_ck CHECK(DURATION > 0),
    primary key (id)
);

CREATE TABLE IF NOT EXISTS film_likes (
    film_id int4 NOT NULL references films(id),
    user_id int4 NOT NULL references users(id),
    primary key (film_id, user_id)
);

CREATE TABLE IF NOT EXISTS film_genres (
    film_id int4 NOT NULL references films(id),
    genre_id int4 NOT NULL references genres(id),
    primary key (film_id, genre_id)
);