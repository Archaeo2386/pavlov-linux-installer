##############################################################################
##############################################################################
# Shell file to install beta versions of
#  _____           _              _____ _                _
# | ___ \         | |            /  ___| | davevillz'   | |
# | |_/ /_ ___   _| | _____   __ \ `--.| |__   __ _  ___| | __
# |  __/ _` \ \ / / |/ _ \ \ / /  `--. \ '_ \ / _` |/ __| |/ /
# | | | (_| |\ V /| | (_) \ V /  /\__/ / | | | (_| | (__|   <
# \_|  \__,_| \_/ |_|\___/ \_/   \____/|_| |_|\__,_|\___|_|\_\
#
# on a Quest using a Linux machine.
# written by Archaeo(#2386), 2020
#
###############################################################################
#
# How to install:
# Video tutorial:
# https://streamable.com/dg9kln
#
# With CLI:
# 1. Attach your Quest with a USB lead
# 2. Switch it on
# 3. Open a Terminal
# 4. Go to the path where the shell file is
# 5. Run: chmod +x pavlov-linux-install.sh
# 6. Run: ./pavlov-linux-install.sh
# 7. Follow the on screen instructions
# 8. When it says 'Installation complete' you can unplug you Quest
# 9. Start Pavlov from "Unknown Sources"
#
# With GUI:
# 1. Attach your Quest with a USB lead
# 2. Switch it on
# 3. Make sure the file is marked as executable
# 4. Run the file
# 5. Follow the on screen instructions
# 6. When it says 'Installation complete' you can unplug you Quest
# 7. Start Pavlov from "Unknown Sources"
#
###############################################################################
#
# Join the Discord: https://discord.gg/pavlov-vr
#
###############################################################################
###############################################################################

###############################################################################
###############################################################################
# DEFINE VARIABLES ############################################################
###############################################################################
## Name of apk-----------------------------------------------------------------
current="Pavlov-Android-Shipping-arm64-es2"
## File locations--------------------------------------------------------------
here="`dirname \"$0\"`"
cd "$here" || exit 1
## Looking for OBB-------------------------------------------------------------
file="$search_path *.obb"
## CLI colors------------------------------------------------------------------
Blue=$'\e[1;34m'
Red=$'\e[1;31m'
White=$'\e[1;37m'
#REINITIALISE ADB BECAUSE UDEV IS A BITCH--------------------------------------
adb kill-server
sudo adb start-server
###############################################################################
###############################################################################
# USERNAME ####################################################################
###############################################################################
## These names that can't be chosen as username.-------------------------------
illegalnames=(ARCHAEO DAVE HITLER NIGGER NULL UMBUSTADO)
# Ask for username and write it to name.txt------------------------------------
namechange(){
  read -p "$Blue What will you be called? $White" name
  if [[ "$name" = "1234" ]]; then
    echo "$Red Dev Mode unlocked, you may choose any name, sir:$White"
    read -p "$Blue What will you be called? $White" name
    echo "$name" > name.txt
  else
    for i in "${illegalnames[@]}"; do
      if [[ ${name^^} = *$i* ]]; then
        echo "$Red No, you aren't! Bastard! Try again"
        echo "(Illegal Name used)$White"
        namechange
      else :
      fi
    done
  fi
echo "$name" > name.txt
}
###############################################################################
###############################################################################
# INSTALLATION ################################################################
###############################################################################
## Check if a name file was provided, Prompt to give a name if it wasn't-------
if test -f name.txt; then
  read -p "$Blue Do you want to change your Pavlov name? (Y/N) $White" namechoice
  if [ ${namechoice^^} = "Y" ]; then
    rm name.txt
    namechange
  fi
else
  namechange
fi
echo "$Blue Alright!$White"
## Check if already installed and uninstall if it is---------------------------
if adb shell pm list packages | grep com.vankrupt.pavlov; then
  echo "$Blue Uninstalling existing application.$White"
  adb -d uninstall com.vankrupt.pavlov
  adb -d shell rm /sdcard/Android/obb/com.vankrupt.pavlov
else echo No previous installation detected
fi
## Install APK-----------------------------------------------------------------
echo "$Blue Installing Pavlov$White"
adb -d install $current.apk
## Push OBB--------------------------------------------------------------------
echo "$Blue Installing additional data.$White"
adb -d shell mkdir /sdcard/Android/obb/com.vankrupt.pavlov
adb -d push $file /sdcard/Android/obb/com.vankrupt.pavlov/
adb -d push name.txt /sdcard/pavlov.name.txt
## Give Permissions------------------------------------------------------------
echo "$Blue Granting Permissions$White"
adb -d shell pm grant com.vankrupt.pavlov android.permission.RECORD_AUDIO
adb -d shell pm grant com.vankrupt.pavlov android.permission.READ_EXTERNAL_STORAGE
adb -d shell pm grant com.vankrupt.pavlov android.permission.WRITE_EXTERNAL_STORAGE
###############################################################################
###############################################################################
echo "$Blue Installation complete$White"
###############################################################################
###############################################################################
