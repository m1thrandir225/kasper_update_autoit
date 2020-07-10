#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <MsgBoxConstants.au3>
local $quer, $row, $msg
$ime_na_firma = InputBox("Ime", "Vnesi ime na firma")
$lokacija = InputBox("Lokacija", "Vnesi lokacija na firma")
_SQLite_Startup()
_SQLite_Open("C:\Users\HP\Desktop\autotit\kasper_update\firmi_python.db")
$msg = _SQLite_Query(-1, "SELECT * FROM firmi WHERE IME LIKE %" & $ime_na_firma & "%", $quer)
MsgBox($MB_SYSTEMMODAL, "data", $msg)
_SQLite_Close()
_SQLite_Shutdown()