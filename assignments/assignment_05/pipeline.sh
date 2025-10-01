#!/bin/bash
set -ueo pipefail

#within assignment_05 directory
./scripts/01_download_data.sh 	#downloads the files
for i in ./data/raw/*_R1_*; do ./scripts/02_run_fastp.sh $i; done
