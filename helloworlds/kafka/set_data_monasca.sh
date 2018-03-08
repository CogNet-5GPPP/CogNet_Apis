#!/bin/sh

url=<monasca_ip>


#get token
auth_token=`curl -X POST http://$url:5000/v2.0/tokens -d '{"auth":{"tenantName":"mini-mon","passwordCredentials":{"username": "mini-mon", "password":"password"}}}' -H "Content-type: application/json" -H "X-Auth-Token: ADMIN" | python -c 'import sys, json; print json.load(sys.stdin)["access"]["token"]["id"]'`


metric_name="cpu_load"
timestamp=`date '+%s'`
dimension_key1="server"
dimension_key1_value="vicomtechserver1"
meta_name="measure_value";
meta_value="percentage";
value=`shuf -i1-100 -n1` #RANDOM 1 to 100
data="{\"name\":\"$metric_name\",\"timestamp\":\"$timestamp\",\"dimensions\":{\"$dimension_key1\":\"$dimension_key1_value\"},\"value\":\"$value\",\"value_meta\":{\"$meta_name\":\"$meta_value\"}}"
#echo $data
curl -i -X POST -H "X-Auth-Token: $auth_token" -H 'Content-Type: application/json' -H 'Cache-Control: no-cache' http://$url:8080/v2.0/metrics -d "$data"

