#!/bin/bash

Ftp_user="$(head -1 /home/shared/scripts/ftpcreds)"  ## a file that contains your credentials for the ftp server
Ftp_password="$(tail -1 /home/shared/scripts/ftpcreds)"
Local_ssh_dest=$Ftp_user"@bastion" ## this is a local server where you can ssh using passwordless authentication to confirm if you are in your home or roaming
Roaming_ftp_dest="nug684.tplinkdns.com:20684"  ## publicly accessable ftp server where you dump your pics when roaming
Local_pic_dir="/home/shared/pic"  ## local dir where pics are saved
Remote_pic_dir="dash/pic"   ## remote location on ftp server to push pics to
Local_rsync_dest="fs:/nfs/3int.dashcam"   ## server where we are saving all files forever in your home.


func_put_files () {
        ssh -C $Local_ssh_dest hostname  ## test if you are local or roaming
        ## Force Roaming for testing uncomment below
        #?=33
        if [ $? -gt 0 ] ; then  ## if exit code for ssh command is 0, then must be local
                echo "Roaming"
#        rsync -avP --remove-source-files /home/shared/pic/* fs.nug.roaming:/nfs/3int/dashcam/pic/
          lftp -c "open ftp://"$Ftp_user":"$Ftp_password"@"$Roaming_ftp_dest"; mirror -v -R --only-newer --parallel=10 "$Local_pic_dir" "$Remote_pic_dir   ### command for putting files to ftp server
        else
          rsync -avP --remove-source-files /home/shared/{vid,pic} $Local_rsync_dest  ## command for storing files at local server, local rpi files are removed
          ssh -C nugftp@bastion.nug.local rm -rf /home/nugftp/dash/pic/*  ## remove
        fi
}

func_put_files
