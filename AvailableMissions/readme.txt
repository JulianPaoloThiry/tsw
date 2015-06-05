Addon Name:      Available Missions
Author:          Julian Paolo Thiry (Aedani)
Version:         1.5
Official Site:   http://games.jupath.me/tsw/available-missions
Distributors:    http://www.secretui.com/downloads/fileinfo.php?id=73
                 http://www.curse.com/tsw-mods/tsw/availablemissions
Official Forum:  http://forums.thesecretworld.com/showthread.php?t=60129
Source Code:     git://git.curseforge.net/tsw/availablemissions/mainline.git


DESCRIPTION
-----------
This addon modifies the Mission Journal to have two new entries in the dropdown:
Available Missions and Tracked Missions.

Available Missions: As you roam through the world, nearby missions that you have
not yet completed will automatically be added to this section so that you will
not forget to complete them. They will be removed once they are completed.
Please be aware that this will include hidden missions such as seasonal or
faction missions that are currently unavailable. However, these hidden missions
will not be expandable, so you will not be able to peek at the details.

Tracked Missions: Simply click the new "eye" icon on any completed, repeatable
mission to add it to the Tracked Missions list. Now you can more easily track
important mission cooldowns in one place.


INSTALLATION
------------
Unpack the archive to <your TSW folder>\Data\Gui\Customized\
You should end up with the following files at a minimum:
• \Data\Gui\Customized\Flash\MissionJournalWindow.swf
• \Data\Gui\Customized\Flash\AvailableMissions\AvailableMissions.swf
• \Data\Gui\Customized\Flash\AvailableMissions\CharPrefs.xml
• \Data\Gui\Customized\Flash\AvailableMissions\Modules.xml
Other files may be present but are not required for the addon to run properly.


UNINSTALLATION 
--------------
Delete the folder \Data\Gui\Customized\Flash\AvailableMissions and
the file \Data\Gui\Customized\Flash\MissionJournalWindow.swf.


HISTORY
-------
1.5
* Updated to the 1.11 source code.

1.4
* Updated to the 1.8 source code.
* The font now matches the game's font more closely.

1.3-fix
* (fix) Packaged the wrong files in 1.3.
* Added region filtering dropdown to Tracked Missions (still no good way to do
  it for Available Missions).
* XP reward line is now shown for all repeatable missions.
* Tightened up the spacing between missions in the list.
* Fixed clipping issue on the rightmost buttons.
* Fixed the scroll-to-top issue for good this time.
* Tweaked visibility of buttons so that valid actions should appear regardless
  of which journal section is active.

1.2.1
* Fixed Tracked Missions not updating when a quest is updated while the Journal
  is open.

1.2
* Added a Tracked Missions list. Just click the "eye" icon on any repeatable,
  completed mission to add it to the list.

1.1.2
* Something went wrong with the font embedding in the previous version. Fixed.

1.1.1
* Updated for patch 1.4.
* Yes, I know the scroll issue when expanding/collapsing still exists - I've
  tried everything I can think of to fix it, and nothing seems to work.

1.1
* Fixed font (now contains all characters so words like "Drăculeşti" appear
  correctly.
* No longer scrolls to the top when expanding/collapsing entries. Well, ok,
  actually it does, but then it scrolls back down. This can be a bit jumpy
  sometimes, but it's better than having to scroll the window constantly. 

1.0
* Initial release.
