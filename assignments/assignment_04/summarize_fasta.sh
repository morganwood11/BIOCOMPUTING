#!/bin/bash

fasta_file="$1"
temp_file=$(mktemp)
seqtk comp "$fasta_file" > "$temp_file"
sequences=$(wc -l < "$temp_file")
cut -f2 "$temp_file" > "${temp_file}_lengths"

#sums lengths and bases
sum_lengths=$(paste -sd+ "${temp_file}_lengths")
sum_bases=$(echo "$sum_lengths" | bc)

#output work
echo "file: $fasta_file"
echo "Total number of sequences: $sequences"
echo "Total number of nucleotides: $sum_bases"
echo "Sequence name and length table:"
cut -f1,2 "$temp_file"

#cleanup space
rm -f "$temp_file" "${temp_file}_lengths"
