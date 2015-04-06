library(RMySQL);
library(diptest);

m <- dbDriver("MySQL")
con <-dbConnect(m,username="mysql_username",password="mysql_passwd",dbname="mysql_db",host="mysql_host");
source("scripts_location/R_function.R");

input_table="sample_name_tso_one_window_het_raw_data";
out_output="sample_name_window_data";

res=try(cnv_aggregate_data_window(con,input_table,out_output));
if(class(res) == "try-error"){
   quit(save = "no", status = 1, runLast = FALSE)
}

dbDisconnect(con);
