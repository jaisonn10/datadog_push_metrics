#!/bin/bash
function usage(){
  echo "Usage:" >&2
  echo "$0 metrics_name value" >&2
  echo "  metrics_name:   The name of the metrics you want to push            ie. 'apache_response_time'" >&2
  echo "  value: Values that you want to send         ie. '2ms, 3ms etc'" >&2
  echo >&2
  exit 1
}

matrics_name=$1
value=$2
dd_config='/etc/dd-agent/datadog.conf'
if [[ -n "$DATADOG_API_KEY" ]]; then
  api_key="$DATADOG_API_KEY"
else
  if [ -f $dd_config ]; then
  api_key=$(grep '^api_key:' $dd_config | cut -d' ' -f2)
  fi
fi
if [[ -z "$api_key" ]]; then
  echo "Could not find Datadog API key in either ${dd_config} or DATADOG_API_KEY environment variable." >&2
  echo "Please provide your API key in one of these locations" >&2
  usage
fi
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
