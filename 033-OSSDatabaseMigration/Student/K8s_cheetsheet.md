**[Home](../README.md)**

# Display  all the nodes

```
kubectl get nodes
```

# Display all the namespaces 

```
kubectl get ns
```

# List the services and the pods for PostgreSQL

```
kubectl -n postgresql get svc
kubectl -n postgresql get pods
```

# List the services and the pods for MySQL

```
kubectl -n mysql get svc
kubectl -n mysql get pods
```

# List the services and the pods for the Pizzeria application on MySQL

```
kubectl -n contosoappmysql get svc
kubectl -n contosoappmysql get pods
```

# List the services and the pods for the Pizzeria application on PostgreSQL

```
kubectl -n contosoapppostgres get svc
kubectl -n contosoapppostgres get pods
```

# Connect to the PostgreSQL or MySQL database

```
kubectl -n postgresql exec deploy/postgres -it -- /usr/bin/psql -U contosoapp postgres
kubectl -n mysql exec deploy/mysql -it -- /usr/bin/mysql -u contosoapp -pOCPHack8
```

# Open a Bash shell for the PostgreSQL pod
```
kubectl -n postgresql exec deploy/postgres -it -- bash
```

# Open a Bash shell for the MySQL pod
```
kubectl -n mysql exec deploy/mysql -it -- bash
```