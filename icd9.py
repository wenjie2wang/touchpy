#!/usr/bin/python3


import os
import re
import touch_icd9 as touch


# read input data
inputFile = input("Please enter the input CSV file name: ")
# inputFile = "sample_icd9.csv"

try:
    fhand0 = open(inputFile)
except:
    print("Error: failed to open/find", inputFile)
    exit()


# define output file name
basePath = os.path.basename(inputFile)
outputFile = re.sub(".csv", "_touch.csv", basePath)

# read in dictionaries
touch.dicts_icd9()

# read input and write output line by line
fout = open(outputFile, "w")
firstObs = 1

for line in fhand0:
    tmpLine = line.strip().lower()
    tmpLine = re.sub('"|[ ]', '', tmpLine)
    oneLine = tmpLine.split(",")
    if firstObs:
        input_colNames = oneLine
        output_colNames = [touch.dicts_icd9.colNames[i].upper()
                           for i in range(len(touch.dicts_icd9.colNames))]
        fout.write(",".join(output_colNames) + '\n')
        dx_idx = []
        drg_idx = None
        for i in range(len(input_colNames)):
            if input_colNames[i].startswith("dx"):
                dx_idx.append(i)
            if input_colNames[i].startswith("drg"):
                drg_idx = i
        firstObs = 0
        # quick check on dx_idx and drg_idx
        if len(dx_idx) <= 1:
            print("Error: failed to locate (secondary) diagnoses code",
                  "in the input file:", inputFile)
            exit()
        if drg_idx is None:
            print("Error: failed to locate DRG code",
                  "in the input file:", inputFile)
            exit()
    else:
        tmp = touch.icd9(oneLine, drg_idx, dx_idx, touch.dicts_icd9)
        fout.write(",".join(list(map(str, tmp))) + "\n")

fout.close()


# output message
print("Comorbidity measures have been generated in", outputFile)
