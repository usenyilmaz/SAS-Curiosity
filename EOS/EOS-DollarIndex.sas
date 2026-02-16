/* STEP 1: Define EOS File Path */
%let file_path = /home/u64447590/EOS/EOS_ready.csv;

/* STEP 2: Data Processing */
data work.eos_data;
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

/* STEP 3: Plot EOS vs DXY */
title "EOS Price and Dollar Index (DXY) Comparison";
proc sgplot data=work.eos_data;
    /* Primary Y-Axis: EOS Price (Logarithmic) */
    series x=Date_sas y=Price_num / lineattrs=(thickness=2 color=blue) 
           name="eos_line" legendlabel="EOS Price";
    
    /* Secondary Y-Axis: Dollar Index */
    series x=Date_sas y=Dollar_num / y2axis 
           lineattrs=(thickness=2 color=red pattern=dot) 
           name="dxy_line" legendlabel="Dollar Index (DXY)";

    xaxis label="Date" interval=month grid;
    yaxis label="EOS Price (Log Scale)" type=log grid;
    y2axis label="Dollar Index (DXY) Value" grid;
    keylegend "eos_line" "dxy_line" / position=topright;
run;
title;