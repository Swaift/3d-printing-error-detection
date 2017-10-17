# -*- coding: utf-8 -*-
"""
Created on Tue Jul 11 13:46:37 2017

@author: Christian Sweet
"""

import picamera 
from picamera import PiCamera
import RPi.GPIO as GPIO
import time
from subprocess import Popen

GPIO.setmode(GPIO.BCM)
GPIO.setup(17, GPIO.IN)
counter = '001'

syncProcesses = []

while(True):
    i = GPIO.input(17)
        
    if i == 1:
        print("Switch Closed")
        with picamera.PiCamera() as camera:
            camera.resolution = (1920, 1080)
            camera.framerate = 80
            camera.vflip = True
            camera.hflip = True
            camera.rotation = 0 # Valid values 0, 90, 180, 270
           
            camera.capture('FRISummerResearch/motion/image{}.jpg'.format(counter), format='jpeg', quality=100)
            
            camera.close()
        
        print("Image {} Capture Successfully".format(counter))
        # asynchronous sync
        #  for process in list(syncProcesses):
            #  if process.poll() is not None:
                #  process.terminate()
                #  syncProcesses.remove(process)
        syncProcesses.append(Popen(['./SyncApp2.sh', 'image{}.jpg'.format(counter)]))
        counter = str(int(counter) + 1).zfill(len(counter))
        time.sleep(1)
