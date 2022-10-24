/* CoolTShirts is a fictional wedsite that sells shirts of all kinds. 
Recently, CTS started a few marketing campaigns to increase website visits and purchases. 
Using touch attribution, they’d like to map their customers’ journey: from initial visit to purchase. 
They can use that information to optimize their marketing campaigns and I as a Data Analyst will help them in that.
This file contains only sql queries. */

-- 1. How many campaigns and sources does CoolTShirts use? Which source is used for each campaign?

-- The query below counts unique campaigns used by CoolTShirt: 
SELECT COUNT(DISTINCT utm_campaign) AS 'unique_campaigns_count'
FROM page_visits;

-- The query below displays unique campaign names used by CoolTShirt:
SELECT DISTINCT utm_campaign AS 'unique_campaign_names'
FROM page_visits;

-- The query below counts unique sources used by CoolTShirt: 
SELECT COUNT(DISTINCT utm_source) AS 'unique_sources_count'
FROM page_visits;

-- The query below displays unique sources names used by CoolTShirt:
SELECT DISTINCT utm_source AS 'unique_sources_names'
FROM page_visits;

-- Which source is used for each campaign?
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

-- What pages are on the CoolTShirts website?
SELECT DISTINCT page_name AS 'unique_pages'
FROM page_visits;

-- 2. What pages are on the CoolTShirts website?
SELECT DISTINCT page_name AS 'unique_pages'
FROM page_visits;

-- 3. User journey: How many first touches is each campaign responsible for?
WITH first_touch AS (
  SELECT user_id, 
         MIN(timestamp) as 'first_touch_time'
  FROM page_visits
  GROUP BY user_id
),
first_touch_attribution AS (
  SELECT ft.user_id,
       ft.first_touch_time,
       pv.utm_source,
       pv.utm_campaign
  FROM first_touch AS 'ft'
  JOIN page_visits AS 'pv' 
     ON ft.user_id = pv.user_id
     AND ft.first_touch_time = pv.timestamp
)
SELECT first_touch_attribution.utm_source,
       first_touch_attribution.utm_campaign,
       COUNT(*) AS 'first_touch_count'
FROM first_touch_attribution
GROUP BY 1, 2
ORDER BY 3 DESC;

-- 4. How many last touches is each campaign responsible for?
WITH last_touch AS (
  SELECT user_id, 
         MAX(timestamp) as 'last_touch_time'
  FROM page_visits
  GROUP BY user_id
),
last_touch_attribution AS (
  SELECT lt.user_id,
       lt.last_touch_time,
       pv.utm_source,
       pv.utm_campaign
  FROM last_touch AS 'lt'
  JOIN page_visits AS 'pv' 
     ON lt.user_id = pv.user_id
     AND lt.last_touch_time = pv.timestamp
)
SELECT last_touch_attribution.utm_source,
       last_touch_attribution.utm_campaign,
       COUNT(*) AS 'last_touch_count'
FROM last_touch_attribution
GROUP BY 1, 2
ORDER BY 3 DESC;

-- 5. How many visitors make a purchase?
SELECT COUNT(DISTINCT user_id) AS 'total_purchase_page_visitors'
FROM page_visits
WHERE page_name = '4 - purchase';

-- 6. How many last touches on the purchase page is each campaign responsible for?
WITH last_touch AS (
  SELECT user_id, 
         MAX(timestamp) as 'last_touch_time'
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id
),
last_touch_attribution AS (
  SELECT lt.user_id,
       lt.last_touch_time,
       pv.utm_source,
       pv.utm_campaign
  FROM last_touch AS 'lt'
  JOIN page_visits AS 'pv' 
     ON lt.user_id = pv.user_id
     AND lt.last_touch_time = pv.timestamp
)
SELECT last_touch_attribution.utm_source,
       last_touch_attribution.utm_campaign,
       COUNT(*) AS 'last_touch_count'
FROM last_touch_attribution
GROUP BY 1, 2
ORDER BY 3 DESC;