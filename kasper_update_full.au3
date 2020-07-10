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
#RequireAdmin
AutoItSetOption("MouseCoordMode", 0)
Opt("GUIOnEventMode", 1)
Global $progressbar = GUICtrlCreateProgress(20, 320, 200, 20, $PBS_SMOOTH)
global $default
global $custom
global $error = ""
global $password_hash = "0xd963fed62548da73b5012d620baba790d75afd79daeb24b5f7ea4d2012db67c6"
global $input_pass
Global $kasper_gui = GUICreate("Kasper Update", 600, 400)
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")
GUICtrlCreateLabel("Kasper Update Software", 230, 15, 200, 50)
GUICtrlSetFont(-1, 10, 900, 4, "Arial", 0)
GUICtrlCreateLabel("© Sebastijan Zindl", 490, 380, 150, 100)
GUICtrlSetFont(-1, 8.5, 700, 2, "Arial", 0)

GUICtrlCreateButton("KASPER_CDEP-UPDATES", 25, 50, 125, 50)
GUICtrlSetOnEvent(-1, "downloadUpdate")
GUICtrlSetFont(-1, 7, 700, 2, "Arial", 0)

GUICtrlCreateButton("KASPER_CDEPS_Install", 225, 50, 125, 50)
GUICtrlSetOnEvent(-1, "downloadInstall")
GUICtrlSetFont(-1, 7.5, 700, 2, "Arial", 0)

GUICtrlCreateButton("Tarifa", 425, 50, 75, 50)
GUICtrlSetOnEvent(-1, "downloadTarifa")
GUICtrlSetFont(-1, 9, 700, 2, "Arial", 0)

GUICtrlCreateButton("SQL Update", 500, 50, 75, 50 )
GUICtrlSetOnEvent(-1, "downloadSQL")
GUICtrlSetFont(-1, 9, 700, 2, "Arial", 0)

GUICtrlCreateButton("Kasper Database Update", 130, 130, 150, 50)
GUICtrlSetOnEvent(-1, "kasper_database_moving")
GUICtrlSetFont(-1, 7.5, 500, 2, "Arial", 0)


GUICtrlCreateButton("Mestenje Printeri", 330, 130, 150, 50)
GUICtrlSetOnEvent(-1,"printer_mestenje")
GUICtrlSetFont(-1, 9, 500, 2, "Arial", 0)

GUICtrlCreateButton("404 nedovrseno", 50, 230, 150, 50)
GUICtrlSetOnEvent(-1, "upcoming")
GUICtrlSetFont(-1, 9, 500, 2, "Arial", 0)

GUICtrlCreateButton("Initialize Database", 400, 230, 150, 50)
GUICtrlSetOnEvent(-1, "initializeDatabase")
GUICtrlSetFont(-1, 9, 500, 2, "Arial", 0)

$default = GUICtrlCreateCheckbox("Default", 50, 350, 50, 50)
$custom = GUICtrlCreateCheckbox("Custom Parameters", 130, 350, 50, 50)

GUISetState(@SW_HIDE)

global $login_form = GUICreate("Login", 257, 115, -1, -1)

login()


Func downloadInstall()
    $downloadPathInstall =  "C:\CDEPS\Sql\CDEPS.zip"
    $downloadInstallURL = "https://www.dropbox.com/sh/2nrqzzb1a204que/AAAyH39uDmtAhWIwEvP063yxa?dl=1"
    $downloadInstall = InetGet($downloadInstallURL,$downloadPathInstall, 1, 1)
    $downloadInstallSize = InetGetSize($downloadInstallURL)
    ProgressOn("Downloading CDEPS Instalation", "The CDEPS Install is downloading", "please wait")
    while not InetGetInfo($downloadInstall, 2)
        sleep(500)
        $downloadInstallBytesRecieved =InetGetInfo($downloadInstall, 0)
        $pctInstall = Int(($downloadInstallBytesRecieved/ $downloadInstallSize) * 100)
        ProgressSet($pctInstall, $pctInstall & "%")
    WEnd
    ProgressOff()
    $zipInstall = "C:\CDEPS\Sql\CDEPS.zip"
    $createnew = DirCreate("C:\Windows\Temp\CDEPS")
    $unzipDestination = ("C:\Windows\Temp\CDEPS")
    $iFlag = 16+256
    _Zip_UnzipAll($zipInstall, $unzipDestination, $iFlag)
    $deleteOriginalInstall = FileDelete($downloadPathInstall)
    InetClose($downloadInstall)
    DirMove($unzipDestination, "C:\", $FC_OVERWRITE)

    ShellExecute("C:\CDEPS\ReceiveTimeout.reg")
    sleep(1000)
    send("{ENTER}")
    sleep(1000)
    send("{ENTER}")

    ShellExecute("C:\CDEPS\Reg.reg")
    sleep(1000)
    send("{ENTER}")
    sleep(1000)
    send("{ENTER}")

    ShellExecute("C:\CDEPS\Fonts\Code-39-Logitogo.ttf")
    sleep(1000)
    MouseClick("left", 164, 55)
    sleep(1000)
    send("{LEFT}")
    sleep(1000)
    send("{ENTER}")
    WinClose("Code-39-Logitogo (TrueType) ")
    MsgBox($MB_SYSTEMMODAL, "Installed Sucesfully", "Novata CDEPS verzija e instalirana", 5)

EndFunc

func downloadUpdate()
    $downloadPathUpdate = "C:\CDEPS\Sql\CDEPS_CLIENT-UPDATES.zip"
    $downloadUpdateURL = "https://www.dropbox.com/sh/a4yxotggghg4bsf/AAAOE2G0U8wDTpxykNNwpIu-a?dl=1"
    $downloadUpdate = InetGet($downloadUpdateURL, $downloadPathUpdate, 1, 1)
    $downloadUpdateSize = InetGetSize($downloadUpdateURL)
    ProgressOn("Downloading Kasper Update", "The Kasper Update is downloading", "please wait")
    while not InetGetInfo($downloadUpdate, 2)
        sleep(500)
        $downloadUpdateBytesRecieved =InetGetInfo($downloadUpdate, 0)
        $pctUpdate = Int(($downloadUpdateBytesRecieved/ $downloadUpdateSize) * 100)
        ProgressSet($pctUpdate, $pctUpdate & "%")
    WEnd
    ProgressOff()
    ;ZIP unpacking
    $zipUpdate = "C:\CDEPS\Sql\CDEPS_CLIENT-UPDATES.zip"
    $unzipDestination = "C:\CDEPS\Sql\"
    $iFlag = 16+256
    $unzipUpdate = _Zip_UnzipAll($zipUpdate, $unzipDestination, $iFlag)
    $deleteOriginalUpdate = FileDelete($downloadPathUpdate)
    MsgBox($MB_OK, "Unzipping Complete", "CDEPS_CLIENT-UPDATES has been sucesfully unzipped")
    InetClose($downloadUpdate)
EndFunc

func downloadTarifa()
    $downloadPathTarifa = "C:\CDEPS\Sql\TARIFA_UPDATES.zip"
    $downloadTarifaURL = "https://www.dropbox.com/sh/sypveyl5t1rjrjf/AAAV7nAZztNSLOwq9G4YSrUOa?dl=1"
    $downloadTarifa = InetGet($downloadTarifaURL, $downloadPathTarifa, 1, 1)
    $downloadTarifaSize = InetGetSize($downloadTarifaURL)
    ProgressOn("Downloading Tarifa", "The newest Tarifa is downloading", "please wait")
    while not InetGetInfo($downloadTarifa, 2)
        sleep(500)
        $downloadTarifaBytesRecieved =InetGetInfo($downloadTarifa, 0)
        $pctTarifa = Int(($downloadTarifaBytesRecieved/ $downloadTarifaSize) * 100)
        ProgressSet($pctTarifa, $pctTarifa & "%")
    WEnd
    ProgressOff()
    $zipTarifa = "C:\CDEPS\Sql\TARIFA_UPDATES.zip"
    $unzipDestination = "C:\CDEPS\Sql\"
    $iFlag = 16+256
    $unzipUpdate = _Zip_UnzipAll($zipTarifa, $unzipDestination, $iFlag)
    $deleteoriginalTarifa = FileDelete($downloadPathTarifa)
    $deletePdf = FileDelete("C:\Cdeps\Sql\Instrukcii za instalacija na tarifa.pdf.pdf")
    MsgBox($MB_OK, "Unzipping Complete", "TARIFA_UPDATES has been sucesfully unzipped")
    InetClose($downloadTarifa)
EndFunc

func downloadSQL()
    $downloadSQLPath = "C:\CDEPS\Sql\CDEPS_SERVER-UPDATES.zip"
    $downloadSQLURL = "https://www.dropbox.com/sh/5povta1r8a1v1yz/AADaFy3mLKphM7ykcInskB9Wa?dl=1"
    $downloadSQL = InetGet($downloadSQLURL, $downloadSQLPath, 1, 1)
    $downloadSQLSize = InetGetSize($downloadSQLURL)
    ProgressOn("Downloading SQL Update", "SQL Update is downloading", "please wait")
    while not InetGetInfo($downloadSQL, 2)
        sleep(500)
        $downloadSQLBytesRecieved =InetGetInfo($downloadSQL, 0)
        $pctSQL = Int(($downloadSQLBytesRecieved/ $downloadSQLSize) * 100)
        ProgressSet($pctSQL, $pctSQL & "%")
    WEnd
    ProgressOff()
    $zipSQL = "C:\CDEPS\Sql\CDEPS_SERVER-UPDATES.zip"
    $unzipDestination = "C:\CDEPS\Sql\"
    $iFlag = 16+256
    $unzipSql = _Zip_UnzipAll($zipSQL, $unzipDestination, $iFlag)
    $deleteOriginalSQL = FileDelete($downloadSQLPath)
    MsgBox($MB_OK, "Complete", "Dowload and unzipping complete")
    InetClose($downloadSQL)
EndFunc

func SpecialEvents()
    Select
        Case @GUI_CtrlId = $GUI_EVENT_CLOSE
            Exit
        Case @GUI_CtrlId = $GUI_EVENT_MINIMIZE
        Case @GUI_CtrlId = $GUI_EVENT_RESTORE
        EndSelect
EndFunc

func upcoming() 
    MsgBox($MB_SYSTEMMODAL, "Error", "Nedovrseno seuste")
EndFunc
func kasper_database_moving()
    MsgBox($MB_OK, "Select Kasper Update", "Please select the newest downloaded kasper database")
    $selectedVersion = FileOpenDialog("Select KASPER_CDEP*****", "C:\CDEPS\Sql\", "All(*.*)", BitOR($FD_FILEMUSTEXIST, $FD_MULTISELECT))
    $updatedFileName = FileMove($selectedVersion, "C:\CDEPS\Sql\KASPER_CDEPS.mdb")

    MsgBox($MB_OK, "Select Current Kasper Database", "Please select the current kasper database")
    $currentVersion = FileOpenDialog("Select KASPER_CDEPS", "C:\CDEPS\", "All(*.*)", BitOR($FD_FILEMUSTEXIST, $FD_MULTISELECT))
    $date = String(_NowDate())
    $date_for_use = StringReplace($date, "/", "")
    $current_to_old = FileMove($currentVersion ,  "C:\CDEPS\old" & $date_for_use & "KASPER_CDEPS.mdb")
    MsgBox($MB_SYSTEMMODAL, "Current Database Name Change", "The Name of the current database has been changed so it can be updated.")

    $file = "C:\CDEPS\Sql\KASPER_CDEPS.mdb"
    $move_file = FileMove($file, "C:\CDEPS\KASPER_CDEPS.mdb")
    MsgBox($MB_OK, "Update Complete", "Databse Update has been completed")
EndFunc


func initializeDatabase()
    Opt("SendKeyDelay", 5)
    $default_check = GUICtrlRead($default)
    $custom_check = GUICtrlRead($custom)
    if $default_check =  $GUI_CHECKED Then
        $date = String(_NowDate())
        $date_for_use = StringReplace($date, "/", "")
        AutoItSetOption("WinTitleMatchMode", 4)
        $open = ShellExecute("C:\CDEPS\KASPER_CDEPS.mdb")
        WinWaitNotActive(" КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
        MouseClick("left", 237, 78)
        WinWaitActive("ПОТВРДЕТЕ")
        send("{ENTER}")
        sleep(1000)
        send("old"& $date_for_use &"KASPER_CDEPS.mdb")
        send("{ENTER}")
        WinWaitNotActive(" КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
        Sleep(1000)
        MouseClick("left", 200, 183)
        sleep(1000)
        send("{ENTER}")
        send("{ENTER}")
        send("{ENTER}")
        send("{ENTER}")
        sleep(10000)
        send("{ENTER}")
        send("{TAB}")
        sleep(10000)
        MouseClick("left", 241, 450)
        sleep(10000)
        MouseClick("left", 51, 43)
        sleep(1000)
        MouseClick("left", 246, 657, 5)
        sleep(1000)
        MouseClick("left", 253, 2)
        WinClose("КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
    ElseIf $custom_check = $GUI_CHECKED Then
        $server = InputBox("Server", "Stavi go Tocnoto ime na serverot")
        if ($server = "") Then
            MsgBox ($MB_SYSTEMMODAL, "Error", "nemate vneseno server")
        Exit
        EndIf
        $database = InputBox("Database", "Vnesi go imeto na databazata")
        if ($server = "") Then
            MsgBox($MB_SYSTEMMODAL, "Error", "Nemate vneseno databaza")
            Exit
        EndIf
        $username = InputBox("Username", "Vnesi username")
        if ($username = "") Then
            MsgBox($MB_SYSTEMMODAL, "Error", "nemate vneseno username")
            Exit
        EndIf
        $password = InputBox("Password", "Vnesete password")
        if ($password = "") Then
            MsgBox($MB_SYSTEMMODAL, "Error", "nemate vneseno password")
            Exit
        EndIf
        $date = String(_NowDate())
        $date_for_use = StringReplace($date, "/", "")
        AutoItSetOption("WinTitleMatchMode", 4)
        $open = ShellExecute("C:\CDEPS\KASPER_CDEPS.mdb")
        WinWaitNotActive(" КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
        MouseClick("left", 237, 78)
        WinWaitActive("ПОТВРДЕТЕ")
        send("{ENTER}")
        sleep(1000)
        send("old"& $date_for_use &"KASPER_CDEPS.mdb")
        send("{ENTER}")
        WinWaitNotActive(" КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
        Sleep(1000)
        MouseClick("left", 200, 183)
        sleep(1000)
        send("{BACKSPACE 50}")
        send($server)
        send("{ENTER}")
        send("{ENTER}")
        send("{BACKSPACE 50}")
        send($database)
        send("{ENTER}")
        send("{BACKSPACE 50}")
        send($username)
        send("{ENTER}")
        send("{BACKSPACE 50}")
        send($password)
        sleep(10000)
        send("{ENTER}")
        send("{TAB}")
        sleep(1000)
        MouseClick("left", 241, 450)
        sleep(10000)
        MouseClick("left", 51, 43)
        sleep(1000)
        MouseClick("left", 246, 657, 5)
        sleep(1000)
        MouseClick("left", 253, 2)
        WinClose("КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
    Elseif (($custom_check <> $GUI_CHECKED) And ($default_check <> $GUI_CHECKED)) Then
        MsgBox($MB_RETRYCANCEL, "Erorr", "No Checkbox was selected")

    EndIf

EndFunc

func printer_mestenje()
    Opt("SendKeyDelay", 5)
    $username = InputBox("Korisnicko ime", "Vnesi korisnicko ime")
    if ($username = "") Then
        MsgBox($MB_SYSTEMMODAL, "Error", "Ne vnesovte korisnicko ime")
        Exit
    EndIf
    $password = InputBox("Password", "Vnesi password")
    if($password = "") Then
        MsgBox($MB_SYSTEMMODAL, "Error", "Ne vnesovte password")
        Exit
    EndIf
    $open = ShellExecute("C:\CDEPS\KASPER_CDEPS.mdb")
    sleep(1000)
    WinWaitNotActive(" КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
    MouseClick("left", 172, 328)
    send("{BACKSPACE 50}")
    send($username)
    sleep(1000)
    send("{ENTER}")
    send("{BACKSPACE 50}")
    sleep(1000)
    send($password)
    send("{ENTER 2}")
    sleep(10000)
    Do
        sleep(250)
    Until WinWaitNotActive("Vegesa Poraki")
    sleep(250)
    MouseClick("left", 194, 42)
    sleep(1000)
    MouseClick("left", 250, 57)
    sleep(1000)
EndFunc

func LoginClick()
    $read_pass = GUiCtrlRead($input_pass)
    $hash_read = _Crypt_HashData($read_pass, $CALG_SHA_256)
    $password_upper = StringUpper($password_hash)
    if $hash_read = $password_upper Then
        MsgBox(0, "Access Granted", "The password is correct", 5)
        sleep(1000)
        GUISetState(@SW_HIDE, $login_form)
        GUISEtState(@SW_SHOW, $kasper_gui)

    Else
        MsgBox($MB_RETRYCANCEL, "Access Denied", "Password is incorrect", 5)
    EndIf
EndFunc

func login()
    Opt("GUIOnEventMode", 1)
    $login_form = GUICreate("Login", 257, 115, -1, -1)
    $input_pass = GUICtrlCreateInput("", 16, 16, 225, 21,$ES_PASSWORD)
    GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
    GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
    GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")

    GUICtrlCreateButton("Login", 192, 80, 50, 25, 0)
    GUICtrlSetOnEvent(-1, "LoginClick")
    GUICtrlCreateButton("Cancel", 16, 80, 50, 25, 0)
    GUICtrlSetOnEvent(-1, "SpecialEvents")

    GUISetState(@SW_SHOW)
    While 1
        sleep(250)
    WEnd
EndFunc
