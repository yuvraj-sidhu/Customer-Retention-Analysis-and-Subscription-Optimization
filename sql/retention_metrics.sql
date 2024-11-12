-- Monthly retention rate and churn rate calculation
WITH monthly_activity AS (
    SELECT
        DATE_TRUNC('month', signup_date) AS month,
        COUNT(DISTINCT user_id) AS total_signups,
        COUNT(DISTINCT CASE WHEN status = 'active' THEN user_id END) AS active_users,
        COUNT(DISTINCT CASE WHEN status = 'canceled' THEN user_id END) AS churned_users
    FROM clean_subscriptions
    GROUP BY month
)
SELECT
    month,
    active_users * 1.0 / total_signups AS retention_rate,
    churned_users * 1.0 / total_signups AS churn_rate
FROM monthly_activity;
