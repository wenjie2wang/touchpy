# grab SAS script from HCUP for possible updates

import os
import re
import urllib.request as urlreq

hcup_sas_icd10 = "https://www.hcup-us.ahrq.gov/toolssoftware/comorbidityicd10/"
txt01 = "comformat_icd10cm_2017.txt"
txt02 = "comoanaly_icd10cm_2017.txt"
sas01 = re.sub("txt", "sas", txt01)
sas02 = re.sub("txt", "sas", txt02)

# define directory to save the SAS scripts and create it if not exists
outDir = "sas/"

if not os.path.exists(outDir):
    os.makedirs(outDir)

urlreq.urlretrieve(hcup_sas_icd10 + txt01, filename = outDir + sas01)
urlreq.urlretrieve(hcup_sas_icd10 + txt02, filename = outDir + sas02)
