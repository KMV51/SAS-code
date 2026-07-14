/* Mock stand-in for the class dataset c (Tar vs BaP). The author's
   permanent-store DATA step and the SGPLOT/REG analysis are unchanged;
   the cw library (BIST0551/Data) is replaced by this WORK sample. */
data c;
    input tar bap;
    datalines;
5    0.8
8    1.3
10   1.7
12   2.1
15   2.6
18   3.2
20   3.5
23   4.1
25   4.4
28   5.0
;
run;

/* Use SAS to evaluate the association between Tar and BaP
   Create a permanent SAS dataset by using class dataset c with same content
   Evaluate association by using the generated permanent SAS data generate a scatter plot
   Create a simple linear regression model to predict BaP by using Tar */

DATA cw_c;
	SET c;
RUN;

PROC SGPLOT DATA = cw_c;
	SCATTER Y = bap X = tar;
RUN;

PROC REG DATA = cw_c;
	MODEL bap = tar;
RUN;
