#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <ComboConstants.au3>
#include <GuiListView.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <GUIConstantsEx.au3>

local $hQuery, $aRow, $aData
$ime_input = InputBox("Ime na Firma", "Vnesi ime na firma")
$lokacija_input = InputBox("Lokacija na Firma", "Vnesi lokacija na firma")
$id_input = InputBox("ID na Firma", "Vnesi ID na firma")

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
_SQLite_QuerySingleRow($sqDB, 'SELECT * FROM firmiD WHERE IME=' & _SQLite_FastEscape($ime_input) & ' AND LOKACIJA=' & _SQLite_FastEscape($lokacija_input) & ' AND RB=' & _SQLite_FastEscape($id_input) & ' ORDER BY RB', $aRow)
_SQLite_Close()
_SQLite_Shutdown()
$firma_id = $aRow[0]
$server = $aRow[3]
$database = $aRow[4]
$ecus = $aRow[5]
$user = $aRow[6]
$pass = $aRow[7]

ConsoleWrite(StringFormat(" %-10s %-10s %-10s %-10s %-10s", $server, $database, $ecus, $user, $pass))