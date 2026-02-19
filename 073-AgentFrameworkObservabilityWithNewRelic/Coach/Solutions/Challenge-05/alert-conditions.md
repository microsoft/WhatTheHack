# Alert Conditions Configuration

This document outlines the alert conditions configured for monitoring the AI travel planner agent application using New Relic. The alerts are designed to notify the development and operations teams of any critical issues that may impact the application's performance or availability.

## Alert Conditions

### 1. High Error Rate Alert

- **Condition Name:** High Error Rate
- **Description:** This alert triggers when the error rate exceeds 5% over a 5
    minute period. This helps to identify issues that may be causing failures in the
    application.
- **NRQL Query:**

  ```sql
  SELECT percentage(count(*), WHERE error IS true) AS 'Error Rate'
  FROM Transaction
  WHERE appName = 'AI_Travel_Planner'
  SINCE 5 minutes ago
  ```

- **Threshold:** Greater than 5% for at least 5 minutes
- **Notification Channels:** Email, Slack
- **Screenshot:**
  ![High Error Rate Alert Configuration](screenshots/high_error_rate_alert.png)

### 2. High Response Time Alert

- **Condition Name:** High Response Time
- **Description:** This alert triggers when the average response time exceeds 2 seconds
    over a 5 minute period. This helps to identify performance bottlenecks in the
    application.
- **NRQL Query:**

  ```sql
  SELECT average(duration) AS 'Average Response Time'
  FROM Transaction
  WHERE appName = 'AI_Travel_Planner'
  SINCE 5 minutes ago
  ```

- **Threshold:** Greater than 2 seconds for at least 5 minutes
- **Notification Channels:** Email, Slack
- **Screenshot:**
  ![High Response Time Alert Configuration](screenshots/high_response_time_alert.png)

### 3. CPU Utilization Alert

- **Condition Name:** High CPU Utilization
- **Description:** This alert triggers when the CPU utilization exceeds 80% over a 5
    minute period. This helps to identify resource constraints that may affect the
    application's performance.
- **NRQL Query:**

  ```sql
  SELECT average(cpuPercent) AS 'CPU Utilization'
  FROM SystemSample
  WHERE appName = 'AI_Travel_Planner'
  SINCE 5 minutes ago
  ```

- **Threshold:** Greater than 80% for at least 5 minutes
- **Notification Channels:** Email, Slack
- **Screenshot:**
  ![High CPU Utilization Alert Configuration](screenshots/high_cpu_utilization_alert.png)

### 4. Memory Utilization Alert

- **Condition Name:** High Memory Utilization
- **Description:** This alert triggers when the memory utilization exceeds 75% over a 5
    minute period. This helps to identify memory leaks or resource constraints that
    may affect the application's performance.
- **NRQL Query:**

  ```sql
  SELECT average(memoryPercent) AS 'Memory Utilization'
  FROM SystemSample
  WHERE appName = 'AI_Travel_Planner'
  SINCE 5 minutes ago
  ```

- **Threshold:** Greater than 75% for at least 5 minutes
- **Notification Channels:** Email, Slack
- **Screenshot:**
  ![High Memory Utilization Alert Configuration](screenshots/high_memory_utilization_alert.png)

## Conclusion

The alert conditions configured above provide comprehensive monitoring for the AI travel planner agent application. By proactively identifying and addressing issues related to error rates, response times, CPU, and memory utilization, the development and operations teams can ensure the application's reliability and performance.
