# Datadog push metrics/events
Easy to use bash scripts to push metrics and events to Datadog

Installation:
-------------

Copy the script in any server where datadog agent is already installed and API keys are already set.

Usage
------

Invoke the script by executing the script with necessary arguments.

Example
--------

sh dd-post-events.sh 'Foo Restated' 'Foo was restarted by user after modification in configutation'

sh dd-post-metrics.sh apache_response_time 3
