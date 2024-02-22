import os
import time

# writes the current Unix-format timestamp to a file.
# running this function would verify that the process has not hung


def update_liveness():

    timestamp = int(time.time())
    with open("logs/lastrun.date", "w") as myfile:
        myfile.write(f"{timestamp}")
