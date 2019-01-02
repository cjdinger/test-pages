%let name=col1;
filename odsout '.';

data my_data;
input CATEGORY SERIES $ 3-11 AMOUNT;
datalines;
1 Series A  5
2 Series A  7.8
1 Series B  9.5
2 Series B  5.9
;
run;

data my_data; set my_data;
length htmlvar $300;
htmlvar=
 'title='||quote( 
  'Category: '|| trim(left(category)) ||'0D'x||
  'Series: '|| trim(left(series)) ||'0D'x||
  'Amount: '|| trim(left(amount))  
  )||
 ' href="col1_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="GChart Clustered Column") 
 style=htmlblue;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";
goptions ctext=gray33;

axis1 label=none value=none;  
axis2 label=(a=90 'AMOUNT') order=(0 to 10 by 2) minor=(number=1) offset=(0,0);
axis3 label=('CATEGORY') offset=(5,5);

pattern1 v=solid color=cx9999ff;  /* light blue */
pattern2 v=solid color=cx993366;  /* purplish */
pattern3 v=solid color=cxffffcc;  /* pale yellow */

title1 ls=1.5 "Clustered Column";
title2 "Compares values across categories";

proc gchart data=my_data; 
vbar series / discrete type=sum sumvar=amount 
 group=category subgroup=series 
 space=0 gspace=5
 maxis=axis1 raxis=axis2 gaxis=axis3 
 autoref clipref cref=graycc
 nolegend coutline=black 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;
