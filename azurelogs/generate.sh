#!/bin/bash

# $MIN0$
# $MAX80$
# $MIN80$
# $MAX90$
# $MIN90$
# $MAX100$

# $FILTER$
# $CUSTOMLABEL$
# $VISUTITLE$
# $ESINDEX$

get_az_limits () {
    # Store all the compute resources
    az vm list-usage -l eastus --query '[*].[name.value,limit]' -o tsv > ./resources/computeresources.txt
    az account list-locations --query '[].name' -o tsv > ./resources/locations.txt
}

# You have to call this function with params, ordered in the function - TITLE - LABEL - VALUETOFILTER - MIN - WARNING - WARNINGMAX - MAX
generate_gauge_visu () {
    VALUEVISUTITLE=$1
    VALUECUSTOMLABEL=$2
    VALUEFILTER=$3
    VALUEFILTERLOCATION=$4

    VALUEMIN0=$5
    VALUEMAX80=$6
    VALUEMIN80=$VALUEMAX80
    VALUEMAX90=$7
    VALUEMIN90=$VALUEMAX90
    VALUEMAX100=$8

    cp ./importVisu/templategauge.json ./resources/$1.json

    sed -i .bk 's/\$MIN0\$/'$VALUEMIN0'/g' ./resources/$1.json
    sed -i .bk 's/\$MAX80\$/'$VALUEMAX80'/g' ./resources/$1.json

    sed -i .bk 's/\$MIN80\$/'$VALUEMIN80'/g' ./resources/$1.json
    sed -i .bk 's/\$MAX90\$/'$VALUEMAX90'/g' ./resources/$1.json

    sed -i .bk 's/\$MIN90\$/'$VALUEMIN90'/g' ./resources/$1.json
    sed -i .bk 's/\$MAX100\$/'$VALUEMAX100'/g' ./resources/$1.json

    sed -i .bk 's/\$FILTERVALUE\$/'$VALUEFILTER'/g' ./resources/$1.json
    sed -i .bk 's/\$FILTERLOCATION\$/'$VALUEFILTERLOCATION'/g' ./resources/$1.json
    sed -i .bk 's/\$CUSTOMLABEL\$/'$VALUECUSTOMLABEL'/g' ./resources/$1.json
    sed -i .bk 's/\$VISUTITLE\$/'$VALUEVISUTITLE'/g' ./resources/$1.json
    sed -i .bk 's/\$ESINDEX\$/'$VALUEESINDEX'/g' ./resources/$1.json
}

generate_time_visu () {
    #Title of the visu
    VALUEVISUTITLE=$1
    #Label for the field to filter on
    VALUECUSTOMLABEL=$2
    #Field to filter on
    VALUEFILTER=$3

    cp ./importVisu/templatetime.json ./resources/$1.json


    sed -i .bk 's/\$FILTERVALUE\$/'$VALUEFILTER'/g' ./resources/$1.json
    sed -i .bk 's/\$CUSTOMLABEL\$/'$VALUECUSTOMLABEL'/g' ./resources/$1.json
    sed -i .bk 's/\$VISUTITLE\$/'$VALUEVISUTITLE'/g' ./resources/$1.json
    sed -i .bk 's/\$ESINDEX\$/'$VALUEESINDEX'/g' ./resources/$1.json
}

determine_es_server() {
    if curl -s -w '%{http_code}\n' "http://elasticsearch:9200" | grep -q "200"
    then
        ESSERVER="elasticsearch"
    elif curl -s -w '%{http_code}\n' "http://localhost:9200" | grep -q "200"
    then
        ESSERVER="localhost"
    else
        echo "Error"
        exit 1
    fi
}

generate_dashboard() {
    VALUEDASHBOARDTITLE=$1
    cp ./importDashboard/template.json ./resources/$1.json

    ONEVALUEVISUPANEL='{\"col\":1,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":1,\"row\":1,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"}'
    VALUEVISUPANELS='"[{\"col\":1,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":1,\"row\":1,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":7,\"id\":\"AV7pyIGGSo8UFX_v3Qap\",\"panelIndex\":2,\"row\":1,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":3,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":4,\"row\":1,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":1,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":5,\"row\":3,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":11,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":6,\"row\":1,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":5,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":7,\"row\":1,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":9,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":8,\"row\":1,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":3,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":9,\"row\":3,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":7,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":10,\"row\":3,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":5,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":11,\"row\":3,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":9,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":12,\"row\":3,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":1,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":13,\"row\":5,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":11,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":14,\"row\":3,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":3,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":15,\"row\":7,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":7,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":16,\"row\":5,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":5,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":17,\"row\":5,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":9,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":18,\"row\":5,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":11,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":19,\"row\":5,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":7,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":20,\"row\":7,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":1,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":21,\"row\":7,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":9,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":22,\"row\":7,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":1,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":23,\"row\":9,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":11,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":24,\"row\":7,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":3,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":25,\"row\":5,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":7,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":26,\"row\":9,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":3,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":27,\"row\":9,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":11,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":28,\"row\":9,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":5,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":29,\"row\":7,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":9,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":30,\"row\":9,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"},{\"col\":5,\"id\":\"AV7px_RXSo8UFX_v3QQA\",\"panelIndex\":31,\"row\":9,\"size_x\":2,\"size_y\":2,\"type\":\"visualization\"}]"'
    
    sed -i .bk 's/\$DASHBOARDTITLE\$/'$VALUEDASHBOARDTITLE'/g' ./resources/$1.json
    sed -i .bk 's/\$VISUPANELS\$/'$VALUEVISUPANELS'/g' ./resources/$1.json
}

determine_es_server
VALUEESINDEX=$(curl -s http://$ESSERVER:9200/.kibana/config/5.6.1 | jq -r '._source.defaultIndex')

get_az_limits

while read -r pres limit remainder; do
  while read ploc; do
    echo "Generating $pres-$ploc-g"
    generate_gauge_visu "$pres-$ploc-g" "$pres" "$pres" "$ploc" 0 $((($limit*80)/100)) $((($limit*90)/100)) $limit
    #curl -s -XPUT http://$ESSERVER:9200/.kibana/visualization/$pres-$ploc-g --data @./resources/$pres-$ploc-g.json -H "content-type: application/json" > /dev/null
  done < ./resources/locations.txt
  echo "Generating $pres-t"
  generate_time_visu "$pres-t" "$pres" "$pres"
  #curl -s -XPUT http://$ESSERVER:9200/.kibana/visualization/$pres-t --data @./resources/$pres-t.json -H "content-type: application/json" > /dev/null
  #generate_dashboard "limitdash-$pres"
done < ./resources/computeresources.txt

