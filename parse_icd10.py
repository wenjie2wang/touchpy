#!/usr/bin/python3

# Python 3.6.0 (default, Jan 16 2017, 12:12:55)
# [GCC 6.3.1 20170109] on linux


# parse SAS scripts
import os
import pickle
import re


# read format script
fName = "sas/comformat_icd10cm_2017.sas"
try:
    fhand = open(fName)
except:
    print("Error: failed to open/find", fName)
    exit()

comformat = fhand.readlines()


# define output file name
outDir = "dict/"
if not os.path.exists(outDir):
    os.makedirs(outDir)
outFile = outDir + "icd10_subme.pickle"


# define dictionary based on key word: value
valueRun = []
equalSignLines = []
dictNames = []
dictValues = []

for i in range(0, len(comformat)):
    line = comformat[i].strip().lower()
    # ignore comments
    comformat[i] = re.sub('/\*.*\*/|"|\$|,$|;$', "", line).strip()
    if comformat[i].startswith(("proc", "other")):
        continue
    if 'value' in comformat[i]:
        dictNames.append(comformat[i].split()[1])
        valueRun.append(i)
    if '=' in comformat[i]:
        equalSignLines.append(i)
        tmp = re.search('=[ ]*.*', comformat[i]).group(0)
        value = re.sub('=|[ ]', "", tmp)
        dictValues.append(value)
        comformat[i] = re.sub(value + '|[ ]|=', "", comformat[i])
    if comformat[i].startswith("run"):
        valueRun.append(i)


# create dictionaries
k = 0
for i in range(len(valueRun) - 1):
    exec(dictNames[i] + " = dict()")
    ind = range(valueRun[i] + 1, valueRun[i + 1])
    for j in ind:
        if (j > equalSignLines[k]):
            k += 1
        key = comformat[j]
        if len(key) == 0 or key.startswith("other"):
            continue
        # for rcomfmt
        if i == 0:
            comm = '["' + key + '"] = "' + dictValues[k] + '"'
            exec(dictNames[i] + comm)
        # for the rest
        else:
            keyList1 = re.sub(",[ ]*", ",", key).split(",")
            for oneKey1 in keyList1:
                tmpList = list(map(int, oneKey1.split("-")))
                if len(tmpList) > 1:
                    keyList2 = list(range(tmpList[0], tmpList[1] + 1))
                else:
                    keyList2 = tmpList
                for oneKey2 in keyList2:
                    comm = '[' + str(oneKey2) + '] = "' + dictValues[k] + '"'
                    exec(dictNames[i] + comm)


# save generated dictionaries into pickles
fName = "icd10_dictionaries.txt"
try:
    fout = open(fName, "w")
    for oneDict in dictNames:
        outName = re.sub("subme", oneDict, outFile)
        fout.write(outName + "\n")
        with open(outName, 'wb') as handle:
            exec("pickle.dump(" + oneDict +
                 ", handle, protocol = pickle.HIGHEST_PROTOCOL)")
    fout.close()
except:
    print("Error: failed to create", fName)
    exit()

print("ICD-10 dictionaries have been successfully generated.")
