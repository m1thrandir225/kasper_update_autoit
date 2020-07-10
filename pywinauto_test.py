import autoit
import time
from datetime import date
import os


def install_cdeps(): 
    autoit.run("C:\\CDEPS\\Sql\\CDEPS_Install.exe")
    autoit.win_wait_active("Information")
    autoit.send("!n")
    autoit.win_wait_active("unregistered WinAce SFX - Инсталација на KASPER_CDEPS 2020 27/06/2020 год.")
    autoit.send("!e")
    autoit.win_wait_active("Confirm File Replace")
    autoit.send("!a")
    print("install done")



def reference_db():
    autoit.opt("SendKeyDelay", 5)
    autoit.opt("MouseCoordMode", 0)
    today_date = date.today()
    formated_date = today_date.strftime("%d%m%y")
    date_for_use = formated_date.replace("/", "")
    os.system("C:\\CDEPS\\KASPER_CDEPS.mdb")
    time.sleep(5)
    os.system("TASKKILL /im cmd.exe")
    autoit.win_wait_not_active(" КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
    autoit.mouse_click("left", 237, 78)
    autoit.win_wait_active("ПОТВРДЕТЕ")
    autoit.send("{ENTER}")
    time.sleep(1)
    autoit.send("old" & date_for_use & "KASPER_CDEPS.mdb")
    autoit.send("{ENTER}")
    autoit.win_wait_not_active(" КАСПЕР_CDEPS+OL_2020_R4_a002_02.07.2020 (Програм за шпедитерско работење (поедноставени постапки)) (c)ВеГеСа")
    time.sleep(1)
    autoit.mouse_click("left", 200, 183)
    time.sleep(1)
    autoit.send("{ENTER 4}")
    time.sleep(10)
    autoit.send("{ENTER}")
    autoit.send("{TAB}")
    time.sleep(10)
    autoit.mouse_click("left", 241, 450)
    time.sleep(10)
    autoit.mouse_click("left", 51, 43)
    time.sleep(1)
    autoit.mouse_click("left", 246, 657, 5)
    time.sleep(1)
    autoit.mouse_click("left", 253, 2)
reference_db()
