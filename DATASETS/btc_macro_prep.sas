%let base = /home/u64449686/sasuser.v94;
%let fed_file = &base./FEDFUNDS.csv;
%let m2_file  = &base./M2SLCHANGE.csv;
%let dxy_file = &base./DOLLARINDEX.csv;
%let btc_file = &base./coin_Bitcoin.csv;
%let out_file = &base./btc_ready.csv;

%macro import_macro(ds=, file=, valuevar=, datefmt=anydtdte.);
data &ds;
  infile "&file" dsd dlm=';' firstobs=2 truncover;
  length obs_date_char $30 val_char $40;
  input obs_date_char :$30. val_char :$40.;
  Date = input(strip(obs_date_char), &datefmt.);
  &valuevar = input(tranwrd(strip(val_char), ',', '.'), best32.);
  format Date yymmdd10.;
  keep Date &valuevar;
run;
%mend;

%import_macro(ds=fedfunds,    file=&fed_file, valuevar=FEDFUNDS);
%import_macro(ds=m2slchange,  file=&m2_file,  valuevar=M2SLCHANGE);


%import_macro(ds=dollarindex, file=&dxy_file, valuevar=DOLLARINDEX, datefmt=mmddyy10.);

data dollarindex;
  set dollarindex;
  Date = intnx('month', Date, 0, 'B');
  format Date yymmdd10.;
run;

proc sort data=fedfunds nodupkey;     by Date; run;
proc sort data=m2slchange nodupkey;   by Date; run;
proc sort data=dollarindex nodupkey;  by Date; run;

proc import datafile="&btc_file"
  out=btc_raw
  dbms=csv
  replace;
  guessingrows=max;
run;

data btc_firstday;
  set btc_raw;
  if vtype(Date)='N' then d = datepart(Date);
  else do;
    dt = input(strip(Date), anydtdtm.);
    d  = datepart(dt);
  end;
  format d yymmdd10.;
  if day(d) = 1;
  Date = d;
  format Date yymmdd10.;
  Price = Close;
  keep Symbol Date Price Volume Marketcap;
run;

proc sort data=btc_firstday nodupkey; by Symbol Date; run;

data btc_ready;
  merge btc_firstday(in=a) fedfunds m2slchange dollarindex;
  by Date;
  if a;
run;

proc export data=btc_ready
  outfile="&out_file"
  dbms=csv
  replace;
run;

proc print data=btc_ready(obs=90); run;