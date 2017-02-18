/******************************************************************/
/* Title:  CREATION OF FORMAT LIBRARY FOR ELIXHAUSER COMORBIDITY GROUPS      */
/*         ELIXHAUSER COMORBIDITY SOFTWARE, VERSION 3.7                      */
/*                                                                */
/* Description:                                                   */
/*    Define all ICD codes, V29 MS-DRGS, and labels for each      */
/*    comorbidity format.  			                  */
/*                                                                */
/* 10/20/15:    Corrections made to CEREDRG and add CARDDRG.      */
/* 10/01/13:    No new codes or DRGs for FY 2013-2015.            */
/* 04/05/12:    Update Version 3.7 to include DRG 252             */
/* 10/26/11:    Version 3.7 contains FY 2012 ICD-9-CM codes.      */
/*                                                                */
/* 11/09/10:    Version 3.6 contains FY 2011 ICD-9-CM codes.      */
/*                                                                */
/* 09/10/09:    Version 3.5 contains FY 2010 ICD-9-CM codes.      */
/*                                                                */
/* 02/09/09:    Version 3.4 contains FY 2009 ICD-9-CM codes and   */
/*              MS-DRG version 26 codes.                          */
/*                                                                */
/* 01/20/08:    Version 3.3b contains the updated ICD-9-CM and    */
/*              DRG version 25 codes for Fiscal Year 2008. For    */
/*              DRG version 24 codes, use 3.3a.                   */
/*                                                                */
/* 01/16/07:    Version 3.2                                       */
/*              new DRG codes for cardiac and nervous system.     */
/*                                                                */
/* 10/25/05:    Version 3.1 contains the updated ICD-9-CM codes   */
/*              for 2006. These codes are found in the renal      */
/*              failure and alcohol abuse formats. There are also */
/*              new DRG codes for cardiac and nervous system.     */
/*                                                                */
/* 01/04/05:    Added FY2005 DRG 543 (CRANIOTOMY WITH IMPLANT-    */
/*              ATION OF CHEMOTHERAPEUTIC AGENT OR ACUTE COMPLEX  */
/*              CENTRAL NERVOUS SYSTEM PRINCIPAL DIAGNOSIS) to    */
/*              the "NERVDRG" DRG exclusion format.  Includes     */
/*              cases previously assigned to DRGs 1 and 2.        */
/*                                                                */
/* 11/29/04:    Version 3.0 contains the updated ICD-9-CM codes   */
/*              for 2005. These codes can be found in the "Other  */
/*              Neurological" format. This format now handles DX  */
/*              codes that are not comorbidities differently:     */
/*              When used with the Comoanaly software, the        */
/*              temporary variable DXVALUE is assigned to blank.  */
/*                                                                */
/* 07/29/04:    Version 2.1 is a minor update that allows for     */
/*              several comorbidities to share the same           */
/*              diagnosis codes, something that has not been done */ 
/*              before because this SAS format does not allow for */
/*              overlapping or repeating values. In order to work */
/*              around this SAS constraint, the comorbidities for */
/*              Congestive Heart Failure and Hypertension         */
/*              Complicated have to be defined in the file        */    
/*              comoanaly2004.txt when they overlap with each     */
/*              other or Renal Failure.                           */   
/******************************************************************/

/***************************************************/
/* Define the subdirectory for the FORMAT library  */
/* Output file:  C:\COMORB\FMTLIB\FORMATS.sc2      */
/***************************************************/

Libname library 'C:\COMORB\FMTLIB\';


TITLE1 'CREATE FORMAT LIBRARY OF ICD CODES AND LABELS';
  
PROC FORMAT LIB=library fmtlib;
   VALUE $RCOMFMT

      "39891",
      "4280 "-"4289 " = "CHF"       /* Congestive heart failure */

   
      "09320"-"09324",
      "3940 "-"3971 ",
      "3979 ", 
      "4240 "-"42499",
      "7463 "-"7466 ",
      "V422 ",
      "V433 "         = "VALVE"     /* Valvular disease */


      "41511"-"41519",
      "4160 "-"4169 ",
      "4179 "         = "PULMCIRC"  /* Pulmonary circulation disorder */


      "4400 "-"4409 ",
      "44100"-"4419 ",
      "4420 "-"4429 ",
      "4431 "-"4439 ",
      "44421"-"44422",
      "4471 ",
      "449  ",
      "5571 ",
      "5579 ",
      "V434 "         = "PERIVASC"  /* Peripheral vascular disorder */


      "4011 ",
      "4019 ",
      "64200"-"64204" = "HTN"       /* Hypertension, uncomplicated */

      "4010 ",
      "4372 "         = "HTNCX"     /* Hypertension, complicated */


      /******************************************************************/
      /* The following are special, temporary formats used in the       */
      /* creation of the hypertension complicated comorbidity when      */
      /* overlapping with congestive heart failure or renal failure     */
      /* occurs. These temporary formats are referenced in the program  */
      /* called comoanaly2009.txt.                                      */
      /******************************************************************/
      "64220"-"64224" = "HTNPREG"   /* Pre-existing hypertension complicating pregnancy */


      "40200",
      "40210",
      "40290",  
      "40509",    
      "40519",
      "40599"         = "HTNWOCHF"  /* Hypertensive heart disease without heart failure */


      "40201",
      "40211",
      "40291"         = "HTNWCHF"   /* Hypertensive heart disease with heart failure */


      "40300",
      "40310",
      "40390",
      "40501",
      "40511",
      "40591",
      "64210"-"64214" = "HRENWORF"  /* Hypertensive renal disease without renal failure */


      "40301",
      "40311",
      "40391"         = "HRENWRF"   /* Hypertensive renal disease with renal failure */  


      "40400",
      "40410",
      "40490"         = "HHRWOHRF"  /* Hypertensive heart and renal disease without heart or renal failure */


      "40401",
      "40411",
      "40491"         = "HHRWCHF"   /* Hypertensive heart and renal disease with heart failure */


      "40402",
      "40412",
      "40492"         = "HHRWRF"    /* Hypertensive heart and renal disease with renal failure */


      "40403",
      "40413",
      "40493"         = "HHRWHRF"   /* Hypertensive heart and renal disease with heart and renal failure */ 
 

      "64270"-"64274",
      "64290"-"64294" = "OHTNPREG"  /* Other hypertension in pregnancy */

      /******************** End Temporary Formats ***********************/


      "3420 "-"3449 ",
      "43820"-"43853",
      "78072"         = "PARA"      /* Paralysis */


      "3300 "-"3319 ",
      "3320 ",
      "3334 ",
      "3335 ",
      "3337 ",
      "33371","33372","33379","33385","33394",
      "3340 "-"3359 ",
      "3380 ",
      "340  ",
      "3411 "-"3419 ",
      "34500"-"34511",
      "3452 "-"3453 ", 
      "34540"-"34591",
      "34700"-"34701",
      "34710"-"34711",
      "64940"-"64944",
      "7687 ",
      "76870"-"76873", 
      "7803 ",
      "78031",
      "78032",
      "78033",
      "78039",
      "78097",
      "7843 "         = "NEURO"     /* Other neurological */


      "490  "-"4928 ",
      "49300"-"49392",
      "494  "-"4941 ",
      "4950 "-"505  ",
      "5064 "         = "CHRNLUNG"  /* Chronic pulmonary disease */


      "25000"-"25033", 
      "64800"-"64804",
      "24900"-"24931" = "DM"        /* Diabetes w/o chronic complications*/


      "25040"-"25093", 
      "7751 ",
      "24940"-"24991" = "DMCX"      /* Diabetes w/ chronic complications */


      "243  "-"2442 ",
      "2448 ",
      "2449 "         = "HYPOTHY"   /* Hypothyroidism */


      "5853 ",
      "5854 ",
      "5855 ",
      "5856 ",
      "5859 ",
      "586  ",
      "V420 ",
      "V451 ",
      "V560 "-"V5632",
      "V568 ",
      "V4511"-"V4512" = "RENLFAIL"  /* Renal failure */

      
      "07022",
      "07023",
      "07032",
      "07033",
      "07044",
      "07054",
      "4560 ",
      "4561 ",
      "45620",
      "45621", 
      "5710 ",
      "5712 ",
      "5713 ",
      "57140"-"57149",
      "5715 ",
      "5716 ",
      "5718 ",
      "5719 ",
      "5723 ",
      "5728 ",
      "5735 ",
      "V427 "         = "LIVER"     /* Liver disease */


      "53141",
      "53151",
      "53161",
      "53170",
      "53171",
      "53191",
      "53241",
      "53251",
      "53261",
      "53270",
      "53271",
      "53291",
      "53341",
      "53351",
      "53361",
      "53370",
      "53371",
      "53391",
      "53441",
      "53451",
      "53461",
      "53470",
      "53471",
      "53491"         = "ULCER"     /* Chronic Peptic ulcer disease (includes bleeding only if obstruction is also present) */


      "042  "-"0449 " = "AIDS"      /* HIV and AIDS */


      "20000"-"20238",
      "20250"-"20301",
      "2386 ",
      "2733 ",
      "20302"-"20382" = "LYMPH"     /* Lymphoma */


      "1960 "-"1991 ",
      "20970"-"20975",
      "20979",
      "78951"         = "METS"      /* Metastatic cancer */


      "1400 "-"1729 ",
      "1740 "-"1759 ",
      "179  "-"1958 ", 
      "20900"-"20924",
      "20925"-"2093 ",
      "20930"-"20936",   
      "25801"-"25803" = "TUMOR"     /* Solid tumor without metastasis */


      "7010 ",
      "7100 "-"7109 ", 
      "7140 "-"7149 ",
      "7200 "-"7209 ",
      "725  " = "ARTH"              /* Rheumatoid arthritis/collagen vascular diseases */


      "2860 "-"2869 ",
      "2871 ",
      "2873 "-"2875 ",
      "64930"-"64934",
      "28984"         = "COAG"      /* Coagulation deficiency - note:
                                     this comorbidity should be dropped when
                                     used with the AHRQ Patient Safety Indicators */


      "2780 ",
      "27800",
      "27801",
      "27803",
      "64910"-"64914",
      "V8530"-"V8539",
      "V8541"-"V8545",
      "V8554",
      "79391"         = "OBESE"     /* Obesity      */
              
                     
      "260  "-"2639 ",
      "78321"-"78322" = "WGHTLOSS"  /* Weight loss */


      "2760 "-"2769 " = "LYTES"     /* Fluid and electrolyte disorders - note:
                                      this comorbidity should be dropped when
                                      used with the AHRQ Patient Safety Indicators*/

      "2800 ", 
      "64820"-"64824" = "BLDLOSS"   /* Blood loss anemia */


      "2801 "-"2819 ",
      "28521"-"28529",
      "2859 "         = "ANEMDEF"  /* Deficiency anemias */


      "2910 "-"2913 ",
      "2915 ",
      "2918 ",
      "29181",
      "29182",
      "29189",
      "2919 ",
      "30300"-"30393",
      "30500"-"30503" = "ALCOHOL"   /* Alcohol abuse */


      "2920 ",
      "29282"-"29289",
      "2929 ",
      "30400"-"30493",
      "30520"-"30593", 
      "64830"-"64834" = "DRUG"      /* Drug abuse */


      "29500"-"2989 ",
      "29910",
      "29911"         = "PSYCH"    /* Psychoses */


      "3004 ",
      "30112",
      "3090 ",
      "3091 ",
      "311  "         = "DEPRESS"  /* Depression */

      Other   = " "
    ;


    /**** V29 MS-DRG Formats ****/    

    VALUE CARDDRG                       /* Cardiac */
        001-002, 215-238, 
        242-252, 253-254, 258-262,
        265-267, 280-293, 296-298, 302-303,
        306-313 = "YES" ;

     VALUE PERIDRG                      /* Peripheral vascular */
        299-301 = "YES" ;

     VALUE RENALDRG                     /* Renal */
        652, 656-661, 673-675,
        682-700 = "YES" ;

     VALUE NERVDRG                      /* Nervous system */
        020-042, 
        052-103 = "YES" ;

     VALUE CEREDRG                      /* Cerebrovascular */
        020-022, 034-039, 
        064-072 = "YES" ;

     VALUE PULMDRG                      /* COPD asthma */
        190-192, 202-203
		          = "YES" ;

     VALUE  DIABDRG                     /* Diabetes */
        637-639 = "YES" ;

     VALUE HYPODRG                      /* Thyroid endocrine */
        625-627, 
        643-645 = "YES" ;

     VALUE RENFDRG                      /* Kidney transp, renal fail/dialysis */
        652, 682-685
		          = "YES" ;

     VALUE LIVERDRG                     /* Liver */
        420-425, 432-434, 441-446
		          = "YES" ;

     VALUE ULCEDRG                      /* GI hemorrhage or ulcer */
        377-384 = "YES"  ;

     VALUE HIVDRG                       /* Human immunodeficiency virus */
        969-970, 
        974-977 = "YES" ;

     VALUE LEUKDRG                      /* Leukemia/lymphoma */
        820-830,
        834-849 = "YES" ;

     VALUE CANCDRG                      /* Cancer, lymphoma */
        054, 055, 146-148, 180-182,
        374-376, 435-437, 
        542-544, 582-585, 597-599,
        656-658, 686-688,  
        715-716, 722-724, 736-741,
        754-756, 826-830, 843-849
	             = "YES" ;

     VALUE ARTHDRG                      /* Connective tissue */
        545-547 = "YES" ;

     VALUE NUTRDRG                      /* Nutrition/metabolic */
        640-641 = "YES" ;

     VALUE ANEMDRG                      /* Anemia */
        808-812 = "YES" ;

     VALUE ALCDRG                       /* Alcohol drug */
        894-897 = "YES" ;

     VALUE COAGDRG			             /*Coagulation disorders*/
        813     = "YES" ;

     VALUE HTNCXDRG                     /*Hypertensive Complicated  */
        077,078,304 
		          = "YES" ;

     VALUE HTNDRG                       /*Hypertensive Uncomplicated  */
        079,305 = "YES" ;

     VALUE PSYDRG			                /* Psychoses */
        885     = "YES" ;

     VALUE OBESEDRG	                   /* Obesity */
        619-621 = "YES" ;

     VALUE DEPRSDRG                     /* Depressive Neuroses */
        881     = "YES" ;

RUN;
