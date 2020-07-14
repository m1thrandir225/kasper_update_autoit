import sqlite3


conn = sqlite3.connect("firmi_python.db")
c = conn.cursor()
c.execute("SELECT * FROM firmiD WHERE (IME=? AND LOKACIJA=?)", (ime, lokacija))


(rb, ime_firma, lokacija_firma, server_firma, database, ecus, username, password, rbr) = de_tuple
print (ime_firma)
print (server_firma)
conn.commit()
conn.close()