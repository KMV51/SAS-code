LIBNAME p '~/BIST0551/Project';
options fmtsearch=(p.pf25format);

proc print data=p.analysis_pf25(obs=10) label;
run;

proc logistic data=p.analysis_pf25 descending;
    class SMOKDAY2 (ref='Not at all')  
          AGEGROUP
          EXERANY2
          VETERAN3
          / param=ref;
    
    model CHCKDNY2 = SMOKDAY2 AGEGROUP EXERANY2 VETERAN3 ALC_DAY MENTHLTH;
    
    oddsratio SMOKDAY2; /* Adjusted ORs and 95% CIs */
    
    title "Adjusted Odds Ratios for SMOKDAY2 and Covariates";
run;

proc npar1way data=p.pf25 wilcoxon;
    class CHCKDNY2;
    var AVE_DRINK;
    title "Wilcoxon Rank Sum Test for AVE_DRINK by CHCKDNY2";
run;

proc univariate data=p.pf25;
    class CHCKDNY2; /* group variable */
    var AVE_DRINK;   /* numeric variable */
    ods select BasicMeasures Quantiles; /* shows medians & quartiles */
run;



proc npar1way data=p.pf25 wilcoxon;
    class CHCKDNY2;
    var PHYSHLTH;
    title "Wilcoxon Rank Sum Test for PHYSHLTH by CHCKDNY2";
run;

proc univariate data=p.pf25;
    class CHCKDNY2; /* group variable */
    var PHYSHLTH;   /* numeric variable */
    ods select BasicMeasures Quantiles; /* shows medians & quartiles */
run;



proc freq data=p.pf25;
    tables CHCKDNY2*EXERANY2 / chisq expected;
    title "Chi-square Test for EXERANY2 by CHCKDNY2";
run;



proc freq data=p.pf25;
    tables CHCKDNY2*VETERAN3 / fisher expected;
    title "Chi-square Test for VETERAN3 by CHCKDNY2";
run;



proc freq data=p.pf25;
    tables CHCKDNY2*AGEGROUP / chisq expected;
    title "Chi-square Test for AGEGROUP by CHCKDNY2";
run;



proc freq data=p.pf25;
    tables CHCKDNY2*SMOKDAY2 / chisq expected;
    title "Chi-square Test for SMOKDAY2 by CHCKDNY2";
run;


/*Task 3*/

data p.analysis_pf25;
    set p.pf25;
run;

/* Simple Logistic Regression: AVE_DRINK */
proc logistic data=p.analysis_pf25 descending;
    model CHCKDNY2 = AVE_DRINK;
    title "Simple Logistic Regression for AVE_DRINK";
run;

/* Simple Logistic Regression: PHYSHLTH */
proc logistic data=p.analysis_pf25 descending;
    model CHCKDNY2 = PHYSHLTH;
    title "Simple Logistic Regression for PHYSHLTH";
run;

/* Simple Logistic Regression: EXERANY2 */
proc logistic data=p.analysis_pf25 descending;
    class EXERANY2 (ref='No') / param=ref;
    model CHCKDNY2 = EXERANY2;
    title "Simple Logistic Regression for EXERANY2";
run;

/* Simple Logistic Regression: VETERAN3 */
proc logistic data=p.analysis_pf25 descending;
    class VETERAN3 (ref='No') / param=ref;
    model ADDEPEV3 = VETERAN3;
    title "Simple Logistic Regression for VETERAN3";
run;

/* Simple Logistic Regression: AGEGROUP */
proc logistic data=p.analysis_pf25 descending;
    class AGEGROUP (ref='Age 45 - 54') / param=ref;
    model CHCKDNY2 = AGEGROUP;
    title "Simple Logistic Regression for AGEGROUP";
run;

/* Simple Logistic Regression: SMOKDAY2 */
proc logistic data=p.analysis_pf25 descending;
    class SMOKDAY2 (ref='Not at all') / param=ref;
    model CHCKDNY2 = SMOKDAY2;
    title "Simple Logistic Regression for SMOKDAY2";
run;


/* Task 4 */


/* Multiple Logistic Regression: Stepwise */
proc logistic data=p.analysis_pf25;
	class VETERAN3 (ref='No') AGEGROUP (ref='Age 45 - 54') EXERANY2 (ref='No') SMOKDAY2 (ref='Not at all') / param=ref;
    model CHCKDNY2 (event="Yes") = SMOKDAY2 VETERAN3 PHYSHLTH AGEGROUP AVE_DRINK EXERANY2 / SELECTION=STEPWISE include=3;
    title "Stepwise selection";
run;

/* Multiple Logistic Regression: Backwards */

proc logistic data=p.analysis_pf25;
	class VETERAN3 (ref='No') AGEGROUP (ref='Age 45 - 54') EXERANY2 (ref='No') SMOKDAY2 (ref='Not at all') / param=ref;
    model CHCKDNY2 (event="Yes") = SMOKDAY2 VETERAN3 PHYSHLTH AGEGROUP AVE_DRINK EXERANY2 / SELECTION=BACKWARD include=3;
    title "Backward selection";
run;

/* Multiple Logistic Regression: Forward */
proc logistic data=p.analysis_pf25;
	class VETERAN3 (ref='No') AGEGROUP (ref='Age 45 - 54') EXERANY2 (ref='No') SMOKDAY2 (ref='Not at all') / param=ref;
    model CHCKDNY2 (event="Yes") = SMOKDAY2 VETERAN3 PHYSHLTH AGEGROUP AVE_DRINK EXERANY2 / SELECTION=FORWARD include=3;
    title "Forward selection";
run;

proc logistic data=p.analysis_pf25 plots=(roc influence dfbetas);
    class SMOKDAY2 (ref="Not at all") VETERAN3 (ref='No') AGEGROUP (ref='Age 45 - 54') / param=ref;
    model CHCKDNY2(event='Yes') =  SMOKDAY2 PHYSHLTH VETERAN3 AGEGROUP AVE_DRINK/ rsquare lackfit;
    title "Final logistic model stepwise selection";
run;
