;-------------------------------------------------------------------------------
;	GENERAL SETTINGS
;-------------------------------------------------------------------------------

#NoEnv
#SingleInstance force
;#InstallKeybdHook
;#InstallMouseHook
#include IniLib1.0.ahk
SetBatchLines -1




;SetWorkingDir %A_ScriptDir%
;ScriptName := A_ScriptName
;StringReplace, ScriptName, ScriptName, .ahk,, All0
;StringReplace, ScriptName, ScriptName, .exe,, All

;-------------------------------------------------------------------------------
;	Vars
;-------------------------------------------------------------------------------
Tap = 0
SH = 1
pixelx = 0
pixely= 0
rpm = 1550
NoRecoil = 0
enough = 0
;xhair = 00

; X shots before to go Left/Right
SHDown = Ins
SHUP = Home
;Pixels up/down/left/right
PixelUp = pgup
PixelDown = pgdn
PixelLeft = del
PixelRight = end
;On/OFF
ToggleNoRecoil = NumpadMult
;RPM
DelayUp = NumpadAdd
DelayDown = NumpadSub
;Save and Load Function
GetFromIni = Numpad0
MoveY = LButton




;-------------------------------------------------------------------------------
;	Hotkeys
;-------------------------------------------------------------------------------
Hotkey, ~*$%SHDown%, DoSHDown
Hotkey, ~*$%SHUp%, DoSHUp
Hotkey, ~*$%PixelLeft%, DoPixelLeft
Hotkey, ~*$%PixelRight%, DoPixelRight
Hotkey, ~*$%PixelUp%, DoPixelUp
Hotkey, ~*$%PixelDown%, DoPixelDown
HotKey, ~*$%ToggleNoRecoil%, DoToggleNoRecoil
HotKey, ~*$%DelayUp%, DoDelayUp
HotKey, ~*$%DelayDown%, DoDelayDown
HotKey, ~*$%GetFromIni%, GetFromINI
#MaxThreadsPerHotkey 1
Hotkey, ~*$%MoveY%, DoMoveY



;-------------------------------------------------------------------------------
;	Functions
;-------------------------------------------------------------------------------


TipRPS(PopupText)
{
	Gui, Destroy
	Gui, +AlwaysOnTop +ToolWindow -SysMenu -Caption
	Gui, Color, 000000
	WinSet, Transparent, 100
	Gui, Font, s8, norm, Verdana
	Gui, Add, Text, x5 y5 c00ff00, %PopupText%
	Gui, Show, NoActivate X0 Y36
}

TipOn(PopupText)
{   
	Gui, Destroy
	Gui, +AlwaysOnTop +ToolWindow -SysMenu -Caption
	Gui, Color, 000000
	WinSet, Transparent, 100
	Gui, Font, s8, norm, Verdana
	Gui, Add, Text, x5 y5 c00ff00, %PopupText%
	Gui, Show, NoActivate X0 Y18
}

TipOff(PopupText)
{
	Gui, Destroy 
	Gui, +AlwaysOnTop +ToolWindow -SysMenu -Caption
	Gui, Color, 000000
	WinSet, Transparent, 100
	Gui, Font, s8, norm, Verdana
	Gui, Add, Text, x5 y5 cff0000, %PopupText%
	Gui, Show, NoActivate X0 Y54
}


TipClear:
{
SetTimer,TipClear, 2000
Gui, destroy
}
return

;-------------------------------------------------------------------------------
;	Hotkey labels
;-------------------------------------------------------------------------------
Numpad6::
If Tap = 0
{
	Tap +=1
	TipOn("Tap  = ON")
}
else
{
	Tap -= 1
	TipOn("Tap  = OFF")
}
return

DoToggleNoRecoil:
	if NoRecoil < 1
	{
		NoRecoil += 1
		if NoRecoil = 1
		{
			SoundBeep, 800, 200
			TipOn("ON")
		}
	}
	else
	{
		NoRecoil := 0
		SoundBeep, 200, 100
		SoundBeep, 200, 100
		TipOff("OFF")
	}
	return
DoSHDown:
        If SH > 1
			SH -= 1
		SHK = 0
		TipOn("SH  = " SH)
		return
		
DoSHUp:
        If SH <20
			SH += 1
		SHK = 0
		TipOn("SH  = " SH)
		return
		
DoPixelLeft:
        if pixelx < 10
                 pixelx += 1
        TipOn("Pixel X Is " pixelX)
        return

DoPixelRight:
        if pixelx > -10
                 pixelx -= 1
        TipOn("Pixel X Is " pixelX)
        return

DoPixelUp:
	if pixely < 50
		pixely += 1
	TipOn("Pixel Y Is " pixelY)
	return

DoPixelDown:
	if pixely > 0
		pixely -= 1
	TipOn("Pixel Y Is " pixelY)
	return

DoDelayUp:
	if rpm > 400
		rpm -= 10
	TipRPS("RPM: " rpm "  " "RPS:" f(rpm)) 
	return

DoDelayDown:
	if rpm < 4000
		rpm += 10
	TipRPS("RPM: " rpm "  " "RPS:" f(rpm))
	return

DoPeriodUp:
	if period > 100
		period -= 100
	TipOn("PERIOD IS " period)
	return

DoPeriodDown:
	if period < 6000
		period += 100
	TipOn("PERIOD IS " period)
	return


;----------------------------------------------SAVE, LOAD, DELETE, FUNC-------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------
;Pulls up Listview of Saved Weapon for easy picking.
GetFromINI:
Gui, Destroy
SetTimer, TipClear, Off
FileRead, ini, config.ini
; Create the ListView with 4 columns:0
gui, add, text, section, Save To INI
Gui, Add, Edit, r1 vWeaponSend
Gui, Add, Button, gSaveToIni, Save
Gui, Add, Button, gDelete, Delete
gui, add, text, section, Double Click Below to LOAD from INI0
Gui, Add, ListView, r20 h200 w300 gMyListView, Name|SH|X|Y|RPM|TAP

sections := ini_getAllSectionNames(ini)
Loop, Parse, sections, `,
{
    LV_Add("", A_LoopField, ini_getValue(ini, A_LoopField, "SH"),ini_getValue(ini, A_LoopField, "X"),ini_getValue(ini,A_LoopField, "Y"), ini_getValue(ini, A_LoopField, "rpm"), ini_GetValue(ini, A_LoopField, "TAP"))
}

LV_ModifyCol(20)  ; Auto-size each column to fit its contents.
LV_ModifyCol()  ; For sorting purposes.

; Display the window and return. The script will be notified whenever the user double clicks a row.
Gui, Show
return

Delete:
RowNumber = 0  ; This causes the first loop iteration to start the search at the top of the list.
Loop
{
    RowNumber := LV_GetNext(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    LV_GetText(Delete, RowNumber)
	IniDelete, %A_WorkingDir%\config.ini, %Delete%
	Gosub, GetFromIni
}

MyListView:
if A_GuiEvent = DoubleClick
{
	LV_GetText(WeaponCall, A_EventInfo)
    LV_GetText(SH, A_EventInfo, 2)  ; Get the text from the row's first field.
    LV_GetText(pixelx, A_EventInfo, 3)
    LV_GetText(pixely, A_EventInfo, 4)  
	LV_GetText(rpm, A_EventInfo, 5)
	LV_GetText(Tap, A_EventInfo, 6)
    TipRPS(" Loaded!!    Weapon : " WeaponCall " " "Y : "pixely "  " "X : "pixelx "  "  "RPM : " rpm "  "" SH" "  " SH " "" TAP" TAP) 
}


SaveToINI:   
{
	Gui,Submit, Nohide0
IniDelete, %A_WorkingDir%\config.ini, %WeaponSend%
IniWrite,%SH%,%A_WorkingDir%\config.ini,%WeaponSend%,SH
IniWrite,%pixely%,%A_WorkingDir%\config.ini,%WeaponSend%,Y
IniWrite,%pixelx%,%A_WorkingDir%\config.ini,%WeaponSend%,X
IniWrite,%rpm%,%A_WorkingDir%\config.ini,%WeaponSend%,rpm
IniWrite,%TAP%,%A_WorkingDir%\config.ini,%WeaponSend%, Tap
TipRPS(" Saved!!    Weapon :" WeaponSend " " "Y :" pixely "  " "X : " pixelx "  "  "RPM :" rpm "  ""SH" "  " SH " " "TAP" TAP)
}


GuiClose:
Settimer, TipClear, 2000
return
;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------

DoMoveY: 
	if NoRecoil = 1	
		{
			GetKeyState, state, RButton, P ; RButton must me held down to use the LButton(Mouse)
			if state = U
				return
				loop 
				{
					GetKeyState, state2, LButton, P
					if state2 = U
					    return
					    {
						Clicks = 0	
						if Tap = 1
						{
					       MouseClick, Left,,,,,D
						   SetMouseDelay, f(rpm)
						   MouseClick, Left,,,,,U
					   }
						     DllCall("mouse_event", "uint",1 , "Uint", 0,"Uint", pixely)
                             SHK += 1
						     { 
						     If SH = %SHK% ; If equals then x
							{
						     SHK := 0 ; Resets Counter
						     DllCall("mouse_event", "uint",1 , "Uint", pixelx,"Uint", 0)						
					         }
						     if Tap = 1
						     {
							sleep, 1
						    }
						    else
						    {					       
					        sleep, f(rpm)
						    }
							tooltip, %sleep%,0,00
						}
					}
				}
			}
        
    

	


	return
 
	;-------------------------------interval per shot in Miliseconds----------------------------------------
 
 f(n)
					   {
						   Return Round(60000/n)
						  
					   }
return