#!/bin/bash
set -euo pipefail

mkdir -p /sciclone/home/mrwood01/BIOCOMPUTING/assignments/assignment_07/output

#map quality filtered reads against dog reference genome
REF="/sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/dog_reference/ncbi_dataset/data/GCF_011100685.1/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fna" 

#build index
bbmap.sh -Xmx26g ref="$REF"

#loop through clean reads and map
for FWD in /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/clean/*_1.fastq;do
REV=${FWD/_1.fastq/_2.fastq}
BASE=$(basename "$FWD" _1.fastq)
OUT=/sciclone/home/mrwood01/BIOCOMPUTING/assignments/assignment_07/output/${BASE}_mapped_to_dog.sam
bbmap.sh -Xmx16g in1=$FWD in2=$REV out=$OUT minid=0.95
done

# extract reads that matched dog genome
for SAM in /sciclone/home/mrwood01/BIOCOMPUTING/assignments/assignment_07/output/*_mapped_to_dog.sam;do
BASE=$(basename "$SAM" _mapped_to_dog.sam)
BAM=/sciclone/home/mrwood01/BIOCOMPUTING/assignments/assignment_07/output/${BASE}.bam
MAPPED_BAM=/sciclone/home/mrwood01/BIOCOMPUTING/assignments/assignment_07/output/${BASE}_mapped.bam
SORTED_BAM=/sciclone/home/mrwood01/BIOCOMPUTING/assignments/assignment_07/output/${BASE}_mapped_sorted.bam
samtools view -S -b "$SAM" > "$BAM"
samtools view -b -F 4 "$BAM" > "$MAPPED_BAM"
samtools sort "$MAPPED_BAM" -o "$SORTED_BAM"
samtools index "$SORTED_BAM"
done
