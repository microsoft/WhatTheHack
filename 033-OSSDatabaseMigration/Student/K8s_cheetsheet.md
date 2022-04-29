**[Home](../README.md)**

### Reset Credentials in case you are re-deploying it

```
az aks get-credentials --name ossdbmigration --resource-group OSSDBMigration
```

### Display all the nodes

```
kubectl get nodes
```

### Display all the namespaces 

```
kubectl get ns
```

### List the services and the pods for MySQL

```
kubectl -n mysql get svc
kubectl -n mysql get pods
```

### List the services and the pods for PostgreSQL

```
kubectl -n postgresql get svc
kubectl -n postgresql get pods
```

### List the services and the pods for Oracle

```
kubectl -n oracle get svc
kubectl -n oracle get pods
```

### List the services and the pods for the Pizzeria application on MySQL

```
kubectl -n contosoappmysql get svc
kubectl -n contosoappmysql get pods
```

### List the services and the pods for the Pizzeria application on PostgreSQL

```
kubectl -n contosoapppostgres get svc
kubectl -n contosoapppostgres get pods
```

### List the services and the pods for the Pizzeria application on Oracle

```
kubectl -n contosoapporacle get svc
kubectl -n contosoapporacle get pods
```

### Connect to the MySQL, Oracle, and PostgreSQL database

```
kubectl -n mysql exec deploy/mysql -it -- /usr/bin/mysql -u contosoapp -pOCPHack8
kubectl -n postgresql exec deploy/postgres -it -- /usr/bin/psql -U contosoapp postgres
kubectl -n oracle exec deploy/oracle -it -- /opt/oracle/product/18c/dbhomeXE/bin/sqlplus C##WTH@XE/<password>
```


### Open a Bash shell to the MySQL service
```
kubectl -n mysql exec deploy/mysql -it -- bash
```

### Open a Bash shell to the PostgreSQL service
```
kubectl -n postgresql exec deploy/postgres -it -- bash
```

### Open a Bash shell to the Oracle service
```
kubectl -n oracle exec deploy/oracle -it -- /bin/bash
```

### View the deployment logs of the container(s)
```bash
kubectl -n {infrastructure.namespace goes here} logs deploy/contosopizza --tail=5000 #Or omit '--tail 5000' if you want to see the environment variables that were used at deployment time 
```
