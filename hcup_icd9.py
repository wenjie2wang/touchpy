# grab SAS script from HCUP for possible updates

import os
import urllib.request as urlreq

hcup_sas_icd9 = "https://www.hcup-us.ahrq.gov/toolssoftware/comorbidity/"
txt01 = "comformat2012-2015.txt"
txt02 = "comoanaly2012-2015.txt"

# define directory to save the SAS scripts and create it if not exists
outDir = "hcup/"

if not os.path.exists(outDir):
    os.makedirs(outDir)

try:
    urlreq.urlretrieve(hcup_sas_icd9 + txt01, filename = outDir + txt01)
    urlreq.urlretrieve(hcup_sas_icd9 + txt02, filename = outDir + txt02)
except:
    print("Error: failed to download SAS scripts from HCUP.")
    exit()

print("SAS scripts have been downloaded from HCUP to", outDir)
