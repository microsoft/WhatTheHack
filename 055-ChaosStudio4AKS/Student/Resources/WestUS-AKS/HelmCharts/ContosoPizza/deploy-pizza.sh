status="Running"

# Install the Kubernetes Resources
helm upgrade --install wth-mysql ../MySQL57 --set infrastructure.password=OCPHack8

# Install the Kubernetes Resources Postgres (un comment if you want Postgress vs MySQL)
# helm upgrade --install wth-postgresql ../PostgreSQL116 --set infrastructure.password=OCPHack8
#
# for ((i = 0 ; i < 30 ; i++)); do
#    pgStatus=$(kubectl -n postgresql get pods --no-headers -o custom-columns=":status.phase")
#
#
#    if [ "$pgStatus" != "$status" ]; then
#        sleep 10
#   fi
# done

# Get the postgres pod name
# pgPodName=$(kubectl -n postgresql get pods --no-headers -o custom-columns=":metadata.name")

#Copy pg.sql to the postgresql pod
# kubectl -n postgresql cp ./pg.sql $pgPodName:/tmp/pg.sql

# Use this to connect to the database server
# kubectl -n postgresql exec deploy/postgres -it -- /usr/bin/psql -U postgres -f /tmp/pg.sql

# Install the Kubernettes Resources MySQL
for ((i = 0 ; i < 30 ; i++)); do
    mysqlStatus=$(kubectl -n mysql get pods --no-headers -o custom-columns=":status.phase")   

    if [ "$mysqlStatus" != "$status" ]; then
        sleep 30
    fi
done

# Use this to connect to the database server

kubectl -n mysql exec deploy/mysql -it -- /usr/bin/mysql -u root -pOCPHack8 <./mysql.sql

# postgresClusterIP=$(kubectl -n postgresql get svc -o json |jq .items[0].spec.clusterIP |tr -d '"')

mysqlClusterIP=$(kubectl -n mysql get svc -o json |jq .items[0].spec.clusterIP |tr -d '"')

# sed "s/XXX.XXX.XXX.XXX/$postgresClusterIP/" ./values-postgresql-orig.yaml >temp_postgresql.yaml && mv temp_postgresql.yaml ./values-postgresql.yaml

sed "s/XXX.XXX.XXX.XXX/$mysqlClusterIP/" ./values-mysql-orig.yaml >temp_mysql.yaml && mv temp_mysql.yaml ./values-mysql.yaml

helm upgrade --install mysql-contosopizza . -f ./values.yaml -f ./values-mysql.yaml 

# helm upgrade --install postgres-contosopizza . -f ./values.yaml -f ./values-postgresql.yaml

for ((i = 0 ; i < 30 ; i++)); do
    appStatus=$(kubectl -n contosoappmysql get svc -o json  |jq .items[0].status.loadBalancer.ingress[0].ip |tr -d '"')   

    if [ "$appStatus" == "null" ]; then
        sleep 30
    fi
done

for ((i = 0 ; i < 30 ; i++)); do
    appStatus=$(kubectl -n contosoappmysql get svc -o json  |jq .items[0].status.loadBalancer.ingress[0].ip |tr -d '"')   

    if [ "$appStatus" == "null" ]; then
        sleep 30
    fi
done

# postgresAppIP=$(kubectl -n contosoapppostgres get svc -o json  |jq .items[0].status.loadBalancer.ingress[0].ip|tr -d '"')

mysqlAppIP=$(kubectl -n contosoappmysql get svc -o json  |jq .items[0].status.loadBalancer.ingress[0].ip |tr -d '"')

echo "Pizzeria app on MySQL is ready at http://$mysqlAppIP:8081/pizzeria"

# echo "Pizzeria app on PostgreSQL is ready at http://$postgresAppIP:8082/pizzeria"
