def icd10(admission, drg_idx, dx_idx):
    com1 = [0] * 30
    com2 = ["chf", "valve", "pulmcirc", "perivasc", "htn", "htncx", "para",
            "neuro", "chrnlung", "dm", "dmcx", "hypothy", "renlfail", "liver",
            "ulcer", "aids", "lymph", "mets", "tumor", "arth", "coag", "obese",
            "wghtloss", "lytes", "bldloss", "anemdef", "alcohol", "drug",
            "psych", "depress"]
    como = {}
    for i in range(30):
        como[com2[i]] = com1[i]
    htnpreg_ = 0
    htnwochf_ = 0
    htnwchf_ = 0
    hrenworf_ = 0
    hrenwrf_ = 0
    hhrwohrf_ = 0
    hhrwchf_ = 0
    hhrwrf_ = 0
    hhrwhrf_ = 0
    ohtnpreg_ = 0

    for i in dx_idx:
        if admission[i] is "NA" or len(admission) is 0:
            continue
        else:
            dx_value = rcomfmt.get(admission[i], "others")
            if dx_value is not "others":
                como[dx_value] = 1
                # detailed hypertension flags
                if dx_value is "htnpreg":
                    htnpreg_ = 1
                if dx_value is "htnwochf":
                    htnwochf_ = 1
                if dx_value is "htnwchf":
                    htnwchf_ = 1
                if dx_value is "hrenworf":
                    hrenworf_ = 1
                if dx_value is "hrenwrf":
                    hrenwrf_ = 1
                if dx_value is "hhrwohrf":
                    hhrwohrf_ = 1
                if dx_value is "hhrwchf":
                    hhrwchf_ = 1
                if dx_value is "hhrwrf":
                    hhrwrf_ = 1
                if dx_value is "hhrwhrf":
                    hhrwhrf_ = 1
                if dx_value is "ohtnpreg":
                    ohtnpreg_ = 1

    # Initialize Hypertension, CHF, and Renal Comorbidity flags to 1 using the
    # detail hypertension flags.
    if htnpreg_ or htnwochf_ or hrenworf_ or hhrwohrf_ or ohtnpreg_:
        como["htncx"] = 1
    if htnwchf_:
        como["htncx"] = 1
        como["chf"] = 1
    if hrenwrf_ or hhrwrf_:
        como["htncx"] = 1
        como["renlfail"] = 1
    if hhrwchf_:
        como["htncx"] = 1
        como["chf"] = 1
    if hhrwhrf_:
        como["htncx"] = 1
        como["chf"] = 1
        como["renlfail"] = 1

    # Set up code to only count the more severe comorbidity
    if como["htncx"]:
        como["htn"] = 0
    if como["mets"]:
        como["tumor"] = 0
    if como["dmcx"]:
        como["dm"] = 0

    # Examine DRG and set flags to identify a particular DRG group
    drg = admission[drg_idx]
    if carddrg.get(drg, "no") is 'yes':
        cardflg = 1
    if peridrg.get(drg, "no") is 'yes':
        periflg = 1
    if ceredrg.get(drg, "no") is 'yes':
        cereflg = 1
    if nervdrg.get(drg, "no") is 'yes':
        nervflg = 1
    if pulmdrg.get(drg, "no") is 'yes':
        pulmflg = 1
    if diabdrg.get(drg, "no") is 'yes':
        diabflg = 1
    if hypodrg.get(drg, "no") is 'yes':
        hypoflg = 1
    if renaldrg.get(drg, "no") is 'yes':
        renalflg = 1
    if renfdrg.get(drg, "no") is 'yes':
        renfflg = 1
    if liverdrg.get(drg, "no") is 'yes':
        liverflg = 1
    if ulcedrg.get(drg, "no") is 'yes':
        ulceflg = 1
    if hivdrg.get(drg, "no") is 'yes':
        hivflg = 1
    if leukdrg.get(drg, "no") is 'yes':
        leukflg = 1
    if cancdrg.get(drg, "no") is 'yes':
        cancflg = 1
    if arthdrg.get(drg, "no") is 'yes':
        arthflg = 1
    if nutrdrg.get(drg, "no") is 'yes':
        nutrflg = 1
    if anemdrg.get(drg, "no") is 'yes':
        anemflg = 1
    if alcdrg.get(drg, "no") is 'yes':
        alcflg = 1
    if htncxdrg.get(drg, "no") is 'yes':
        htncxflg = 1
    if htndrg.get(drg, "no") is 'yes':
        htnflg = 1
    if coagdrg.get(drg, "no") is 'yes':
        coagflg = 1
    if psydrg.get(drg, "no") is 'yes':
        psyflg = 1
    if obesedrg.get(drg, "no") is 'yes':
        obeseflg = 1
    if deprsdrg.get(drg, "no") is 'yes':
        deprsflg = 1

    # Redefining comorbidities by eliminating the DRG directly related to
    # comorbidity, thus limiting the screens to principal diagnoses not
    # directly related to comorbidity in question
    if como["chf"] and cardflg:
        como["chf"] = 0
    if como["valve"] and cardflg:
        como["valve"] = 0
    if como["pulmcirc"] and (cardflg or pulmflg):
        como["pulmcirc"] = 0
    if como["perivasc"] and periflg:
        como["perivasc"] = 0
    if como["htn"] and htnflg:
        como["htn"] = 0

    # Apply DRG Exclusions to Hypertension Complicated, Congestive Heart
    # Failure, and Renal Failure comorbidities using the detailed hypertension
    # flags created above.
    if como["htncx"] and htncxflg:
        como["htncx"] = 0
    if htnpreg_ and htncxflg:
        como["htncx"] = 0
    if htnwochf_ and (htncxflg or cardflg):
        como["htncx"] = 0
    if htnwchf_:
        if htncxflg:
            como["htncx"] = 0
        if cardflg:
            como["htncx"] = 0
            como["chf"] = 0
    if hrenworf_ and (htncxflg or renalflg):
        como["htncx"] = 0
    if hrenwrf_:
        if htncxflg:
            como["htncx"] = 0
        if renalflg:
            como["htncx"] = 0
            como["renlfail"] = 0
    if hhrwohrf_ and (htncxflg or cardflg or renalflg):
        como["htncx"] = 0
    if hhrwchf_:
        if htncxflg:
            como["htncx"] = 0
        if cardflg:
            como["htncx"] = 0
            como["chf"] = 0
        if renalflg:
            como["htncx"] = 0
    if hhrwrf_:
        if htncxflg or cardflg:
            como["htncx"] = 0
        if renalflg:
            como["htncx"] = 0
            como["renlfail"] = 0
    if hhrwhrf_:
        if htncxflg:
            como["htncx"] = 0
        if cardflg:
            como["htncx"] = 0
            como["chf"] = 0
        if renalflg:
            como["htncx"] = 0
            como["renlfail"] = 0
    if ohtnpreg_ and (htncxflg or cardflg or renalflg):
        como["htncx"] = 0
    if como["neuro"] and nervflg:
        como["neuro"] = 0
    if como["chrnlung"] and pulmflg:
        como["chrnlung"] = 0
    if como["dm"] and diabflg:
        como["dm"] = 0
    if como["dmcx"] and diabflg:
        como["dmcx"] = 0
    if como["hypothy"] and hypoflg:
        como["hypothy"] = 0
    if como["renlfail"] and renfflg:
        como["renlfail"] = 0
    if como["liver"] and liverflg:
        como["liver"] = 0
    if como["ulcer"] and ulceflg:
        como["ulcer"] = 0
    if como["aids"] and hivflg:
        como["aids"] = 0
    if como["lymph"] and leukflg:
        como["lymph"] = 0
    if como["mets"] and cancflg:
        como["mets"] = 0
    if como["tumor"] and cancflg:
        como["tumor"] = 0
    if como["arth"] and arthflg:
        como["arth"] = 0
    if como["coag"] and coagflg:
        como["coag"] = 0
    if como["obese"] and (nutrflg or obeseflg):
        como["obese"] = 0
    if como["wghtloss"] and nutrflg:
        como["wghtloss"] = 0
    if como["lytes"] and nutrflg:
        como["lytes"] = 0
    if como["bldloss"] and anemflg:
        como["bldloss"] = 0
    if como["anemdef"] and anemflg:
        como["anemdef"] = 0
    if como["alcohol"] and alcflg:
        como["alcohol"] = 0
    if como["drug"] and alcflg:
        como["drug"] = 0
    if como["psych"] and psyflg:
        como["psych"] = 0
    if como["depress"] and deprsflg:
        como["depress"] = 0
    if como["para"] and cereflg:
        como["para"] = 0

    # Combine HTN and HTNCX into HTN_C
    if como["htn"] or como["htncx"]:
        como["htn_c"] = 1
    else:
        como["htn_c"] = 0
    como.pop("htn", None)
    como.pop("htn_c", None)

    out = [como[key] for key in com2]
    return out
