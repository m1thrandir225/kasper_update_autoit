import gspread
from oauth2client.service_account import ServiceAccountCredentials
import sqlite3


def update_database():
    scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']
    credits_json = ("C:/Users/HP/Desktop/autotit/kasper_update/credits.json")
    creds = ServiceAccountCredentials.from_json_keyfile_name(credits_json, scope)
    client = gspread.authorize(creds)

    sheet = client.open("test_so_marko").sheet1
    print("Successfully connected to sheet...")
    print("\n getting the data..")
    data = sheet.get_all_values()
    print("\n data stored. Importing in database")



    list_of_rows = list(data)
    connection = sqlite3.connect("C:\\Users\\HP\\Desktop\\autotit\\kasper_update\\firmi_python.db")
    cursor = connection.cursor()

    number_of_lists = len(list_of_rows)
    cursor.executemany( )
    print("\n data successfully imported.")
    print("\n exiting :D")
    connection.close()

update_database()