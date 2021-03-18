# Display  all the nodes

```
kubectl get nodes
```

# Display all the namespaces 

```
kubectl get ns
```

# For each of the namespaces of interest for the application, list the services and the pods


# PostgreSQL

```
kubectl -n postgresql get svc
kubectl -n postgresql get pods
```

# MySQL

```
kubectl -n mysql get svc
kubectl -n mysql get pods
```

# ContosoappMySQL

```
kubectl -n contosoappmysql get svc
kubectl -n contosoappmysql get pods
```

# ContosoappPostgres

```
kubectl -n contosoapppostgres get svc
kubectl -n contosoapppostgres get pods
```

# Connect to Postgres or  MySQL database

```
kubectl -n postgresql exec deploy/postgres -it -- /usr/bin/psql -U contosoapp postgres
kubectl -n mysql exec deploy/mysql -it -- /usr/bin/mysql -u contosoapp -pOCPHack8
```