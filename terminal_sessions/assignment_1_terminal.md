morganwood@Morgans-MacBook-Air desktop % cd biocomputing
morganwood@Morgans-MacBook-Air biocomputing % ls
BIOCOMPUTING
morganwood@Morgans-MacBook-Air biocomputing % cd BIOCOMPUTING
morganwood@Morgans-MacBook-Air BIOCOMPUTING % ls
README.md	assignments
morganwood@Morgans-MacBook-Air BIOCOMPUTING % cd assignments
morganwood@Morgans-MacBook-Air assignments % ls
assignment_01
morganwood@Morgans-MacBook-Air assignments % mkdir assignment_1/
morganwood@Morgans-MacBook-Air assignments % ls
assignment_01	assignment_1
morganwood@Morgans-MacBook-Air assignments % cd assignment_1
morganwood@Morgans-MacBook-Air assignment_1 % mkdir data scripts results docs config logs assignment_1_essay.md README.md
morganwood@Morgans-MacBook-Air assignment_1 % ls
README.md		config			docs			results
assignment_1_essay.md	data			logs			scripts
morganwood@Morgans-MacBook-Air assignment_1 % cd data 
morganwood@Morgans-MacBook-Air data % mkdir raw clean 
morganwood@Morgans-MacBook-Air data % ls
clean	raw
morganwood@Morgans-MacBook-Air data % cd assignment_1
cd: no such file or directory: assignment_1
morganwood@Morgans-MacBook-Air data % cd  
morganwood@Morgans-MacBook-Air ~ % ls 
Applications	Downloads	Music		Zotero		model.sh
Desktop		Library		Pictures	fasta_files	raw.fastq
Documents	Movies		Public		installer.log	shell_practice
morganwood@Morgans-MacBook-Air ~ % cd desktop
morganwood@Morgans-MacBook-Air desktop % cd biocomputing
morganwood@Morgans-MacBook-Air biocomputing % ls
BIOCOMPUTING
morganwood@Morgans-MacBook-Air biocomputing % cd BIOCOMPUTING
morganwood@Morgans-MacBook-Air BIOCOMPUTING % ls
README.md	assignments
morganwood@Morgans-MacBook-Air BIOCOMPUTING % cd assignments
morganwood@Morgans-MacBook-Air assignments % ls
assignment_01	assignment_1
morganwood@Morgans-MacBook-Air assignments % cd assignment_1
morganwood@Morgans-MacBook-Air assignment_1 % ls
README.md		config			docs			results
assignment_1_essay.md	data			logs			scripts
morganwood@Morgans-MacBook-Air assignment_1 % touch ./data/raw/raw.fastq ./data/clean/clean.fastq
morganwood@Morgans-MacBook-Air assignment_1 % cd data
morganwood@Morgans-MacBook-Air data % ls
clean	raw
morganwood@Morgans-MacBook-Air data % ls -a
.	..	clean	raw
morganwood@Morgans-MacBook-Air data % ls -R
clean	raw

./clean:
clean.fastq

./raw:
raw.fastq
morganwood@Morgans-MacBook-Air data % cd ..
morganwood@Morgans-MacBook-Air assignment_1 % ls
README.md		config			docs			results
assignment_1_essay.md	data			logs			scripts
morganwood@Morgans-MacBook-Air assignment_1 % touch ./scripts/sctip.sh ./logs/logfile.log
morganwood@Morgans-MacBook-Air assignment_1 % touch ./results/example.sam
morganwood@Morgans-MacBook-Air assignment_1 % touch ./docs/example.txt
morganwood@Morgans-MacBook-Air assignment_1 % touch ./config/example.vcf
morganwood@Morgans-MacBook-Air assignment_1 % touch README.md
morganwood@Morgans-MacBook-Air assignment_1 % ls
README.md		config			docs			results
assignment_1_essay.md	data			logs			scripts
morganwood@Morgans-MacBook-Air assignment_1 % touch README.md
morganwood@Morgans-MacBook-Air assignment_1 % open README.md
morganwood@Morgans-MacBook-Air assignment_1 % code README.md 
zsh: command not found: code
morganwood@Morgans-MacBook-Air assignment_1 % xdg-open README.md 
zsh: command not found: xdg-open
morganwood@Morgans-MacBook-Air assignment_1 % nano README.md 

  GNU nano 2.0.6                      New Buffer                                          Modified  

# assignment 1

this assignment is learning project structure and rationale via the command line 

# project structure 

- data/ --> contains raw directory and clean directory; used to store data files 
- scripts/ --> contains script files 
- results/ --> contains output files
- docs/ --> contains text documents
- config/ --> contains configuration files 
- logs/ --> contains log files 
- assignment_1_essay.md --> contains essay portion of assigment 1 
- README.md --> contains structure, instruction, and notes information for assignment 1 directory 

# setup instructions

```bash 
cd desktop 
cd biocomputing 
cd BIOCOMPUTING
cd assignments
mkdir assignment_1
cd assignment_1
mkdir data scripts results docs config logs assignment_1_essay.md README.md
cd data
mkdir raw clean 
touch ./data/raw/raw.fastq ./data/clean/clean.fastq
cd ..
touch ./





























^G Get Help     ^O WriteOut     ^R Read File    ^Y Prev Page    ^K Cut Text     ^C Cur Pos
^X Exit         ^J Justify      ^W Where Is     ^V Next Page    ^U UnCut Text   ^T To Spell
  [Restored Aug 28, 2025 at 10:23:27 PM]
Last login: Thu Aug 28 22:23:24 on console
/Users/morganwood/.zshrc:1: no such file or directory: “/opt/homebrew/opt/coreutils/libexec/gnubin”
morganwood@Morgans-MacBook-Air assignment_1 % nano README.md 
morganwood@Morgans-MacBook-Air assignment_1 % nano README.md 
morganwood@Morgans-MacBook-Air assignment_1 % nano README.md 
morganwood@Morgans-MacBook-Air assignment_1 % nano README.md 
morganwood@Morgans-MacBook-Air assignment_1 % nano README.md 
morganwood@Morgans-MacBook-Air assignment_1 % ls   
README.md		assignment_1_essay.md	data			logs			scripts
assignment_1		config			docs			results
morganwood@Morgans-MacBook-Air assignment_1 % cd assignment_1
cd: not a directory: assignment_1
morganwood@Morgans-MacBook-Air assignment_1 % ls
README.md		assignment_1_essay.md	data			logs			scripts
assignment_1		config			docs			results
morganwood@Morgans-MacBook-Air assignment_1 % touch README.md
morganwood@Morgans-MacBook-Air assignment_1 % nano README.md 
morganwood@Morgans-MacBook-Air assignment_1 % rm -r README.md assignment_1_essay.md
morganwood@Morgans-MacBook-Air assignment_1 % 
morganwood@Morgans-MacBook-Air assignment_1 % touch README.md assignment_1_essay.md
morganwood@Morgans-MacBook-Air assignment_1 % ls
README.md		config			logs
assignment_1		data			results
assignment_1_essay.md	docs			scripts
morganwood@Morgans-MacBook-Air assignment_1 % rm -r assignment_1
morganwood@Morgans-MacBook-Air assignment_1 % ls
README.md		config			docs			results
assignment_1_essay.md	data			logs			scripts
morganwood@Morgans-MacBook-Air assignment_1 % nano README.md 
morganwood@Morgans-MacBook-Air assignment_1 % nano README.md 
morganwood@Morgans-MacBook-Air assignment_1 % ls
README.md		config			docs			results
assignment_1_essay.md	data			logs			scripts
morganwood@Morgans-MacBook-Air assignment_1 % nano assignment_1_essay.md
morganwood@Morgans-MacBook-Air assignment_1 % nano assignment_1_essay.md 
morganwood@Morgans-MacBook-Air assignment_1 % wc -w assignment_1_essay.md 
     533 assignment_1_essay.md
morganwood@Morgans-MacBook-Air assignment_1 % cd 
morganwood@Morgans-MacBook-Air ~ % cd desktop
morganwood@Morgans-MacBook-Air desktop % cd biocomputing
morganwood@Morgans-MacBook-Air biocomputing % cd BIOCOMPUTING
morganwood@Morgans-MacBook-Air BIOCOMPUTING % ls
README.md	assignments
morganwood@Morgans-MacBook-Air BIOCOMPUTING % cd assignments
morganwood@Morgans-MacBook-Air assignments % ls
assignment_01	assignment_1
morganwood@Morgans-MacBook-Air assignments % git status
On branch main
Your branch is up to date with 'origin/main'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	../.DS_Store
	.DS_Store
	assignment_01/.DS_Store
	assignment_1/

nothing added to commit but untracked files present (use "git add" to track)
morganwood@Morgans-MacBook-Air assignments % git add assignment_1 
morganwood@Morgans-MacBook-Air assignments % git commit -m "add assignment 1: project structure and rationale"
[main 7f75291] add assignment 1: project structure and rationale
 Committer: Morgan Wood <morganwood@Morgans-MacBook-Air.local>
Your name and email address were configured automatically based
on your username and hostname. Please check that they are accurate.
You can suppress this message by setting them explicitly. Run the
following command and follow the instructions in your editor to edit
your configuration file:

    git config --global --edit

After doing this, you may fix the identity used for this commit with:

    git commit --amend --reset-author

 10 files changed, 80 insertions(+)
 create mode 100644 assignments/assignment_1/.DS_Store
 create mode 100644 assignments/assignment_1/README.md
 create mode 100644 assignments/assignment_1/assignment_1_essay.md
 create mode 100644 assignments/assignment_1/config/example.vcf
 create mode 100644 assignments/assignment_1/data/clean/clean.fastq
 create mode 100644 assignments/assignment_1/data/raw/raw.fastq
 create mode 100644 assignments/assignment_1/docs/example.txt
 create mode 100644 assignments/assignment_1/logs/logfile.log
 create mode 100644 assignments/assignment_1/results/example.sam
 create mode 100644 assignments/assignment_1/scripts/sctip.sh
morganwood@Morgans-MacBook-Air assignments % git push
Enumerating objects: 18, done.
Counting objects: 100% (18/18), done.
Delta compression using up to 8 threads
Compressing objects: 100% (8/8), done.
Writing objects: 100% (16/16), 3.04 KiB | 3.04 MiB/s, done.
Total 16 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/morganwood11/BIOCOMPUTING.git
   d16f364..7f75291  main -> main
morganwood@Morgans-MacBook-Air assignments % git status
On branch main
Your branch is up to date with 'origin/main'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	../.DS_Store
	.DS_Store
	assignment_01/.DS_Store

nothing added to commit but untracked files present (use "git add" to track)
morganwood@Morgans-MacBook-Air assignments %
