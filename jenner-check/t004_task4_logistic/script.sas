/* Mock stand-in for the BRFSS project extract p.pf25. Character class
   variables carry exactly the reference levels the author's models expect
   (SMOKDAY2 'Not at all', AGEGROUP 'Age 45 - 54', EXERANY2/VETERAN3 'No').
   Comma-delimited (DSD) so the multi-word AGEGROUP levels load intact.
   The Task 1-4 analysis below is the author's, with the p library rewritten
   to WORK. */
data pf25;
    length CHCKDNY2 SMOKDAY2 AGEGROUP $12 EXERANY2 VETERAN3 ADDEPEV3 $4;
    infile datalines dsd;
    input CHCKDNY2 $ SMOKDAY2 $ AGEGROUP $ EXERANY2 $ VETERAN3 $
          ALC_DAY MENTHLTH AVE_DRINK PHYSHLTH ADDEPEV3 $;
    datalines;
No,Every day,Age 45 - 54,Yes,Yes,4.6,12,3.3,14,No
No,Not at all,Age 55 - 64,No,No,3.5,0,5.1,0,No
No,Every day,Age 65+,Yes,No,1.8,25,4.8,27,Yes
Yes,Every day,Age 65+,Yes,No,4.5,3,4.9,26,Yes
No,Every day,Age 65+,Yes,No,4.6,30,2.2,15,Yes
Yes,Not at all,Age 55 - 64,No,No,2.6,14,3.9,13,Yes
Yes,Some days,Age 18 - 44,No,No,1.6,16,0.5,18,No
No,Not at all,Age 55 - 64,Yes,No,1.1,17,0.3,14,No
No,Not at all,Age 65+,Yes,No,1.3,24,0.9,20,No
Yes,Every day,Age 18 - 44,No,No,3.3,5,4.1,23,Yes
No,Not at all,Age 55 - 64,No,No,1.9,20,4.7,8,Yes
No,Not at all,Age 65+,No,No,1.6,18,5.9,21,No
No,Not at all,Age 65+,No,No,3.0,0,5.6,12,Yes
No,Some days,Age 55 - 64,Yes,No,4.1,16,1.6,29,No
No,Every day,Age 55 - 64,No,Yes,3.6,28,4.7,4,No
Yes,Some days,Age 18 - 44,No,Yes,3.3,13,1.1,25,Yes
Yes,Not at all,Age 18 - 44,Yes,No,0.8,16,3.2,13,Yes
No,Some days,Age 18 - 44,No,No,0.4,1,0.7,16,Yes
Yes,Not at all,Age 45 - 54,Yes,Yes,4.9,26,2.6,7,No
Yes,Every day,Age 18 - 44,Yes,No,0.8,12,1.2,7,Yes
Yes,Every day,Age 18 - 44,No,No,0.0,0,2.0,29,No
Yes,Some days,Age 18 - 44,Yes,No,0.7,5,0.4,23,No
Yes,Every day,Age 18 - 44,No,No,3.2,26,2.5,21,Yes
No,Some days,Age 45 - 54,Yes,Yes,2.4,1,4.3,1,No
No,Not at all,Age 55 - 64,Yes,No,3.8,30,3.5,24,No
Yes,Some days,Age 18 - 44,No,Yes,0.1,12,3.8,30,Yes
No,Every day,Age 65+,No,Yes,1.5,19,5.3,28,Yes
No,Every day,Age 45 - 54,No,No,1.1,24,1.8,20,No
Yes,Not at all,Age 18 - 44,Yes,Yes,3.8,29,2.5,27,Yes
No,Some days,Age 45 - 54,Yes,No,5.0,21,6.0,6,No
Yes,Every day,Age 65+,No,No,1.4,1,1.3,5,No
No,Not at all,Age 18 - 44,Yes,No,0.0,7,3.7,22,Yes
Yes,Every day,Age 55 - 64,No,No,3.6,10,1.4,24,No
No,Not at all,Age 18 - 44,Yes,No,3.6,8,1.8,17,Yes
No,Some days,Age 55 - 64,No,No,4.2,20,2.4,0,No
No,Not at all,Age 65+,Yes,Yes,0.7,11,1.3,7,Yes
No,Not at all,Age 55 - 64,Yes,No,4.4,22,5.8,1,Yes
No,Every day,Age 18 - 44,No,No,4.9,14,4.3,4,Yes
No,Every day,Age 65+,No,No,1.7,22,4.2,11,Yes
Yes,Not at all,Age 45 - 54,Yes,Yes,3.8,10,1.9,13,Yes
Yes,Some days,Age 45 - 54,Yes,No,2.9,25,3.1,27,No
Yes,Some days,Age 45 - 54,No,No,1.6,10,1.1,4,No
Yes,Some days,Age 18 - 44,Yes,No,4.7,16,2.7,5,No
Yes,Every day,Age 18 - 44,No,No,1.9,6,5.8,7,No
No,Every day,Age 65+,Yes,No,4.9,0,2.0,8,Yes
Yes,Every day,Age 45 - 54,No,No,3.9,1,3.6,23,Yes
Yes,Every day,Age 18 - 44,No,No,1.3,17,5.9,15,No
Yes,Not at all,Age 18 - 44,Yes,Yes,3.7,15,2.9,4,No
;
run;

data analysis_pf25;
    set pf25;
run;

proc logistic data=analysis_pf25 descending;
    class SMOKDAY2 (ref='Not at all')
          AGEGROUP (ref='Age 45 - 54')
          EXERANY2 (ref='No')
          VETERAN3 (ref='No')
          / param=ref;
    model CHCKDNY2 = SMOKDAY2 AGEGROUP EXERANY2 VETERAN3 ALC_DAY MENTHLTH;
    oddsratio SMOKDAY2; /* Adjusted ORs and 95% CIs */
    title "Adjusted Odds Ratios for SMOKDAY2 and Covariates";
run;

proc npar1way data=pf25 wilcoxon;
    class CHCKDNY2;
    var AVE_DRINK;
    title "Wilcoxon Rank Sum Test for AVE_DRINK by CHCKDNY2";
run;

proc univariate data=pf25;
    class CHCKDNY2;
    var AVE_DRINK;
    ods select BasicMeasures Quantiles;
run;

proc freq data=pf25;
    tables CHCKDNY2*EXERANY2 / chisq expected;
    title "Chi-square Test for EXERANY2 by CHCKDNY2";
run;

proc freq data=pf25;
    tables CHCKDNY2*AGEGROUP / chisq expected;
    title "Chi-square Test for AGEGROUP by CHCKDNY2";
run;

/* Simple Logistic Regression: AVE_DRINK */
proc logistic data=analysis_pf25 descending;
    model CHCKDNY2 = AVE_DRINK;
    title "Simple Logistic Regression for AVE_DRINK";
run;

/* Multiple Logistic Regression: Stepwise */
proc logistic data=analysis_pf25;
    class VETERAN3 (ref='No') AGEGROUP (ref='Age 45 - 54') EXERANY2 (ref='No') SMOKDAY2 (ref='Not at all') / param=ref;
    model CHCKDNY2 (event="Yes") = SMOKDAY2 VETERAN3 PHYSHLTH AGEGROUP AVE_DRINK EXERANY2 / SELECTION=STEPWISE include=3;
    title "Stepwise selection";
run;
