#!/bin/bash
mysql -h hostname -u username -pXXXX database < tso_exon_60bp_segments_main_data.sql
mysql -h hostname -u username -pXXXX database < tso_reference_exon.sql
mysql -h hostname -u username -pXXXX database < tso_exon_contig_pileup.sql
mysql -h hostname -u username -pXXXX database < tso_exon_60bp_segments_pileup.sql
mysql -h hostname -u username -pXXXX database < tso_exon_60bp_segments_window_data.sql
mysql -h hostname -u username -pXXXX database < tso_windows_padded_pileup.sql
mysql -h hostname -u username -pXXXX database < tso_data.sql
mysql -h hostname -u username -pXXXX database < training_data.sql
mysql -h hostname -u username -pXXXX database < tso_reference.sql
