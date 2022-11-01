--Database script to turn on/off Result Set caching
--Run script on master database
--Performance results will improve after the data is cached on the second execution of the report.
--Record response times in Performance Analyzer in Power BI report since it will be simple to rerun and capture queries
--This will have the most sigificant impact on the Power BI report outside of composite models

--Cache off
ALTER DATABASE [wwisynapse] SET RESULT_SET_CACHING OFF;

--Cache on
ALTER DATABASE [wwisynapse] SET RESULT_SET_CACHING ON;