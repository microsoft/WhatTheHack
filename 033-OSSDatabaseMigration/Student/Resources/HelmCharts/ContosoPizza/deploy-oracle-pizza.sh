status="Running"

#Deploy Oracle DB
helm upgrade --install wth-oracle ../Oracle21c --set infrastructure.password=OCPHack8
helm upgrade --install ora2pg ../ora2pg

for ((i = 0 ; i < 30 ; i++)); do
    oraStatus=$(kubectl -n oracle get pods --no-headers -o custom-columns=":status.phase")


    if [ "$oraStatus" != "$status" ]; then
        sleep 10
    else
        break
    fi
done

#Copy oracle.sql to the oracle pod
oraPod=$(kubectl -n oracle get pod -l app=oracle -o jsonpath="{.items[0].metadata.name}")

kubectl -n oracle cp ./oracle.sql $oraPod:/tmp/oracle.sql

for ((i = 0 ; i < 90 ; i++)); do
    oraLog=$(kubectl -n oracle logs $oraPod)
    echo $oraLog 
    if [[ $oraLog != *"Completed"* ]]; then
        sleep 10
    else
        break
    fi
done

#kubectl -n oracle exec -it $oraPod -- /opt/oracle/product/21c/dbhomeXE/bin/sqlplus SYSTEM@XE/OCPHack8 @/tmp/oracle.sql
kubectl -n oracle exec -it $oraPod -- sqlplus SYSTEM/OCPHack8@XE @/tmp/oracle.sql
oracleClusterIP=$(kubectl -n oracle get svc -o jsonpath="{.items[0].spec.clusterIP}")

sed "s/XXX.XXX.XXX.XXX/$oracleClusterIP/" ./values-oracle-orig.yaml >temp_oracle.yaml && mv temp_oracle.yaml ./values-oracle.yaml

helm upgrade --install oracle-contosopizza . -f ./values.yaml -f ./values-oracle.yaml

for ((i = 0 ; i < 30 ; i++)); do
    appStatus=$(kubectl -n contosoapporacle get svc -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")
    if [[ $appStatus =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo $appStatus
        break
    else
        echo "Waiting for load balancer IP address for contosoapporacle"
        sleep 30
    fi
done

ora2pgIP=$(kubectl -n ora2pg get svc -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")
ora2pgPort=$(kubectl -n ora2pg get svc -o jsonpath="{.items[0].spec.ports[0].port}")     
echo "ora2pg is at http://$ora2pgIP:$ora2pgPort/"

oracleAppIP=$(kubectl -n contosoapporacle get svc -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")
echo "Pizzeria app on Oracle is ready at http://$oracleAppIP:8083/pizzeria"