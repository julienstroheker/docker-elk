while read p; do
  echo "Sending compute limits resutls - $p"
  az vm list-usage -l $p > ./resources/computelimit$p.json
  curl -s -H "content-type: application/json" -H "location: $p" http://logstash:5001 -d @./resources/computelimit$p.json &
done < ./resources/locations.txt

