proc sgplot data=work.data;

  series x=Date_sas y=Price_num / lineattrs=(thickness=2) name="btc";


  series x=Date_sas y=DOLLAR_INDEX_num / y2axis 
         lineattrs=(pattern=dot thickness=2) name="dxy";

  xaxis type=time 
        interval=month
        fitpolicy=thin
        label="Date"
        grid;

  yaxis label="BTC Price"
        type=log
        grid;

  y2axis label="DOLLAR INDEX"
         grid;

  keylegend "btc"  "dxy" / position=topright;

run;
