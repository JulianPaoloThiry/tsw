import com.GameInterface.Chat;
import com.GameInterface.Game.Character;
import com.GameInterface.Game.Shortcut;
import com.GameInterface.Game.TargetingInterface;
import com.GameInterface.Game.Team;
import com.GameInterface.Input;
import com.GameInterface.Inventory;
import com.Components.ItemSlot;
import GUI.Inventory.ItemIconBox;
import com.Utils.ID32;
import flash.geom.Point;

class HotbarShortcut
{
	static var m_UseItem1:Boolean = false;
	static var m_UseItem2:Boolean = false;
	static var m_Hotbar:ItemIconBox;
	static var m_Inventory:Inventory;
	static var m_Team:Team = null;
	
	public static function Register(hotbar:ItemIconBox, inventory:Inventory)
	{
		m_Hotbar = hotbar;
		m_Inventory = inventory;
		RegisterHotkey(_global.Enums.InputCommand.e_InputCommand_ToggleSelectSelf, "HotbarShortcut.Shortcutbar1");
		RegisterHotkey(_global.Enums.InputCommand.e_InputCommand_SelectTeammember2, "HotbarShortcut.Shortcutbar2");
		RegisterHotkey(_global.Enums.InputCommand.e_InputCommand_SelectTeammember3, "HotbarShortcut.Shortcutbar3");
		RegisterHotkey(_global.Enums.InputCommand.e_InputCommand_SelectTeammember4, "HotbarShortcut.Shortcutbar4");
		RegisterHotkey(_global.Enums.InputCommand.e_InputCommand_SelectTeammember5, "HotbarShortcut.Shortcutbar5");
		RegisterHotkey(_global.Enums.InputCommand.e_InputCommand_SelectTeammember6, "HotbarShortcut.Shortcutbar6");
		RegisterHotkey(_global.Enums.InputCommand.e_InputCommand_SaveVideo, "HotbarShortcut.ItemDown1");
		RegisterHotkey(_global.Enums.InputCommand.e_InputCommand_SaveVideo_Mov, "HotbarShortcut.ItemDown2");
	}
	
	private static function RegisterHotkey(hotkey:Number, func:String) {
		//KeyUp events are not sent while any key is still down, so clear on all KeyUp events
		Input.RegisterHotkey(hotkey, "", _global.Enums.Hotkey.eHotkeyDown, 0);
		Input.RegisterHotkey(hotkey, "", _global.Enums.Hotkey.eHotkeyUp, 0);
		Input.RegisterHotkey(hotkey, func, _global.Enums.Hotkey.eHotkeyDown, 0);
		Input.RegisterHotkey(hotkey, "HotbarShortcut.ClearModifiers", _global.Enums.Hotkey.eHotkeyUp, 0);
	}
	
	
	//This could be done more elegantly by using one method and checking the hotkey/state values,
	//but it would be less efficient since the binding already directs to the right place.
	public static function ItemDown1(hotkey:Number, state:Number)
	{
		m_UseItem1 = true;
	}
	public static function ItemDown2(hotkey:Number, state:Number)
	{
		m_UseItem2 = true;
	}
	public static function Shortcutbar1(hotkey:Number, state:Number)
	{
		UseItem(0);
	}
	public static function Shortcutbar2(hotkey:Number, state:Number)
	{
		UseItem(1);
	}
	public static function Shortcutbar3(hotkey:Number, state:Number)
	{
		UseItem(2);
	}
	public static function Shortcutbar4(hotkey:Number, state:Number)
	{
		UseItem(3);
	}
	public static function Shortcutbar5(hotkey:Number, state:Number)
	{
		UseItem(4);
	}
	public static function Shortcutbar6(hotkey:Number, state:Number)
	{
		UseItem(5);
	}
	
	public static function SetTeam(team:Team)
	{
		m_Team = team;
	}
	
	private static function SetTarget(i:Number)
	{
		if (i == 0) TargetingInterface.SetTarget(Character.GetClientCharID());
		else if (m_Team != null)
		{
			var id:ID32 = m_Team.GetTeamMemberID(i);
			if (id) TargetingInterface.SetTarget(id);
		}
	}
	
	private static function UseItem(i:Number)
	{
		//When no triggers are down, set the target instead
		if (!m_UseItem1 && !m_UseItem2)
		{
			SetTarget(i);
			return;
		}
		
		var row:Number = -1;
		var col:Number = -1;
		
		//Make sure the hotbar is sized reasonably
		var cols:Number = m_Hotbar.GetNumColumns();
		var rows:Number = m_Hotbar.GetNumRows();
		if (cols != 6 && rows != 6)
		{
			ShowError("Hotbar must have either six rows or six columns.");
			return;
		}
		if (cols == 6)
		{
			if (rows > 3)
			{
				ShowError("Hotbar must have three or fewer rows.");
				return;
			}
			col = i;
			if (m_UseItem1) row+=1;
			if (m_UseItem2) row+=2;
			if (row >= rows)
			{
				ShowError("Hotbar has no row " + string(row+1) + ".");
				return;
			}
		}
		else if (rows == 6)
		{
			if (cols > 3)
			{
				ShowError("Hotbar must have three or fewer columns.");
				return;
			}
			row = i;
			if (m_UseItem1) col+=1;
			if (m_UseItem2) col+=2;
			if (col >= cols)
			{
				ShowError("Hotbar has no column " + string(col+1) + ".");
				return;
			}
		}

		//Use Item
		var gridPos:Point = new Point(col, row);
		var item:ItemSlot = m_Hotbar.GetItemAtGridPosition(gridPos);
		if (item != undefined && item.GetData() != undefined)
			m_Inventory.UseItem(item.GetSlotID());
		else
			ShowError("No item on Hotbar at column " + string(col+1) + ", row " + string(row+1) + ".");
	}
	public static function ClearModifiers()
	{
		m_UseItem1 = false;
		m_UseItem2 = false;
	}
	private static function ShowError(msg:String)
	{
		Chat.SignalShowFIFOMessage.Emit(msg, 0);
	}
}