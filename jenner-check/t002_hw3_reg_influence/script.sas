/* Mock stand-in for cw.ch05q17 (Chapter 5, Q17): advertising vs sales.
   The author's regression code below is unchanged; only the libref
   points at this WORK sample instead of the local BIST0551 library. */
data ch05q17;
    input ADV SALES;
    datalines;
1.0   10.2
1.5   12.8
2.0   14.1
2.5   16.9
3.0   18.4
3.5   21.0
4.0   22.7
4.5   25.3
5.0   26.8
5.5   29.6
6.0   31.1
6.5   33.9
;
run;

 /* Chapter 14, Problem 25 */

proc contents data=ch05q17; title "Contents: ch05q17"; run;

proc reg data=ch05q17;
    model SALES = ADV;
run;

proc reg data=ch05q17;
    model SALES = ADV / influence r;
    output out=RegOut rstudent=Jackknife_Residual;
run;

proc means data=RegOut max;
    var Jackknife_Residual;
run;

proc sgplot data=RegOut;
    scatter x=ADV y=Jackknife_Residual;
    refline 0 / axis=y lineattrs=(color=red);
    title "Scatter Plot of Jackknife Residuals vs Advertising";
run;
