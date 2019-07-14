#!/usr/bin/env python3

import pickle
import numpy as np
import matplotlib.pyplot as plt

def recall_dynamics(controls, depressed, dynamic):
    '''
    Plot recall dynamics for pstart and pstop
    '''
    objects = ["controls", "depressed"]
    y_pos = np.arange(len(objects))
    pstart_total_controls = 0
    pstart_total_depressed = 0
    for k, v in controls[dynamic].items():
        pstart_total_controls += v
    for k, v in depressed[dynamic].items():
        pstart_total_depressed += v        

    plt.subplot(1,2,1)
    plt.title('A')
    plt.bar(y_pos, 
            [controls[dynamic]["positive"]/pstart_total_controls, 
            depressed[dynamic]["positive"]/pstart_total_depressed], 
            align='center', alpha=0.5, color="green")
    plt.xticks(y_pos, objects)
    plt.ylabel('P('+dynamic+' positive)')
    plt.gca().set_ylim([0, .5])
    
    plt.subplot(1,2,2)
    plt.title('B')
    plt.bar(y_pos, 
            [controls[dynamic]["negative"]/pstart_total_controls, 
            depressed[dynamic]["negative"]/pstart_total_depressed], 
            align='center', alpha=0.5, color="purple")
    plt.xticks(y_pos, objects)
    plt.ylabel('P('+dynamic+' negative)')
    plt.gca().set_ylim([0, .5])
    plt.tight_layout()
    plt.savefig('images/'+dynamic+'.png', bbox_inches='tight')
    plt.close()

try:
    cfile = open("results_controls.pickle","rb")
    control_results = pickle.load(cfile)
    print("Succesfully loaded results for [controls]!")
except FileNotFoundError:
    print("Please run the model for controls first to get their results!")

try:
    dfile = open("results_depressed.pickle","rb")
    depressed_results = pickle.load(dfile)  
    print("Succesfully loaded results for [depressed]!")
except FileNotFoundError:
    print("Please run the model for depressed first to get their results!")

recall_dynamics(control_results, depressed_results, "pstart")
recall_dynamics(control_results, depressed_results, "pstop")