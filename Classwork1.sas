/* Use SAS to evaluate the association between Tar and BaP
Create a permanent SAS dataset by using class dataset c with same content
Evaluate association by using the generated permanent SAS data generate a scatter plot
Create a simple linear regression model to predict BaP by using Tar */

LIBNAME cw '/home/u64143124/BIST0551/Data';

DATA cw.c;
	SET c;
RUN;

PROC SGPLOT DATA = cw.c;
	SCATTER Y = bap X = tar;
RUN;

PROC REG DATA = cw.c;
	MODEL bap = tar;
RUN;