import tkinter as tk
win = tk.Tk()
button1 = tk.Button(win, text="download update", command=downloadUpdate)

button1.pack()
win.mainloop()
