#### Morgan Wood 		10/1/2025
###Assignment 5 

##Task 1: Setup Assignment 5 directory
#sign into HPC bora
ssh mrwood01@bora.sciclone.wm.edu
#enter password
cd BIOCOMPUTING/assignments/assignment_05
mkdir data data/raw data/trimmed log scripts

##Task 2: Script to download and prepare fastq data
cd scripts
nano 01_download_data.sh
#type all of this (below) into file
	# #!/bin/bash
	# set -ueo pipefail

	# #within assignment_05 directory
	# wget https://gzahn.github.io/data/fastq_examples.tar
	# tar -xf fastq_examples.tar
	# gunzip 6*
	# mv 6* ./data/raw
	# rm fastq_examples.tar
chmod +x 01_download_data.sh
cd .. 	#return to assignment_05 directory to run script 

##Task 3: Install and explore the fastp tool
wget http://opengene.org/fastp/fastp
chmod a+x fastp
mv fastp ~/programs/
export PATH=$PATH:/sciclone/home/mrwood01/programs/fastp
cd
nano .bashrc 		#doing echo " " >> ~/.bashrc pastes my entire path into the file and I don't understand why
#type into file: 
	#export PATH=$PATH:/sciclone/home/mrwood01/programs/fastp
	#save, etc to get out of file
fastp --help 		#explore options within this program for understanding

##Task 4: Script to run fastp
cd BIOCOMPUTING/assignments/assignments_05/scripts
nano 02_run_fastp.sh
#type all of this (below) into file
	# #!/bin/bash
	# set -ueo pipefail
	# 
	# FWD_IN=$1
	# REV_IN=${FWD_IN/_R1_/_R2_}
	# FWD_OUT=${FWD_IN/.fastq/.trimmed.fastq}
	# REV_OUT=${REV_IN/.fastq/.trimmed.fastq}
	# fastp --in1 $FWD_IN \
	# --in2 $REV_IN \
	# --out1 ${FWD_OUT/subset/clean} \
	# --out2 ${REV_OUT/subset/clean} \
	# --json /dev/null \
	# --html /dev/null \
	# --trim_front1 8 \
	# --trim_front2 8 \
	# --trim_tail1 20 \
	# --trim_tail2 20 \
	# --n_base_limit 0 \
	# --length_required 100 \
	# --average_qual 20
	# 
	# mkdir -p ./data/raw/trimmed
	# mv ./data/raw/*clean* ./data/raw/trimmed
#save, close, etc

chmod +x 02_run_fastp.sh
cd .. 		#back to assignment_05 directory
./scripts/02_run_fastp.sh ./data/raw/6083_001_S1_R1_001.subset.fastq 	#to check 02_run_fastp

##Task 5: write pipeline.sh script 
nano pipeline.sh
#type all of this (below) into file
	# #!/bin/bash
	# set -ueo pipefail

	# #within assignment_05 directory
	# ./scripts/01_download_data.sh   #downloads the files
	# for i in ./data/raw/*_R1_*; do ./scripts/02_run_fastp.sh $i; done
#save, close, etc.
chmod +x pipeline.sh

##Task 6: delete all files and start over
cd data/raw
rm 6*
cd ../..	#back to assignment_05 directory
./pipeline.sh 	#run pipeline.sh

cd ~/BIOCOMPUTING/
nano .gitignore
assignments/assignment_05/data 		#adding this so that git push is not a nightmare
##Task 7: Document everything
This pipeline will download tarball files, extract them, g-unzip them, and run the fastp program 
on those files. 

My biggest challenge was creating the run_fastp script because I kept getting small things wrong
(like the name changes and moving to a new directory) that would mess up the output. My general 
script was right, but the naming and where files were moving was wrong. I think I am slowly 
getting the hang of script writing and how to utilize scripts and pipelines to do a lot of work 
in a short span of time and less "manual" labor than the brute force way. I think I need to 
work on the calling variables aspect of script writing and how changing names works within this.
The main reason I believe we split this assignment up into multiple scripts and then a final 
pipeline is because it allows us to more easily perform sanity checks on different parts of 
a script, rather than running the entire pipeline outright and hoping for the best. This is the 
easiest way to tell which part went wrong, which thing we may want to change to get a better 
result, etc. The pro is that we can troubleshoot much more easily; however, it also does take 
more time and effort to write three scripts as opposed to one. I personally prefer this because 
I mess up all the time so it was very easy for me to figure out which script I needed to fix 
when it was wrong, rather than parsing through one very long (potentially complicated) script. 
