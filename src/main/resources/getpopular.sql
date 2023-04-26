SELECT
    FILMS.ID,
    FILMS.name,
    FILMS.DESCRIPTION,
    FILMS.RELEASE_DATE,
    FILMS.DURATION,
    IFNULL(MFR.ID,
    0) AS MPA_FILM_RATING_ID,
    MFR.NAME AS MPA_FILM_RATING_NAME
FROM
    FILMS AS FILMS
LEFT JOIN
    (
        SELECT
            FILM_ID,
            COUNT(USER_ID) AS TOTAL
        FROM
            FILM_LIKES
        GROUP BY
            FILM_ID
        ORDER BY
            COUNT(USER_ID)
    ) AS LIKES
        ON FILMS.ID = LIKES.FILM_ID
LEFT JOIN
    MPA_FILM_RATINGS AS MFR
        ON MFR.ID = FILMS.MPA_FILM_RATING_ID
ORDER BY
    IFNULL(LIKES.TOTAL,
    0) DESC                 FETCH FIRST ? ROWS ONLY;