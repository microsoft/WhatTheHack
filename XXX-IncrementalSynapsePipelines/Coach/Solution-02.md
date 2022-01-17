# Challenge #2: Create Incremental Load Pipelines - Coach's Guide

[< Previous Challenge](Solution-01.md) - **[Home](README.md)** - [Next Challenge>](Solution-03.md)

## Notes & Guidance
Here are some sample scripts to Enable Change Data Capture on the AdventureWorks SQL database.

1. Enable Database for CDC template

```sql
USE AdventureWorks  
GO  
EXEC sys.sp_cdc_enable_db  
GO
```
