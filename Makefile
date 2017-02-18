# for icd-10 codes
sas_icd10 := hcup/comformat_icd10cm_2017.txt hcup/comoanaly_icd10cm_2017.txt
dict_icd10 := icd10_dictionaries.txt

hcup_icd10 := hcup_icd10.py
parse_icd10 := parse_icd10.py

# for icd-9 codes
sas_icd9 := hcup/comformat2012-2015.txt hcup/comoanaly2012-2015.txt
dict_icd9 := icd9_dictionaries.txt

hcup_icd9 := hcup_icd9.py
parse_icd9 := parse_icd9.py


.PHONY: icd10
icd10: $(dict_icd10) touch_icd10.py icd10.py
	@python3 icd10.py

$(sas_icd10): $(hcup_icd10)
	@echo "Downloading SAS scripts from HCUP..."
	@python3 $(hcup_icd10)

$(dict_icd10): $(sas_icd10) $(parse_icd10)
	@echo "Generating dictionaries..."
	@python3 $(parse_icd10)


.PHONY: icd9
icd9: $(dict_icd9) touch_icd9.py icd9.py
	@python3 icd9.py

$(sas_icd9): $(hcup_icd9)
	@echo "Downloading SAS scripts from HCUP..."
	@python3 $(hcup_icd9)

$(dict_icd9): $(sas_icd9) $(parse_icd9)
	@echo "Generating dictionaries..."
	@python3 $(parse_icd9)


.PHONY: clean
clean:
	rm -rf __pycache__ *~
