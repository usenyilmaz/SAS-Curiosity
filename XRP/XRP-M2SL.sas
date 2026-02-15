/* 1. STEP: Define the file path */
/* Update this path if it's different in your SAS Studio environment */
%let file_path = /home/u64447590/XRP/XRP_ready.csv;

/* 2. STEP: Read and Process the Data */
data work.xrp_data;
    infile "&file_path" dlm=';' firstobs=2 dsd;
    /* Define temporary strings for all columns to handle comma-decimal conversion */
    length Symbol $10 Date_str $15 Price_str $32 Vol_str $32 Mcap_str $32 Fed_str $32 M2_str $32 Dollar_str $32;
    input Symbol $ Date_str $ Price_str $ Vol_str $ Mcap_str $ Fed_str $ M2_str $ Dollar_str $;

    /* Convert date string to SAS Date format (DD.MM.YYYY) */
    Date_sas = input(Date_str, anydtdte10.);
    
    /* Convert comma-decimal strings to numeric (e.g., 0,56 to 0.56) */
    Price_num = input(translate(Price_str, '.', ','), best32.);
    M2_num = input(translate(M2_str, '.', ','), best32.);

    format Date_sas date9. Price_num M2_num 12.4;
    /* Keep only necessary variables for the plot */
    keep Date_sas Price_num M2_num;
run;

/* 3. STEP: Generate the Plot comparing XRP and M2 Money Supply */
title "XRP Price and M2 Money Supply Comparison";

proc sgplot data=work.xrp_data;
    /* Primary Y-Axis: XRP Price (Logarithmic) */
    series x=Date_sas y=Price_num / lineattrs=(thickness=2 color=blue) 
           name="xrp_line" legendlabel="XRP Price";
    
    /* Secondary Y-Axis (Right): M2 Money Supply Change */
    series x=Date_sas y=M2_num / y2axis 
           lineattrs=(thickness=2 color=darkgreen pattern=solid) 
           name="m2_line" legendlabel="M2 Money Supply Change";

    /* Axis Customization */
    xaxis label="Date" interval=month grid;
    yaxis label="XRP Price (Log Scale)" type=log grid;
    y2axis label="M2 Money Supply Change" grid;

    /* Legend Setup */
    keylegend "xrp_line" "m2_line" / position=topright;
run;

title; /* Clear title after execution */