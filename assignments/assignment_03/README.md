#!/bin/bash

####Morgan Wood		9/17/2025
###Assignment 3: Exploring DNA Sequence Files with Command Line Tools

##Task 1: Navigate to Assignment 3 Directory; set up
ssh mrwood01@bora.sciclone.wm.edu

cd BIOCOMPUTING/assignments/
mkdir assignment_0{3..8} 	#already have 1 and 2 made
cd assignment_03
mkdir data
touch README.md

##Task 2: Download fasta sequence file 
cd data
wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz
gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz

##Task 3: Use Unix Tools to explore the file contents 

#How many sequences are in the fasta file? (7)
grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l

#What is the total number of nucleotides? (119,668,634)
grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna | tr -d "\n" | wc -m

#How many total lines are in the file? (1,495,867) 
awk '/^>/ {print; next} {print $0 | "fold -w80"}' GCF_000001735.4_TAIR10.1_genomic.fna > reformatted_80wrap.fna
wc -l reformatted_80wrap.fna 	#kept getting 14 total lines because each sequence existed on one line 

#How many header lines contain the word "mitochondrion"? (1) 
grep -owi "mitochondrion" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l

#How many header lines contain the word "chromosome"? (5)
grep -owi "chromosome" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l

#How many nucleotides are in each of the first 3 chromosome sequences? 
grep -n "^>.*chromosome" GCF_000001735.4_TAIR10.1_genomic.fna | head -3
sed -n '2p' GCF_000001735.4_TAIR10.1_genomic.fna | tr -d '\n' | wc -m
	#30,427,672
sed -n '4p' GCF_000001735.4_TAIR10.1_genomic.fna | tr -d '\n' | wc -m
	#19,698,290
sed -n '6p' GCF_000001735.4_TAIR10.1_genomic.fna | tr -d '\n' | wc -m
	#23,459,831

#How many nucleotides are in the sequence for chromosome 5? (26975503)
grep -n "^>.*chromosome 5" GCF_000001735.4_TAIR10.1_genomic.fna
sed -n '10p' GCF_000001735.4_TAIR10.1_genomic.fna | wc -m 

#How many sequences contain "AAAAAAAAAAAAAAAA"? (1)
grep "AAAAAAAAAAAAAAAA" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l

#Sorting alphabetically, which header would be first? (>NC_000932.1)
grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna | sort | head -n 1

#Tab separated version: headers first column, sequences second column
grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna > headers
grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna > sequences
paste headers sequences

##Task 5: Reflection
echo "My overall approach was to try to utilize the commands and processes we 
learned in class so that I could better understand what we have discussed 
so far. I learned that you can combine a bunch of the same commands 
numerous ways and it allow you to perform so many different functions 
and learn so much about one file. Some of the tools that surprised me was 
sed and awk, mainly because we have not really talked about them much. 
I thought sed was pretty useful and was glad I used it for a couple 
of the questions. I only decided to use awk because the normal commands
we have gone over to figure out number of lines was consistently giving
me 14 lines. I believe this was because each sequence was being 
evaluated as all on one line, so it was consistently wrong and I had to 
change the wrapping of each line so it would produce the correct answer.
That was the most frustrating part of the commands and methods I used. 
As far as computational biology, many of these skills are critical for 
being able to break down sequence files, search via primers or specific
sections of sequences, cutting where we know certain genes are, etc. We 
can also search for variation (mutations) in sequences that we may be 
looking for, or places where we inserted/deleted genes. Without the ability
to use these commands effectively, it would be extremely hard to filter 
through loads and loads of sequences containing millions (and billions) 
of nucleotides. This is honestly extremely useful for my project because 
when I begin sequencing later down the line, I will be using many of these
exact same commands to sift through tons of files to find any genetic 
variation (new/fixed mutations) that were not present prior to my 
evolution experiment. In terms of automating my solution, I could 
definitely be quicker at the command line in general. Even just using the 
up arrow to repeat commands or slightly tweak something to fix a command, 
I feel like I am constantly remembering that I can do it, rather than 
not even thinking and it being my automatic reaction. Also, I feel like 
I need to practice more to have the commands better memorized, and I need 
to memorize more of the flags and their uses so that I am not constantly 
referring to my notes to do a new task."
