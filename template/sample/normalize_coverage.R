library(RMySQL)
library(calibrate)
library(plotrix)
library(zoo)

m <- dbDriver("MySQL")

con <-dbConnect(m,username="mysql_username",password="mysql_passwd",dbname="mysql_db",host="mysql_host");

directory_path = "sample_path";

setwd(directory_path);

source("scripts_location/R_function.R");

input_table <- "cnv_sample_name_over_control_name_n_bowtie_bwa_ratio_gene";
output_table = "cnv_sample_name_over_control_name_n_bowtie_bwa_ratio_gene_norm";

res=try(cnv_normalize(con,input_table,output_table));
if(class(res) == "try-error"){
   quit(save = "no", status = 1, runLast = FALSE)
}

dbDisconnect(con)
