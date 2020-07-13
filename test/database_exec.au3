#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <ComboConstants.au3>
#include <GuiListView.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>

local $hQuery, $aRow, $aData, $iRival, $aResult, $iColumns

$ime_input = InputBox("", "vnesi ime")
GUICreate("", 600, 500)
$listView = GUICtrlCreateListView("", 2, 2, 590, 490)
GUISetState(@SW_SHOW)

_GUICtrlListView_AddColumn($listView, "")
_GUICtrlListView_AddColumn($listView, "", 70)
_GUICtrlListView_AddColumn($listView, "", 100)
_GUICtrlListView_AddColumn($listView, "")
_GUICtrlListView_AddColumn($listView, "")
_GUICtrlListView_AddColumn($listView, "")
_GUICtrlListView_AddColumn($listView, "")
_GUICtrlListView_AddColumn($listView, "")
_GUICtrlListView_AddColumn($listView, "", 100)

_SQLite_Startup()
ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)
if @error Then
    MsgBox($MB_SYSTEMMODAL, "SQLite Error", "DLL ERROR")
    Exit -1
EndIf
$sqDB = _SQLite_Open("firmi_python.db")
if @error Then
    MsgBox($MB_SYSTEMMODAL, "Sqlite erorr", "cant load db")
    Exit -1
EndIf
$iRival = _SQLite_GetTable2d($sqDB, "SELECT * FROM firmiD WHERE IME=" & _SQLite_FastEscape($ime_input) &" ORDER BY RB", $aResult, $aRow, $iColumns)
_GUICtrlListView_AddArray($listView, $aResult)
_SQLite_Close()
_SQLite_Shutdown()

Do
    Sleep(250)
Until GUIGetMsg() = $GUI_EVENT_CLOSE
