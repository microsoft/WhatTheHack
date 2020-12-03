

webSiteName=$(echo $WebSiteURL| sed "s/https*:\/\///g" | sed "s/\./-/g")
#reportFile=/app/loadtestreport-$REGION-$ts.html

#artillery run /app/loadtest.yaml -o /app/report.json -t $WebSiteURL
#artillery report -o $reportFile /app/report.json

#az login --identity
#az storage blob upload --auth-mode login --container-name logfiles --file $reportFile --name loadtestreport-$REGION-$webSiteName-$ts.html

reportFile=/app/loadtestreport-$REGION-$ts.txt

k6 run -e WebSiteURL=$WebSiteURL -e CDN=$CDN /app/loadTest.js > $reportFile

az login --identity
az storage blob upload --auth-mode login --container-name logfiles --file $reportFile --name loadtestreport-$REGION-$webSiteName-$CDN.txt

