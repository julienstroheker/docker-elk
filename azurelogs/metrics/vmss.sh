az vmss list > resultvmss.json
echo Sending VMSS results
curl -s -H "content-type: application/json" http://logstash:5000 -d @resultvmss.json