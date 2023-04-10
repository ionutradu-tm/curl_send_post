#!/bin/bash

MAX_TIMEOUT=${MAX_TIMEOUT:-30}

if [[ -z ${URL} ]]; then
    echo "You must provide an URL"
    exit 1
fi


CASEMATCH=$(shopt -p nocasematch)
shopt -s nocasematch
PAYLOAD=$(echo -e "{\n}")
while IFS='=' read -r name value ; do
    if [[ $name == 'x_'* ]]; then
        POST_VAR=$(echo $name| cut -d_ -f2- )
        PAYLOAD=$(echo $PAYLOAD| jq 'setpath(["__KEY__"]; "'"${!name}"'")'|sed s/__KEY__/$POST_VAR/)
    fi

done < <(env)
$CASEMATCH

RESPONSE_CODE=$(curl --max-time ${MAX_TIMEOUT} --write-out %{http_code} --silent --output /tmp/respose.json -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" --data "$PAYLOAD" ${URL} )
if [[ $RESPONSE_CODE != 200 ]];then
        echo "Error sending data to the pipeline API"      
fi
if [ -f /tmp/respose.json ]; then
    cat /tmp/respose.json
fi
  
