# First-year Research Project

Project Code for the course First-year Research Project [KIM.FYRP11.2018-2019.2] from the University of Groningen. Modelling the effects of rumination on free recall in ACT-R.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites

What things you need to install the software and how to install them

```
Python, version 3.6+
ACT-R, version 7.13
```

### Installing

```
pip install -r requirements.txt
```

### How to run the models
First we need to start the ACT-R environment.

Then to run the models use the line below in an interpreter:
```
python3 -c "import csm_free_recall; csm_free_recall.do_experiment('controls')"
```
This will run the model for the controls.
To change from the controls model to the depressed model we can use the following line:
```
python3 -c "import csm_free_recall; csm_free_recall.do_experiment('depressed')"
```
To see the model run in realtime we can do the following:
```
python3 -c "import csm_free_recall; csm_free_recall.do_experiment('controls', True)"
```
Lastly we can change the standard amount of 2000 word lists to a different number like 500, using the following:
```
python3 -c "import csm_free_recall; csm_free_recall.do_experiment('controls', True, 500)"
```

If there are more word lists necessary then there are available you can create more word lists.
To do this we first delete the [word_lists_dict.pickle](word_lists_dict.pickle) file.
We can then use the create_lists(list_amount, list_length) function to create new word lists.
The standard word list amount available is 2500, with each word list consisting of 20 words.

To get some more recall dynamic information, we can use the [recall_dynamics.py](recall_dynamics.py) file:
```
python3 recall_dynamics.py
```

## Authors

* **Chi Sam Mac** - [Bitbucket](https://bitbucket.org/csmac/) - [E-Mail](chisam_mac@hotmail.com) - [LinkedIn](https://www.linkedin.com/in/chi-sam-mac-910924167/)

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* M.K. van Vugt for mentoring my project giving me guidance and tips
* M. van der Velde for helping me choose a project topic and telling my about his related research
