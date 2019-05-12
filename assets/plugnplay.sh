#!/bin/bash

# READ ONLY VARIABLES
#====================
readonly SCRIPT_DIR=$(dirname $(readlink -f $0))

readonly FILE_SYSTEMS_REQ_KB="$SCRIPT_DIR/systems-requiring-keyboard.txt"
readonly FILE_SYSTEMS_REQ_M="$SCRIPT_DIR/systems-requiring-mouse.txt"
readonly FILE_SYSTEMS_REQ_KB_M="$SCRIPT_DIR/systems-requiring-both-keyboard-and-mouse.txt"

readonly ROMS_DIR="/home/pi/RetroPie/roms"
readonly HIDDEN_ROMS_DIR="/home/pi/RetroPie/roms/_HIDDEN"
#====================

# GLOBAL VARIABLES (SWITCHES)
#============================
LOG=1
mouseplugged=0
keyboardplugged=0
keyboardandmouseplugged=0
#============================

# FUNCTIONS
#==========
# Fixes DOS newline in text files edited in Windows.
FixTextFiles () {
	sed -i 's/\r//' $FILE_SYSTEMS_REQ_KB
	sed -i 's/\r//' $FILE_SYSTEMS_REQ_M
	sed -i 's/\r//' $FILE_SYSTEMS_REQ_KB_M
}
# Check if a keyboard is plugged in
CheckKeyboardPlugged () {
	lsusb -v 2>/dev/null | egrep '(^Bus|Keyboard)' | grep -B1 Keyboard > /dev/null
	if [ $? == "0" ];	# lsusb exit status 0 = plugged
		then
			echo "- Keyboard is plugged in."
			keyboardplugged=1
			return 1;
		else			# lsusb exit status 1 = unplugged
			echo "- Keyboard is not plugged in."
			keyboardplugged=0
			return 0;
	fi
}

# Check if a mouse is plugged in
CheckMousePlugged () {
	lsusb -v 2>/dev/null | egrep '(^Bus|Mouse)' | grep -B1 Mouse > /dev/null
	if [ $? == "0" ];	# lsusb exit status 0 = plugged
		then
			echo "- Mouse is plugged in."
			mouseplugged=1
			return 1;
		else			# lsusb exit status 1 = unplugged
			echo "- Mouse is not plugged in."
			mouseplugged=0
			return 0;
	fi
}

# Check if both keyboard and mouse are plugged in
CheckKeyboardAndMousePlugged () {
	CheckKeyboardPlugged
	CheckMousePlugged
	
	if [ $keyboardplugged == 1 ] && [ $mouseplugged == 1 ];
		then
			keyboardandmouseplugged=1
			return 1;
		else
			keyboardandmouseplugged=0
			return 0;
	fi
}

# Try to hide roms from given system (f.e. "macintosh")
HideRoms () {
	# Move roms to hidden roms folder
	# Check if path exists (f.e. if it isn't moved yet)
	if [ -d "$ROMS_DIR/$1" ];
		then
			echo "-> Moving '$ROMS_DIR/$1' to '$HIDDEN_ROMS_DIR/$1'."
			mkdir -p $(dirname "$HIDDEN_ROMS_DIR/$1")
			mv "$ROMS_DIR/$1" "$HIDDEN_ROMS_DIR/$1"
		else
			# Check if it's already hidden
			if [ -d "$HIDDEN_ROMS_DIR/$1" ];
				then
					echo "* The system '$1' is already hidden and thus won't be moved."
				else
					# Check if file exists
					if [ -f "$ROMS_DIR/$1" ];
					then
						mkdir -p $(dirname "$HIDDEN_ROMS_DIR/$1")
						echo "-> Moving '$ROMS_DIR/$1' to '$HIDDEN_ROMS_DIR/$1'."
						mv "$ROMS_DIR/$1" "$HIDDEN_ROMS_DIR/$1"
					else
						# Check if it's already hidden
						if [ -f "$HIDDEN_ROMS_DIR/$1" ];
							then
								echo "* The system '$1' is already hidden and thus won't be moved."
							else
								echo "* (!) The system '$1' can not be found. Skipping."
						fi
					fi
			fi
	fi
}

# Try to unhide roms from given system (f.e. "macintosh")
UnhideRoms () {
	# Unhide roms
	# Check if path exists (f.e. if it isn't moved yet)
	if [ -d "$HIDDEN_ROMS_DIR/$1" ];
		then
			echo "-> Moving '$HIDDEN_ROMS_DIR/$1' to '$ROMS_DIR/$1'."
			mkdir -p $(dirname "$ROMS_DIR/$1")
			mv "$HIDDEN_ROMS_DIR/$1" "$ROMS_DIR/$1"
		else
			# Check if it's already unhidden
			if [ -d "$ROMS_DIR/$1" ];
				then
					echo "* The system '$1' isn't hidden and thus won't be moved."
				else
					# Check if file exists
					if [ -f "$HIDDEN_ROMS_DIR/$1" ];
					then
						echo "-> Moving '$HIDDEN_ROMS_DIR/$1' to '$ROMS_DIR/$1'."
						mkdir -p $(dirname "$ROMS_DIR/$1")
						mv "$HIDDEN_ROMS_DIR/$1" "$ROMS_DIR/$1"
					else
						# Check if it's already unhidden
						if [ -f "$ROMS_DIR/$1" ];
							then
								echo "* The system '$1' isn't hidden and thus won't be moved."
							else
								echo "* (!) The system '$1' can not be found. Skipping."
						fi
					fi
			fi
	fi
}

# Process a given system (f.e. "macintosh") according to given peripheral switches (kbm, kb, m)
ProcessSystem () {
	case $2 in
			"kbm" )		# Move rom dirs to hidden roms dir when keyboard and mouse are not plugged in.
						if [ $keyboardandmouseplugged == 0 ];
							then
								echo "Disabling '$1'..."
								HideRoms "$1"
							else
								echo "Enabling '$1'..."
								UnhideRoms "$1"
						fi;;
			"kb" )		# Move rom dirs to hidden roms dir when keyboard isn't plugged in.
						if [ $keyboardplugged == 0 ];
							then
								echo "Disabling '$1'..."
								HideRoms "$1"
							else
								echo "Enabling '$1'..."
								UnhideRoms "$1"
						fi;;
			"m" )		# Move rom dirs to hidden roms dir when mouse isn't plugged in.
						if [ $mouseplugged == 0 ];
							then
								echo "Disabling '$1'..."
								HideRoms "$1"
							else
								echo "Enabling '$1'..."
								UnhideRoms "$1"
						fi;;
	esac
}
#==========

# PROGRAM LOGIC
#==============
# Enable or disable logging
while [ "$1" != "" ]
	do
		case $1 in
			-l | --log )		shift
								LOG=$1;;
		esac
		shift
done
if [ $LOG == 1 ];
	then
		exec 3>&1 4>&2
		trap 'exec 2>&4 1>&3' 0 1 2 3
		exec 1>"$SCRIPT_DIR/plugnplay.log" 2>&1
fi

# Fix text files
FixTextFiles

# Create a hidden roms folder (if one doesn't exist)
mkdir -p $HIDDEN_ROMS_DIR;

# Check peripherals
CheckKeyboardAndMousePlugged

echo "***************************************************"

# Read and loop the file containing systems that require keyboard
echo "Processing file '$(basename ${FILE_SYSTEMS_REQ_KB})':"
if [ -s $FILE_SYSTEMS_REQ_KB ]
	then
		while IFS= read -r system || [[ -n "$system" ]]
			do
				#echo "Processing system '${system//\\//}':" # Replace any occurrence of \ with /
				ProcessSystem "${system//\\//}" "kb"	# Keyboard
		done < "$FILE_SYSTEMS_REQ_KB"
	else
		echo "No systems found."
fi

echo "***************************************************"

# Read and loop the file containing systems that require mouse
echo "Processing file '$(basename ${FILE_SYSTEMS_REQ_M})':"
if [ -s $FILE_SYSTEMS_REQ_M ]
	then
		while IFS= read -r system || [[ -n "$system" ]]
			do
				#echo "Processing system '${system//\\//}':" # Replace any occurrence of \ with /
				ProcessSystem "${system//\\//}" "m"	# Mouse
		done < "$FILE_SYSTEMS_REQ_M"
	else
		echo "No systems found."
fi

echo "***************************************************"

# Read and loop the file containing systems that both require keyboard and mouse
echo "Processing file '$(basename ${FILE_SYSTEMS_REQ_KB_M})':"
if [ -s $FILE_SYSTEMS_REQ_KB_M ]
	then
		while IFS= read -r system || [[ -n "$system" ]]
			do
				#echo "Processing system '${system//\\//}':" # Replace any occurrence of \ with /
				ProcessSystem "${system//\\//}" "kbm"	# Keyboard and Mouse
		done < "$FILE_SYSTEMS_REQ_KB_M"
	else
		echo "No systems found."
fi

#==============
