# Retention_Analysis

# Import necessary libraries
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import datetime as dt

# Load data
data = pd.read_csv('../data/subscription_data.csv')

# Convert date columns to datetime format
data['signup_date'] = pd.to_datetime(data['signup_date'])
data['cancel_date'] = pd.to_datetime(data['cancel_date'])
data['last_activity_date'] = pd.to_datetime(data['last_activity_date'])
data['renewal_date'] = pd.to_datetime(data['renewal_date'])

# Basic EDA
print("First few rows of data:")
print(data.head())

# Calculate Retention Metrics
data['churned'] = data['status'] == 'canceled'
data['active'] = data['status'] == 'active'

# Monthly Cohort Grouping
data['cohort_month'] = data['signup_date'].dt.to_period('M')
data['activity_month'] = data['last_activity_date'].dt.to_period('M')

# Cohort Analysis: Counting Users by Cohort
cohort_counts = data.groupby(['cohort_month', 'activity_month']).size().unstack().fillna(0)
print("Cohort Table:")
print(cohort_counts)

# Visualize the Retention Rate by Cohort
plt.figure(figsize=(12, 8))
sns.heatmap(cohort_counts, annot=True, fmt=".0f", cmap="Blues")
plt.title("Customer Retention by Monthly Cohorts")
plt.ylabel("Cohort Month (Signup)")
plt.xlabel("Activity Month")
plt.show()

# Churn Prediction Analysis: Identifying High-Risk Customers
today = dt.datetime.today()
data['days_inactive'] = (today - data['last_activity_date']).dt.days
data['churn_risk'] = data.apply(lambda row: 'High Risk' if (row['days_inactive'] > 30 and row['renewal_date'] < today) else 'Low Risk', axis=1)

high_risk_customers = data[data['churn_risk'] == 'High Risk']
print("High-Risk Customers:")
print(high_risk_customers[['user_id', 'days_inactive', 'churn_risk']])

# Customer Lifetime Value (CLV) Estimation
avg_revenue = data.groupby('plan_type')['monthly_revenue'].mean()
retention_rate = data['active'].mean()
clv = avg_revenue / (1 - retention_rate)
print("Estimated Customer Lifetime Value by Plan Type:")
print(clv)

