/* 1. Import the dataset from the specified path */
filename csv_file '/home/u64447590/ALL_CORRELATIONS_RESULTS.csv';

proc import datafile=csv_file
    out=crypto_data
    dbms=csv
    replace;
    getnames=yes;
run;

/* 2. Calculate the mean correlation for each macro parameter */
proc summary data=crypto_data nway;
    class Label;
    var Correlation_r;
    output out=means_data mean=mean_r;
run;

/* 3. Store mean values into macro variables for use in plots */
data _null_;
    set means_data;
    if index(Label, "Fed Funds") then call symputx('fed_mean', mean_r);
    else if index(Label, "M2 Money") then call symputx('m2_mean', mean_r);
    else if index(Label, "Dollar Index") then call symputx('dxy_mean', mean_r);
run;

/* 4. FED Funds histogram with Mean line */
title "FED Funds histogram";
proc sgplot data=crypto_data;
    where Label contains "Fed Funds";
    vbar Cryptocurrency / response=Correlation_r 
                          datalabel 
                          categoryorder=respasc
                          fillattrs=(color=CX3498DB);
    yaxis label="Pearson Correlation Coefficient (r)";
    xaxis label="Cryptocurrency Symbol";
    
    /* Zero reference line */
    refline 0 / axis=y lineattrs=(thickness=1 color=black); 
    
    /* Mean (mu) reference line */
    refline &fed_mean / axis=y lineattrs=(thickness=2 color=darkred pattern=dash) 
                        label="Mean (&fed_mean)" labelloc=inside;
run;
title;

/* 5. M2 Money Supply histogram with Mean line */
title "M2 Money Supply histogram";
proc sgplot data=crypto_data;
    where Label contains "M2 Money";
    vbar Cryptocurrency / response=Correlation_r 
                          datalabel 
                          categoryorder=respasc
                          fillattrs=(color=CX2ECC71);
    yaxis label="Pearson Correlation Coefficient (r)";
    xaxis label="Cryptocurrency Symbol";
    
    refline 0 / axis=y lineattrs=(thickness=1 color=black);
    
    /* Mean (mu) reference line */
    refline &m2_mean / axis=y lineattrs=(thickness=2 color=darkblue pattern=dash) 
                       label="Mean (&m2_mean)" labelloc=inside;
run;
title;

/* 6. US Dollar Index histogram with Mean line */
title "US Dollar Index histogram";
proc sgplot data=crypto_data;
    where Label contains "Dollar Index";
    vbar Cryptocurrency / response=Correlation_r 
                          datalabel 
                          categoryorder=respasc
                          fillattrs=(color=CXE74C3C);
    yaxis label="Pearson Correlation Coefficient (r)";
    xaxis label="Cryptocurrency Symbol";
    
    refline 0 / axis=y lineattrs=(thickness=1 color=black);
    
    /* Mean (mu) reference line */
    refline &dxy_mean / axis=y lineattrs=(thickness=2 color=black pattern=dash) 
                        label="Mean (&dxy_mean)" labelloc=inside;
run;
title;