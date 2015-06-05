Addon Name:      Mission Info
Author:          Julian Paolo Thiry (Aedani)
Version:         2.0.1
Official Site:   http://games.jupath.me/tsw/mission-info
Distributors:    http://www.secretui.com/downloads/fileinfo.php?id=79
                 http://www.curse.com/tsw-mods/tsw/missioninfo
Official Forum:  http://forums.thesecretworld.com/showthread.php?t=62045
Source Code:     git://git.curseforge.net/tsw/missioninfo/mainline.git


DESCRIPTION
-----------
Mission Info modifies the mission tracker on the right side of the screen. When
you hover over a mission's icon or text, you'll get a tooltip with the flavor
text of that mission's current tier. Additionally, clicking on the currently
active mission's icon will show any associated image, video, or audio clip. The
Mission Journal can be opened by selecting the active mission in the mission
bar (the part that auto-hides). 


INSTALLATION
------------
NOTE: Be sure to uninstall version 1 using the instructions found in that
      version's readme.txt before installing version 2.0 or later.
NOTE: If you are installing version 2.0.1 on top of an existing installation,
	  you will need to delete the following three files:
	  • \Data\Gui\Customized\Flash\MissionTracker\LoginPrefs.bxml
	  • \Data\Gui\Customized\Flash\MissionTracker\LoginPrefs.xml
	  • \Data\Gui\Customized\Flash\MissionTracker\Modules.bxml

Unpack the archive to <your TSW folder>\Data\Gui\Customized\
You should end up with the following files at a minimum:
• \Data\Gui\Customized\Flash\MissionTracker\MissionTracker.swf
• \Data\Gui\Customized\Flash\MissionTracker\Modules.xml
Other files may be present but are not required for the add-on to run properly.


UNINSTALLATION 
--------------
Delete the MissionTracker folder mentioned above.


HISTORY
-------
2.0.1
* Fixed issue with mission bar showing no missions after accepting or completing
  missions.

2.0
* Rewrote completely so that this addon does not replace any Funcom components.
  It is now much smaller and should not need updated with each game patch.
* Change the tooltip of the current mission in the mission bar to indicate that
  it will toggle the Mission Journal window.

1.3
* Updated to the 1.9 source code.

1.2
* Updated to the 1.8 source code.

1.1.1
* Fix Mission Journal popping up when zoning.

1.1
* Updated to the latest source, bringing in whatever fixes FUNCOM has made.
* The fonts now match the game's more closely.
* Tooltips now show up for all missions in the sidebar.
* The mission journal can be opened by selecting the current mission in the
  auto-hide section.

1.0
* Initial release.
