-- whew!
SELECT * FROM tweets WHERE body='WHEW!';

-- there are only a whew of us left
SELECT city, state FROM tweeters WHERE tweeter IN (
    SELECT tweeter FROM tweets WHERE body='WHEW!'
);

-- how many tweets have said good morning?
SELECT COUNT(*) FROM tweets WHERE body ILIKE '%good morning%';

-- what's the average time people say good morning?
SELECT AVG(date::time) FROM tweets WHERE body ILIKE '%good morning%';

-- how many people in each state have said good morning?
SELECT state, COUNT(*) FROM tweeters 
INNER JOIN tweets ON tweets.tweeter=tweeters.tweeter 
WHERE tweets.body ILIKE '%good morning%' 
GROUP BY state ORDER BY state;

-- twitter state courteousness
SELECT morning.state, morning.count::float/total.count::float AS courtesy
FROM (SELECT state, COUNT(*) FROM tweeters GROUP BY state)
AS total
JOIN (SELECT state, COUNT(*) FROM tweeters INNER JOIN tweets 
    ON tweets.tweeter=tweeters.tweeter 
    WHERE tweets.body ILIKE '%good morning%' 
    GROUP BY state ORDER BY state) 
AS morning 
ON total.state=morning.state;

-- good morning tweet frequency by city
SELECT tweeters.city, tweeters.state, COUNT(*) AS count 
FROM tweeters INNER JOIN tweets ON tweets.tweeter=tweeters.tweeter 
WHERE tweets.body ILIKE '%good morning%' 
AND tweets.body ILIKE '%' || tweeters.city || '%' 
GROUP BY tweeters.city, tweeters.state 
ORDER BY count DESC;

-- tweet frequency by city
SELECT tweeters.city, tweeters.state, COUNT(*) AS count 
FROM tweeters INNER JOIN tweets ON tweets.tweeter=tweeters.tweeter 
GROUP BY tweeters.city, tweeters.state 
ORDER BY count DESC;

-- twitter's true colors
SELECT regexp_matches(body,
'[^A-z](red|orange|yellow|green|blue|purple|brown|white|black)[^A-z]'
) AS reg, COUNT(*) AS count FROM tweets GROUP BY reg ORDER BY count DESC;

-- that's all, folks!
SELECT body, city FROM tweets
INNER JOIN tweeters ON tweeters.tweeter=tweets.tweeter
WHERE body='that''s all, folks!';
