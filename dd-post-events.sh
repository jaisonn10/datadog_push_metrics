#!/bin/bash

function usage(){
  echo "Usage:" >&2
  echo "$0 title message [tags...]" >&2
  echo "  title:   The title of this event            ie. 'Foo Restated'" >&2
  echo "  message: The message for this event         ie. 'Foo was restarted by monit'" >&2
  echo >&2
  exit 1
}

title="$1"
message="$2"

dd_config='/etc/dd-agent/datadog.conf'

if [[ -n "$DATADOG_API_KEY" ]]; then
  api_key="$DATADOG_API_KEY"
else
  api_key=$(grep '^api_key:' $dd_config | cut -d' ' -f2)
fi

if [[ -z "$api_key" ]]; then
  echo "Could not find Datadog API key in either ${dd_config} or DATADOG_API_KEY environment variable." >&2
  echo "Please provide your API key in one of these locations" >&2
  usage
fi

if [[ -z "$title" || -z "$message" ]]; then
  usage
fi
env_tags=`cat /etc/dd-agent/datadog.conf| grep tags | grep -v '#' | grep -o '".*"'`
full_tags="$env_tags"

api="https://app.datadoghq.com/api/v1"
url="${api}/events?api_key=${api_key}"

payload=$(cat <<-EOJ
  {
    "title": "$title",
    "text": "$message",
    "tags": [$full_tags],
    "alert_type": "error"
  }
EOJ
)

curl -s -X POST -H "Content-type: application/json" -d "$payload" "$uri"
echo -e "\nDone \n"