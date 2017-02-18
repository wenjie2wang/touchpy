# touchpy

**touchpy** is an **Python** implementation of the software tools developed in
the [H-CUP][hcup] (Healthcare Cost and Utilization Project) at AHRQ (Agency for
Healthcare Research and Quality).  It provides functions to map ICD-10 code to
AHRQ comorbidity measures.


# Development

This project is still under development now and needs testing for performance
and correctness.


# Requirement

**touchpy** only requires **Python** 3 (and its standard modules).  No extra
module is needed.

The input data has to be a comma-separated values (CSV) file, which contains
header or column names for ICD-10 codes and diagnosis-related group (DRG) codes,
etc. in the first row.  In addition, the column names of ICD-10 codes have to
started with `DX` or `dx` (not case-sensitive) and the column name specifying
DRG codes has to start with `DRG` or `drg` (not case-sensitive). There has to be
at least one column of ICD-10 codes and only one column of DRG codes. (If
multiple columns of DRG codes are detected, the last one will be used.)
Furthermore, missing ICD-10 codes should be indicated by blanks, `NA`, or `na`
(not case-sensitive).


# Getting Started

First of all, we need manually download or clone this repository by

```bash
git clone git@github.com:wenjie2wang/touchpy.git
cd touchpy
```

## Usage with help of make

A Makefile is provided to simplify usage. We should be able to generate output
CSV file by simply calling `make` (or explicitly `make icd10`) in the
terminal. We will then be asked to enter the path of the input CSV file.  The
output file will be generated under the current directory named after the input
file with a trailing `_touch` tag.

For example, suppose the input file is `data/sample_icd10.csv`, we may call
`make` and enter `data/sample_icd10.csv` in the terminal. The output file will
be `sample_icd10_touch.csv`, which contains the following 29 Elixhauser
comorbidity measures: `CHF`, `VALVE`, `PULMCIRC`, `PERIVASC`, `HTN_C` (either
`HTN` or `HTNCX`), `PARA`, `NEURO`, `CHRNLUNG`, `DM`, `DMCX`, `HYPOTHY`,
`RENLFAIL`, `LIVER`, `ULCER`, `AIDS`, `LYMPH`, `METS`, `TUMOR`, `ARTH`, `COAG`,
`OBESE`, `WGHTLOSS`, `LYTES`, `BLDLOSS`, `ANEMDEF`, `ALCOHOL`, `DRUG`, `PSYCH`,
`DEPRESS`.


## Alternative usage (without using make)

For the first time usage, we need first generate dictionaries for ICD-10 codes
by

```bash
python3 parse_icd10.py
```

A text file `icd10_dictionaries.txt` and **Python** dictionary objects will be
generated under the current directory and `dict/`, respectively. We should not
modify or remove these files manually.

Then we may call the main script by

```bash
python3 icd10.py
```

Similarly, we will asked to enter the path of the input CSV file.  The output
file will be generated under the current directory named after the input
file with a trailing `_touch` tag.


# License

**touchpy** is free and open source software, licensed under GPL-3.



[hcup]: https://www.hcup-us.ahrq.gov/
