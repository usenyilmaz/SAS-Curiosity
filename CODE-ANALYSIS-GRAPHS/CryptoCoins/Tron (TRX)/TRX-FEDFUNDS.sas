/* STEP 1: Data Processing (Reading FEDFUNDS) */
data work.trx_fed;
    infile "/home/u64447590/TRON/Tron_ready.csv" dlm=';' firstobs=2 dsd;
    length Symbol $10 Date_str $15 Price_str $32 Vol_str $32 Mcap_str $32 Fed_str $32 M2_str $32 Dollar_str $32;
    input Symbol $ Date_str $ Price_str $ Vol_str $ Mcap_str $ Fed_str $ M2_str $ Dollar_str $;

    Date_sas = input(Date_str, anydtdte10.);
    Price_num = input(translate(Price_str, '.', ','), best32.);
    Fed_num = input(translate(Fed_str, '.', ','), best32.);

    format Date_sas date9. Price_num Fed_num 12.4;
    keep Date_sas Price_num Fed_num;
run;

/* STEP 2: Plot TRX vs FED Funds */
title "Tron (TRX) Price and FED Funds Rate Comparison";
proc sgplot data=work.trx_fed;
    series x=Date_sas y=Price_num / lineattrs=(thickness=2 color=blue) 
           name="trx_line" legendlabel="TRX Price";
    
    series x=Date_sas y=Fed_num / y2axis 
           lineattrs=(thickness=2 color=orange) 
           name="fed_line" legendlabel="FED Funds Rate (%)";

    xaxis label="Date" interval=month grid;
    yaxis label="TRX Price (Log Scale)" type=log grid;
    y2axis label="FED Funds Rate (%)" grid;
    keylegend "trx_line" "fed_line" / position=topright;
run;
title;