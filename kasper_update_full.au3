#include <InetConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIfiles.au3>
#include <ProgressConstants.au3>
#include <_Zip.au3>
#include <Date.au3>
#include <StaticConstants.au3>
#include <Crypt.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <Array.au3>
#include <GuiListView.au3>
#include <ColorConstants.au3>
#RequireAdmin

AutoItSetOption("MouseCoordMode", 0)
Opt("GUIOnEventMode", 1)


Global $default, $custom, $error= "", $input_pass, $password_hash = "0xd963fed62548da73b5012d620baba790d75afd79daeb24b5f7ea4d2012db67c6", $hQuerry, $aRow, $aData, $iRival, $aResult, $iColumns,  $firma_id, $server_firma, $firma_db, $ecus_firma, $user_firma, $pass_firma, $firma_mesto, $firma_ime
Global $progressbar = GUICtrlCreateProgress(20, 320, 200, 20, $PBS_SMOOTH)
Global $kasper_gui = GUICreate("Kasper Update", 600, 400)
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")
GUICtrlCreateLabel("Kasper Update Software", 230, 15, 200, 50)
GUICtrlSetFont(-1, 10, 900, 4, "Segoe UI", 0)
GUICtrlCreateLabel("© Sebastijan Zindl", 490, 380, 150, 100)
GUICtrlSetFont(-1, 8.5, 700, 0, "Segoe UI", 0)

GUICtrlCreateButton("KASPER_CDEP-UPDATES", 25, 50, 125, 50)
GUICtrlSetOnEvent(-1, "downloadUpdate")
GUICtrlSetFont(-1, 7, 700, 0, "Segoe UI", 0)

GUICtrlCreateButton("KASPER_CDEPS_Install", 225, 50, 125, 50)
GUICtrlSetOnEvent(-1, "downloadInstall")
GUICtrlSetFont(-1, 7.5, 700, 0, "Segoe UI", 0)

GUICtrlCreateButton("Tarifa", 425, 50, 75, 50)
GUICtrlSetOnEvent(-1, "downloadTarifa")
GUICtrlSetFont(-1, 9, 700, 0, "Segoe UI", 0)

GUICtrlCreateButton("SQL Update", 500, 50, 75, 50)
GUICtrlSetOnEvent(-1, "downloadSQL")
GUICtrlSetFont(-1, 9, 700, 0, "Segoe UI", 0)

GUICtrlCreateButton("Kasper Database Update", 130, 130, 150, 50)
GUICtrlSetOnEvent(-1, "kasper_database_moving")
GUICtrlSetFont(-1, 7.5, 500, 0, "Segoe UI", 0)


GUICtrlCreateButton("Mestenje Printeri", 330, 130, 150, 50)
GUICtrlSetOnEvent(-1, "printer_mestenje")
GUICtrlSetFont(-1, 9, 500, 0, "Segoe UI", 0)

GUICtrlCreateButton("404 nedovrseno", 50, 230, 150, 50)
GUICtrlSetOnEvent(-1, "upcoming")
GUICtrlSetFont(-1, 9, 500, 0, "Segoe UI", 0)

GUICtrlCreateButton("Initialize Database", 400, 230, 150, 50)
GUICtrlSetOnEvent(-1, "initializeDatabase")
GUICtrlSetFont(-1, 9, 500, 0, "Segoe UI", 0)

GUICtrlCreateLabel("V1.0.4", 15, 380, 50, 50)
GUICtrlSetFont(-1, 9, 500, 0, "Segoe UI", 0)
GUISetState(@SW_HIDE)

$id_na_firma_label = GuiCtrlCreateLabel("", 20, 330, 140, 20,-1)
GUiCTRLSETBkColor(-1, $COLOR_MEDGRAY)
GUICtrlSetColor(-1, $COLOR_WHITE)
$ime_na_firma_label = GuiCtrlCreateLabel("", 170, 330, 140, 20,-1)
GUiCTRLSETBkColor(-1, $COLOR_MEDGRAY)
GUICtrlSetColor(-1, $COLOR_WHITE)
$lokacija_na_firma_label = GuiCtrlCreateLabel("", 320, 330, 140, 20,-1)
GUiCTRLSETBkColor(-1, $COLOR_MEDGRAY)
GUICtrlSetColor(-1, $COLOR_WHITE)
$server_na_firma_label = GuiCtrlCreateLabel("", 470, 330, 140, 20,-1)
GUiCTRLSETBkColor(-1, $COLOR_MEDGRAY)
GUICtrlSetColor(-1, $COLOR_WHITE)
$db_na_firma_label = GuiCtrlCreateLabel("", 160, 380, 140, 20,-1)
GUiCTRLSETBkColor(-1, $COLOR_MEDGRAY)
GUICtrlSetColor(-1, $COLOR_WHITE)
$ecus_na_firma_label = GuiCtrlCreateLabel("", 320, 380, 140, 20,-1)
GUiCTRLSETBkColor(-1, $COLOR_MEDGRAY)
GUICtrlSetColor(-1, $COLOR_WHITE)
Global $login_form = GUICreate("Login", 257, 115, -1, -1)

;sql_gui
Global $sql_info = GUICreate("Informacii za firma", 500, 400, -1, -1)
Global $ime_input = GuiCtrlCreateInput("", 10, 20, 270, 40,-1)
Global $id_input = GuiCtrlCreateInput("", 10, 100, 270, 40,-1)
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")
$ime = GuiCtrlCreateLabel("Vnesi ime na firma", 310, 30, 170, 30,-1)
$Id = GuiCtrlCreateLabel("Vnesi ID na firma", 310, 110, 170, 30,-1)
$Search = GuiCtrlCreateButton("Search", 10, 160, 70, 30,-1)
GUICtrlSetOnEvent(-1, "sql_search")
$Clear = GuiCtrlCreateButton("Clear", 80, 160, 70, 30,-1)
GUICtrlSetOnEvent(-1, "clear")
$Continue = GuiCtrlCreateButton("Continue", 410, 160, 70, 30,-1)
GUICtrlSetOnEvent(-1, "sql_continue")
global $listView = GUICtrlCreateListView("", 0, 205, 500, 205)
_GUICtrlListView_AddColumn($listView, "")
_GUICtrlListView_AddColumn($listView, "", 150)
_GUICtrlListView_AddColumn($listView, "", 70)
_GUICtrlListView_AddColumn($listView, "", 150)
_GUICtrlListView_AddColumn($listView, "")
_GUICtrlListView_AddColumn($listView, "")
_GUICtrlListView_AddColumn($listView, "")
_GUICtrlListView_AddColumn($listView, "")
_GUICtrlListView_AddColumn($listView, "", 100)
GUISetState(@SW_HIDE, $sql_info)
downloadDatabase()

Func downloadInstall()
	$downloadPathInstall = "C:\CDEPS\Sql\CDEPS.zip"
	$downloadInstallURL = "https://www.dropbox.com/sh/2nrqzzb1a204que/AAAyH39uDmtAhWIwEvP063yxa?dl=1"
	$downloadInstall = InetGet($downloadInstallURL, $downloadPathInstall, 1, 1)
	$downloadInstallSize = InetGetSize($downloadInstallURL)
	ProgressOn("Downloading CDEPS Instalation", "The CDEPS Install is downloading", "please wait")
	While Not InetGetInfo($downloadInstall, 2)
		Sleep(500)
		$downloadInstallBytesRecieved = InetGetInfo($downloadInstall, 0)
		$pctInstall = Int(($downloadInstallBytesRecieved / $downloadInstallSize) * 100)
		ProgressSet($pctInstall, $pctInstall & "%")
	WEnd
	ProgressOff()
	$zipInstall = "C:\CDEPS\Sql\CDEPS.zip"
	$createnew = DirCreate("C:\Windows\Temp\CDEPS")
	$unzipDestination = ("C:\Windows\Temp\CDEPS")
	$iFlag = 16 + 256
	_Zip_UnzipAll($zipInstall, $unzipDestination, $iFlag)
	$deleteOriginalInstall = FileDelete($downloadPathInstall)
	InetClose($downloadInstall)
	DirMove($unzipDestination, "C:\", $FC_OVERWRITE)

	ShellExecute("C:\CDEPS\ReceiveTimeout.reg")
	Sleep(1000)
	Send("{ENTER}")
	Sleep(1000)
	Send("{ENTER}")

	ShellExecute("C:\CDEPS\Reg.reg")
	Sleep(1000)
	Send("{ENTER}")
	Sleep(1000)
	Send("{ENTER}")

	ShellExecute("C:\CDEPS\Fonts\Code-39-Logitogo.ttf")
	Sleep(1000)
	MouseClick("left", 164, 55)
	Sleep(1000)
	Send("{LEFT}")
	Sleep(1000)
	Send("{ENTER}")
	WinClose("Code-39-Logitogo (TrueType) ")
	MsgBox($MB_SYSTEMMODAL, "Installed Sucesfully", "Novata CDEPS verzija e instalirana", 5)

EndFunc   ;==>downloadInstall

Func downloadUpdate()
	$downloadPathUpdate = "C:\CDEPS\Sql\CDEPS_CLIENT-UPDATES.zip"
	$downloadUpdateURL = "https://www.dropbox.com/sh/a4yxotggghg4bsf/AAAOE2G0U8wDTpxykNNwpIu-a?dl=1"
	$downloadUpdate = InetGet($downloadUpdateURL, $downloadPathUpdate, 1, 1)
	$downloadUpdateSize = InetGetSize($downloadUpdateURL)
	ProgressOn("Downloading Kasper Update", "The Kasper Update is downloading", "please wait")
	While Not InetGetInfo($downloadUpdate, 2)
		Sleep(500)
		$downloadUpdateBytesRecieved = InetGetInfo($downloadUpdate, 0)
		$pctUpdate = Int(($downloadUpdateBytesRecieved / $downloadUpdateSize) * 100)
		ProgressSet($pctUpdate, $pctUpdate & "%")
	WEnd
	ProgressOff()
	;ZIP unpacking
	$zipUpdate = "C:\CDEPS\Sql\CDEPS_CLIENT-UPDATES.zip"
	$unzipDestination = "C:\CDEPS\Sql\"
	$iFlag = 16 + 256
	$unzipUpdate = _Zip_UnzipAll($zipUpdate, $unzipDestination, $iFlag)
	$deleteOriginalUpdate = FileDelete($downloadPathUpdate)
	MsgBox($MB_OK, "Unzipping Complete", "CDEPS_CLIENT-UPDATES has been sucesfully unzipped")
	InetClose($downloadUpdate)
EndFunc   ;==>downloadUpdate

Func downloadTarifa()
	$downloadPathTarifa = "C:\CDEPS\Sql\TARIFA_UPDATES.zip"
	$downloadTarifaURL = "https://www.dropbox.com/sh/sypveyl5t1rjrjf/AAAV7nAZztNSLOwq9G4YSrUOa?dl=1"
	$downloadTarifa = InetGet($downloadTarifaURL, $downloadPathTarifa, 1, 1)
	$downloadTarifaSize = InetGetSize($downloadTarifaURL)
	ProgressOn("Downloading Tarifa", "The newest Tarifa is downloading", "please wait")
	While Not InetGetInfo($downloadTarifa, 2)
		Sleep(500)
		$downloadTarifaBytesRecieved = InetGetInfo($downloadTarifa, 0)
		$pctTarifa = Int(($downloadTarifaBytesRecieved / $downloadTarifaSize) * 100)
		ProgressSet($pctTarifa, $pctTarifa & "%")
	WEnd
	ProgressOff()
	$zipTarifa = "C:\CDEPS\Sql\TARIFA_UPDATES.zip"
	$unzipDestination = "C:\CDEPS\Sql\"
	$iFlag = 16 + 256
	$unzipUpdate = _Zip_UnzipAll($zipTarifa, $unzipDestination, $iFlag)
	$deleteoriginalTarifa = FileDelete($downloadPathTarifa)
	$deletePdf = FileDelete("C:\Cdeps\Sql\Instrukcii za instalacija na tarifa.pdf.pdf")
	MsgBox($MB_OK, "Unzipping Complete", "TARIFA_UPDATES has been sucesfully unzipped")
	InetClose($downloadTarifa)
EndFunc   ;==>downloadTarifa

Func downloadSQL()
	$downloadSQLPath = "C:\CDEPS\Sql\CDEPS_SERVER-UPDATES.zip"
	$downloadSQLURL = "https://www.dropbox.com/sh/5povta1r8a1v1yz/AADaFy3mLKphM7ykcInskB9Wa?dl=1"
	$downloadSQL = InetGet($downloadSQLURL, $downloadSQLPath, 1, 1)
	$downloadSQLSize = InetGetSize($downloadSQLURL)
	ProgressOn("Downloading SQL Update", "SQL Update is downloading", "please wait")
	While Not InetGetInfo($downloadSQL, 2)
		Sleep(500)
		$downloadSQLBytesRecieved = InetGetInfo($downloadSQL, 0)
		$pctSQL = Int(($downloadSQLBytesRecieved / $downloadSQLSize) * 100)
		ProgressSet($pctSQL, $pctSQL & "%")
	WEnd
	ProgressOff()
	$zipSQL = "C:\CDEPS\Sql\CDEPS_SERVER-UPDATES.zip"
	$unzipDestination = "C:\CDEPS\Sql\"
	$iFlag = 16 + 256
	$unzipSql = _Zip_UnzipAll($zipSQL, $unzipDestination, $iFlag)
	$deleteOriginalSQL = FileDelete($downloadSQLPath)
	MsgBox($MB_OK, "Complete", "Dowload and unzipping complete")
	InetClose($downloadSQL)
EndFunc   ;==>downloadSQL

func downloadDatabase()
	if (FileExists(@ScriptDir & "\firmi_python.db") and FileExists(@ScriptDir & "\sqlite3.dll")) Then
		login()
	Else
		DirCreate(@ScriptDir & "\temp\")
		$downloadDBPath = (@ScriptDir & "\temp\sql_db.zip")
		$downloadDLLPath = (@ScriptDir & "\temp\dll.zip")
		$downloadDLLURL = "https://www.sqlite.org/2020/sqlite-dll-win32-x86-3320300.zip"
		$downloadDBURL = "https://www.dropbox.com/sh/dkhcu4cn1aqoil1/AAB2ngBDa_I33uBHKux1o_O_a?dl=1"
		$downloadDB = InetGet($downloadDBURL, $downloadDBPath, 1, 1)
		$downloadDLL = InetGet($downloadDLLURL, $downloadDLLPath, 1, 1)
		$downloadDBSize = InetGetSize($downloadDBURL)
		$downloadDLLSize = InetGetSize($downloadDLLURL)
		ProgressOn("Downloading requirenments", "Pocekajte se simnuvaat potrebni fajlovi", "please wait")
		While Not InetGetInfo($downloadDB, 2)
			sleep(500)
			$downloadDBBytesRecieved = InetGetInfo($downloadDB, 0)
			$pctDB = Int(($downloadDBBytesRecieved/$downloadDBSize)*100)
			ProgressSet($pctDB, $pctDB & "%")
		WEnd
		While Not InetGetINfo($downloadDLL, 2)
			sleep(500)
			$downloadDLLBytesRecieved = InetGetInfo($downloadDLL, 0)
			$pctDLL = Int(($downloadDLLBytesRecieved/$downloadDLLSize)*100)
			ProgressSet($pctDLL, $pctDLL & "%")
		WEnd
		ProgressOff()
		$zipDLL = (@ScriptDir & "\temp\dll.zip")
		$zipDB =  (@ScriptDir &  "\temp\sql_db.zip")
		$unzipDestination = (@ScriptDir & "\temp\")
		$iFlag = 16 + 256
		$unzipDB = _Zip_UnzipAll($ZipDB, $unzipDestination, $iFlag)
		$unzipDLL = _Zip_UnzipAll($zipDLL, $unzipDestination, $iFlag)
		$deletezipDLL = FileDelete(@ScriptDir & "\temp\dll.zip")
		$deletezipRES = FileDelete(@ScriptDir & "\temp\sqlite3.def")
		$deletezipDB = FileDelete(@ScriptDir & "\temp\sql_db.zip")
		InetClose($downloadDB)
		$moveDLL = FileMove(@ScriptDir & "\temp\sqlite3.dll", @ScriptDir)
		$moveDB = FileMove(@ScriptDir & "\temp\firmi_python.db", @ScriptDir)
		$deleteTemp = DirRemove(@ScriptDir & "\temp")
		login()
	EndIf
EndFunc

Func SpecialEvents()
	Select
		Case @GUI_CtrlId = $GUI_EVENT_CLOSE
			$deleteDLL = FileDelete(@ScriptDir & "\sqlite3.dll")
			$hashDB = _Crypt_HashFile(@ScriptDir & "\firmi_python.db", $CALG_SHA_256)
			$deleteDB = FileDelete(@ScriptDir & "\firmi_python.db")
			Exit
		Case @GUI_CtrlId = $GUI_EVENT_MINIMIZE
		Case @GUI_CtrlId = $GUI_EVENT_RESTORE
	EndSelect
EndFunc   ;==>SpecialEvents

Func upcoming()
	MsgBox($MB_SYSTEMMODAL, "Error", "Nedovrseno seuste")
	ConsoleWrite(StringFormat(" %-10s %-10s %-10s %-10s %-10s %-10s", $firma_id, $server_firma, $firma_db, $ecus_firma, $user_firma, $pass_firma))
EndFunc   ;==>upcoming
Func kasper_database_moving()
	MsgBox($MB_OK, "Select Kasper Update", "Please select the newest downloaded kasper database")
	$selectedVersion = FileOpenDialog("Select KASPER_CDEP*****", "C:\CDEPS\Sql\", "All(*.*)", BitOR($FD_FILEMUSTEXIST, $FD_MULTISELECT))
	$updatedFileName = FileMove($selectedVersion, "C:\CDEPS\Sql\KASPER_CDEPS.mdb")

	MsgBox($MB_OK, "Select Current Kasper Database", "Please select the current kasper database")
	$currentVersion = FileOpenDialog("Select KASPER_CDEPS", "C:\CDEPS\", "All(*.*)", BitOR($FD_FILEMUSTEXIST, $FD_MULTISELECT))
	$date = String(_NowDate())
	$date_for_use = StringReplace($date, "/", "")
	$current_to_old = FileMove($currentVersion, "C:\CDEPS\old" & $date_for_use & "KASPER_CDEPS.mdb")
	MsgBox($MB_SYSTEMMODAL, "Current Database Name Change", "The Name of the current database has been changed so it can be updated.")

	$file = "C:\CDEPS\Sql\KASPER_CDEPS.mdb"
	$move_file = FileMove($file, "C:\CDEPS\KASPER_CDEPS.mdb")
	MsgBox($MB_OK, "Update Complete", "Databse Update has been completed")
EndFunc   ;==>kasper_database_moving


Func initializeDatabase()
	Opt("SendKeyDelay", 5)
	$date = String(_NowDate())
	$date_for_use = StringReplace($date, "/", "")
	AutoItSetOption("WinTitleMatchMode", 4)
	$open = ShellExecute("C:\CDEPS\KASPER_CDEPS.mdb")
	WinWaitNotActive(" КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
	sleep(1000)
	MouseClick("left")
	sleep(1000)
	MouseClick("left", 237, 78)
	WinWaitActive("ПОТВРДЕТЕ")
	Send("{ENTER}")
	Sleep(1000)
	Send("old" & $date_for_use & "KASPER_CDEPS.mdb")
	Send("{ENTER}")
	WinWaitNotActive(" КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
	Sleep(1000)
	MouseClick("left", 200, 183)
	Sleep(1000)
	Send("{BACKSPACE 50}")
	Send($server_firma)
	Send("{ENTER}")
	Send("{ENTER}")
	Send("{BACKSPACE 50}")
	Send($firma_db)
	Send("{ENTER}")
	Send("{BACKSPACE 50}")
	Send($user_firma)
	Send("{ENTER}")
	Send("{BACKSPACE 50}")
	Send($pass_firma)
	Sleep(10000)
	Send("{ENTER}")
	send("{BACKSPACE 50}")
	send($firma_id)
	Send("{TAB}")
	Sleep(1000)
	MouseClick("left", 241, 450)
	Sleep(10000)
	MouseClick("left", 51, 43)
	Sleep(1000)
	MouseClick("left", 246, 657, 5)
	Sleep(1000)
	MouseClick("left", 253, 2)
	WinClose("КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
EndFunc   ;==>initializeDatabase

Func printer_mestenje()
	Opt("SendKeyDelay", 5)
	$username = InputBox("Korisnicko ime", "Vnesi korisnicko ime")
	If ($username = "") Then
		MsgBox($MB_SYSTEMMODAL, "Error", "Ne vnesovte korisnicko ime")
		Exit
	EndIf
	$password = InputBox("Password", "Vnesi password")
	If ($password = "") Then
		MsgBox($MB_SYSTEMMODAL, "Error", "Ne vnesovte password")
		Exit
	EndIf
	$open = ShellExecute("C:\CDEPS\KASPER_CDEPS.mdb")
	Sleep(1000)
	WinWaitNotActive(" КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
	MouseClick("left", 172, 328)
	Send("{BACKSPACE 50}")
	Send($username)
	Sleep(1000)
	Send("{ENTER}")
	Send("{BACKSPACE 50}")
	Sleep(1000)
	Send($password)
	Send("{ENTER 2}")
	Sleep(10000)
	Do
		Sleep(250)
	Until WinWaitNotActive("Vegesa Poraki")
	Sleep(250)
	MouseClick("left", 194, 42)
	Sleep(1000)
	MouseClick("left", 250, 57)
	Sleep(1000)
EndFunc   ;==>printer_mestenje

Func LoginClick()
	$read_pass = GUICtrlRead($input_pass)
	$hash_read = _Crypt_HashData($read_pass, $CALG_SHA_256)
	$password_upper = StringUpper($password_hash)
	If $hash_read = $password_upper Then
		MsgBox(0, "Access Granted", "The password is correct", 5)
		Sleep(1000)
		GUISetState(@SW_HIDE, $login_form)
		GUISetState(@SW_SHOW, $sql_info)
		sleep(100)
		WinActivate("Informacii za firma")
	Else
		MsgBox($MB_RETRYCANCEL, "Access Denied", "Password is incorrect", 5)
	EndIf
EndFunc   ;==>LoginClick

Func login()
	Opt("GUIOnEventMode", 1)
	$login_form = GUICreate("Login", 257, 115, -1, -1)
	$input_pass = GUICtrlCreateInput("", 16, 16, 225, 21, $ES_PASSWORD)
	GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
	GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")

	GUICtrlCreateButton("Login", 192, 80, 50, 25, 0)
	GUICtrlSetOnEvent(-1, "LoginClick")
	GUICtrlCreateButton("Cancel", 16, 80, 50, 25, 0)
	GUICtrlSetOnEvent(-1, "SpecialEvents")

	GUISetState(@SW_SHOW)
	While 1
		Sleep(250)
	WEnd
EndFunc   ;==>login
func sql_search()
	$read_ime = GUiCtrlRead($ime_input)
	$read_id = GUICtrlRead($id_input)
	if $read_ime = "" And $read_id= "" Then
		MsgBox($MB_RETRYCANCEL, "Error", "Nema dovolno parametrni za prebaruvanje")
	ElseIf $read_ime="" Then
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
		$iRival = _SQLite_GetTable2d($sqDB, "SELECT * FROM firmiD WHERE RB=" & _SQLite_FastEscape($read_id) &" ORDER BY RB", $aResult, $aRow, $iColumns)
		_GUICtrlListView_AddArray($listView, $aResult)
		_SQLite_Close()
		_SQLite_Shutdown()
	ElseIf $read_id="" Then
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
		$iRival = _SQLite_GetTable2d($sqDB, "SELECT * FROM firmiD WHERE IME=" & _SQLite_FastEscape($read_ime) &" ORDER BY RB", $aResult, $aRow, $iColumns)
		_GUICtrlListView_AddArray($listView, $aResult)
		_SQLite_Close()
		_SQLite_Shutdown()
	Else
		MsgBox($MB_RETRYCANCEL, "Error", "Nemoze prebaruvanje so 2 parametri")
	EndIf
EndFunc
func sql_continue() 
	$ime_read = GUICtrlRead($ime_input)
	$id_read = GUICtrlRead($id_input)
	if $id_read = ""  Then
		MsgBox($MB_RETRYCANCEL,  "Error", "Ne vnesovte ID")
	ElseIf $ime_read="" Then
		_SQLite_Startup()
		ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)
		if @error Then
			MsgBox($MB_SYSTEMMODAL, "SQLite Error", "DLL ERROR")
			Exit -1
		EndIf
		global $sqDB = _SQLite_Open("firmi_python.db")
		if @error Then
			MsgBox($MB_SYSTEMMODAL, "Sqlite erorr", "cant load db")
			Exit -1
		EndIf
		_SQLite_QuerySingleRow($sqDB, 'SELECT * FROM firmiD WHERE RB=' & _SQLite_FastEscape($id_read) & ' ORDER BY RB', $aRow)
		_SQLite_Close()
		_SQLite_Shutdown()
		$firma_id = $aRow[0]
		$firma_ime = $aRow[1]
		$firma_mesto = $aRow[2]
		$server_firma = $aRow[3]
		$firma_db = $aRow [4]
		$ecus_firma = $aRow [5]
		$user_firma = $aRow [6]
		$pass_firma = $aRow [7]
		GUISetState(@SW_HIDE, $sql_info)
		if $firma_id = "" Then
			GUICtrlSetData($id_na_firma_label, "/")
		Else
			GUICtrlSetData($id_na_firma_label, $firma_id)
		EndIf
		if $firma_ime = "" Then
			GUICtrlSetData($ime_na_firma_label, "/")
		Else
			GUICtrlSetData($ime_na_firma_label, $firma_ime)
		EndIf
		if $server_firma = "" Then
			GUICtrlSetData($server_na_firma_label, "/")
		Else
			GUICtrlSetData($server_na_firma_label, $server_firma)
		EndIf
		if $firma_mesto = "" Then
			GUICtrlSetData($lokacija_na_firma_label, "/")
		Else
			GUICtrlSetData($lokacija_na_firma_label, $firma_mesto)
		EndIf
		if $firma_db = "" Then
			GUICtrlSetData($db_na_firma_label, "/")
		Else
			GUICtrlSetData($db_na_firma_label, $firma_db)
		EndIf
		if $ecus_firma = "" Then
			GUICtrlSetData($ecus_na_firma_label, "/")
		Else
			GUICtrlSetData($ecus_na_firma_label, $ecus_firma)
		EndIf
		GuiSetState(@SW_SHOW, $kasper_gui)
		WinActivate("Kasper Update")
	Else
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
		_SQLite_QuerySingleRow($sqDB, 'SELECT * FROM firmiD WHERE IME=' & _SQLite_FastEscape($ime_read) & ' AND RB=' & _SQLite_FastEscape($id_read) & ' ORDER BY RB', $aRow)
		_SQLite_Close()
		_SQLite_Shutdown()
		$firma_id = $aRow[0]
		$firma_ime = $aRow[1]
		$firma_mesto = $aRow[2]
		$server_firma = $aRow[3]
		$firma_db = $aRow [4]
		$ecus_firma = $aRow [5]
		$user_firma = $aRow [6]
		$pass_firma = $aRow [7]
		GUICtrlSetData($id_na_firma_label, $firma_id)
		GUICtrlSetData($ime_na_firma_label, $firma_ime)
		GUICtrlSetData($server_na_firma_label, $server_firma)
		GUICtrlSetData($lokacija_na_firma_label, $firma_mesto)
		GUICtrlSetData($db_na_firma_label, $firma_db)
		GUICtrlSetData($ecus_na_firma_label, $ecus_firma)
		GUISetState(@SW_HIDE, $sql_info)
		GuiSetState(@SW_SHOW, $kasper_gui)
		WinActivate("Kasper Update")
	EndIf
EndFunc

func clear()
	_GUICtrlListView_DeleteAllItems($listView)
EndFunc
func quit()
	Exit
EndFunc

