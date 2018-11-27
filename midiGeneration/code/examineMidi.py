# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

from mido import MidiFile

mid = MidiFile('F:/FBA2013experiments/FBA2013experiments/src/midiGeneration/original/2015middle_saxophone.mid')

for i, track in enumerate(mid.tracks):
    print('track {}: {}'.format(i, track.name))
    cnt = 0
    for msg in track:
        cnt = cnt + 1
        print(msg)
        