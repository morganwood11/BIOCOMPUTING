#!/bin/bash
set -ueo pipefail

./scripts/01_prep_data.sh 	#downloading data, moving them to a data directory, and tar unzip them to extract 
./scripts/02_get_stats.sh 	#getting stats on downloaded files and putting the output into a .txt file
./scripts/03_cleanup.sh 	#removing the tar gunzipped data file that we extracted from 

echo "success"

