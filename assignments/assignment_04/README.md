####Morgan Wood 	9/22/2025

###Assignment 4: Bash scripts and program PATHs

##Task 1: Make directory in $home (if not already there)
ssh mrwood01@bora.sciclone.wm.edu
mkdir programs
export PATH=$PATH:/sciclone/home/mrwood01/programs
nano .bashrc
#type into file: export PATH=$PATH:/sciclone/home/mrwood01/programs 

##Task 2: download and unpack the gh "tarball" file
cd programs
wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
tar -xzvf gh_2.74.2_linux_amd64.tar.gz
rm -r gh_2.74.2_linux_amd64.tar.gz

##Task 3: Build a bash script from Task 2
nano install_gh.sh
#type below commands into file 
	# #!/bin/bash
	wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
	#tar -xzvf gh_2.74.2_linux_amd64.tar.gz
	#rm -r gh_2.74.2_linux_amd64.tar.gz
chmod +x install_gh.sh

##Task 4: Run the install_gh.sh script
install_gh.sh

##Task 5: add location of gh binary to $PATH
export PATH=$PATH:/sciclone/home/mrwood01/programs/gh_2.74.2_linux_amd64/bin
nano ~/.bashrc
#type into file: export PATH="/sciclone/home/mrwood01/programs/gh_2.74.2_linux_amd64/bin:$PATH"

##Task 6: run gh login 
gh auth login
#choose GitHub.com
#choose HTTPS
#type Y for authenticating Git
#choose paste an authentication token
#paste GitHub account personal token
git pull

##Task 7: create another installation script for seqtk
nano install_seqtk.sh
#type below lines into script: 
# #!/bin/bash
#
#git clone https://github.com/lh3/seqtk.git
#cd seqtk
#make
#export PATH=$PATH:/sciclone/home/mrwood01/programs/seqtk
#echo "export PATH=$PATH:/sciclone/home/mrwood01/programs/seqtk" >> ~/.bashrc

##Task 8: Figure out seqtk
#from seqtk directory:
cd ../../BIOCOMPUTING/assignments/assignment_03
mv GCF_000001735.4_TAIR10.1_genomic.fna GCF_000001735.4_TAIR10.1_genomic.fasta
seqtk size GCF_000001735.4_TAIR10.1_genomic.fasta #gave number of sequences and bases
seqtk comp GCF_000001735.4_TAIR10.1_genomic.fasta #gives nucleotide composition
rm -r GCF_000001735.4_TAIR10.1_genomic.fasta 	#causing issues when pushing to github

##Task 9: write a summarize_fasta.sh script 
cd ../assignment_04
nano summarize_fasta.sh
#typed everything below into file:
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

chmod +x summarize_fasta.sh 	#executable permissions

##Task 10: run summarize_fasta.sh on multiple fasta files
#already in assignment_04 directory
mkdir data
cd data
#download data and gunzip them 
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/308/935/GCA_000308935.1_ZTW1/GCA_000308935.1_ZTW1_genomic.fna.gz
gunzip GCA_000308935.1_ZTW1_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/021/172/205/GCA_021172205.1_ASM2117220v1/GCA_021172205.1_ASM2117220v1_genomic.fna.gz
gunzip GCA_021172205.1_ASM2117220v1_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/004/014/915/GCA_004014915.1_ASM401491v1/GCA_004014915.1_ASM401491v1_genomic.fna.gz
gunzip GCA_004014915.1_ASM401491v1_genomic.fna.gz
#change file names from fna to fasta for seqtk to work 
mv GCA_000308935.1_ZTW1_genomic.fna GCA_000308935.1_ZTW1_genomic.fasta
mv GCA_021172205.1_ASM2117220v1_genomic.fna GCA_021172205.1_ASM2117220v1_genomic.fasta
mv GCA_004014915.1_ASM401491v1_genomic.fna GCA_004014915.1_ASM401491v1_genomic.fasta

#run summarize_fasta.sh on all files using for loop
for file in *.fasta; do ../summarize_fasta.sh "$file"; done 	#still in data directory

##Task 11: reflection
The hardest part of this assignment that was not technical difficulties (which happened with my gh auth login briefly) was the summarize_fasta.sh script. 
It was hard to work through because I am still a little rusty on arguments and variables, which I just need to study more. I was also struggling with the 
commands that would give me a table of what I needed for my output. I think I am slowly picking up the for loop a little better, but I think I get stuck 
because I don't realize just how much it can do and how malleable it is as long as it maintains the correct parameters. I also learned that I think I will 
find working with sequencing data to be fun, once I actually feel like I know what I am doing and can do things efficiently. $PATH is an environment variable 
that basically tells the shell where to look for the programs you want to run. That is why we have to add new programs to our $PATH (and .bashrc for permanence 
between terminal sessions) so that we can get the scripts we have written or have borrowed from other people to run properly. I think overall this assignment
forced me to work through some of the more difficult concepts that we have recently covered in class. 
