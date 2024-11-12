-- Calculating lifetime value by average monthly revenue and retention rate
WITH avg_revenue AS (
    SELECT
        plan_type,
        AVG(monthly_revenue) AS avg_monthly_revenue
    FROM clean_subscriptions
    GROUP BY plan_type
),
avg_retention AS (
    SELECT
        plan_type,
        AVG(active_users * 1.0 / total_signups) AS avg_retention_rate
    FROM monthly_activity
    GROUP BY plan_type
)
SELECT
    c.plan_type,
    c.avg_monthly_revenue / (1 - r.avg_retention_rate) AS lifetime_value
FROM avg_revenue c
JOIN avg_retention r ON c.plan_type = r.plan_type;
