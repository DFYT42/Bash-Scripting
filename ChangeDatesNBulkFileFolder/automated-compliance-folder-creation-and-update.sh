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
    mkdir IT\ Records\ $y
}

function createSubDirs {
    ##Going into newly created Year folder and adding sub folders
    ##Happens once a year
    rsync -av -f"+ */" -f"- *" /home/it.svc/QMS/QMS\ Records/Infrastructure/IT\ Records\ $p/ /home/it.svc/QMS/QMS\ Records/Infrastructure/IT\ Records\ $y/
}

function runScripts {
    for i in /home/it.svc/AuditAutomationScripts/*
    do
        $i
    done
}

##########ACTION##########

if [ -e /home/it.svc/QMS/QMS\ Records/Infrastructure/IT\ Records\ $y ]
then
    #####FILE EXISTS#####"
    cd /home/it.svc/QMS/QMS\ Records/Infrastructure/IT\ Records\ $y/
    updateQMS
    runScripts
    addCommitQMS
    updateQMS
    exit
else
    #####FILE DOES NOT EXIST#####"
    ##Going into parent folder to create new folder for new year
    cd /home/it.svc/QMS/QMS\ Records/Infrastructure/
    updateQMS
    mkdirNewYear
    createSubDirs
    updateQMS
    runScripts
    addCommitQMS
    updateQMS
fi
