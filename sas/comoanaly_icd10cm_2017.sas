/******************************************************************/
/* Title:       CREATION OF ELIXHAUSER COMORBIDITY VARIABLES      */
/*              ICD-10-CM ELIXHAUSER COMORBIDITY SOFTWARE,        */
/*                       VERSION 1.1                              */
/*                                                                */
/* PROGRAM:     COMOANALY2017                                     */
/*                                                                */
/* Description: Creates comorbidity variables based on the        */
/*              presence of secondary diagnoses and redefines     */
/*              comorbidity group by eliminating DRGs directly    */
/*              related to them. Valid through FY2017 (09/30/17). */
/******************************************************************/


/***********************************************************/
/*  Define subdirectory for data files and format library. */
/*  Input files:    C:\DATA\                               */
/*  Output files:   C:\DATA\                               */
/*  Format library: C:\COMORB\FMTLIB\                      */
/***********************************************************/

LIBNAME IN1     'C:\DATA\';            
LIBNAME OUT1    'C:\DATA\';          
LIBNAME LIBRARY 'C:\COMORB\FMTLIB\'; 	   

TITLE1 'CREATION AND VALIDATION OF COMORBIDITY MEASURES FOR';
TITLE2 'USE WITH DISCHARGE ADMINISTRATIVE DATA';

/*******************************************************************/
/*  Macro Variables that must be set to define the characteristics */
/*  of the input discharge data to the program                     */
/*******************************************************************/
* Maximum number of DXs;        %LET NUMDX = 15;
* Input SAS file member name;   %LET CORE  = XXXXXX;


DATA OUT1.ANALYSIS;

    SET  IN1.&CORE (KEEP=DRG DX1-DX&NUMDX NDX);

    DROP  DRG DX1-DX&NUMDX NDX I J DXVALUE A1-A30
          HTN HTNCX
          CARDFLG PERIFLG CEREFLG PULMFLG DIABFLG
          HYPOFLG RENALFLG RENFFLG LIVERFLG
          ULCEFLG HIVFLG LEUKFLG CANCFLG ARTHFLG
          NUTRFLG ANEMFLG ALCFLG NERVFLG HTNCXFLG HTNFLG
			 PSYFLG OBESEFLG DEPRSFLG COAGFLG
          HTNPREG_ HTNWOCHF_ HTNWCHF_ HRENWORF_ 
          HRENWRF_ HHRWOHRF_ HHRWCHF_ HHRWRF_ 
          HHRWHRF_ OHTNPREG_ ;

	/********************************************************/
	/* Non-HCUP data users should un-comment the NDX= line  */
	/* below and remove NDX from the KEEP= statement above  */
        /* in order to create the needed variable NDX:          */
	/*                  NDX = &NUMDX ;                      */


   /*****************************************/
   /*  Declare variables as array elements  */
   /*****************************************/ 
   ARRAY DX (&NUMDX) $  DX1 - DX&NUMDX;

   ARRAY COM1 (30)  CHF      VALVE    PULMCIRC PERIVASC
                    HTN      HTNCX    PARA     NEURO    CHRNLUNG
                    DM       DMCX     HYPOTHY  RENLFAIL LIVER
                    ULCER    AIDS     LYMPH    METS     TUMOR
                    ARTH     COAG     OBESE    WGHTLOSS LYTES
                    BLDLOSS  ANEMDEF  ALCOHOL  DRUG     PSYCH
                    DEPRESS ;

   ARRAY COM2 (30) $ 8 A1-A30
                    ("CHF"     "VALVE"   "PULMCIRC" "PERIVASC" 
                     "HTN"     "HTNCX"   "PARA"     "NEURO"     "CHRNLUNG" 
                     "DM"      "DMCX"    "HYPOTHY"  "RENLFAIL"  "LIVER" 
                     "ULCER"   "AIDS"    "LYMPH"    "METS"      "TUMOR" 
                     "ARTH"    "COAG"    "OBESE"    "WGHTLOSS"  "LYTES" 
                     "BLDLOSS" "ANEMDEF" "ALCOHOL"  "DRUG"      "PSYCH" 
                     "DEPRESS") ; 

   LENGTH   CHF      VALVE    PULMCIRC PERIVASC
            HTN      HTNCX    PARA     NEURO    CHRNLUNG
            DM       DMCX     HYPOTHY  RENLFAIL LIVER
            ULCER    AIDS     LYMPH    METS     TUMOR
            ARTH     COAG     OBESE    WGHTLOSS LYTES
            BLDLOSS  ANEMDEF  ALCOHOL  DRUG     PSYCH
            DEPRESS 3 ;


   /****************************************************/
   /* Initialize  COM1 to 0 and assigns the variable   */
   /*  name from COM1 as the VALUE of COM2             */
   /****************************************************/
   DO I = 1 TO 30;
      COM1(I) = 0;
   END;

    /***************************************************/
    /* Looking at the secondary DXs and using formats, */
    /* create DXVALUE to define each comorbidity group */
    /*                                                 */
    /* If DXVALUE is equal to the comorbidity name in  */
    /* array COM2 then a value of 1 is assigned to the */
    /* corresponding comorbidity group in array COM1   */
    /***************************************************/
   HTNPREG_  = 0;
   HTNWOCHF_ = 0;
   HTNWCHF_  = 0;
   HRENWORF_ = 0;
   HRENWRF_  = 0;
   HHRWOHRF_ = 0;
   HHRWCHF_  = 0;
   HHRWRF_   = 0;
   HHRWHRF_  = 0;
   OHTNPREG_ = 0;

   DO I = 2 TO MIN(NDX, &NUMDX); 
      IF DX(I) NE " " THEN DO;
         DXVALUE = PUT(DX(I),$RCOMFMT.);
         IF DXVALUE NE " " THEN DO;
            DO J = 1 TO 30;
               IF DXVALUE = COM2(J)  THEN COM1(J) = 1;
            END;			 
			
		   /*********************************************/
		   /* Create detailed hypertension flags that   */
		   /* cover combinations of Congestive Heart    */
		   /* Failure, Hypertension Complicated, and    */
		   /* Renal Failure. These will be used in con- */
		   /* junction with DRG values to set the HTNCX,*/
		   /* CHF, and RENLFAIL comorbidities.          */
		   /*********************************************/
		   SELECT(DXVALUE);
		      WHEN ("HTNPREG")     HTNPREG_  = 1;
		      WHEN ("HTNWOCHF")    HTNWOCHF_ = 1;
		      WHEN ("HTNWCHF")     HTNWCHF_  = 1;
		      WHEN ("HRENWORF")    HRENWORF_ = 1;
		      WHEN ("HRENWRF")     HRENWRF_  = 1;
		      WHEN ("HHRWOHRF")    HHRWOHRF_ = 1;
		      WHEN ("HHRWCHF")     HHRWCHF_  = 1;
		      WHEN ("HHRWRF")      HHRWRF_   = 1;
		      WHEN ("HHRWHRF")     HHRWHRF_  = 1;
		      WHEN ("OHTNPREG")    OHTNPREG_ = 1;
		      OTHERWISE;
		   END;
         END;
      END;
   END;

	/*******************************************/
	/* Initialize Hypertension, CHF, and Renal */
	/* Comorbidity flags to 1 using the detail */
	/* hypertension flags.                     */
	/*******************************************/
	IF HTNPREG_  THEN HTNCX = 1;
	IF HTNWOCHF_ THEN HTNCX = 1;
	IF HTNWCHF_  THEN DO;
	   HTNCX    = 1;
      CHF      = 1;
	END;
	IF HRENWORF_ THEN HTNCX = 1;
	IF HRENWRF_  THEN DO;
	   HTNCX    = 1;
      RENLFAIL = 1;
	END;
	IF HHRWOHRF_ THEN HTNCX = 1;
        IF HHRWCHF_  THEN DO;
	   HTNCX    = 1;
	   CHF      = 1;
	END;
	IF HHRWRF_   THEN DO;
	   HTNCX    = 1;
      RENLFAIL = 1;
	END;
	IF HHRWHRF_  THEN DO;
	   HTNCX    = 1;
	   CHF      = 1;
	   RENLFAIL = 1;
	END;
	IF OHTNPREG_ THEN HTNCX = 1;	  


   /*********************************************************/
   /* Set up code to only count the more severe comorbidity */
   /*********************************************************/ 
   IF HTNCX = 1 THEN HTN = 0 ;
   IF METS = 1 THEN TUMOR = 0 ;
   IF DMCX = 1 THEN DM = 0 ;

   /******************************************************/
   /* Examine DRG and set flags to identify a particular */
   /* DRG group                                          */
   /******************************************************/
   IF PUT(DRG,CARDDRG.)  = 'YES' THEN CARDFLG  = 1;
   IF PUT(DRG,PERIDRG.)  = 'YES' THEN PERIFLG  = 1;
   IF PUT(DRG,CEREDRG.)  = 'YES' THEN CEREFLG  = 1;
   IF PUT(DRG,NERVDRG.)  = 'YES' THEN NERVFLG  = 1;
   IF PUT(DRG,PULMDRG.)  = 'YES' THEN PULMFLG  = 1;
   IF PUT(DRG,DIABDRG.)  = 'YES' THEN DIABFLG  = 1;
   IF PUT(DRG,HYPODRG.)  = 'YES' THEN HYPOFLG  = 1;
   IF PUT(DRG,RENALDRG.) = 'YES' THEN RENALFLG = 1;
   IF PUT(DRG,RENFDRG.)  = 'YES' THEN RENFFLG  = 1;
   IF PUT(DRG,LIVERDRG.) = 'YES' THEN LIVERFLG = 1;
   IF PUT(DRG,ULCEDRG.)  = 'YES' THEN ULCEFLG  = 1;
   IF PUT(DRG,HIVDRG.)   = 'YES' THEN HIVFLG   = 1;
   IF PUT(DRG,LEUKDRG.)  = 'YES' THEN LEUKFLG  = 1;
   IF PUT(DRG,CANCDRG.)  = 'YES' THEN CANCFLG  = 1;
   IF PUT(DRG,ARTHDRG.)  = 'YES' THEN ARTHFLG  = 1;
   IF PUT(DRG,NUTRDRG.)  = 'YES' THEN NUTRFLG  = 1;
   IF PUT(DRG,ANEMDRG.)  = 'YES' THEN ANEMFLG  = 1;
   IF PUT(DRG,ALCDRG.)   = 'YES' THEN ALCFLG   = 1;
   IF PUT(DRG,HTNCXDRG.) = 'YES' THEN HTNCXFLG = 1;
   IF PUT(DRG,HTNDRG.)   = 'YES' THEN HTNFLG   = 1;
   IF PUT(DRG,COAGDRG.)  = 'YES' THEN COAGFLG  = 1;
	IF PUT(DRG,PSYDRG.)   = 'YES' THEN PSYFLG   = 1;  
	IF PUT(DRG,OBESEDRG.) = 'YES' THEN OBESEFLG = 1;
	IF PUT(DRG,DEPRSDRG.) = 'YES' THEN DEPRSFLG = 1;

   /************************************************************/
   /* Redefining comorbidities by eliminating the DRG directly */
   /* related to comorbidity, thus limiting the screens to     */
   /* principal diagnoses not directly related to comorbidity  */
   /* in question                                              */
   /************************************************************/  
   IF CHF AND CARDFLG  THEN    CHF = 0 ;
   IF VALVE AND CARDFLG  THEN  VALVE = 0;
   IF PULMCIRC AND ( CARDFLG OR PULMFLG ) THEN PULMCIRC = 0;
   IF PERIVASC AND PERIFLG THEN PERIVASC = 0;
   IF HTN AND HTNFLG THEN HTN = 0;

   /**********************************************************/
   /* Apply DRG Exclusions to Hypertension Complicated, Con- */
   /* gestive Heart Failure, and Renal Failure comorbidities */
   /* using the detailed hypertension flags created above.   */
   /**********************************************************/
   IF HTNCX     AND HTNCXFLG THEN HTNCX = 0  ;
   IF HTNPREG_  AND HTNCXFLG THEN HTNCX = 0;
   IF HTNWOCHF_ AND (HTNCXFLG OR CARDFLG) THEN HTNCX = 0;
   IF HTNWCHF_  THEN DO;
      IF HTNCXFLG THEN HTNCX  = 0;
      IF CARDFLG THEN DO;
         HTNCX = 0;
	      CHF   = 0;
      END;
   END;
   IF HRENWORF_ AND (HTNCXFLG OR RENALFLG) THEN HTNCX = 0;
   IF HRENWRF_  THEN DO;
      IF HTNCXFLG THEN HTNCX = 0;
      IF RENALFLG THEN DO;
         HTNCX    = 0;
         RENLFAIL = 0;
      END;
   END;
   IF HHRWOHRF_ AND (HTNCXFLG OR CARDFLG OR RENALFLG) THEN HTNCX = 0;
   IF HHRWCHF_ THEN DO;
      IF HTNCXFLG THEN HTNCX = 0;
      IF CARDFLG THEN DO;
	      HTNCX = 0;
	      CHF   = 0;
      END;
      IF RENALFLG THEN HTNCX = 0;
   END;
   IF HHRWRF_ THEN DO;
      IF HTNCXFLG OR CARDFLG THEN HTNCX = 0;
      IF RENALFLG THEN DO;
         HTNCX    = 0;
         RENLFAIL = 0;
      END;
   END;
   IF HHRWHRF_ THEN DO;
      IF HTNCXFLG THEN HTNCX = 0;
      IF CARDFLG THEN DO;
         HTNCX = 0;
         CHF   = 0;
      END;
      IF RENALFLG THEN DO;
         HTNCX    = 0;
	      RENLFAIL = 0;
      END;
   END;
   IF OHTNPREG_ AND (HTNCXFLG OR CARDFLG OR RENALFLG) THEN HTNCX = 0;

   IF NEURO AND NERVFLG THEN NEURO = 0;
   IF CHRNLUNG AND PULMFLG THEN CHRNLUNG = 0;
   IF DM AND DIABFLG THEN DM = 0;
   IF DMCX AND DIABFLG THEN DMCX = 0 ;
   IF HYPOTHY AND HYPOFLG THEN HYPOTHY = 0;
   IF RENLFAIL AND RENFFLG THEN   RENLFAIL = 0;
   IF LIVER AND LIVERFLG THEN LIVER = 0;
   IF ULCER AND ULCEFLG THEN  ULCER = 0;
   IF AIDS AND HIVFLG THEN AIDS = 0;
   IF LYMPH AND LEUKFLG THEN LYMPH = 0;
   IF METS AND CANCFLG THEN METS = 0;
   IF TUMOR AND CANCFLG THEN TUMOR = 0;
   IF ARTH AND ARTHFLG THEN ARTH = 0;
   IF COAG AND COAGFLG THEN COAG = 0;
   IF OBESE AND (NUTRFLG OR OBESEFLG) THEN  OBESE = 0;
   IF WGHTLOSS AND NUTRFLG THEN WGHTLOSS = 0;
   IF LYTES AND NUTRFLG THEN LYTES = 0;
   IF BLDLOSS AND ANEMFLG THEN BLDLOSS = 0;
   IF ANEMDEF AND ANEMFLG THEN ANEMDEF = 0;
   IF ALCOHOL AND ALCFLG THEN ALCOHOL = 0;
   IF DRUG AND ALCFLG THEN DRUG = 0;
   IF PSYCH AND PSYFLG THEN PSYCH = 0;
   IF DEPRESS AND DEPRSFLG THEN DEPRESS = 0;
   IF PARA AND CEREFLG THEN PARA = 0;

   /*************************************/
   /*  Combine HTN and HTNCX into HTN_C */
   /*************************************/
   ATTRIB HTN_C LENGTH=3 LABEL='Hypertension';

   IF HTN=1 OR HTNCX=1 THEN HTN_C=1;
   ELSE HTN_C=0;


     LABEL CHF        = 'Congestive heart failure'
           VALVE      = 'Valvular disease'
           PULMCIRC   = 'Pulmonary circulation disease'
           PERIVASC   = 'Peripheral vascular disease'
           PARA       = 'Paralysis'
           NEURO      = 'Other neurological disorders'
           CHRNLUNG   = 'Chronic pulmonary disease'
           DM         = 'Diabetes w/o chronic complications'
           DMCX       = 'Diabetes w/ chronic complications'
           HYPOTHY    = 'Hypothyroidism'
           RENLFAIL   = 'Renal failure'
           LIVER      = 'Liver disease'
           ULCER      = 'Peptic ulcer Disease x bleeding'
           AIDS       = 'Acquired immune deficiency syndrome'
           LYMPH      = 'Lymphoma'
           METS       = 'Metastatic cancer'
           TUMOR      = 'Solid tumor w/out metastasis'
           ARTH       = 'Rheumatoid arthritis/collagen vas'
           COAG       = 'Coagulopthy'
           OBESE      = 'Obesity'
           WGHTLOSS   = 'Weight loss'
           LYTES      = 'Fluid and electrolyte disorders'
           BLDLOSS    = 'Chronic blood loss anemia'
           ANEMDEF    = 'Deficiency Anemias'
           ALCOHOL    = 'Alcohol abuse'
           DRUG       = 'Drug abuse'
           PSYCH      = 'Psychoses'
           DEPRESS    = 'Depression'
        ;
RUN;



/*************************************************/
/* Sample print and contents of comorbidity file */
/*************************************************/  
PROC PRINT DATA=OUT1.ANALYSIS (OBS=60);
  TITLE3 'Print of analysis file variables';
RUN;

PROC CONTENTS DATA=OUT1.ANALYSIS ;
  TITLE3 'Contents of comorbidity analysis file';
RUN;

/****************************************/
/*  Frequency of comorbidity variables  */
/****************************************/ 
PROC FREQ DATA=OUT1.ANALYSIS;
  TABLE  CHF      VALVE    PULMCIRC PERIVASC
         HTN_C    PARA     NEURO    CHRNLUNG DM
         DMCX     HYPOTHY  RENLFAIL LIVER    ULCER
         AIDS     LYMPH    METS     TUMOR    ARTH
         COAG     OBESE    WGHTLOSS LYTES    BLDLOSS
         ANEMDEF  ALCOHOL  DRUG     PSYCH    DEPRESS
       / LIST MISSING;
  TITLE3 'Frequency of comorbidity variables';
RUN;

/***********************************/
/*  Means of comorbidity variables */
/***********************************/  
PROC MEANS DATA=OUT1.ANALYSIS  N NMISS MEAN STD MIN MAX;
  VAR    CHF      VALVE    PULMCIRC PERIVASC
         HTN_C    PARA     NEURO    CHRNLUNG DM
         DMCX     HYPOTHY  RENLFAIL LIVER    ULCER
         AIDS     LYMPH    METS     TUMOR    ARTH
         COAG     OBESE    WGHTLOSS LYTES    BLDLOSS
         ANEMDEF  ALCOHOL  DRUG     PSYCH    DEPRESS
      ;
   TITLE3 'Means of comorbidity variables';
RUN;

