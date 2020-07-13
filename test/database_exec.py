import sqlite3


conn = sqlite3.connect("firmi_python.db")
c = conn.cursor()
ime = input("vnesi ime: ")
lokacija = input("vnesi lokacija: ")
c.execute("SELECT * FROM firmiD WHERE (IME=? AND LOKACIJA=?)", (ime, lokacija))
result = c.fetchmany()
de_tuple = result[0]

(rb, ime_firma, lokacija_firma, server_firma, database, ecus, username, password, rbr) = de_tuple
print (ime_firma)
print (server_firma)
conn.commit()
conn.close()