# Challenge 1: Assessment 

[< Previous Challenge](./00-prereqs.md) - **[Home](./README.md)** - [Next Challenge >](./02-size-analysis.md)

## Coach Tips

* The attendee should be able to connect to the PostgreSQL/MySQL container like this to run monitoring tool for assessment :

    ```bash
    kubectl -n postgresql exec deploy/postgres -it -- bash
    ```
    or

    ```bash
    kubectl -n mysql exec deploy/mysql -it -- bash
    ```

    Once they do that they can use psql or mysql to check the version. In MySQL to check the db engine and what type of tables we have, do this:
    
    ```sql
    select table_schema, engine, count(1) from information_schema.tables group by table_schema, engine  ;
    ```
