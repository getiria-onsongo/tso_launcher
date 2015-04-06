library(RMySQL)
library(calibrate)
library(plotrix)
library(zoo)

m <- dbDriver("MySQL")
con <-dbConnect(m,username="mysql_username",password="mysql_passwd",dbname="mysql_db",host="mysql_host");
dir_path = "sample_path";
setwd(dir_path);
source("scripts_location/R_function.R");
