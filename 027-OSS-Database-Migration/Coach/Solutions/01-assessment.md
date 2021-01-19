# Challenge 1: Assessment (feature differences and compatibility) 

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-size-analysis.md)

## Proctor Tips

1) The attendee should be to connect to the PostgreSQL/MySQL container like this:
    kubectl -n postgresql exec deploy/postgres -it -- bash
    or
    kubectl -n mysqlwth exec deploy/mysql -it -- bash

    Once they do that they can use psql or mysql to check the version

