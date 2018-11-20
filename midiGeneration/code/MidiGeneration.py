# -*- coding: utf-8 -*-
"""
Generate Midi with jumps and noises

Created on Tue Nov 20 00:01:50 2018

@author: jhuang
"""
import numpy as np
import random
from mido import MidiFile, Message

def generateMidi(year, jump_num, max_jump_dist, silence_length, if_noise, if_mistake, index):
    mid = MidiFile('F:/FBA2013experiments/FBA2013experiments/src/midiGeneration/original/' \
                   + str(year) + 'middle_saxophone.mid')
    writeFile = 'F:/FBA2013experiments/FBA2013experiments/src/midiGeneration/generated/' \
                   + str(year) + '_' + str(max_jump_dist) + '_' + str(silence_length) + \
                   '_' + str(if_noise) + '_' + str(if_mistake) + '_No_' + str(index) + '.mid'
    
    # find the range of note_on/note_off messages
    begin = 0
    while (mid.tracks[1][begin].type != 'note_on'):
        begin = begin + 1
    end = len(mid.tracks[1])-2
    
    for i in np.arange(jump_num):
        print('add the ' + str(i) + ' th jump')
        # jump_num: decide where is the jump (posi^ 1 2 jump^ 1 2 3 4 ...)
        jump_dist = random.randint(2, max_jump_dist)
        jump_posi = random.randint(begin, end-jump_dist+1)
        while ((jump_posi > begin) and (mid.tracks[1][jump_posi].type != 'note_on')):
            jump_posi = jump_posi - 1
        print('jump_dist: ' + str(jump_dist))
        print('jump_posi: ' + str(jump_posi))
    
        # swap notes...
        #for k in np.arange(jump_dist):
        #    assert(mid.tracks[1][jump_posi+k].type == 'note_on')
        #    t = jump_posi + 2*k + 1
        #    print('find note_off of ' + str(t))
        #    while(!((mid.tracks[1][t].type == 'note_off') and (mid.tracks[1][jump_posi+2*k].note == mid.tracks[1][t].note))){
        #            t = t + 1
        #    }
        #    print("t = " + str(t))
    
    
    
        jump_dist = 2
        jump_posi = begin
        # add silence and insert the new notes
        # currently no mistake and noise
        event = mid.tracks[1][jump_posi]
        newevent = Message(event.type, channel=0, note = event.note, velocity=event.velocity, time = event.time+silence_length)
        mid.tracks[1].insert(jump_posi+2*jump_dist, newevent)
        print('insert at: ' + str(jump_posi+2*jump_dist))
        for j in np.arange(2*jump_dist-1):
            print(jump_posi+j+1)
            p = jump_posi+j+1
            event = mid.tracks[1][int(p)]
            mid.tracks[1].insert(jump_posi+2*jump_dist+j+1, event)
        
        
        end = end + jump_dist
    
    
    
    
    
    
    mid.save(writeFile)


if __name__ == '__main__':
    num = 1
    for i in np.arange(num):
        generateMidi(year = 2015, jump_num = 1, max_jump_dist = 2, silence_length = 1500, \
                     if_noise = 0, if_mistake = 0, index = i)