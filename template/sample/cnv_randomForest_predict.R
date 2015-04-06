library(RMySQL);
library("randomForest");

m <- dbDriver("MySQL")
con <-dbConnect(m,username="mysql_username",password="mysql_passwd",dbname="mysql_db",host="mysql_host");
source("scripts_location/R_function.R");

train="training";
test="sample_name_data";
train_data="sample_name_train_test";
res=try(cnv_normalize_scale(con,train,test,train_data));
if(class(res) == "try-error"){
   quit(save = "no", status = 1, runLast = FALSE)
}

predict_output = "sample_name_prediction";
res=try(cnv_predict(con,train_data,predict_output));
if(class(res) == "try-error"){
   quit(save = "no", status = 1, runLast = FALSE)
}

dbDisconnect(con);
