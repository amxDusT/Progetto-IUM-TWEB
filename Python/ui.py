import customtkinter
from word_file import WordFinder
from word_file import WordError
import threading
import time
import os


def background():
    th = threading.Thread(target=start)
    another_thread = threading.Thread(target=loading)
    global is_loading
    is_loading = True
    another_thread.start()
    th.start()


is_loading = False


def loading():
    loading_base = "Loading"
    i = 0
    while is_loading is True:
        i = i + 1
        dots = "." * (i % 4)
        spaces = " " * (3 - len(dots))
        loading_text = loading_base + dots + spaces
        labelResult.configure(text=loading_text)
        labelResult.update_idletasks()
        time.sleep(0.1)


def start():
    text1 = entry1.get()
    text2 = entry2.get()
    path_name = os.path.join(os.path.dirname(__file__), 'words.italian.txt')
   
    word_finder = WordFinder(path_name)

    
    global is_loading

    try:
        word_finder.set_words(text1, text2)
        route, _ = word_finder.find_path()
        is_loading = False
        if route:
            result = ', '.join(route)
            labelResult.configure(text=result)
        else:
            labelResult.configure(text="No path found")
    except WordError:
        is_loading = False
        labelResult.configure(text="One of the words isn\'t in the dictionary.Try changing the words")


customtkinter.set_appearance_mode("dark")
customtkinter.set_default_color_theme("dark-blue")

root = customtkinter.CTk()
root.geometry("500x300")
root.title('Word Finder')

frame = customtkinter.CTkFrame(master=root)
frame.pack(pady=0, padx=0, fill="both", expand=True)

label = customtkinter.CTkLabel(master=frame, text="Word Finder")
label.pack(pady=12, padx=10)

entry1 = customtkinter.CTkEntry(master=frame, placeholder_text="Starting Word")
entry1.pack(pady=12, padx=10)

entry2 = customtkinter.CTkEntry(master=frame, placeholder_text="Ending Word")
entry2.pack(pady=12, padx=10)

button = customtkinter.CTkButton(master=frame, text="Find", command=lambda: background())
button.pack(pady=18, padx=10)

labelResult = customtkinter.CTkLabel(master=frame, text="")
labelResult.pack(pady=18, padx=10)

root.mainloop()
