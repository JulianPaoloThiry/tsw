Addon Name:      Hotbar
Author:          Aedani
Version:         1.0.4
Official Sites:  http://www.secretui.com/downloads/fileinfo.php?id=78
                 http://www.curse.com/tsw-mods/tsw/hotbar
Official Forum:  http://forums.thesecretworld.com/showthread.php?t=61753
Source Code:     git://git.curseforge.net/tsw/hotbar/mainline.git


DESCRIPTION
-----------
This addon adds a drag and drop Hotbar to the UI. Items on the Hotbar can be
triggered via keyboard shortcuts. 


INSTALLATION
------------
Unpack the archive to <your TSW folder>\Data\Gui\Customized\
You should end up with the following files at a minimum:
• \Data\Gui\Customized\Flash\Hotbar\Hotbar.swf
• \Data\Gui\Customized\Flash\Hotbar\LoginPrefs.xml
• \Data\Gui\Customized\Flash\Hotbar\Modules.xml
Other files may be present but are not required for the addon to run properly.


UNINSTALLATION 
--------------
Delete the folder \Data\Gui\Customized\Flash\Hotbar.


CONFIGURING THE HOTBAR
----------------------
1. Open the controls menu, locate the following items, and change them to the
   values listed below.

      Save Video (Mov)                    ALT
      Save Video (Quicktime)              SHIFT
      Offensive Target Self               F1
      Target Group Member 2               F2
      Target Group Member 3               F3
      Target Group Member 4               F4
      Target Group Member 5               F5
      Target Group Member 6               F6

2. Find "Exit Game" and set it to anything that isn't a combination of the
   above values (something like CTRL+SHIFT+F12 will work).

3. Find the inventory bag with the name "Hotbar" and drag some items into it.
   Any item that can be activated will work - potions, quest items, Deathless
   skills, gear, etc., are all acceptable.

4. Activate items on the hotbar by pressing the keys listed in the corresponding
   square on hotbarkeys.png.

   
TROUBLESHOOTING
---------------
Problem: I don't have an inventory bag named "Hotbar".
Solution: If you already have 20 bags, the initial creation will fail and you
will see a message in the FIFO area. You will need to either delete at least
one bag or rename one of your existing bags to "Hotbar" and then reload the UI
for the addon to work.

Problem: I've configured my targeting keys the way I like them already.
Solution: Assign F1-F6 (or the keys of your choice) to the secondary column.

Problem: I'm pressing a hotkey, but something else is happening.
Solution: Make sure that another control isn't assigned to the combination
you're pressing. For example, by default, "Exit Game" is assigned to ALT-F4,
which overlaps the hotkey for the fourth item on the second row.

Problem: I want my Hotbar to be vertical rather than horizontal.
Solution: This is perfectly fine. Just resize the Hotbar window (drag from the
bottom right corner). When oriented vertically, the keys for rows and columns
swap. The left column is SHIFT, the middle is ALT, and the right is ALT+SHIFT.

Problem: I'm getting a message about the Hotbar's number of rows or columns.
Solution: The Hotbar must be resized to be either 1x6, 2x6, 3x6, 6x1, 6x2, or
6x3. If it is not one of those sizes, then a message will display on screen
when you try to activate a shortcut.

Problem: I want to use something other than ALT and SHIFT.
Solution: Reassign the "Save Video (Mov)" and "Save Video (Quicktime)" controls
to the keys you want to use. Be sure to check that no other controls are
assigned to combinations of your chosen keys and the targeting keys.

Problem: I'm trying to use two items, one after the other, but the second one
is targeting a team member instead.
Solution: To use multiple items in quick succession, you must release the ALT
and SHIFT keys before hitting the new hotkey. This is simply due to the way
the keyboard is read in The Secret World, and cannot currently be avoided.

Problem: If I press SHIFT and ALT, then release ALT and hit a targeting key,
the wrong item is used.
Solution: This is also caused by the keyboard reading in The Secret World. To
avoid this issue, always release both SHIFT and ALT if you've hit one that you
did not intend to press. Alternatively, do not put items on the third row.


HISTORY
-------
1.0.4
* Built against the 1.11 source.

1.0.3
* Updated to latest Funcom source.
* Changed override triggers to Save Movie instead of Print Position, as the
  latter have proven to be useful during world events.

1.0.2
* No actual changes - just recompiled against the latest FUNCOM sources. This
  apparently fixes issues with /reloadui and pin buttons.

1.0.1
* Fixed Hotbar not updating correctly after zoning.

1.0
* Initial release.
