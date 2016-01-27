# S3backupOnTheFly

Script Description :  On the fly archive backup to S3

Author:   Guillaume Seigneuret

Date:     27/01/2016

Version:  1.0

Usage:    Crypt directory with GPG and send the archive to S3 bucket


 Usage domain: Made to be inserted into cron script on Linux only

 Parameters:   Variables into the script :
 
               AWS_ACCESS_KEY_ID       : AWS ID
               AWS_SECRET_ACCESS_KEY   : AWS secret key
               PATH                    : Path with go and gof3r places
               TO_BACKUP               : Directories to backup
               GPG_KEY_ID              : Your GPG key ID

Arguments:

               when backup : backup
               when restore : restore S3_object_name dir_to_restore

 Config file:  None

 Prerequisites : 
 Need the following tools:
 
                   - pv (apt-get install pv)
                   - s3gofr3 (https://github.com/rlmcpherson/s3gof3r)
                   - gpg (apt-get install gpg)
