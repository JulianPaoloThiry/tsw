import com.GameInterface.Chat;
import com.GameInterface.Game.Character;
import com.GameInterface.Game.CharacterBase;
import com.GameInterface.DistributedValue;
import com.GameInterface.FeatInterface;
import com.GameInterface.FeatData;
import com.GameInterface.Utils
import com.Utils.LDBFormat;
import com.Utils.SignalGroup;
import mx.utils.Delegate;
//import com.GameInterface.Log;

var m_SkillsMaxed:Boolean;
var m_AnimaMaxed:Boolean;
var m_BlinkNotificationsMonitor:DistributedValue;
var m_SuppressAPWhenCappedMonitor:DistributedValue;
var m_SuppressSPWhenCappedMonitor:DistributedValue;
var m_SignalGroup:SignalGroup;
var m_MaxInitDelay:Number;
var m_InitDelayInterval:Number = 250; //ms

function onLoad():Void
{
	m_MaxInitDelay = 10000; //ms
//	DumpFeats();
	setTimeout(Delegate.create(this, InitWait), m_InitDelayInterval);
}
function onUnload()
{
    m_SignalGroup.DisconnectAll();
}

function InitWait():Void
{
	var code:String = "";
	if (_root.animawheellink.SetVisible == undefined) code += "A1.";
	if (_root.animawheellink.SlotTokenAmountChanged == undefined) code += "A2.";
	if (_root.animawheellink.m_AnimaPointsIcon == undefined) code += "A3.";
	if (_root.animawheellink.m_SkillPointsIcon == undefined) code += "A4.";
	if (_root.animawheellink.m_NotificationThrottleIntervalId == undefined) code += "A5.";
	else if (_root.animawheellink.m_NotificationThrottleIntervalId < 0) code += "A8.";
	if (_root.animawheellink.AnimateUnclickedNotifications == undefined) code += "A6.";
	if (_root.animawheellink.m_NotificationThrottleInterval == undefined) code += "A7.";
	if (_root.fifo.onUnload == undefined) code += "F1.";
	if (_root.fifo.SlotShowFIFOMessage == undefined) code += "F2.";
	if (code != "")
	{
		if (m_MaxInitDelay <= 0)
		{
			Chat.SignalShowFIFOMessage.Emit("CleanNotifications initialization failure code: "+code, 0);
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
    m_SkillsMaxed = false;
    m_AnimaMaxed = false;
	
	m_SignalGroup = new SignalGroup;
	Chat.SignalShowFIFOMessage.Connect(m_SignalGroup, SlotShowFIFOMessage);
	_root.fifo.onUnload();

    m_BlinkNotificationsMonitor = DistributedValue.Create("BlinkNotifications");
    m_BlinkNotificationsMonitor.SignalChanged.Connect(SlotBlinkNotifications, this);

    m_SuppressAPWhenCappedMonitor = DistributedValue.Create("SuppressAPWhenCapped");
    m_SuppressSPWhenCappedMonitor = DistributedValue.Create("SuppressSPWhenCapped");

    Character.SignalClientCharacterAlive.Connect(SlotCharacterAlive, this);
    SlotCharacterAlive();
}

function GetAPCapMessage():String {
	var APSPText:String = LDBFormat.LDBGetText(100, 24702512);
	// The first time the above statement runs, it successfully returns "Blah %s blah %d.".
	// Absurdly, if it is called after receiving the message in game (say, a /reloadui after
	// turning in some quests), it returns "Blah Skill Point blah 40." instead. Therefore
	// the following attempts to detect and undo this mess.
	var APText:String = LDBFormat.LDBGetText(10028, 1);
	var SPText:String = LDBFormat.LDBGetText(10028, 2);
	var character:Character = Character.GetClientCharacter();
	var APCap:String = "" + (Utils.GetGameTweak("LevelTokensCap") + character.GetStat(_global.Enums.Stat.e_PersonalAnimaTokenCap, 2));
	var SPCap:String = "" + (Utils.GetGameTweak("SkillTokensCap") + character.GetStat(_global.Enums.Stat.e_PersonalSkillTokenCap, 2));
	if (APSPText.indexOf("%") > 0) {
		return LDBFormat.Printf(APSPText, APText, APCap);
	} else if (APSPText.indexOf(APText) > 0) {
		return APSPText;
	} else if (APSPText.indexOf(SPText) > 0) {
		return APSPText.split(SPText).join(APText).split(SPCap).join(APCap);
	}
}
function GetSPCapMessage():String {
	var APSPText:String = LDBFormat.LDBGetText(100, 24702512);
	// The first time the above statement runs, it successfully returns "Blah %s blah %d.".
	// Absurdly, if it is called after receiving the message in game (say, a /reloadui after
	// turning in some quests), it returns "Blah Skill Point blah 40." instead. Therefore
	// the following attempts to detect and undo this mess.
	var APText:String = LDBFormat.LDBGetText(10028, 1);
	var SPText:String = LDBFormat.LDBGetText(10028, 2);
	var character:Character = Character.GetClientCharacter();
	var APCap:String = "" + (Utils.GetGameTweak("LevelTokensCap") + character.GetStat(_global.Enums.Stat.e_PersonalAnimaTokenCap, 2));
	var SPCap:String = "" + (Utils.GetGameTweak("SkillTokensCap") + character.GetStat(_global.Enums.Stat.e_PersonalSkillTokenCap, 2));
	if (APSPText.indexOf("%") > 0) {
		return LDBFormat.Printf(APSPText, SPText, SPCap);
	} else if (APSPText.indexOf(APText) > 0) {
		return APSPText.split(APText).join(SPText).split(APCap).join(SPCap);
	} else if (APSPText.indexOf(SPText) > 0) {
		return APSPText;
	}
}

function SlotCharacterAlive():Void
{
    SlotBlinkNotifications();
    var character:Character = Character.GetClientCharacter();
    
    if (character != undefined)
    {
        character.SignalTokenAmountChanged.Connect(SlotTokenAmountChanged, this);
    }
}

function SlotTokenAmountChanged(id:Number, newValue:Number, oldValue:Number):Void
{
    if (id == 1) //Anima Points
    {
		var visible:Boolean = !AnimaMaxed();
		var wasVisible:Boolean = DistributedValue.GetDValue("ap_notifications", true);
		if (wasVisible != visible) {
			DistributedValue.SetDValue("ap_notifications", visible);
			if (visible) _root.animawheellink.SlotTokenAmountChanged(id, newValue, oldValue);
			else _root.animawheellink.SetVisible(_root.animawheellink.m_AnimaPointsIcon, visible);
		}
    }
    else if (id == 2) //Skill Points
    {
		var visible:Boolean = !SkillsMaxed();
		var wasVisible:Boolean = DistributedValue.GetDValue("sp_notifications", true);
		if (wasVisible != visible) {
			DistributedValue.SetDValue("sp_notifications", visible);
			if (visible) _root.animawheellink.SlotTokenAmountChanged(id, newValue, oldValue);
			else _root.animawheellink.SetVisible(_root.animawheellink.m_SkillPointsIcon, visible);
		}
    }
}

function SlotBlinkNotifications():Void
{
    if (_root.animawheellink.m_NotificationThrottleIntervalId > -1) {
        clearInterval( _root.animawheellink.m_NotificationThrottleIntervalId );
		_root.animawheellink.m_NotificationThrottleIntervalId = -1;
	}
    
    if (m_BlinkNotificationsMonitor.GetValue())
        _root.animawheellink.m_NotificationThrottleIntervalId = setInterval(Delegate.create(_root.animawheellink, _root.animawheellink.AnimateUnclickedNotifications), _root.animawheellink.m_NotificationThrottleInterval );
}

function SlotShowFIFOMessage( text:String, mode:Number )
{
    // Don't add the line if it's the AP/SP capped notification and points are maxed.
    if ((text == GetAPCapMessage() && AnimaMaxed()) || (text == GetSPCapMessage() && SkillsMaxed()))
        return;
	_root.fifo.SlotShowFIFOMessage(text, mode);
}  

function SkillsMaxed():Boolean
{
    if (m_SkillsMaxed) return true;
	if (m_SuppressSPWhenCappedMonitor.GetValue()) {
		var character:Character = Character.GetClientCharacter();
		var cap:Number = Utils.GetGameTweak("SkillTokensCap") + character.GetStat(_global.Enums.Stat.e_PersonalSkillTokenCap, 2);		
		var current:Number = character.GetTokens(_global.Enums.Token.e_Skill_Point);
		if (current >= cap) return true;
	}
    for (var featID in FeatInterface.m_FeatList)
    {
        var featData:FeatData = FeatInterface.m_FeatList[featID];
        if (featData != undefined && !featData.m_AutoTrain && !featData.m_Trained &&
            featData.m_ClusterIndex > 1000 && featData.m_ClusterIndex < 2000)
            return false;
    }
    m_SkillsMaxed = true;
    return true;
}
function AnimaMaxed():Boolean
{
    if (m_AnimaMaxed) return true;
	if (m_SuppressAPWhenCappedMonitor.GetValue()) {
		var character:Character = Character.GetClientCharacter();
		var cap:Number = Utils.GetGameTweak("LevelTokensCap") + character.GetStat(_global.Enums.Stat.e_PersonalAnimaTokenCap, 2);		
		var current:Number = character.GetTokens(_global.Enums.Token.e_Anima_Point);
		if (current >= cap) return true;
	}
    for (var featID in FeatInterface.m_FeatList)
    {
        var featData:FeatData = FeatInterface.m_FeatList[featID];
        if (featData != undefined && !featData.m_AutoTrain && !featData.m_Trained &&
            (featData.m_ClusterIndex < 1000 || featData.m_ClusterIndex > 2000))
            return false;
    }
    m_AnimaMaxed = true;
    return true;
}

/*
function DumpFeats():Void
{
    for (var featID in FeatInterface.m_FeatList)
    {
        var featData:FeatData = FeatInterface.m_FeatList[featID];
        if (featData != undefined && !featData.m_AutoTrain && !featData.m_Trained)
			Log.Error("FeatDump", "Id="+featData.m_Id
				+", Name="+featData.m_Name
				//+", Desc="+featData.m_Desc
				//+", IconID="+featData.m_IconID
				+", ColorLine="+featData.m_ColorLine
				+", Spell="+featData.m_Spell
				+", SpellType="+featData.m_SpellType
				+", PowerLevel="+featData.m_PowerLevel
				+", Trained="+featData.m_Trained
				+", CanTrain="+featData.m_CanTrain
				+", Refundable="+featData.m_Refundable
				+", Cost="+featData.m_Cost
				+", ClusterIndex="+featData.m_ClusterIndex
				+", CellIndex="+featData.m_CellIndex
				+", AbilityIndex="+featData.m_AbilityIndex
				+", AutoTrain="+featData.m_AutoTrain
				+", Level="+featData.m_Level
				+", ClassId="+featData.m_ClassId
				+", Category="+featData.m_Category
				+", FeatGroupId="+featData.m_FeatGroupId
				+", DependencyId1="+featData.m_DependencyId1
			);
    }
}
*/
