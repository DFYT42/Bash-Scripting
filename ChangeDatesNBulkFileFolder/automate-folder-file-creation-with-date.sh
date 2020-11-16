#!/bin/bash
##Created 20180907
##Client needed a folder created daily and text files created within the folder as place holders to be populated with a different program.
##This script goes into a directory, creates a folder with today's date, and creates the required text files.
##An added feature is to delete any folders that existed due to human error.

##cd into directory location, create directory with current date, cd into new directory, and touch files
##This can be done in a scheduled cronjob w script or w the script below--commands instead of variables
set -x

##Working script--want to remove folders that already exist and run code below--otherwise "error: directory exists"
##cd <file path>
##rm -r $(date '+%Y-%m')


##Variables
OF=$(mkdir $(date '+%Y-%m')) ##makes directory w today's date
MOM=$(touch files{1..5}.txt) ##creates files

##Calls
cd <path> && $OF | cd "$_" && MOM ##directs script into subfolder to create daily folder & files

