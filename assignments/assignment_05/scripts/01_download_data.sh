#!/bin/bash
set -ueo pipefail

#within assignment_05 directory
wget https://gzahn.github.io/data/fastq_examples.tar
tar -xf fastq_examples.tar
gunzip 6*
mv 6* ./data/raw
rm fastq_examples.tar
