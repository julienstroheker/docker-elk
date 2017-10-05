az storage account list > resultsa.json
echo Sending SA results
curl -s -H "content-type: application/json" http://logstash:5000 -d @resultsa.json