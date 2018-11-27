# -*- coding: utf-8 -*-
"""
Created on Mon Nov 26 20:15:33 2018

@author: lenovo
"""

import os

dataPath = '/home/jhuang/fluidsynth/midi/'
savePath = '/home/jhuang/fluidsynth/converted/'

def convertToAudio():
    files = os.listdir(dataPath)
    for file in files:
        writeFile = savePath + file[0:-4] + '.wav'
        #midiFile = dataPath + file
        os.system('fluidsynth -F ' + writeFile + ' soundfont.sf2 + ' + file)

if __name__ == "__main__":
    convertToAudio()
