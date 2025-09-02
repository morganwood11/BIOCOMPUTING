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
touch ./scripts/sctip.sh ./logs/logfile.log ./results/example.sam ./docs/example.txt ./config/examp$
touch README.md
