#!/bin/bash

# ####################################################################
# Script Description :  On the fly archive backup to S3
# Author:   Guillaume Seigneuret
# Date:     27/01/2016
# Version:  1.0
#
# Usage:    Crypt directory with GPG and send the archive to S3 bucket
#
#
# Usage domain: Made to be inserted into cron script on Linux only
#
# Parameters:   Variables into the script :
#               AWS_ACCESS_KEY_ID       : AWS ID
#               AWS_SECRET_ACCESS_KEY   : AWS secret key
#               PATH                    : Path with go and gof3r places
#               TO_BACKUP               : Directories to backup
#               GPG_KEY_ID              : Your GPG key ID
#
#               Arguments:
#               when backup : backup
#               when restore : restore S3_object_name dir_to_restore
#
# Config file:  None
#
# Prerequisites : Need the following tools:
#                   - pv (apt-get install pv)
#                   - s3gofr3 (https://github.com/rlmcpherson/s3gof3r)
#                   - gpg (apt-get install gpg)
#
# ####################################################################
# GPL v3
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# ####################################################################


export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/local/go/bin:/root/gocode/bin

AWS_REGION=s3-eu-west-1.amazonaws.com
BUCKET=

TO_BACKUP="/home/www"

DATE=$(date +%Y%m%d%H%M%S)

GPG_KEY_ID=xxx

function backup {
    tar cf - $TO_BACKUP | gpg --encrypt --recipient $GPG_KEY_ID | gof3r put -b $BUCKET -k backup_$DATE.tar.gpg --endpoint $AWS_REGION
}

function restore {
    TO_RECOVER=$1
    WHERE_TO_RECOVER=$3

    gof3r get -b $BUCKET -k $TO_RECOVER --endpoint $AWS_REGION | pv -a | gpg --decrypt | tar -x -C $WHERE_TO_RECOVER
}

function Usage {
    echo "backup backup|(restore SOURCE DEST)"
    echo "mandatory restore options : file_to_get_from_S3 where_to_recover_it"
    echo "ex: backup restore media_27_01_16.tar.gpg /tmp"

    exit 2

}

case "$1" in
    backup)
        backup
        exit 0
    ;;
    restore)
        TO_RECOVER=$2
        WHERE_TO_RECOVER=$3
        [[ -n "$2" ]] || Usage
        [[ -n "$3" ]] || Usage
        restore $TO_RECOVER $WHERE_TO_RECOVER
        exit 0
    ;;
    *)
        Usage
    ;;
esac
