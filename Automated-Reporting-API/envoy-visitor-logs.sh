#!/bin/bash
##Created 20190717
##Compliance Audit Reports require monthly downloads of the Envoy visitor log
##This script uses an API key with the Envoy API to pull this report and svn to copy it into a file in the svn repo
##Logs will be copied into the required directory with the current date
##This script is run as often as needed with a cronjob

##########VARIABLES##########
##Set date variable
d=$(date +%Y-%m-%d)

##Set year variable
y=$(date +%Y)

##Set file path variable to search for logs
searchFile="/path/sub-path/sub-sub-path_$d /path/sub-path/sub-sub-path/$y/EnvoyRecords_$d"

##########FUNCTIONS##########
function pullEnvoyLogs {
    ##pull report from Envoy into your folder and mv to your records folder
    ##cannot pull directly into the svn repo folder
    GET https://app.envoy.com/api/entries.json?api_key=[your-api-key] > EnvoyRecords_$d
    mv /path/sub-path/sub-sub-path_$d /path/sub-path/sub-sub-path/$y/EnvoyRecords_$d
}

##########ACTIONS##########
##search for file in the svn repo and, if not there, cd into Envoy Log Folder, and pull log
if [ ! -f "$searchFile" ]
then
    ##move into your folder, pull logs there, and then move to your records folder
    cd /path/sub-path/
    pullEnvoyLogs
fi

