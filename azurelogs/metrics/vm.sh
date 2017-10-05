az vm list > resultvm.json
echo Sending VM results
curl -s -H "content-type: application/json" http://logstash:5000 -d @resultvm.json