import com.GameInterface.Chat;
import com.GameInterface.Game.Team;
import com.GameInterface.Game.TeamInterface;
//import com.GameInterface.Log;
import com.Utils.Archive;
import com.Utils.LDBFormat;
import GUI.Inventory.ItemIconBox;
import mx.utils.Delegate;


function onLoad()
{
    TeamInterface.SignalClientJoinedTeam.Connect(SlotClientJoinedTeam, this);
    TeamInterface.SignalClientLeftTeam.Connect(SlotClientLeftTeam, this);
	TeamInterface.RequestTeamInformation();
}
function OnModuleActivated(config:Archive)
{
	FindHotbar();
}
function FindHotbar()
{
	var m_Backpack = _root.backpack2;
	if (m_Backpack == undefined || m_Backpack == null)
	{
		setTimeout(Delegate.create(this, FindHotbar), 100);
		return;
	}

	var m_IconBoxes:Array = m_Backpack.m_IconBoxes;
	if (m_IconBoxes == null || m_IconBoxes == undefined || m_IconBoxes.length == 0)
	{
		setTimeout(Delegate.create(this, FindHotbar), 100);
		return;
	}

	var m_Hotbar:ItemIconBox = null;
	for (var i:Number = 0; i < m_IconBoxes.length; i++)
	{
		var iconBox:ItemIconBox = m_IconBoxes[i];
		if (iconBox != undefined)
		{
			if ("Hotbar" == iconBox.GetName())
			{
				m_Hotbar = iconBox;
				break;
			}
		}
	}
	
	if (m_Hotbar == null) {
		if (m_IconBoxes.length < m_Backpack.m_MaxNumBoxes)
		{
			m_Hotbar = m_Backpack.CreateNewBox();
			m_Hotbar.SetName("Hotbar");
			m_Hotbar.SetPinned(true);
			m_Hotbar.ResizeBoxTo(3, 6);
			m_IconBoxes.push(m_Hotbar);
		}
		else
		{
			//FIFO
			var fifoMessage:String = LDBFormat.LDBGetText("GenericGUI", "MaxInventoryWindows");
			Chat.SignalShowFIFOMessage.Emit(fifoMessage, 0);
		}
	}
	if (m_Hotbar != null) {
		m_Hotbar.SignalTrashButtonPressed.Disconnect(m_Backpack.SlotTrashPressed, m_Backpack);
		m_Hotbar.SignalTrashButtonPressed.Connect(SlotTrashPressed, this);
		HotbarShortcut.Register(m_Hotbar, m_Backpack.m_Inventory);
	}
}

//Slot Trash Pressed
function SlotTrashPressed():Void
{
	Chat.SignalShowFIFOMessage.Emit("Hotbar cannot be deleted", 0);
}

//Slot Client Joined Team
function SlotClientJoinedTeam(team:Team):Void
{
	HotbarShortcut.SetTeam(team);
}

//Slot Client Left Team
function SlotClientLeftTeam():Void
{
	HotbarShortcut.SetTeam(null);
}
