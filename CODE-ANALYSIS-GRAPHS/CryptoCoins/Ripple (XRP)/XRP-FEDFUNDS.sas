/* 1. STEP: Define the file path */
%let file_path = /home/u64447590/XRP/XRP_ready.csv;

/* 2. STEP: Read and Process the Data */
data work.xrp_data;
    infile "&file_path" dlm=';' firstobs=2 dsd;
    /* Define temporary strings for columns to handle comma-decimal conversion */
    length Symbol $10 Date_str $15 Price_str $32 Vol_str $32 Mcap_str $32 Fed_str $32 M2_str $32 Dollar_str $32;
    input Symbol $ Date_str $ Price_str $ Vol_str $ Mcap_str $ Fed_str $ M2_str $ Dollar_str $;

    /* Convert date string to SAS Date format (DD.MM.YYYY) */
    Date_sas = input(Date_str, anydtdte10.);
    
    /* Convert comma-decimal strings to numeric (e.g., 0,08 to 0.08) */
    Price_num = input(translate(Price_str, '.', ','), best32.);
    Fed_num = input(translate(Fed_str, '.', ','), best32.);

    format Date_sas date9. Price_num Fed_num 12.4;
    /* Keep only necessary variables for the plot */
    keep Date_sas Price_num Fed_num;
run;

/* 3. STEP: Generate the Plot comparing XRP and FED Funds Rate */
title "XRP Price and FED Funds Rate Comparison";

proc sgplot data=work.xrp_data;
    /* Primary Y-Axis: XRP Price (Logarithmic) */
    series x=Date_sas y=Price_num / lineattrs=(thickness=2 color=blue) 
           name="xrp_line" legendlabel="XRP Price";
    
    /* Secondary Y-Axis (Right): FED Funds Rate */
    series x=Date_sas y=Fed_num / y2axis 
           lineattrs=(thickness=2 color=darkorange pattern=solid) 
           name="fed_line" legendlabel="FED Funds Rate (%)";

    /* Axis Customization */
    xaxis label="Date" interval=month grid;
    yaxis label="XRP Price (Log Scale)" type=log grid;
    y2axis label="FED Funds Rate (%)" grid;

    /* Legend Setup */
    keylegend "xrp_line" "fed_line" / position=topright;
run;

title;