\copy (SELECT state, COUNT(*) AS num FROM tweeters INNER JOIN tweets ON tweets.tweeter=tweeters.tweeter WHERE tweets.body ILIKE '%good morning%' GROUP BY state ORDER BY state) TO 'tweet_mornings.csv' DELIMITER ',' CSV HEADER;

\copy (SELECT state, COUNT(*) AS num FROM tweeters GROUP BY state) TO 'tweet_states.csv' DELIMITER ',' CSV HEADER;

\copy (SELECT morning.state, morning.count::float/total.count::float AS num FROM (SELECT state, COUNT(*) FROM tweeters GROUP BY state) AS total JOIN (SELECT state, COUNT(*) FROM tweeters INNER JOIN tweets ON tweets.tweeter=tweeters.tweeter WHERE tweets.body ILIKE '%good morning%' GROUP BY state ORDER BY state) AS morning ON total.state=morning.state) TO 'tweet_courtesies.csv' DELIMITER ',' CSV HEADER;

