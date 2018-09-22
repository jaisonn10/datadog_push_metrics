#!/bin/bash
matrics_name=$1
value=$2
dd_config='/etc/dd-agent/datadog.conf'
api_key=$(grep '^api_key:' $dd_config | cut -d' ' -f2)
api="https://app.datadoghq.com/api/v1"
uri="$api/series?api_key=$api_key"
env_tags=`cat /etc/dd-agent/datadog.conf| grep tags | grep -v '#' | grep -o '".*"'`
host_name="$HOSTNAME"
currenttime=$(date +%s)
payload=$(cat <<-EOJ
{ "series" :
         [{"metric":"$matrics_name",
          "points":[[$currenttime, $value]],
          "host":"$host_name",
}
EOJ
)
curl -s -X POST -H "Content-type: application/json" -d "$payload" "$uri"
echo -e "\n"