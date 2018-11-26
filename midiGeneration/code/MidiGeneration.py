# -*- coding: utf-8 -*-
"""
Generate Midi with jumps and noises

Created on Tue Nov 20 00:01:50 2018

@author: jhuang
"""
import numpy as np
import random
from mido import MidiFile, Message

def removeOverlap(mid, trackno, iNoteOn):
    #newmid = MidiFile()
    track = mid.tracks[trackno]
    newtrack = track[0:iNoteOn]
    #newmid.tracks.append(mid.tracks[0])
    #newmid.tracks.append(mid.tracks[1])
    #newmid.tracks.append(newtrack)
    i = iNoteOn
    j = iNoteOn+1
    note_v = 0
    cuT = 0
    lcuT = 0
    onT = 0
    while(i < len(track)):
        onT = onT + track[i].time
        if (track[i].type == 'note_on'):
            note_v = track[i].note
            #print('i=' + str(note_v))
            j = i + 1
            lcuT = cuT
            cuT = 0
            while (track[j].type != 'note_off' or track[j].note != note_v):
                cuT = cuT + track[j].time
                j = j + 1
                #print(cuT)
            cuT = cuT + track[j].time
            # note off found
            # append note on and note off
            #print('j=' + str(note_v))
            #print('onT=' + str(onT) + ' onT-lcut= ' + str(onT-lcuT))
            event = track[i]
            neweventi = Message(event.type, channel=0, note = event.note, velocity=event.velocity, time = max(onT-lcuT, 0))
            newtrack.append(neweventi)
            event = track[j]
            neweventj = Message(event.type, channel=0, note = event.note, velocity=event.velocity, time = cuT)
            newtrack.append(neweventj)
            onT = 0
        i = i + 1;
    
    mid.tracks[1] = newtrack
    #mid.save('F:/FBA2013experiments/FBA2013experiments/src/midiGeneration/newmid.mid')
    return mid
    


def generateMidi(year, jump_num, max_jump_dist, silence_length, if_noise, if_mistake, index):
    # year: year option
    # jump_num: number of jumps to generate in one file
    # max_jump_dist: the maximum distance of jump
    # silence_length: the length of silence before jumping
    # if_noise: variance in time (not implemented yet)
    # if_mistake: whether to add mistakes in the last note before a jump
    # index: the index of generated file (to determine a unique file name)
    
    # read the original midi and specify the write file name
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
    
    # remove the overlap in the original midi
    mid = removeOverlap(mid, 1, begin)
    
    # add jump(s)
    for i in np.arange(jump_num):
        print('add the ' + str(i) + ' th jump')
        # jump_num: decide where is the jump (posi^ 1 2 jump^ 1 2 3 4 ...)
        jump_dist = random.randint(2, max_jump_dist)
        jump_posi = random.randint(begin, end-jump_dist+1)
        while ((jump_posi > begin) and (mid.tracks[1][jump_posi].type != 'note_on')):
            jump_posi = jump_posi - 1
        print('jump_dist: ' + str(jump_dist))
        print('jump_posi: ' + str(jump_posi))
        
        #jump_dist = 2 # debug
        #jump_posi = begin # debug
        # add silence and insert the new notes
        event = mid.tracks[1][jump_posi]
        newevent = Message(event.type, channel=0, note = event.note, velocity=event.velocity, time = event.time+silence_length)
        mid.tracks[1].insert(jump_posi+2*jump_dist, newevent)
        print('insert at: ' + str(jump_posi+2*jump_dist))
        for j in np.arange(2*jump_dist-1):
            #print(jump_posi+j+1)
            p = jump_posi+j+1
            event = mid.tracks[1][int(p)]
            newevent = Message(event.type, channel=0, note = event.note, velocity=event.velocity, time = event.time)
            mid.tracks[1].insert(jump_posi+2*jump_dist+j+1, newevent)
        
        # add a mistake to the last note before the jump
        if (if_mistake == 1):
            mis = random.randint(-2, 2)
            no = random.randint(0, jump_dist-1)
            mid.tracks[1][jump_posi+no*2].note = mid.tracks[1][jump_posi+no*2].note+mis
            mid.tracks[1][jump_posi+no*2+1].note = mid.tracks[1][jump_posi+no*2+1].note+mis
        
        end = end + jump_dist * 2 # not used

    
    mid.save(writeFile)


if __name__ == '__main__':
    num = 10
    for i in np.arange(num):
        generateMidi(year = 2013, jump_num = 1, max_jump_dist = 4, silence_length = 1200, \
                     if_noise = 0, if_mistake = 1, index = i)
        generateMidi(year = 2014, jump_num = 1, max_jump_dist = 4, silence_length = 1200, \
                     if_noise = 0, if_mistake = 1, index = i)
        generateMidi(year = 2015, jump_num = 1, max_jump_dist = 4, silence_length = 1200, \
                     if_noise = 0, if_mistake = 1, index = i)
