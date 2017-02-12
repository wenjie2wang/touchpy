# parse SAS scripts
import re
import string
translator = str.maketrans('', '', string.punctuation)


# read format script
fhand = open("sas/comformat_icd10cm_2017.sas")
comformat = fhand.readlines()


# define dictionary based on key word: value
valueLines = []
equalSignLines = []
dictNames = []
dictValues = []


for i in range(0, len(comformat)):
    line = comformat[i]
    # ignore comments
    comformat[i] = re.sub("/\*.*\*/|,|;", "", line).strip().lower()
    if comformat[i].startswith("proc") | comformat[i].startswith("other"):
        continue
    if 'value' in comformat[i]:
        dictNames.append(comformat[i].translate(translator).split()[1])
        valueLines.append(i)
    if '=' in comformat[i]:
        equalSignLines.append(i)
        tmp = re.search('=[ ]*".*"', comformat[i]).group(0)
        value = re.sub('=|[ ]', "", tmp)
        dictValues.append(value)
        comformat[i] = re.sub(value + "|[ ]|=", "", comformat[i])


# create dictionary
exec(dictNames[0] + " = dict()")
lastInd = valueLines[0] + 1

for j in range(len(equalSignLines)):
    if equalSignLines[j] > valueLines[1]:
        break
    ind = slice(lastInd, equalSignLines[j] + 1)
    for key in comformat[ind]:
        if len(key):
            comm = '[' + key + '] = ' + dictValues[j]
            exec(dictNames[0] + comm)
    lastInd = equalSignLines[j] + 1

# FIXME
# for i in range(3575, 3590):
#     print(comformat[i])
