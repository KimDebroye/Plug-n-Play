#!/bin/bash
# Sets up required stuff for Plug'n'Play to work

# INSTALL SCRIPT

# The Plug'n'Play install directory has already been created using the installer cmd file.
PLUGNPLAY_DIR="/opt/retropie/configs/all/plugnplay"

# Set main script permissions
echo "- Setting permissions for Plug'n'Play main script."
chmod +x "$PLUGNPLAY_DIR/plugnplay.sh"

# ---

# Create text files when not present
echo "- Creating user editable text files."
# 1) systems-requiring-both-keyboard-and-mouse.txt
if [ -f "$PLUGNPLAY_DIR/systems-requiring-both-keyboard-and-mouse.txt" ];
	then
		echo "-> 'systems-requiring-both-keyboard-and-mouse.txt' already exists. Skipping."
	else
		touch "$PLUGNPLAY_DIR/systems-requiring-both-keyboard-and-mouse.txt"
		echo "-> Created text file 'systems-requiring-both-keyboard-and-mouse.txt'."
fi
# 2) systems-requiring-keyboard.txt
if [ -f "$PLUGNPLAY_DIR/systems-requiring-keyboard.txt" ];
	then
		echo "-> 'systems-requiring-keyboard.txt' already exists. Skipping."
	else
		touch "$PLUGNPLAY_DIR/systems-requiring-keyboard.txt"
		echo "-> Created text file 'systems-requiring-keyboard.txt'."
fi
# 3) systems-requiring-mouse.txt
if [ -f "$PLUGNPLAY_DIR/systems-requiring-mouse.txt" ];
	then
		echo "-> 'systems-requiring-mouse.txt' already exists. Skipping."
	else
		touch "$PLUGNPLAY_DIR/systems-requiring-mouse.txt"
		echo "-> Created text file 'systems-requiring-mouse.txt'."
fi

# ---

AUTOSTART_SH="/opt/retropie/configs/all/autostart.sh"
# Add Plug'n'Play reference to autostart.sh
echo "- Setting permissions for '$AUTOSTART_SH'."
chmod 777 $AUTOSTART_SH
# Add Plug'n'Play reference to autostart.sh
echo "- Adding Plug'n'Play reference to '$AUTOSTART_SH'."
if grep -q "/opt/retropie/configs/all/plugnplay/plugnplay.sh" "$AUTOSTART_SH";
	then
		echo "-> 'autostart.sh' already contains a startup reference. Skipped."
	else
		echo "# Launches Plug'n'Play" > /tmp/tempfile
		echo "/opt/retropie/configs/all/plugnplay/plugnplay.sh" >> /tmp/tempfile
		echo "" >> /tmp/tempfile
		cat $AUTOSTART_SH >> /tmp/tempfile
		cp /tmp/tempfile $AUTOSTART_SH
		echo "-> Startup reference added to '$AUTOSTART_SH'."
fi

# TEST (Comment these lines when done testing.)
# echo -e "\n"
# echo -e "============================================================================"
# echo -e "=========== Testing Plug'n'Play ============================================"
# echo -e "============================================================================"
# ./plugnplay.sh --log 0
# echo -e "============================================================================"
# echo -e "=========== Test End ======================================================="
# echo -e "============================================================================"

# DONE MESSAGE
echo -e "\n"
echo -e "****************************************************************************"
echo -e "******************************** SETUP DONE ********************************"
echo -e "****************************************************************************"
echo -e "Upon exit, this window will open the Plug'n'Play folder on the Pi at"
echo "\\\\RETROPIE\configs\all\plugnplay"
echo -e "where systems can be added to the corresponding text files."
echo -e "---"
echo -e "Example of contents of text file"
echo -e "'systems-requiring-both-keyboard-and-mouse.txt':"
echo -e "macintosh"
echo -e "ports/Desktop.sh"
echo -e "ports/Duke Nukem 3D.sh"
echo -e "ports/Quake III Arena.sh"
echo -e "---"
echo -e "Please reboot Pi at any time in order for peripheral changes to take effect."
echo -e "****************************************************************************"
echo -e "Press any key to exit."
read -n 1 -s -r -p ""
exit