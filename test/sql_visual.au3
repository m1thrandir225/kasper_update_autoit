#region ---Head--
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <WindowsConstants.au3>

#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>

Global $hGUI,$ime_input,$lokacija_input,$id_input,$ime,$Lokacija,$Id,$Cancel,$Continue
create_form()
#endregion ---Head---

#region --- Form ---

func create_form()
$hGUI=GuiCreate("MyGUI", 350, 200, -1, -1, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_VISIBLE + $WS_CLIPSIBLINGS + $WS_MINIMIZEBOX)

$ime_input = GuiCtrlCreateInput("", 10, 20, 200, 30,-1)
$lokacija_input = GuiCtrlCreateInput("", 10, 70, 200, 30,-1)
$id_input = GuiCtrlCreateInput("", 10, 120, 200, 30,-1)
$ime = GuiCtrlCreateLabel("Vnesi Ime", 220, 30, 120, 20,-1)
$Lokacija = GuiCtrlCreateLabel("Vnesi Lokacija", 220, 80, 120, 20,-1)
$Id = GuiCtrlCreateLabel("Vnesi ID", 220, 130, 120, 20,-1)
$Cancel = GuiCtrlCreateButton("Cancel", 20, 170, 70, 20,-1)
$Continue = GuiCtrlCreateButton("Continue", 260, 170, 70, 20,-1)

GuiSetState()
endfunc
#EndRegion --- Form ---

#region --- Loop ---
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
WEnd
#Endregion --- Loop ---

#Region --- Additional Functions ---
#Endregion --- Additional Functions ---

Exit

