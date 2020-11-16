#!/bin/bash
##Created 20190723
##This script pushes reports to the appropriate svn repo used for compliance records once a week.
##It also checks for folder names that corrospond to the cuurent year.
##If the folders do not exist, they are created.
##The records include things like: visitor logs, door key card logs, or any record needed for compliance that is pushed to an svn repo.
##These reports are pulled separately and copied into files on a server.

##########VARIABLES##########
##setting date variable for commit notes
d=$(date +%Y-%m-%d)

##setting year variable to update correct folder, based on year
###REQUIRES Each Year Records folder to be named exactly the same
y=$(date +%Y)

##setting previous year variable for looping through previous year folder to copy to new year folder
p=$(date +%Y -d 'last year')

##########FUNCTIONS##########

function updateRecordRepo {
    #echo "Updating"
    svn update --username daffy.duck --non-interactive
}

function addCommitRecordRepo {
    #echo "Adding"
    svn add --force * --auto-props --parents --depth infinity -q

    #echo "Committing"
    svn commit -m "RecordRepo audit logs automation $d"
}

function mkdirNewYear {
    #create new folder for current year
    #Happens once a year
    mkdir name\ Records\ $y
}

function createSubDirs {
    ##Going into newly created Year folder and adding sub folders
    ##Happens once a year
    rsync -av -f"+ */" -f"- *" /home/daffy.duck/path/sub-path/sub-sub-path/Records\ $p/ /home/daffy.duck/path/sub-path/sub-sub-path/Records\ $y/
}

function runScripts {
    for i in /home/daffy.duck/Scripts/*
    do
        $i
    done
}

##########ACTION##########

if [ -e /home/daffy.duck/path/sub-path/sub-sub-path/Records\ $y ]
then
    #####FILE EXISTS#####"
    cd /home/daffy.duck/path/sub-path/sub-sub-path/Records\ $y/
    updateRecordRepo
    runScripts
    addCommitRecordRepo
    updateRecordRepo
    exit
else
    #####FILE DOES NOT EXIST#####"
    ##Going into parent folder to create new folder for new year
    cd /home/daffy.duck/path/sub-path/sub-sub-path/
    updateRecordRepo
    mkdirNewYear
    createSubDirs
    updateRecordRepo
    runScripts
    addCommitRecordRepo
    updateRecordRepo
fi
