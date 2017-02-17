sas_icd10 := sas/comformat_icd10cm_2017.sas sas/comoanaly_icd10cm_2017.sas
dict_icd10 := icd10_dictionaries.txt

hcup_icd10 := hcup_icd10.py
parse_icd10 := parse_icd10.py


.PHONY: icd10
icd10: $(dict_icd10) touch_icd10.py icd10.py
	@python3 icd10.py

$(sas_icd10): $(hcup_icd10)
	@echo "Downloading SAS scripts from HCUP..."
	@python3 $(hcup_icd10)

$(dict_icd10): $(sas_icd10) $(parse_icd10)
	@echo "Generating dictionaries..."
	@python3 $(parse_icd10)

.PHONY: clean
clean:
	rm -rf __pycache__ *~
