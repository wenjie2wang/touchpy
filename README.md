# touchpy

**touchpy** is an **Python** implementation of the software tools developed in
the [H-CUP][hcup] (Healthcare Cost and Utilization Project) at AHRQ (Agency for
Healthcare Research and Quality) and it provides functions to map ICD-9 or
ICD-10 code to AHRQ comorbidity measures.


# Development

This project is still under development now and needs testing for performance
and correctness.


# Requirement

- **touchpy** only requires **Python 3** (and its standard modules).  No extra
  module is needed.

- The input data has to be a comma-separated values (CSV) file, which contains
  header or column names for ICD-9 or ICD-10 codes, and diagnosis-related group
  (DRG) codes, etc. in the first row.

- There has to be at least one column of ICD-10 codes and the column names of
  ICD-9 or ICD-10 codes have to start with `DX` or `dx` (not case-sensitive). In
  addition, the principal diagnosis (usually `DX1`) must be given before
  secondary diagnoses.

- There should be only one column of DRG codes and the column name has to start
  with `DRG` or `drg` (not case-sensitive). (If multiple columns of DRG codes
  are detected, the last one will be used.)

- Missing ICD-9 or ICD-10 codes should be indicated by blanks (white spaces),
  `NA`, or `na` (not case-sensitive).


# Getting Started

First of all, we need manually download or clone this repository by

```bash
git clone git@github.com:wenjie2wang/touchpy.git
cd touchpy
```

## Usage with help of make

A Makefile is provided to simplify usage.  We should be able to generate output
CSV file by simply calling `make icd9` or `make icd10` in the terminal for ICD-9
codes or ICD-10 codes, respectively.  We will then be asked to enter the path of
the input CSV file.  The output file will be generated under the current
directory named after the input file with a trailing `_touch` tag.

For example, suppose we want to generate comorbidity measures from ICD-10 codes
and the input file is `data/sample_icd10.csv`, we may simply call `make icd10`
and enter `data/sample_icd10.csv` in the terminal.  The output file will be
`sample_icd10_touch.csv`, which contains the following 29 Elixhauser comorbidity
measures: `CHF`, `VALVE`, `PULMCIRC`, `PERIVASC`, `HTN_C` (either `HTN` or
`HTNCX`), `PARA`, `NEURO`, `CHRNLUNG`, `DM`, `DMCX`, `HYPOTHY`, `RENLFAIL`,
`LIVER`, `ULCER`, `AIDS`, `LYMPH`, `METS`, `TUMOR`, `ARTH`, `COAG`, `OBESE`,
`WGHTLOSS`, `LYTES`, `BLDLOSS`, `ANEMDEF`, `ALCOHOL`, `DRUG`, `PSYCH`,
`DEPRESS`.


## Alternative usage (without using make)

For the first time usage, we need first generate dictionaries for ICD-9 or
ICD-10 codes by

```bash
python3 parse_icd9.py   # for ICD-9 codes
## or
python3 parse_icd10.py  # for ICD-10 codes
```

The corresponding **Python** dictionary objects will be generated under `dict/`
with a text file named `icd9_dictionaries.txt` or `icd10_dictionaries.txt` under
the current directory.  We should not modify or remove these files manually.

Then we may call the main script by

```bash
python3 icd9.py   # for ICD-9 codes
## or
python3 icd10.py  # for ICD-10 codes
```

Similarly, we will asked to enter the path of the input CSV file.  The output
file will be generated under the current directory named after the input file
with a trailing `_touch` tag.


# License

**touchpy** is free and open source software, licensed under GPL-3.  It is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.



[hcup]: https://www.hcup-us.ahrq.gov/
