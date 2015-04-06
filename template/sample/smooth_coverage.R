library(RMySQL)
library(calibrate)
library(plotrix)
library(zoo)

m <- dbDriver("MySQL")

con <-dbConnect(m,username="mysql_username",password="mysql_passwd",dbname="mysql_db",host="mysql_host");

directory_path = "sample_path";

setwd(directory_path);

source("scripts_location/R_function.R");

input_table_name <- "cnv_sample_name_over_control_name_n_bowtie_bwa_ratio_gene_norm";
output_table_name <- "cnv_sample_name_tso_over_control_name_n_bowtie_bwa_ratio_gene_out";
window_length <- 200;

res=try(cnv_smooth_coverages(con, input_table_name, output_table_name, window_length));
if(class(res) == "try-error"){
   quit(save = "no", status = 1, runLast = FALSE)
}

dbDisconnect(con)
