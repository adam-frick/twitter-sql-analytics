import re

file = open("training_set_tweets.txt", "r")
lines = file.read().split('\n')
reg = re.compile(r'^\d+\t+\d+\t+[^\\\t\x00]*\t' 
               + r'\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}$')

for line in lines:
    if re.match(reg, line):
        print(line)
