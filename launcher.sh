#!/bin/bash 
echo "Creating scripts ..."
FILE=$1
current_path=$(pwd)
echo "Current directory is: $current_path"
while read line;do
	if [[ $line =~ control_name ]]; then
		IFS='=' read -a array <<< "$line"
		control_name=${array[1]}
	fi
	if [[ $line =~ control_bwa_no_dup ]]; then
		IFS='=' read -a array <<< "$line"
		control_bwa_no_dup=${array[1]}
	fi
	if [[ $line =~ control_bwa ]]; then
		IFS='=' read -a array <<< "$line"
		control_bwa=${array[1]}
	fi
	if [[ $line =~ control_bowtie ]]; then
		IFS='=' read -a array <<< "$line"
		control_bowtie=${array[1]}
	fi
	if [[ $line =~ sample_name ]]; then
		IFS='=' read -a array <<< "$line"
		sample_name=${array[1]}
	fi
	if [[ $line =~ sample_bwa_no_dup ]]; then
		IFS='=' read -a array <<< "$line"
		sample_bwa_no_dup=${array[1]}
	fi
	if [[ $line =~ sample_bwa ]]; then
		IFS='=' read -a array <<< "$line"
		sample_bwa=${array[1]}
	fi
	if [[ $line =~ sample_bowtie ]]; then
		IFS='=' read -a array <<< "$line"
		sample_bowtie=${array[1]}
	fi
	if [[ $line =~ mysql_host ]]; then
		IFS='=' read -a array <<< "$line"
		mysql_host=${array[1]}
	fi
	if [[ $line =~ mysql_username ]]; then
		IFS='=' read -a array <<< "$line"
		mysql_username=${array[1]}
	fi
	if [[ $line =~ mysql_passwd ]]; then
		IFS='=' read -a array <<< "$line"
		mysql_passwd=${array[1]}
	fi
	if [[ $line =~ mysql_db ]]; then
		IFS='=' read -a array <<< "$line"
		mysql_db=${array[1]}
	fi
	if [[ $line =~ training ]]; then
		IFS='=' read -a array <<< "$line"
		training=${array[1]}
	fi
	if [[ $line =~ ordered_genes ]]; then
		IFS='=' read -a array <<< "$line"
		ordered_genes=${array[1]}
	fi
	if [[ $line =~ email ]]; then
		IFS='=' read -a array <<< "$line"
		email=${array[1]}
	fi
done < $FILE
	
scripts_location="$current_path/scripts"
template_pwd="$current_path/template"
control_path="$current_path/$control_name"
sample_path="$current_path/$sample_name"

# ######################################################################### CREARE DIRECTORIES

mkdir -p $sample_path
mkdir -p $control_path

# ######################################################################### SCRIPTS FOR CONTROL
# NOTE: You can use "sed s,find,replace,g foo.txt" instead of "sed s/find/replace/g foo.txt"
# 
# If we use "," as a separator character, we won't need to worry about escaping the forward slashes.
# in the file paths

# DATABASE TABLE CLEAN-UP SCRIPTS FOR CONTROL 
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g \
< "$template_pwd/control/clean_tables.sql" > "$control_path/clean_tables.sql"
# PBS SCRIPT FOR LOADING CONTROL 
sed -e s,control_path,"$control_path",g -e s,control_name,"$control_name",g -e s,mysql_login,"$mysql_login",g -e s,scripts_location,"$scripts_location",g \
-e s,mysql_host,"$mysql_host",g -e s,mysql_username,"$mysql_username",g -e s,mysql_passwd,"$mysql_passwd",g -e s,mysql_db,"$mysql_db",g \
-e s,sample_email@umn.edu,"$email",g \
< "$template_pwd/control/load_control.pbs" > "$control_path/load_$control_name.pbs"
# SQL SCRIPT FOR LOADING CONTROL 
sed -e s,control_name,"$control_name",g -e s,control_bwa_no_dup,"$control_bwa_no_dup",g -e s,control_bwa,"$control_bwa",g -e s,control_bowtie,"$control_bowtie",g \
< "$template_pwd/control/load_control.sql" > "$control_path/load_control.sql"

# ######################################################################### SCRIPTS FOR SAMPLE
# DATABASE TABLE CLEAN-UP SCRIPTS FOR SAMPLE
# clean_tables.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/clean_tables.sql" > "$sample_path/clean_tables.sql"
# cnv_tables.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/cnv_tables.sql" > "$sample_path/cnv_tables.sql"
# create_control_coverage.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/create_control_coverage.sql" > "$sample_path/create_control_coverage.sql"
# create_coverage.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/create_coverage.sql" > "$sample_path/create_coverage.sql"
# create_reference.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/create_reference.sql" > "$sample_path/create_reference.sql"
# create_sample_coverage.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/create_sample_coverage.sql" > "$sample_path/create_sample_coverage.sql"
# create_tables_part1.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/create_tables_part1.sql" > "$sample_path/create_tables_part1.sql"
# create_tables_part2.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/create_tables_part2.sql" > "$sample_path/create_tables_part2.sql"
# create_tables_part3.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/create_tables_part3.sql" > "$sample_path/create_tables_part3.sql"
# create_tables_ref_v1.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/create_tables_ref_v1.sql" > "$sample_path/create_tables_ref_v1.sql"
# create_tables_ref_v2.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/create_tables_ref_v2.sql" > "$sample_path/create_tables_ref_v2.sql"
# get_cnv.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/get_cnv.sql" > "$sample_path/get_cnv.sql"
# load_sample.sql
sed -e s,sample_name,"$sample_name",g -e s,sample_bwa_no_dup,"$sample_bwa_no_dup",g -e s,sample_bwa,"$sample_bwa",g -e s,sample_bowtie,"$sample_bowtie",g \
< "$template_pwd/sample/load_sample.sql" > "$sample_path/load_sample.sql"
# output.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g < "$template_pwd/sample/output.sql" > "$sample_path/output.sql"
# run_sample.pbs
sed -e s,sample_path,"$sample_path",g -e s,sample_name,"$sample_name",g -e s,control_name,"$control_name",g -e s,scripts_location,"$scripts_location",g \
-e s,mysql_host,"$mysql_host",g -e s,mysql_username,"$mysql_username",g -e s,mysql_passwd,"$mysql_passwd",g -e s,mysql_db,"$mysql_db",g \
-e s,sample_email@umn.edu,"$email",g \
< "$template_pwd/sample/run_sample.pbs" > "$sample_path/run_cnv_$sample_name.pbs"
# create_tables_ref.R
sed -e s,sample_path,"$sample_path",g -e s,sample_name,"$sample_name",g -e s,control_name,"$control_name",g -e s,scripts_location,"$scripts_location",g \
-e s,mysql_host,"$mysql_host",g -e s,mysql_username,"$mysql_username",g -e s,mysql_passwd,"$mysql_passwd",g -e s,mysql_db,"$mysql_db",g \
< "$template_pwd/sample/create_tables_ref.R" > "$sample_path/create_tables_ref.R"
# find_median.R
sed -e s,sample_path,"$sample_path",g -e s,sample_name,"$sample_name",g -e s,control_name,"$control_name",g -e s,r_login,"$r_login",g -e s,scripts_location,"$scripts_location",g \
-e s,mysql_host,"$mysql_host",g -e s,mysql_username,"$mysql_username",g -e s,mysql_passwd,"$mysql_passwd",g -e s,mysql_db,"$mysql_db",g \
< "$template_pwd/sample/find_median.R" > "$sample_path/find_median.R"
# normalize_coverage.R
sed -e s,sample_path,"$sample_path",g -e s,sample_name,"$sample_name",g -e s,control_name,"$control_name",g -e s,r_login,"$r_login",g -e s,scripts_location,"$scripts_location",g \
-e s,mysql_host,"$mysql_host",g -e s,mysql_username,"$mysql_username",g -e s,mysql_passwd,"$mysql_passwd",g -e s,mysql_db,"$mysql_db",g \
< "$template_pwd/sample/normalize_coverage.R" > "$sample_path/normalize_coverage.R"
# smooth_coverage.R
sed -e s,sample_path,"$sample_path",g -e s,sample_name,"$sample_name",g -e s,control_name,"$control_name",g -e s,r_login,"$r_login",g -e s,scripts_location,"$scripts_location",g \
-e s,mysql_host,"$mysql_host",g -e s,mysql_username,"$mysql_username",g -e s,mysql_passwd,"$mysql_passwd",g -e s,mysql_db,"$mysql_db",g \
< "$template_pwd/sample/smooth_coverage.R" > "$sample_path/smooth_coverage.R"
# plot_genes.R
sed -e s,sample_path,"$sample_path",g -e s,scripts_location,"$scripts_location",g \
-e s,mysql_host,"$mysql_host",g -e s,mysql_username,"$mysql_username",g -e s,mysql_passwd,"$mysql_passwd",g -e s,mysql_db,"$mysql_db",g \
< "$template_pwd/sample/plot_genes.R" > "$sample_path/plot_genes.R"

# create_data.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g -e s,sample_path,"$sample_path",g < "$template_pwd/sample/create_data.sql" > "$sample_path/create_data.sql"

# get_machine_learning_data.sql
sed -e s,control_name,"$control_name",g -e s,sample_name,"$sample_name",g -e s,sample_path,"$sample_path",g < "$template_pwd/sample/get_machine_learning_data.sql" > "$sample_path/get_machine_learning_data.sql"

# Create file with list of gene panel (comma delimited)
echo $ordered_genes > "$sample_path/ordered_genes_temp.txt"

# Replace comma with newline so we can load it into a MySQL database
tr , '\n' < "$sample_path/ordered_genes_temp.txt" > "$sample_path/ordered_genes.txt"

# Delete the temp file 
rm -rf "$sample_path/ordered_genes_temp.txt"

# ordered_genes.sql
sed -e s,sample_name,"$sample_name",g -e s,control_name,"$control_name",g < "$template_pwd/sample/ordered_genes.sql" > "$sample_path/ordered_genes.sql"

# aggregate_window.R
sed -e s,sample_name,"$sample_name",g -e s,sample_path,"$sample_path",g -e s,scripts_location,"$scripts_location",g \
-e s,mysql_host,"$mysql_host",g -e s,mysql_username,"$mysql_username",g -e s,mysql_passwd,"$mysql_passwd",g -e s,mysql_db,"$mysql_db",g \
< "$template_pwd/sample/aggregate_window.R" > "$sample_path/aggregate_window.R"

# combine_data.sql
sed -e s,sample_name,"$sample_name",g < "$template_pwd/sample/combine_data.sql" > "$sample_path/combine_data.sql"

# cnv_randomForest_predict.R
sed -e s,sample_name,"$sample_name",g -e s,sample_path,"$sample_path",g -e s,scripts_location,"$scripts_location",g \
-e s,mysql_host,"$mysql_host",g -e s,mysql_username,"$mysql_username",g -e s,mysql_passwd,"$mysql_passwd",g -e s,mysql_db,"$mysql_db",g \
-e s,training,"$training",g < "$template_pwd/sample/cnv_randomForest_predict.R" > "$sample_path/cnv_randomForest_predict.R"

# get_predicted.sql
sed -e s,sample_name,"$sample_name",g -e s,control_name,"$control_name",g < "$template_pwd/sample/get_predicted.sql" > "$sample_path/get_predicted.sql"
