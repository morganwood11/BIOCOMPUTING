#!/bin/bash
set -ueo pipefail

FWD_IN=$1
REV_IN=${FWD_IN/_R1_/_R2_}
FWD_OUT=${FWD_IN/.fastq/.trimmed.fastq}
REV_OUT=${REV_IN/.fastq/.trimmed.fastq}
fastp --in1 $FWD_IN \
--in2 $REV_IN \
--out1 ${FWD_OUT/subset/clean} \
--out2 ${REV_OUT/subset/clean} \
--json /dev/null \
--html /dev/null \
--trim_front1 8 \
--trim_front2 8 \
--trim_tail1 20 \
--trim_tail2 20 \
--n_base_limit 0 \
--length_required 100 \
--average_qual 20

mkdir -p ./data/raw/trimmed
mv ./data/raw/*clean* ./data/raw/trimmed
