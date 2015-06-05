import com.GameInterface.Chat;
import com.GameInterface.ComputerPuzzleIF;
import com.GameInterface.DistributedValue;
import com.GameInterface.ProjectUtils;
import mx.utils.Delegate;

var m_MaxDelay:Number;
var m_DelayInterval:Number = 50; //ms
var m_OnKeyDown:Function;
var m_GHOSTTabletLayout:DistributedValue;
var m_GHOSTTabletExtraLines:DistributedValue;
var m_Init:Boolean;
var m_Height:Number;

function onLoad():Void
{
	ComputerPuzzleIF.SignalTextUpdated.Connect(SlotInit, this);
    m_GHOSTTabletLayout = DistributedValue.Create("GHOSTTabletLayout");
    m_GHOSTTabletExtraLines = DistributedValue.Create("GHOSTTabletExtraLines");
}

function SlotInit():Void
{
	m_MaxDelay = 5000; //ms
	setTimeout(Delegate.create(this, InitWait), m_DelayInterval);
}

function InitWait():Void
{
	var code:String = "";
	var that = _root.computerpuzzle.m_ComputerInterfaceWindow;
	if (that == undefined) code += "C1.";
	else {
		if (that.m_CloseButton == undefined) code += "C2.";
		if (that.m_Dragpoint == undefined) code += "C3.";
		if (that.m_TextArea == undefined) code += "C4.";
		else {
			if (that.m_TextArea.m_TopArrow == undefined) code += "T1.";
			if (that.m_TextArea.m_BottomArrow == undefined) code += "T2.";
			if (that.m_TextArea.m_Background == undefined) code += "T3.";
			if (that.m_TextArea.textField == undefined) code += "T4.";
		}
		if (that.m_UserInputField == undefined) code += "C5.";
		if (that.m_Title == undefined) code += "C6.";
		if (that.m_Dragpoint.onPress == undefined) code += "C7.";
		if (that.onKeyDown == undefined) code += "C8.";
		if (that.CheckTextArea == undefined) code += "C9.";
		if (that.CloseComputerPuzzle == undefined) code += "C10.";
		if (that.m_SkinParent == undefined) code += "C11.";
		else {
			if (that.m_SkinParent.m_Skin == undefined) code += "S1.";
			if (that.m_SkinParent.m_Skin.m_LayoutLoader == undefined) code += "S2.";
		}
		if (that.SetLayout == undefined) code += "C12.";
	}
	if (code != "")
	{
		if (m_MaxDelay <= 0)
		{
			Chat.SignalShowFIFOMessage.Emit("GHOSTTablet initialization failure code: "+code, 0);
		} else {
			m_MaxDelay -= m_DelayInterval;
			setTimeout(Delegate.create(this, InitWait), m_DelayInterval);
		}
	} else {
		Init();
	}
	m_Init = true;
}

function Init():Void
{
	var that = _root.computerpuzzle.m_ComputerInterfaceWindow;
	if (that.onKeyDown != this.OnKeyDown) {
		m_OnKeyDown = that.onKeyDown;
		that.onKeyDown = this.OnKeyDown;

		that._alpha = 1;
		that.m_CloseButton._alpha = 10000;
		that.m_TextArea._alpha = 10000;
		that.m_SkinParent._alpha = 10000;
		that.m_SkinParent.m_Skin._alpha = 1;
		that.m_SkinParent.m_Skin.m_LayoutLoader._alpha = 5000;
		that.m_UserInputField._alpha = 10000;
		that.m_Title._alpha = 10000;
		
		Resize();
		_root.computerpuzzle._y -= (m_Height - 252) / 2;
	}
}

function Resize():Void
{
    var that = _root.computerpuzzle.m_ComputerInterfaceWindow;
	if (that != undefined) {
		m_Height = Math.round(252 * (17 + parseInt(m_GHOSTTabletExtraLines.GetValue(),10)) / 17);
		that.m_TextArea.m_Background._height = m_Height;
		that.m_SkinParent.m_Skin.m_LayoutLoader._height = m_Height + 54;
		that.m_Dragpoint._height = m_Height + 108;
		that.m_TextArea.m_BottomArrow._y = m_Height - 20.5;
		that.m_UserInputField._y = m_Height + 66;
		
		that.m_TextArea.setMask(null);
		ProjectUtils.SetMovieClipMask(that.m_TextArea, null, that.m_TextArea.m_Background._height, that.m_TextArea.m_Background._width, false);

		var mask:MovieClip;
		if (that["mask2"]) {
			mask = that.mask2;
			mask.clear();
		} else {
			mask = that.createEmptyMovieClip("mask2", that.getNextHighestDepth());
			mask.swapDepths(that.m_TextArea);
			mask.swapDepths(that.m_UserInputField);
			mask.swapDepths(that.m_CloseButton);
			mask.swapDepths(that.m_Dragpoint);
			mask.swapDepths(that.m_Title);
			mask.swapDepths(that.m_SkinParent);
			mask._x = that._x;
			mask._y = that._y;
			mask._alpha = 5000;
		}
		var cornerRadius:Number = 10;
		mask.beginFill(0x000000);
		mask.moveTo(cornerRadius, 0);
		mask.lineTo(that.m_Dragpoint._width - cornerRadius, 0);
		mask.curveTo(that.m_Dragpoint._width, 0, that.m_Dragpoint._width, cornerRadius);
		mask.lineTo(that.m_Dragpoint._width, cornerRadius);
		mask.lineTo(that.m_Dragpoint._width, that.m_Dragpoint._height - cornerRadius);
		mask.curveTo(that.m_Dragpoint._width, that.m_Dragpoint._height, that.m_Dragpoint._width - cornerRadius, that.m_Dragpoint._height);
		mask.lineTo(that.m_Dragpoint._width - cornerRadius, that.m_Dragpoint._height);
		mask.lineTo(cornerRadius, that.m_Dragpoint._height);
		mask.curveTo(0, that.m_Dragpoint._height, 0, that.m_Dragpoint._height - cornerRadius);
		mask.lineTo(0, that.m_Dragpoint._height - cornerRadius);
		mask.lineTo(0, cornerRadius);
		mask.curveTo(0, 0, cornerRadius, 0);
		mask.lineTo(cornerRadius, 0);
		mask.endFill();

		if (that["mask3"]) {
			mask = that.mask3;
			mask.clear();
		} else {
			mask = that.createEmptyMovieClip("mask3", that.getNextHighestDepth());
			mask.swapDepths(that.m_TextArea);
			mask.swapDepths(that.m_UserInputField);
			mask.swapDepths(that.m_CloseButton);
			mask.swapDepths(that.m_Dragpoint);
			mask.swapDepths(that.m_Title);
			mask.swapDepths(that.m_SkinParent);
			mask._x = that.m_TextArea._x;
			mask._y = that.m_TextArea._y;
			mask._alpha = 4000;
		}
		mask.beginFill(0x000000);
		mask.moveTo(-5, -5);
		mask.lineTo(that.m_TextArea.m_Background._width + 5, -5);
		mask.lineTo(that.m_TextArea.m_Background._width + 5, that.m_TextArea.m_Background._height + 10);
		mask.lineTo(-5, that.m_TextArea.m_Background._height + 10);
		mask.lineTo(-5, -5);
		mask.endFill();
		mask.beginFill(0x111111);
		mask.moveTo(-5, that.m_TextArea.m_Background._height + 10);
		mask.lineTo(that.m_TextArea.m_Background._width + 5, that.m_TextArea.m_Background._height + 10);
		mask.lineTo(that.m_TextArea.m_Background._width + 5, that.m_TextArea.m_Background._height + 50);
		mask.lineTo(-5, that.m_TextArea.m_Background._height + 50);
		mask.lineTo(-5, that.m_TextArea.m_Background._height + 10);
		mask.endFill();
		mask.lineStyle(1, 0xDDDDDD, 5000);
		mask.moveTo(-6, -6);
		mask.lineTo(that.m_TextArea.m_Background._width + 5, -6);
		mask.lineTo(that.m_TextArea.m_Background._width + 5, that.m_TextArea.m_Background._height + 50);
		mask.lineTo(-6, that.m_TextArea.m_Background._height + 50);
		mask.lineTo(-6, -6);
		
		if (m_GHOSTTabletLayout.GetValue() != "Default")
			doLayout(m_GHOSTTabletLayout.GetValue());

		that.CheckTextArea();
	}

}

function OnKeyDown()
{
    var that = _root.computerpuzzle.m_ComputerInterfaceWindow;
	if (that != undefined) {
		var scanCode:Number = Key.getCode();
		if (Key.isDown(18)) {
			var layout:String = "";
			if (scanCode == 81)
				that.CloseComputerPuzzle();
			else if (scanCode == 82) //R
				ComputerPuzzleIF.AcceptPlayerInput("root");
			else if (scanCode == 72) //H
				ComputerPuzzleIF.AcceptPlayerInput("help");
			else if (scanCode == 68) //D
				doLayout(that.DRAGON_SKIN);
			else if (scanCode == 73) //I
				doLayout(that.ILLUMINATI_SKIN);
			else if (scanCode == 84) //T
				doLayout(that.TEMPLARS_SKIN);
			//else if (scanCode == 86) //V
			//	doLayout(that.VALENTINE_SKIN); //Broken - m_Logo doesn't exist
			else if (scanCode == 78) //N
				doLayout("Default");
			else if (scanCode == 33) //PgUp
				changeLines(-1);
			else if (scanCode == 34) //PgDn
				changeLines(1);
		} else if (scanCode == 33) { //PgUp
			if (!that.m_TextArea.m_TopArrow.disabled) {
				that.m_TextArea.textField._y += m_Height;
				that.CheckTextArea();
			}
		} else if (scanCode == 34) { //PgDn
			if (!that.m_TextArea.m_BottomArrow.disabled) {
				that.m_TextArea.textField._y -= m_Height;
				that.CheckTextArea();
			}
		}
		m_OnKeyDown();
	}
}

function changeLines(lines:Number):Void
{
	var newLines:Number = parseInt(m_GHOSTTabletExtraLines.GetValue(),10) + lines;
	if (newLines < -10) newLines = -10;
	if (newLines > 50) newLines = 50;
	m_GHOSTTabletExtraLines.SetValue(""+newLines);
	Resize();
}

function doLayout(layout:String):Void
{
    var that = _root.computerpuzzle.m_ComputerInterfaceWindow;
	if (that != undefined) {
		if (that.m_SkinParent.m_Skin)
		{
			that.m_SkinParent.m_Skin.removeMovieClip();
		}
		that.SetLayout(layout);
		
		if (layout != "Default")  {
			if (that.m_SkinParent.m_Skin.m_LayoutLoader.m_illuminatiBg) {
				that.m_SkinParent.m_Skin.m_LayoutLoader.m_illuminatiBg.m_Logo._alpha = 1;
				if (m_Height > 205)
					that.m_SkinParent.m_Skin.attachMovie("BackgroundIlluminati", "m_Logo", that.m_SkinParent.m_Skin.getNextHighestDepth());
			} else if (that.m_SkinParent.m_Skin.m_LayoutLoader.m_templarsBg) {
				that.m_SkinParent.m_Skin.m_LayoutLoader.m_templarsBg.m_Logo._alpha = 1;
				if (m_Height > 205)
					that.m_SkinParent.m_Skin.attachMovie("BackgroundTemplars", "m_Logo", that.m_SkinParent.m_Skin.getNextHighestDepth());
			} else if (that.m_SkinParent.m_Skin.m_LayoutLoader.m_dragonBg) {
				that.m_SkinParent.m_Skin.m_LayoutLoader.m_dragonBg.m_Logo._alpha = 1;
				if (m_Height > 205)
					that.m_SkinParent.m_Skin.attachMovie("BackgroundDragon", "m_Logo", that.m_SkinParent.m_Skin.getNextHighestDepth());
			}
			if (that.m_SkinParent.m_Skin.m_Logo) {
				that.m_SkinParent.m_Skin.m_Logo._alpha = 1;
				if (m_Height > 345) {
					that.m_SkinParent.m_Skin.m_Logo._x = -115;
					that.m_SkinParent.m_Skin.m_Logo._y = (m_Height - 315) / 2;
					that.m_SkinParent.m_Skin.m_Logo._yscale = 150;
					that.m_SkinParent.m_Skin.m_Logo._xscale = 150;
					that.m_SkinParent.m_Skin.m_Logo.m_Logo._alpha = 200000;
				} else {
					that.m_SkinParent.m_Skin.m_Logo._x = 0;
					that.m_SkinParent.m_Skin.m_Logo._y = (m_Height - 170) / 2;
					that.m_SkinParent.m_Skin.m_Logo._yscale = 100;
					that.m_SkinParent.m_Skin.m_Logo._xscale = 100;
					that.m_SkinParent.m_Skin.m_Logo.m_Logo._alpha = 200000;
				}				
			}
		}
		
		that.m_SkinParent.m_Skin._alpha = 1;
		that.m_SkinParent.m_Skin.m_LayoutLoader._alpha = 5000;
		that.m_SkinParent.m_Skin.m_LayoutLoader._height = m_Height + 54;
		
		m_GHOSTTabletLayout.SetValue(layout);
	}
}
