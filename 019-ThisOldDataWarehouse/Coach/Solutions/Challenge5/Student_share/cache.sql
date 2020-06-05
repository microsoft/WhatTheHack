--Database script to turn on/off Result Set caching
--Run script on master database

--Cache off
ALTER DATABASE [wwisynapse] SET RESULT_SET_CACHING OFF;

--Cache on
ALTER DATABASE [wwisynapse] SET RESULT_SET_CACHING ON;