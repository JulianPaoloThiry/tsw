import com.GameInterface.DistributedValue;
import com.GameInterface.Quests;
import com.Utils.LDBFormat;
import com.Utils.Signal;
import mx.utils.Delegate;

var m_MaxInitDelay:Number;
var m_InitDelayInterval:Number = 250; //ms
var m_TDB_Tier:String;
var m_TDB_PlayAudio:String;
var m_TDB_PlayVideo:String;
var m_TDB_ShowImage:String;
var m_IsMissionJournalActive:DistributedValue;

function onLoad():Void
{
	m_MaxInitDelay = 10000; //ms
	setTimeout(Delegate.create(this, InitWait), m_InitDelayInterval);
}

function onUnload()
{
	var window = _root.missiontracker;
	if (window["ShowAllMissionsOrig"] != undefined) {
		window.ShowAllMissions = window["ShowAllMissionsOrig"];
		delete window["ShowAllMissionsOrig"];
		window.ShowMission = window["ShowMissionOrig"];
		delete window["ShowMissionOrig"];
	}
}

function InitWait():Void
{
	var code:String = "";
	if (_root.missiontracker == undefined) code += "M1.";
	if (_root.missiontracker.ShowAllMissions == undefined) code += "M2.";
	if (_root.missiontracker.ShowMission == undefined) code += "M3.";
	if (_root.missiontracker.m_MissionTrackerItemArray == undefined) code += "M4.";
	if (_root.missiontracker.OpenMissionJournal == undefined) code += "M5.";
	if (code != "")
	{
		if (m_MaxInitDelay <= 0)
		{
			Chat.SignalShowFIFOMessage.Emit("MissionInfo initialization failure code: "+code, 0);
		} else {
			m_MaxInitDelay -= m_InitDelayInterval;
			setTimeout(Delegate.create(this, InitWait), m_InitDelayInterval);
		}
	} else {
		Init();
	}
}

function Init():Void
{
	m_TDB_Tier = LDBFormat.LDBGetText( "MiscGUI", "Mission_Tier_MixedCase");
	m_TDB_PlayAudio = LDBFormat.LDBGetText( "MiscGUI", "PlayAudio");
	m_TDB_PlayVideo = LDBFormat.LDBGetText( "MiscGUI", "PlayVideo");
	m_TDB_ShowImage = LDBFormat.LDBGetText( "MiscGUI", "ShowImage");
	m_TDB_ToggleJournal = LDBFormat.LDBGetText( 10027, 268031047);
    m_IsMissionJournalActive = DistributedValue.Create( "mission_journal_window" );
	var window = _root.missiontracker;
	if (window["ShowAllMissionsOrig"] == undefined) {
		window["ShowAllMissionsOrig"] = window.ShowAllMissions;
		window["ShowMissionOrig"] = window.ShowMission;
		window.ShowAllMissions = Delegate.create(window, this.ShowAllMissions);
		window.ShowMission = Delegate.create(window, this.ShowMission);
	}
	if (window.m_MissionTrackerItem != undefined)
		window.ShowMission(window.m_MissionTrackerItem.GetMissionId());
}

function AddTooltip(tracker)
{
	if (_root.missiontracker.m_ActiveMission == tracker.GetMissionId() && tracker != _root.missiontracker.m_MissionTrackerItem) {
		var tooltipText:String = m_TDB_ToggleJournal;
		com.GameInterface.Tooltip.TooltipUtils.AddTextTooltip( tracker, tooltipText, 150, com.GameInterface.Tooltip.TooltipInterface.e_OrientationHorizontal, true );
	} else {
		var tooltipText:String = "<font size='15' color='#FF8000'><b>"+tracker.m_Quest.m_MissionName+": "+m_TDB_Tier+" "+tracker.m_Quest.m_CurrentTask.m_Tier+"</b></font>";
		tooltipText += "<br/> <br/>" + tracker.m_Quest.m_CurrentTask.m_TierDesc;
		var mediaTask = tracker.m_Quest.m_CurrentTask;
		if (mediaTask.m_MediaRDBID != 0)
		{
			var mediaText:String = "";
			switch(mediaTask.m_MediaType)
			{
				case  _global.Enums.QuestMediaType.QuestGiverList_QuestMediaType_Video:
					mediaText = m_TDB_PlayVideo;
					break;
				case  _global.Enums.QuestMediaType.QuestGiverList_QuestMediaType_Image:
					mediaText = m_TDB_ShowImage;
					break;
				case  _global.Enums.QuestMediaType.QuestGiverList_QuestMediaType_Audio:
					mediaText = m_TDB_PlayAudio;
					break;
			}
			if (mediaText != "")
			{
				tooltipText += "<br/> <br/>[" + mediaText + "]";
			}
		}
		com.GameInterface.Tooltip.TooltipUtils.AddTextTooltip( tracker, tooltipText, 310, com.GameInterface.Tooltip.TooltipInterface.e_OrientationHorizontal, true );
	}
}

function ShowAllMissions()
{
	this["ShowAllMissionsOrig"]();
    for ( var i = 0; i < _root.missiontracker.m_MissionTrackerItemArray.length; ++i )
	{
		var tracker = _root.missiontracker.m_MissionTrackerItemArray[i];
		tracker.onRelease = Delegate.create( tracker, OnRelease);
		tracker.onPress = tracker.onRollOver = tracker.onRollOut = tracker.onDragOut = tracker.onMouseDown = null;
		AddTooltip(tracker);
	}
}

function ShowMission(tierId:Number, goalId:Number, isActive:Boolean) :Boolean
{
	var result:Boolean = this["ShowMissionOrig"](tierId, goalId, isActive);
	var tracker = _root.missiontracker.m_MissionTrackerItem;
	if (tracker != undefined) {
		tracker.onRelease = Delegate.create( tracker, MediaButtonHandler);
		AddTooltip(tracker);
	}
	return result;
}

function OnRelease()
{
	if (_root.missiontracker.m_ActiveMission == this.GetMissionId())
		m_IsMissionJournalActive.SetValue(!m_IsMissionJournalActive.GetValue());
	this.SignalSetAsMainMission.Emit( this.GetMissionId() );
}
function MediaButtonHandler( event:Object ) : Void
{
	var mediaTask = this.m_Quest.m_CurrentTask;
	if (mediaTask.m_MediaRDBID != 0)
	{
		var mediaType:Number = 0;
		switch(mediaTask.m_MediaType)
		{
			case  _global.Enums.QuestMediaType.QuestGiverList_QuestMediaType_Video:
				mediaType = _global.Enums.RDBID.e_RDB_USM_Movie;
				break;
			case  _global.Enums.QuestMediaType.QuestGiverList_QuestMediaType_Image:
				mediaType = _global.Enums.RDBID.e_RDB_GUI_Image;
				break;
			case  _global.Enums.QuestMediaType.QuestGiverList_QuestMediaType_Audio:
				mediaType = _global.Enums.RDBID.e_RDB_FlashFile;
				break;
		}
		Quests.ShowMedia(mediaType, mediaTask.m_MediaRDBID);
	}
}
