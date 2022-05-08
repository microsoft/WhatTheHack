status="Running"

# Install the Kubernetes Resources
helm upgrade --install wth-postgresql ../PostgreSQL116 --set infrastructure.password=OCPHack8

for ((i = 0 ; i < 30 ; i++)); do
    pgStatus=$(kubectl -n postgresql get pods --no-headers -o custom-columns=":status.phase")


    if [ "$pgStatus" != "$status" ]; then
        sleep 10
    else   
        break
    fi
done

# Get the postgres pod name
pgPodName=$(kubectl -n postgresql get pods --no-headers -o custom-columns=":metadata.name")

#Copy pg.sql to the postgresql pod
kubectl -n postgresql cp ./pg.sql $pgPodName:/tmp/pg.sql

# Use this to connect to the database server
kubectl -n postgresql exec deploy/postgres -it -- /usr/bin/psql -U postgres -f /tmp/pg.sql

postgresClusterIP=$(kubectl -n postgresql get svc -o jsonpath="{.items[0].spec.clusterIP}")

sed "s/XXX.XXX.XXX.XXX/$postgresClusterIP/" ./values-postgresql-orig.yaml >temp_postgresql.yaml && mv temp_postgresql.yaml ./values-postgresql.yaml

helm upgrade --install postgres-contosopizza . -f ./values.yaml -f ./values-postgresql.yaml

for ((i = 0 ; i < 30 ; i++)); do
    appStatus=$(kubectl -n contosoapppostgres get svc -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")
    if [[ $appStatus =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo $appStatus
        break
    else
        echo "Waiting for load balancer IP address for contosoapppostgres"
        sleep 30
    fi
done

postgresAppIP=$(kubectl -n contosoapppostgres get svc -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")

echo "Pizzeria app on PostgreSQL is ready at http://$postgresAppIP:8082/pizzeria"
