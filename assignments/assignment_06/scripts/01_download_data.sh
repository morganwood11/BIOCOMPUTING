#!/bin/bash
set -ueo pipefail

cd data 	#in assignment 6 directory
wget https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz
gunzip SRR33939694.fastq.gz
