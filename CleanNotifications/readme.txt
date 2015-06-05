Addon Name:      Clean Notifications
Author:          Julian Paolo Thiry (Aedani)
Version:         2.1
Official Site:   http://games.jupath.me/tsw/clean-notifications
Distributors:    http://www.secretui.com/downloads/fileinfo.php?id=75
                 http://www.curse.com/tsw-mods/tsw/cleannotifications
Official Forum:  http://forums.thesecretworld.com/showthread.php?t=60787
Source Code:     git://git.curseforge.net/tsw/cleannotifications/mainline.git


DESCRIPTION
-----------
This addon automatically toggles the game's HUD settings for AP and SP
notifications when all abilities or skills have already been acquired. The
FIFO text telling you that you've reached the cap is also prevented.
The following options can also be entered into a chat window:

/option BlinkNotifications false        Turns off the blinking effect.
/option BlinkNotifications true         Turns on the blinking effect (default).
/option SuppressAPWhenCapped true       Hides AP notifications when the cap is reached.
/option SuppressAPWhenCapped false      Hides AP notifications only when all abilities are acquired (default).
/option SuppressSPWhenCapped true       Hides SP notifications when the cap is reached.
/option SuppressSPWhenCapped false      Hides SP notifications only when all skills are acquired (default).

The above settings are persistent and affect all characters.


INSTALLATION
------------
NOTE: Be sure to uninstall version 1 using the instructions found in that
      version's readme.txt before installing version 2.0 or later.

NOTE: If you are installing version 2.1 on top of an existing installation,
	  you will need to delete the following two files:
	  • \Data\Gui\Customized\Flash\CleanNotifications\LoginPrefs.bxml
	  • \Data\Gui\Customized\Flash\CleanNotifications\Modules.bxml

Unpack the archive to <your TSW folder>\Data\Gui\Customized\
You should end up with the following files at a minimum:
• \Data\Gui\Customized\Flash\CleanNotifications\CleanNotifications.swf
• \Data\Gui\Customized\Flash\CleanNotifications\LoginPrefs.xml
• \Data\Gui\Customized\Flash\CleanNotifications\Modules.xml
Other files may be present but are not required for the addon to run properly.


UNINSTALLATION 
--------------
Delete the CleanNotifications folder mentioned above.


HISTORY
-------
2.1
* Fix for disabling the blink effect sometimes failing.
* Correctly handle when AP/SP cap has been raised.
* Add two new options for hiding notifications when the cap has been reached
  instead of only when all abilities or skills have been acquired.

2.0
* Rewrote completely so that this addon does not replace any Funcom components.
  It is now much smaller and should not need updated with each game patch.
* Abandoned the new version syntax given the previous change.
* Removed the HideNotifications option as this feature is now part of the game.

1.10.1
* New version syntax: X.YY.Z - X is the major version, YY is the game patch
  version, and Z is the revision. This way you can quickly tell if a particular
  release is likely to work with a particular game patch.
* Updated to the 1.10 source code.

1.5
* Updated to the 1.9 source code.

1.4
* Updated to the 1.8 source code.

1.3
* The font now matches the game's font more closely.
* Updated to the latest source code, fixing a minor bug related to clicking on
  the Achievement notification.
* Remember once skills/abilities are maxed instead of calculating it every time
  points are gained, conserving a small amount of processing time.

1.2
* Now also prevents the FIFO text "you have reached the cap" from appearing.

1.1
* Added HideNotifications options.

1.0
* Initial release.
