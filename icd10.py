#!/usr/bin/python3


import re
import touch_icd10 as touch


# read input data
inputFile = input("Please enter the input file name: ")
# inputFile = "sample_icd10.csv"

try:
    fhand0 = open(inputFile)
except:
    print("Error: cannot open/find", inputFile)
    exit()


# define output file name
outputFile = re.sub(".csv", "_touch.csv", inputFile)

# read in dictionaries
touch.dicts()

# read input and write output line by line
fout = open(outputFile, "w")
firstObs = 1

for line in fhand0:
    tmpLine = line.strip().lower()
    tmpLine = re.sub('"|[ ]', '', tmpLine)
    oneLine = tmpLine.split(",")
    if firstObs:
        input_colNames = oneLine
        output_colNames = [touch.dicts.colNames[i].upper()
                           for i in range(len(touch.dicts.colNames))]
        fout.write(",".join(output_colNames) + '\n')
        dx_idx = []
        for i in range(len(input_colNames)):
            if "dx" in input_colNames[i]:
                dx_idx.append(i)
            if "drg" in input_colNames[i]:
                drg_idx = i
        firstObs = 0
    else:
        tmp = touch.icd10(oneLine, drg_idx, dx_idx, touch.dicts)
        fout.write(",".join(list(map(str, tmp))) + "\n")

fout.close()


# output message
print("Comorbidity measures have been generated in", outputFile)
