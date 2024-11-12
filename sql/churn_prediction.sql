-- Predict potential churn by identifying users with no activity in the last 30 days and a past due renewal
SELECT
    user_id,
    DATEDIFF(CURRENT_DATE, last_activity_date) AS days_inactive,
    CASE 
        WHEN DATEDIFF(CURRENT_DATE, last_activity_date) > 30 
             AND DATEDIFF(CURRENT_DATE, renewal_date) > 0 THEN 'High Risk'
        ELSE 'Low Risk'
    END AS churn_risk
FROM clean_subscriptions
WHERE status = 'active';
