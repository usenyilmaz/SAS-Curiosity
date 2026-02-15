proc import datafile="/home/u64447590/mydata/coin_Aave.csv"
     out=work.my_aave_data
     dbms=csv
     replace;
     getnames=yes;
run;