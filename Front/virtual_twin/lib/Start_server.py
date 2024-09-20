import subprocess
import os

# Change this to your Django project directory
os.chdir('D:/cours_II2/S2/stage/Application/back/virtualtwin')
print("here we will activate the server")

# Run the Django server
try:
    subprocess.Popen(['python', 'manage.py', 'runserver'], shell=True)
    print("Server started successfully.")
except Exception as e:
    print(f"Could not execute command: {e}")
