/* STEP 1: Define LTC File Path */
%let file_path = /home/u64447590/LTC/Litecoin_ready.csv;

/* STEP 2: Data Processing */
data work.ltc_data;
    infile "&file_path" dlm=';' firstobs=2 dsd;
    length Symbol $10 Date_str $15 Price_str $32 Vol_str $32 Mcap_str $32 Fed_str $32 M2_str $32 Dollar_str $32;
    input Symbol $ Date_str $ Price_str $ Vol_str $ Mcap_str $ Fed_str $ M2_str $ Dollar_str $;

    /* Convert date and handle comma-to-dot conversion for numeric fields */
    Date_sas = input(Date_str, anydtdte10.);
    Price_num = input(translate(Price_str, '.', ','), best32.);
    Dollar_num = input(translate(Dollar_str, '.', ','), best32.);

    format Date_sas date9. Price_num Dollar_num 12.4;
    keep Date_sas Price_num Dollar_num;
run;

/* STEP 3: Plot LTC vs DXY */
title "Litecoin (LTC) Price and Dollar Index (DXY) Comparison";
proc sgplot data=work.ltc_data;
    /* Primary Y-Axis: LTC Price (Logarithmic) */
    series x=Date_sas y=Price_num / lineattrs=(thickness=2 color=blue) 
           name="ltc_line" legendlabel="LTC Price";
    
    /* Secondary Y-Axis: Dollar Index */
    series x=Date_sas y=Dollar_num / y2axis 
           lineattrs=(thickness=2 color=red pattern=dot) 
           name="dxy_line" legendlabel="Dollar Index (DXY)";

    xaxis label="Date" interval=month grid;
    yaxis label="LTC Price (Log Scale)" type=log grid;
    y2axis label="Dollar Index (DXY) Value" grid;
    keylegend "ltc_line" "dxy_line" / position=topright;
run;
title;