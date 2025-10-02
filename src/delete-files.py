import os
import time

absolute_path = os.path.abspath(__file__)
current_directory = os.path.dirname(absolute_path)
held_files = open("./held_files").read()
files_folder = os.chdir(os.path.join(os.getcwd(), "files"))

while True:
    current_time = time.time()

    for i in os.listdir():
        file_location = os.path.join(os.getcwd(), i)
        file_time = os.stat(file_location).st_mtime

        if( ( i not in held_files ) and ( file_time < current_time ) ):
            os.remove(file_location)
    
    time.sleep(5)
