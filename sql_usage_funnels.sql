/*
Warby Parker is a lifestyle brand that offers designer eyewear at a revolutionary price while leading the way for socially conscious businesses. To help users find their perfect frame, Warby Parker has a Style Quiz that has the following questions:
- “What are you looking for?”
- “What’s your fit?”
- “Which shapes do you like?”
- “Which colors do you like?”
- “When was your last eye exam?”

The users’ responses are stored in a table called survey.

In this project, I analyzed usage funnels below and calculated conversion rates:

Quiz Funnel:
- Survey

Home Try-On Funnel:
- quiz
- home_try_on
- Purchase
*/

-- Users will “give up” at different points in the survey. Let’s create a quiz funnel command to analyze how many users move from Question 1 to Question 2, etc.
SELECT question, COUNT(DISTINCT user_id) as total_users
FROM survey
GROUP BY 1;

-- Write a query that shows how many users completed each step of the purchase funnel and calculate conversion rate.
WITH purchase_funnel AS (
 SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
  ON q.user_id = h.user_id
LEFT JOIN purchase p
  ON p.user_id = q.user_id
)
SELECT COUNT(*) AS 'quiz',
      SUM(is_home_try_on) AS 'home_try_on',
      SUM(is_purchase) AS 'purchase',
      1.0 * SUM(is_home_try_on) / COUNT(user_id) AS '%_home_try_on',
      1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS '%_purchase'
FROM purchase_funnel;

-- Write a query that shows the difference in purchase rates between users who received 3 and 5 pairs of glasses.
WITH ab_test AS (
SELECT DISTINCT q.user_id,
 h.user_id IS NOT NULL AS 'is_home_try_on',
 h.number_of_pairs AS "ab_variant",
 p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS q
LEFT JOIN home_try_on AS h
 ON q.user_id = h.user_id
LEFT JOIN purchase AS p
 ON p.user_id = q.user_id
)
SELECT ab_variant,
      SUM(CASE WHEN is_home_try_on = 1 THEN 1 ELSE 0 END) AS 'home_try_on',
      SUM(CASE WHEN is_purchase = 1 THEN 1 ELSE 0 END) AS 'purchase'
FROM ab_test
GROUP BY ab_variant
HAVING home_try_on > 0;