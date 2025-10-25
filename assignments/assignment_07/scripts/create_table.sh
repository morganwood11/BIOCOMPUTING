#!/bin/bash
set -ueo pipefail
module load samtools

echo -e "Sample_ID\tQC_Reads\tDog_Mapped_Reads\tPercent_Dog" > ./output/dog_mapping_summary.tsv

for BAM in /sciclone/home/mrwood01/BIOCOMPUTING/assignments/assignment_07/output/SRR*_mapped_sorted.bam; do
    SAMPLE=$(basename "$BAM" _mapped_sorted.bam)

    # count reads mapped to dog genome
    DOG_MAPPED=$(samtools view -c -F 4 "$BAM")

    # total QC reads
    if [[ -f ${SAMPLE}.bam ]]; then
        QC_READS=$(samtools view -c ${SAMPLE}.bam)
    else
        QC_READS=0
    fi

    # calculate percentage
    if [[ $QC_READS -gt 0 ]]; then
        PCT=$(echo "scale=6; ($DOG_MAPPED/$QC_READS)*100" | bc)
    else
        PCT=0
    fi

    echo -e "${SAMPLE}\t${QC_READS}\t${DOG_MAPPED}\t${PCT}" | tee -a ./output/dog_mapping_summary.tsv
done
