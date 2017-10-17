#!/bin/bash

PROG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"    # folder location of this script
cd $PROG_DIR

SYNC_DIR='FRISummerResearch/motion'                             # relative to this script folder - location of files to sync
FILES_TO_SYNC='*.jpg'                                           # Set the type of files to sync * for all

function do_gdrive_sync ()
{
    # function to perform a gdrive sync between RPI local folder (exit if not found) and
    # a matching google drive folder. (Create remote folder if required)
    # Check if Local SYNC_DIR folder exists
    if [ ! -d "$PROG_DIR/$SYNC_DIR" ] ; then
        echo "ERROR   - Local Folder $PROG_DIR/$SYNC_DIR Does Not Exist"
        echo "          Please Check SYNC_DIR variable and/or Local Folder PATH"
        return 1
    fi

    # Check for matching files to sync in folder
    ls -1 $PROG_DIR/$SYNC_DIR/$FILES_TO_SYNC > /dev/null 2>&1
    if [ ! "$?" = "0" ] ; then
        echo "WARNING - No Matching $FILES_TO_SYNC Files Found in $PROG_DIR/$SYNC_DIR"
        return 1
    fi

    # Check if a matching remote folder exists
    # and if Not then create one
    echo "STATUS  - Check if Remote Folder /$SYNC_DIR Exists"
    echo "------------------------------------------"
    gdrive file-id $SYNC_DIR
    if [ ! $? -eq 0 ] ; then
        echo "------------------------------------------"
        echo "STATUS  - Creating Remote Folder /$SYNC_DIR"
        echo "------------------------------------------"
        gdrive new --folder $SYNC_DIR
        gdrive file-id $SYNC_DIR
        if [ $? -eq 0 ] ; then
            echo "------------------------------------------"
            echo "STATUS  - Successfully Created Remote Folder /$SYNC_DIR"
        else
            echo "------------------------------------------"
            echo "ERROR   - Problem Creating Remote Folder $SYNC_DIR"
            echo "          Please Investigate Problem"
            return 1
        fi
    fi
    echo "------------------------------------------"
    echo "STATUS  - Start gdrive Sync ...."
    echo "STATUS  - Local Source Folder - $PROG_DIR/$SYNC_DIR"
    echo "STATUS  - Remote Destn Folder - /$SYNC_DIR"
    echo "STATUS  - Files $FILES_TO_SYNC"
    echo "STATUS  - Running  This May Take Some Time ....."
    echo "STATUS  - sudo gdrive push -no-prompt -ignore-conflict $SYNC_DIR/$FILES_TO_SYNC"
    echo "------------------------------------------"
    date
    START=$(date +%s)
    sudo gdrive push -no-prompt -ignore-conflict $SYNC_DIR/$FILES_TO_SYNC
    if [ $? -ne 0 ] ;  then
        # Check if gdrive sync was successfully
        date
        echo "------------------------------------------"
        echo "ERROR   - gdrive Sync Failed."
        echo "          Possible Cause - See gdrive Error Message Above"
        echo "          Please Investigate Problem and Try Again"
    else
        # If successful then display processing time and remove sync file
        date
        END=$(date +%s)
        DIFF=$((END - START))
        echo "------------------------------------------"
        echo "STATUS  - $0 Completed Successfully"
        echo "STATUS  - Processing Took $DIFF seconds"
    fi
}

if [ -z "$(pgrep -f gdrive)" ] ; then
    do_gdrive_sync
fi
exit
