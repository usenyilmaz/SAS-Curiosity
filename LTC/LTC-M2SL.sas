/* STEP 1: Data Processing (Reading M2SLCHANGE) */
data work.ltc_m2;
    infile "/home/u64447590/LTC/Litecoin_ready.csv" dlm=';' firstobs=2 dsd;
    length Symbol $10 Date_str $15 Price_str $32 Vol_str $32 Mcap_str $32 Fed_str $32 M2_str $32 Dollar_str $32;
    input Symbol $ Date_str $ Price_str $ Vol_str $ Mcap_str $ Fed_str $ M2_str $ Dollar_str $;

    Date_sas = input(Date_str, anydtdte10.);
    Price_num = input(translate(Price_str, '.', ','), best32.);
    M2_num = input(translate(M2_str, '.', ','), best32.);

    format Date_sas date9. Price_num M2_num 12.4;
    keep Date_sas Price_num M2_num;
run;

/* STEP 2: Plot LTC vs M2 */
title "Litecoin (LTC) Price and M2 Money Supply Comparison";
proc sgplot data=work.ltc_m2;
    series x=Date_sas y=Price_num / lineattrs=(thickness=2 color=blue) 
           name="ltc_line" legendlabel="LTC Price";
    
    series x=Date_sas y=M2_num / y2axis 
           lineattrs=(thickness=2 color=darkgreen) 
           name="m2_line" legendlabel="M2 Money Supply Change";

    xaxis label="Date" interval=month grid;
    yaxis label="LTC Price (Log Scale)" type=log grid;
    y2axis label="M2 Money Supply Change" grid;
    keylegend "ltc_line" "m2_line" / position=topright;
run;
title;