WITH cohorts AS (
    SELECT
        user_id,
        DATE_TRUNC('month', signup_date) AS cohort_month,
        DATE_TRUNC('month', last_activity_date) AS last_activity_month
    FROM clean_subscriptions
)
SELECT
    cohort_month,
    COUNT(DISTINCT user_id) AS total_users,
    COUNT(DISTINCT CASE WHEN last_activity_month = cohort_month THEN user_id END) AS retained_month_0,
    COUNT(DISTINCT CASE WHEN last_activity_month = cohort_month + INTERVAL '1 month' THEN user_id END) AS retained_month_1,
    COUNT(DISTINCT CASE WHEN last_activity_month = cohort_month + INTERVAL '2 month' THEN user_id END) AS retained_month_2
FROM cohorts
GROUP BY cohort_month
ORDER BY cohort_month;
