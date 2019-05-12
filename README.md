# Plug'n'Play
## In short
Plug'n'Play is
- a RetroPie/EmulationStation script
- for Raspberry Pi
  - tested on Model 3B,
  - untested on 3B+ or older models though it should work
- that automatically
  - shows (~enables) &amp;
  - hides (~disables)
- systems chosen by the user
- at boot
- based on connected peripherals detection (keyboard &amp; mouse).
## How to setup
Installing this script should be a walk in the park.
- Go to https://github.com/KimDebroye/Plug-n-Play/releases and download the latest release
  - or download the latest master
- Extract anywhere on PC
- Double click "Install Plug'n'Play on the Pi.cmd"

Note: please make sure SSH is enabled on your Raspberry Pi.
Tutorials to enable SSH:
- (with pictures) https://nostalgiatechs.com/enable-ssh-retropie/
- (without pictures) https://github.com/RetroPie/RetroPie-Setup/wiki/SSH#enable-ssh
## How to use
Normally the installer script should guide you through the steps you need to take.
Basically, when installation of the script is complete:
- Navigate to `\\\RETROPIE\configs\all\plugnplay`
  - Use Windows Explorer or an FTP client for this
- In this folder, you should see 3 (empty) text files:
  - systems-requiring-both-keyboard-and-mouse.txt
  - systems-requiring-keyboard.txt
  - systems-requiring-mouse.txt
- Based on the peripherals that need to be connected for certain systems to show/hide:
  - Open a text file in any text editor (although I don't advice to use Notepad since it can't display Unix/OSX line-breaks)
  - Type a system short name or a path/file name (relative to \\\RETROPIE\roms)
    - **on a one system/file per line basis**
    - If you don't know a system's short name, navigate to `\\\RETROPIE\roms`
    (using Windows Explorer or an FTP client)
    - Examples:
      - `atari5200`
      - `macintosh`
      - `ports/Desktop.sh` 
      - `ports/Duke Nukem 3D.sh`
  - Save the edited text file
  - Connect/Disconnect peripherals
  - Reboot
    - You won't see the script running
    - The script runs in the background at boot time
## Notes
- In order to hide the systems, a folder `_HIDDEN` is created at `\\\RETROPIE\roms`.
Feel free to manually move systems you do not want to see into that folder and move them back whenever and if ever you do want to see them again.
- Feel free to test, improve the script (specific joypads?) and let me know about bugs/issues.
I can't follow up full time though. I'm hoping the community can improve this script where needed and gladly wanted to share it as is.
Furthermore, feedback is always welcome.
