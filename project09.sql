DROP TABLE IF EXISTS tweeters CASCADE;
DROP TABLE IF EXISTS tweeters_temp CASCADE;

DROP TABLE IF EXISTS tweets CASCADE;
DROP TABLE IF EXISTS states CASCADE;

DROP TABLE IF EXISTS state_pops_temps CASCADE;
DROP TABLE IF EXISTS state_pops CASCADE;

DROP TABLE IF EXISTS biggest_cities CASCADE;

CREATE TABLE tweets (
    tweeter serial,
    tweet bigserial,
    body text,
    date timestamp
);

CREATE TABLE tweeters (
    tweeter serial PRIMARY KEY,
    city text,
    state text
);

CREATE TABLE tweeters_temp (
    tweeter serial,
    area text
);

CREATE TABLE states (
    state text,
    abbrev text
);

CREATE TABLE state_pops (
    city text,
    state text,
    pop integer
);

CREATE TABLE biggest_cities (
    city text,
    state text
);

CREATE TABLE state_pops_temps (
    c1    text,
    c2    text,
    c3    text,
    c4    text,
    c5    text,

    c6    text,
    c7    text,
    c8    text,
    city  text,
    state text,

    c11   text,
    pop   integer,
    c13   text,
    c14   text,
    c15   text,

    c16   text,
    c17   text,
    c18   text,
    c19   text
);


\copy tweeters_temp FROM 'training_set_users.txt'

\copy tweets FROM 'valid_tweets.txt' DELIMITER E'\t'

-- some users are duplicates, so only add unique tweeters to table
INSERT INTO tweeters
SELECT DISTINCT ON (tweeter) * FROM tweeters_temp;

DROP TABLE IF EXISTS tweeters_temp;

-- separate 'City, State' into two columns
UPDATE tweeters
SET city=split_part(city, ', ', 1),
    state=split_part(city, ', ', 2);

\copy states FROM 'states.csv' CSV HEADER;

-- need custom encoding because of special characters in cities(!)
\copy state_pops_temps FROM 'sub-est2016_all.csv' CSV HEADER ENCODING 'latin1';

-- remove those pesky postfixes
UPDATE state_pops_temps SET city =
(regexp_split_to_array(city,
    ' (?:city|town|village|Borough|Municipality|municipality|Town|borough|plantation)')
)[1];

-- removes states and counties and such
DELETE FROM state_pops_temps WHERE c1='040';
DELETE FROM state_pops_temps WHERE c1='050';
DELETE FROM state_pops_temps WHERE city LIKE '%County%';
DELETE FROM state_pops_temps WHERE city LIKE '%Balance of%';

-- get unique cities with the highest population
INSERT INTO biggest_cities
SELECT s1.city, s1.state FROM state_pops_temps AS s1
INNER JOIN state_pops_temps AS s2
ON s1.city=s2.city
GROUP BY s1.city, s1.state, s1.pop
HAVING MAX(s2.pop)=s1.pop;

-- infer that tweeters that didn't specify a state live in the
-- most populous city they refer to
UPDATE tweeters SET state=bc.state FROM biggest_cities AS bc
WHERE tweeters.state='' AND bc.city=tweeters.city;

-- all states now use abbreviations rather than full names
UPDATE tweeters
SET state=states.abbrev FROM STATES
WHERE tweeters.state=states.state;

INSERT INTO state_pops
SELECT DISTINCT city, state, pop FROM state_pops_temps;

DROP TABLE IF EXISTS state_pops_temps;
                                                             128,1         Bot

