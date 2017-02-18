# grab SAS script from HCUP for possible updates

import os
import re
import urllib.request as urlreq

hcup_sas_icd9 = "https://www.hcup-us.ahrq.gov/toolssoftware/comorbidity/"
txt01 = "comformat2012-2015.txt"
txt02 = "comoanaly2012-2015.txt"
sas01 = re.sub("txt", "sas", txt01)
sas02 = re.sub("txt", "sas", txt02)

# define directory to save the SAS scripts and create it if not exists
outDir = "sas/"

if not os.path.exists(outDir):
    os.makedirs(outDir)

try:
    urlreq.urlretrieve(hcup_sas_icd9 + txt01, filename = outDir + sas01)
    urlreq.urlretrieve(hcup_sas_icd9 + txt02, filename = outDir + sas02)
except:
    print("Error: failed to download SAS scripts from HCUP.")
    exit()

print("SAS scripts have been downloaded from HCUP to", outDir)
