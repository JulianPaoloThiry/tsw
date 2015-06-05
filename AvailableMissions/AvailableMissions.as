import mx.utils.Delegate;
import com.GameInterface.Game.Dynel;
import com.GameInterface.Log;
import com.GameInterface.QuestGiver;
import com.GameInterface.Quests;
import com.GameInterface.Quest;
import com.GameInterface.VicinitySystem;
import com.Utils.Archive;
import com.Utils.ID32;
import com.Utils.Signal;
import GUI.MissionJournal.JournalWindow;

var m_Dynels:Object;
var m_Queue:Array;
var m_QueueCheckTimer:Number;

function onLoad()
{
	m_Dynels = new Object();
	m_Queue = new Array();
	m_QueueCheckTimer = -1;
}
function SlotEnterVicinity( dynelID:ID32 )
{
	if (m_Dynels[dynelID] == undefined)
	{
//		Log.Error("SlotEnterVicinity", string(dynelID));
		m_Queue.push(dynelID);
	}
}

function CheckDynels()
{
	var dynelID;
	while (m_Queue.length > 0)
	{
		dynelID = m_Queue.pop();
		if (m_Dynels[dynelID] == undefined)
		{
			var dynel = Dynel.GetDynel(dynelID);
			m_Dynels[dynelID] = true;
			if (dynel.IsMissionGiver())
			{
//				Log.Error("MissionGiver", string(dynelID));
				var questGiver:QuestGiver = Quests.GetQuestGiver( dynelID, true );
				var quests:Array = questGiver.m_AvailableQuests;
				for (var i:Number = 0; i < quests.length; i++ )
				{
					var quest:Quest = quests[i];
					if (!quest.m_HasCompleted /*&& (!quest.m_IsLocked || !quest.m_HideIfLocked)*/)
					{
						AddAvailableMission(quest);
					}
				}
			}
		}
	}
}

function SlotMissionCompleted(missionID:Number)
{
	for (var i:Number = 0; i < JournalWindow.m_AvailableMissions.length; i++ )
	{
		if (JournalWindow.m_AvailableMissions[i].m_ID == missionID)
		{
			JournalWindow.m_AvailableMissions.splice(i, 1);
			return;
		}
	}
}

function AddAvailableMission(quest:Quest)
{
	for (var i:Number = 0; i < JournalWindow.m_AvailableMissions.length; i++ )
	{
		if (JournalWindow.m_AvailableMissions[i].m_ID == quest.m_ID)
		{
			return;
		}
	}
	JournalWindow.m_AvailableMissions.push(quest);
	JournalWindow.SignalAvailableMissions.Emit();
}

function OnModuleActivated(config:Archive)
{
	m_Dynels = new Object();
	m_Queue = new Array();

	var m_AvailableMissions = new Array();
	var aidsArray:Array = config.FindEntryArray("m");
	for (var i:Number = 0; i < aidsArray.length; i++)
	{
		var quest:Quest = Quests.GetQuest(aidsArray[i], true, true);
		if (quest != undefined && !quest.m_HasCompleted)
			m_AvailableMissions.push(quest);
	}
	var m_TrackedMissions = new Array();
	var tidsArray:Array = config.FindEntryArray("t");
	for (var i:Number = 0; i < tidsArray.length; i++)
	{
		var quest:Quest = Quests.GetQuest(tidsArray[i], true, true);
		if (quest != undefined)
			m_TrackedMissions.push(quest);
	}
	JournalWindow.SetMissions(m_AvailableMissions, m_TrackedMissions);
	JournalWindow.SignalAvailableMissions.Emit();

	VicinitySystem.SignalDynelEnterVicinity.Connect(SlotEnterVicinity, this);
	Quests.SignalMissionCompleted.Connect(SlotMissionCompleted, this);

	if (m_QueueCheckTimer != -1)
		clearInterval(m_QueueCheckTimer);
	m_QueueCheckTimer = setInterval(Delegate.create(this, CheckDynels), 1500);
}

function OnModuleDeactivated()
{
    VicinitySystem.SignalDynelEnterVicinity.Disconnect(SlotEnterVicinity, this);
	Quests.SignalMissionCompleted.Disconnect(SlotMissionCompleted, this);

	if (m_QueueCheckTimer != -1)
		clearInterval(m_QueueCheckTimer);
	m_QueueCheckTimer = -1;

	return CreateConfig();
}

function CreateConfig():Archive
{
    var archive:Archive = new Archive();

	for (var i:Number = 0; i < JournalWindow.m_AvailableMissions.length; i++)
	{
		archive.AddEntry("m", JournalWindow.m_AvailableMissions[i].m_ID);
	}
	for (var i:Number = 0; i < JournalWindow.m_TrackedMissions.length; i++)
	{
		archive.AddEntry("t", JournalWindow.m_TrackedMissions[i].m_ID);
	}
	return archive;
}

