az storage account list > result.json

curl -v -H "content-type: application/json" http://logstash:5000 -d @result.json