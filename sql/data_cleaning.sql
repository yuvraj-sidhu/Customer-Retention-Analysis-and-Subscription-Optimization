-- Cleaning null values and formatting dates
CREATE TABLE clean_subscriptions AS
SELECT
    user_id,
    COALESCE(cancel_date, '9999-12-31') AS cancel_date,
    signup_date,
    last_activity_date,
    plan_type,
    renewal_date,
    status,
    monthly_revenue
FROM subscriptions;
