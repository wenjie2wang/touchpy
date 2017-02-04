# parse SAS scripts
import re


# read format script
fhand = open("sas/comformat_icd10cm_2017.sas")
comformat = fhand.readlines()

for i in range(0, len(comformat)):
    line = comformat[i]
    # ignore comments
    comformat[i] = re.sub("/\*.*\*/", "", line).strip()
