####Morgan Wood		9/10/2025

###This is assignment 2: HPC Access and Remote File Transfer

##Task 1: set up your semester workspace on the HPC

#sign into the HPC cluster
ssh mrwood01@bora.sciclone.wm.edu
#type in password when prompted (not going to type that out lol)

#create base course structure 
mkdir ~/BIOCOMPUTING/{notes,projects,practice} 	#already have assignments directory from git clone
mkdir ~/BIOCOMPUTING/assignments/assignment_02
mkdir ~/BIOCOMPUTING/assignments/assignment_02/data
touch ~/BIOCOMPUTING/assignments/assignment_02/README.md

exit 	#task two begins on local computer 

##Task 2: Download files from NCBI via command-line FTP
#within the NCBI FTP server:
ftp ftp.ncbi.nlm.nih.gov
anonymous	#enter this when prompted for username
mrwood01	 #school username as  password 
passive 	#enter passive mode; removes time limit within network 
cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/
get GCF_000005845.2_ASM584v2_genomic.fna.gz
get GCF_000005845.2_ASM584v2_genomic.gff.gz
bye
#in local terminal: 
mv GCF_000005845.2_ASM584v2_genomic.fna.gz Desktop
mv GCF_000005845.2_ASM584v2_genomic.gff.gz Desktop
cd Desktop
mv GCF_000005845.2_ASM584v2_genomic.fna.gz biocomputing/BIOCOMPUTING/assignments/assignment_02
mv GCF_000005845.2_ASM584v2_genomic.gff.gz biocomputing/BIOCOMPUTING/assignments/assignment_02

##Task 3: File Transfer and Permissions
#3.1: move files to HPC via FileZilla
connect using SFTP:
	host: bora.sciclone.wm.edu
	username: mrwood01
	password: password 
	Port: 22
	protocol: SFTP
drag files from ~/BIOCOMPUTING/assignments/assignment_02 to HPC: ~/BIOCOMPUTING/assignments/assignment_02/data/
#3.2: Ensure files are world-readable
chmod a+r GCF_000005845.2_ASM584v2_genomic.fna.gz	#allows everyone to read the file
chmod a+r GCF_000005845.2_ASM584v2_genomic.gff.gz	#same as previous line

##Task 4: Verify File Integrity with md5sum
#on local machine (still within assignment_02 as pwd): 
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz

#on the HPC:
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz

nano README.md
copy and paste MD5 hashes into README.md:
#MD5 hashes from local machine for files downloaded from NCBI FTP server:
e1b894042b53655594a1623a7e0bb63f  GCF_000005845.2_ASM584v2_genomic.fna.gz
494dc5999874e584134da5818ffac925  GCF_000005845.2_ASM584v2_genomic.gff.gz

#MD5 hashes from HPC for files downloaded from NCBI FTP server:
e1b894042b53655594a1623a7e0bb63f  GCF_000005845.2_ASM584v2_genomic.fna.gz
494dc5999874e584134da5818ffac925  GCF_000005845.2_ASM584v2_genomic.gff.gz
	#the MD5 hashes match, so document data is intact both locally and on HPC

control 'o', return, control 'x' to save and get out 

##Task 5: Create useful bash aliases
cd 	#return to home within HPC
nano .bashrc
#type aliases into .bashrc file with HPC
alias u='cd ..;clear;pwd;ls -alFh --group-directories-first'
	#alias u means: change directory up one level(parent directory); clear screen; print working directory; list all, long form, human-readable, use detailed view, with the directories listed first 
alias d='cd -;clear;pwd;ls -alFh --group-directories-first'
	#alias d means: change directory to previous; clear screen; print working directory; list all, long-form, human-readable, use detailed view, with directories listed first  
alias ll='ls -alFh --group-directories-first'
	#alias ll means: list all, long-form, human-readable, use detailed view, with directories listed first

control 'o', return, control 'x' to save and get out

source ~/.bashrc 	#enables aliases 
exit 		#to exit HPC and return to local 

#submitting assignment 2
in FileZilla, drag assignment_02 directory from the HPC over to the ~/Desktop/biocomputing/BIOCOMPUTING/assignments directory 
in local machine: 
cd Desktop/biocomputing/BIOCOMPUTING
git status
git add assignment_02
git commit -m "submit assignment_02"
git push 

##reflection for assignment 2
All of the tasks except for task 2 were fairly straightforward. Task 2 was a little bit tougher 
because it was harder to figure out exactly what the FTP server wanted, and the time limit to 
sign in threw me off in the beginning. I also kept hitting the 60 second time limit when I was 
working on downloading the files, so that is why I added the passive command in there because I 
was frankly getting frustrated since it felt like a race. I think the main thing I would like 
to go over is understanding what exactly happens to our repositories when we move them from
one machine to the next. Does our local BIOCOMPUTING directory get overwritten? Is it just 
updated? Are files in duplicate when we move them, or replaced with the updated version? I know
that GitHub helps with this, but I do not understand how it exactly keeps all of this 
information succinct and how these problems do not arise. 
