"""
Copyright 2019 Chi Sam Mac
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

############################################## [BASIC INFORMATION] ##############################################
# Creator:                      Chi Sam Mac (s2588382)
# Course:                       First-year Research Project [KIM.FYRP11.2018-2019.2]
# Supervised by:                M.K. van Vugt
# Python version:               3.6+
# Running instructions:         
#     Model (controls)          python3 -c "import csm_free_recall; csm_free_recall.do_experiment()"
#     Model (depressed)         python3 -c "import csm_free_recall; csm_free_recall.do_experiment('depressed')"
# More information:             https://bitbucket.org/csmac/fyrp
# Contact:                      c.s.mac@student.rug.nl
#################################################################################################################

import actr
import pickle
import random
import os
import sys
import numpy as np
import matplotlib.pyplot as plt
from collections import defaultdict
from itertools import groupby

word_lists_dict = defaultdict(list)

# Ensure there are enough unique words to create the word lists
word_dict = {"positive": ["positive" + str(i) for i in range(999)],
            "negative": ["negative" + str(i) for i in range(999)],
            "neutral": ["neutral" + str(i) for i in range(999)]}  

def add_words(i, list_length):
    '''
    Add the words to the word lists, ensures valence categories are balanced
    '''
    global word_lists_dict

    amnt_wanted = (list_length-2)/3 # Amount of each valence wanted, minus 2 neutrals controlling for primacy
    amt_positive, amt_negative, amt_neutral, count = 0, 0, 0, 0
    while len(word_lists_dict[i]) != list_length:
        count += 1
        if count >= 9999: # IF it takes too long to create a unique list at random, start over
            word_lists_dict[i] = []
            add_words(i, list_length)
        if len(word_lists_dict[i]) == 0: # Place two neutral words at the start to control for primacy effects
            word_to_add1 = word_dict["neutral"][random.randint(0, len(word_dict["neutral"])-1)]
            word_to_add2 = word_dict["neutral"][random.randint(0, len(word_dict["neutral"])-1)]
            if word_to_add1 not in word_lists_dict[i] and word_to_add2 not in word_lists_dict[i] and word_to_add1 != word_to_add2:
                word_lists_dict[i].append(word_to_add1)
                word_lists_dict[i].append(word_to_add2)
            else:
                continue # skip this loop iteration                   
        else: 
            random_valence = random.choice(["positive", "negative", "neutral"])
            word_to_add = word_dict[random_valence][random.randint(0, len(word_dict[random_valence])-1)]
            if word_to_add not in word_lists_dict[i] and word_lists_dict[i][-1] not in word_dict[random_valence] and \
               amt_positive <= amnt_wanted and amt_negative <= amnt_wanted and amt_neutral <= amnt_wanted:
                if random_valence == "positive" and amt_positive < amnt_wanted:
                    amt_positive += 1
                elif random_valence == "negative" and amt_negative < amnt_wanted:
                    amt_negative +=1
                elif random_valence == "neutral" and amt_neutral < amnt_wanted:
                    amt_neutral +=1
                else:
                    continue # skip this loop iteration
                word_lists_dict[i].append(word_to_add)


def create_lists(list_amount=3, list_length=20):
    '''
    Create the wordlists used during the free recall tasks 
    '''  
    global word_lists_dict 

    for i in range(list_amount):
        print(f'List {i}/{list_amount} created!', end="\r")
        add_words(i, list_length)

    # Save the dictionary to a .pickle file, so we do not have to create the word lists everytime we run the model                    
    file = open("word_lists_dict.pickle","wb")
    pickle.dump(word_lists_dict, file)
    file.close()
    return word_lists_dict

# Check if the word lists already exist, else create new word lists
try:
    file = open("word_lists_dict.pickle","rb")
    word_lists_dict = pickle.load(file)  
    file.close()
    print("\nSuccesfully loaded the word lists!\n")
except FileNotFoundError:
    print("\nCreating word lists!\n")
    amount_to_create = 2500
    word_lists_dict = create_lists(amount_to_create)


def display_word_lists():
    '''
    Display the word lists loaded/created
    '''
    for key, value in word_lists_dict.items():
        print(f'List {key}:\n {value}\n')   
    

def close_exp_window():
    '''
    Close opened ACT-R window
    '''
    return actr.current_connection.evaluate_single("close-exp-window") 


### Experiment part ###

subject = ''
current_list = ''
recalled_words = defaultdict(list)
rehearsed_words =  defaultdict(lambda: defaultdict(int))

def prepare_for_recall(): 
    '''
    Disable rehearsing productions, and clearing buffer contents to start the recalling phase 
    '''
    disable_list = ["rehearse-first", "rehearse-second", "rehearse-third", "rehearse-fourth", 
                    "rehearse-it", "skip-first", "skip-second", "skip-third", "skip-fourth"]
    for prod in disable_list:
        actr.pdisable(prod)
    actr.run(1, False) 
    for buff in ["imaginal", "retrieval", "production"]:
        actr.clear_buffer(buff)  


def setup_dm(word_list):
    '''
    Add words to declarative memory, since it can be assumed the test subjects know the English language already
    '''
    colour_conversion = {'pos': 'GREEN', 'neg': 'RED', 'neu': 'BLACK'}
    for idx, word in enumerate(word_list):
        valence = ''.join([char for char in word if not char.isdigit()])[:3]
        actr.add_dm(('item'+str(idx), 'isa', 'memory', 'word', "'"+word+"'", 'valence', colour_conversion[valence]))
        

def setup_experiment(human=True):
    '''
    Load the correct ACT-R model, and create a window to display the words
    '''
    if subject == "controls":
        actr.load_act_r_model("/Users/chisa/Desktop/masters/first_year_research_project/my_model/csm_free_recall_model.lisp")
    elif subject == "depressed":
        actr.load_act_r_model("/Users/chisa/Desktop/masters/first_year_research_project/my_model/csm_free_recall_model_depressed.lisp")

    window = actr.open_exp_window("Free Recall Experiment", width=1024, height=768, visible=human) # 15inch resolution window
    actr.install_device(window) 
    return window    


def record_words_recalled(item):
    '''
    Register which words were recalled during the experiment for a specific wordlist and strip the numbers
    '''
    valence = ''.join(char for char in item if not char.isdigit())
    item_idx = ''.join(char for char in item if char.isdigit())
    recalled_words[current_list].append((valence, item_idx))
   

def record_words_rehearsed(item):
    '''
    Register amount of rehearsals per word for each wordlist
    '''
    rehearsed_words[current_list][item] += 1


def create_lplot(idx, xlabel, ylabel, x, y, xticks_len, filename, ytick_range=None, show=False):
    '''
    Create line plot using matplotlib
    '''
    plt.figure(idx)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.plot(x, y)
    plt.xticks(np.arange(0, xticks_len, 1)) 
    plt.yticks(ytick_range)
    plt.savefig("images/"+subject+"_"+filename, bbox_inches='tight')
    if show:
        plt.show()    
 

def create_result_dict():
    '''
    Use a module-level function, instead of lambda function, to enable pickling it
    '''
    return defaultdict(int)


def analysis(wlist_amount, show_plots=False):
    '''
    Review results of the recall experiment
    '''
    result_dict = defaultdict(create_result_dict) # instead of defaultdict(lambda: defaultdict(int))
    first_recall = defaultdict(int)
    recall_probability = defaultdict(int)
    rehearse_frequency = defaultdict(int)
    transitions_amnt = 0
    thought_train_len = []

    for key, val in recalled_words.items():
        thought_train_len.extend([(k, sum(1 for _ in count)) for k, count in groupby([val[0] for val in val[2:]])])
        for idx, (retrieved_word, item_num) in enumerate(val[2:]):
            if idx != 0:
                if retrieved_word != val[2:][idx-1][0]:
                    transitions_amnt += 1/wlist_amount # average over word lists
    
    print(f'Avg. Amount of recall transitions = {int(transitions_amnt)}')
    neg_thought_train_len = 0
    neg_divider = 0.0001
    for x in thought_train_len:
        if x[0] == 'negative':
            neg_divider += 1
            neg_thought_train_len += x[1]
    print(f'Avg. Negative Thought train length = {round(neg_thought_train_len/neg_divider, 3)}')            

    for list_num, wlist in word_lists_dict.items():
        if list_num < wlist_amount:
            for key, val in recalled_words.items():
                if key==list_num:
                    first_recall[wlist.index(''.join(val[0]))] += 1   
                    for idx, word in enumerate(wlist):
                        first_recall[idx] += 0
                        if ((''.join(char for char in word if not char.isdigit()), 
                             ''.join(char for char in word if char.isdigit()))) in val:
                            recall_probability[idx] += 1
                        else:
                            recall_probability[idx] += 0                            
                for retrieved_word, item_num in val[2:4]:
                    result_dict["pstart"][retrieved_word] += 1  
                for retrieved_word, item_num in val[4:-2]:
                    result_dict["pstay"][retrieved_word] += 1
                for retrieved_word, item_num in val[-2:]:
                    result_dict["pstop"][retrieved_word] += 1                                                        
            for key, val in rehearsed_words.items():
                if key==list_num:
                    for idx, word in enumerate(wlist):
                        rehearse_frequency[idx] += rehearsed_words[key][word]
    
    for key, val in first_recall.items():
        first_recall[key] = val/wlist_amount

    for key, val in recall_probability.items():
        recall_probability[key] = val/wlist_amount

    for key, val in rehearse_frequency.items():
        rehearse_frequency[key] = val/wlist_amount      

    xticks_len = len(word_lists_dict[0])
  
    create_lplot(0, 'Serial input position', 'Rehearse Frequency', range(len(word_lists_dict[0])), list(rehearse_frequency.values()), 
                xticks_len, 'rehearse_frequency.png', None, show_plots)

    create_lplot(1, 'Serial input position', 'Starting Recall', range(len(word_lists_dict[0])), list(first_recall.values()), 
                xticks_len, 'starting_recall.png', np.arange(0, .5, .1), show_plots)                

    create_lplot(2, 'Serial input position', 'Recall Probability', range(len(word_lists_dict[0])), list(recall_probability.values()), 
                xticks_len, 'recall_probability.png', np.arange(0, 1, .1), show_plots)                    

    file = open("results_"+subject+".pickle","wb")
    pickle.dump(result_dict, file)
    file.close()

    return result_dict


def do_experiment(subj="depressed", human=False, wlist_amount=2000):
    '''
    Run the experiment
    '''
    global subject
    subject = subj
    assert wlist_amount <= len(word_lists_dict), "Chosen too many lists, choose less or create more word lists using function: create_lists()"
    # display_word_lists()
  
    for idx, (key, value) in enumerate(word_lists_dict.items()):
        actr.reset()
        window = setup_experiment(human)
        global current_list
        current_list = idx # keep track for which list words are recalled
        setup_dm(value)   
        actr.add_command("retrieved-word", record_words_recalled,"Retrieves recalled words.")
        actr.add_command("rehearsed-word", record_words_rehearsed,"Retrieves rehearsed words.")
        for word in value:
            if "neutral" in word:
                color = "black"
            elif "positive" in word:
                color = "green"
            else:
                color = "red"
            actr.add_text_to_exp_window(window, word, x=475-len(word) , y=374, color=color, font_size=20) # change later 
            actr.run(6, human) # True when choosing Human, False when choosing differently
            actr.clear_exp_window(window)
            actr.run(.5, human)  # 500-ms blank screen                        
        prepare_for_recall()       
        actr.remove_command("rehearsed-word")
        actr.goal_focus("startrecall") # set goal to start recalling
        actr.run(10, human)  
        actr.remove_command("retrieved-word")  
        print(f'Experiment {idx+1}/{wlist_amount} completed!', end="\r")
        if idx == wlist_amount-1: # run for a chosen amount of word lists
            break
    close_exp_window() # close window at end of experiment     

    avg_recalled, avg_recalled_unique = 0, 0
    for key, val in recalled_words.items():
        avg_recalled += len(val)
        avg_recalled_unique += len(set(val))
    #    print(f'\nList {key} (length={len(val)}, unique={len(set(val))})')

    print("\n\n#############################################")
    print(f'\n[{subj}] Results!\n')  

    result = analysis(wlist_amount, False)        
    print(f'Avg. Amount of words recalled = {avg_recalled//wlist_amount}')
    print(f'Avg. Amount of unique words recalled = {avg_recalled_unique//wlist_amount}')

    for key, val in result.items():
        print(f'{key} = {dict(val)}')
    print()
 