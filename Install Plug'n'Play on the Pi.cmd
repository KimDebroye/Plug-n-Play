@echo off

echo ****************************************************************************
echo ***************************** PLUG'N'PLAY INSTALLER ************************
echo ****************************************************************************
echo ~ Setting up Plug'n'Play directory at /opt/retropie/configs/all/plugnplay.
plink -ssh -l pi -pw raspberry retropie.local "mkdir -p /opt/retropie/configs/all/plugnplay"
echo ****************************************************************************
echo ~ Transferring Plug'n'Play main script 'plugnplay.sh'.
pscp -l pi -pw raspberry -r .\assets\plugnplay.sh retropie.local:/opt/retropie/configs/all/plugnplay
echo ****************************************************************************
echo ~ Running install script.
plink -ssh -l pi -pw raspberry retropie.local -m .\assets\install.sh

explorer.exe \\RETROPIE\configs\all\plugnplay
exit