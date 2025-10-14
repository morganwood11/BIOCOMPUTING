#### Morgan Wood 		10/12/2025

###Assignment 6

##Task 1: Setup assignment 6 directory
```
mkdir assemblies data scripts 	#making main directories
mkdir assemblies/assembly_conda assemblies/assembly_local assemblies/assembly_module 	#making assembly directories 
#rest of directory assembled as I move through the assignment 
```

##Task 2: download raw ONT data
```
cd scripts
touch README.md
nano 01_download_data.sh 	#type all comments below into script 
	# #!/bin/bash
	# set -ueo pipefail

	# cd data         #in assignment 6 directory
	# wget https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz
	# gunzip SRR33939694.fastq.gz
chmod +x 01_download_data.sh
cd ..
./scripts/01_download_data.sh
```

##Task 3: get flye v2.9.6
```
cd scripts
nano flye_2.9.6_manual_build.sh 	#type comments below into script
	# #!/bin/bash
	# set -ueo pipefail
	# git clone https://github.com/fenderglass/Flye
	# cd Flye
	# make
	# cd ..
	# mv ./Flye ~/programs/
chmod +x flye_2.9.6_manual_build.sh
./flye_2.9.6_manual_build.sh 	#runs the script within scripts directory
cd
nano .bashrc	#doing the >> into the bashrc file prints my entire PATH in there and I don't know why
export PATH=$PATH:/sciclone/home/mrwood01/programs/Flye/bin
source .bashrc
```

##Task 4: get flye v2.9.6
```
cd BIOCOMPUTING/assignments/assignment_06/scripts
nano flye_2.9.6_conda_install.sh 	#type all comments below into script
	# #!/bin/bash
	# set -ueo pipefail

	# module load miniforge3
	# source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
	# mamba create -yn flye-env -c bioconda -c conda-forge flye=2.9.6 	#did not work without searching other modules
	# conda activate flye-env
	# flye -v
	# conda env export --no-builds > flye-env.yml
	# deactivate flye-env
mv flye-env.yml ../
```

##Task 5: decipher how to use Flye
```
cd../data
gunzip SRR33939694.fastq.gz
cd ..
flye --help 	#looking at information on flye program
flye   --nano-hq ./data/SRR33939694.fastq   --genome-size 200k   --out-dir flye_phage_assembly   --threads 6
#^above line is for assembling the genomes 
#output was flye_phage_assembly directory in assignment 6 directory 
```

##Task 6: run flye 3 ways
```
cd scripts
nano 03_run_flye_conda.sh 		#type all comments below into script
	# #!/bin/bash
	# set -ueo pipefail

	# source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

	# conda activate flye-env

	# mkdir -p ./assemblies/assembly_conda

	# flye \
	# --nano-hq ./data/SRR33939694.fastq \
	# --genome-size 200k \
	# --out-dir ./assemblies/assembly_conda \
	# --threads 6 | tee ./assemblies/assembly_conda/flye.log

	# mv ./assemblies/assembly_conda/assembly.fasta ./assemblies/assembly_conda/conda_assembly.fasta
	# mv ./assemblies/assembly_conda/flye.log ./assemblies/assembly_conda/conda_flye.log

	# mkdir -p ./tmp_keep
	# mv ./assemblies/assembly_conda/conda_assembly.fasta ./tmp_keep/
	# mv ./assemblies/assembly_conda/conda_flye.log ./tmp_keep/
	# rm -rf ./assemblies/assembly_conda/*
	# mv ./tmp_keep/* ./assemblies/assembly_conda/
	# rmdir ./tmp_keep

	# conda deactivate

chmod +x 03_run_flye_conda.sh
nano 03_run_flye_module.sh		#type all comments below into script
	# #!/bin/bash
	# set -ueo pipefail

	# module purge
	# module load Flye/gcc-11.4.1/2.9.6

	# mkdir -p ./assemblies/assembly_module

	# flye \
	# --nano-hq ./data/SRR33939694.fastq \
	# --genome-size 200k \
	# --out-dir ./assemblies/assembly_module \
	# --threads 6 | tee ./assemblies/assembly_module/flye.log

	# mv ./assemblies/assembly_module/assembly.fasta ./assemblies/assembly_module/module_assembly.fasta
	# mv ./assemblies/assembly_module/flye.log ./assemblies/assembly_module/module_flye.log

	# mkdir -p ./tmp_keep
	# mv ./assemblies/assembly_module/module_assembly.fasta ./tmp_keep/
	# mv ./assemblies/assembly_module/module_flye.log ./tmp_keep/
	# rm -rf ./assemblies/assembly_module/*
	# mv ./tmp_keep/* ./assemblies/assembly_module/
	# rmdir ./tmp_keep

chmod +x 03_run_flye_module.sh
nano 03_run_flye_local.sh 		#type all comments below into script
	# #!/bin/bash
	# set -ueo pipefail

	# export PATH=$PATH:/sciclone/home/mrwood01/programs/Flye/bin

	# mkdir -p ./assemblies/assembly_local

	# flye \
	# --nano-hq ./data/SRR33939694.fastq \
	# --genome-size 200k \
	# --out-dir ./assemblies/assembly_local \
	# --threads 6 | tee ./assemblies/assembly_local/flye.log

	# mv ./assemblies/assembly_local/assembly.fasta ./assemblies/assembly_local/local_assembly.fasta
	# mv ./assemblies/assembly_local/flye.log ./assemblies/assembly_local/local_flye.log

	# mkdir -p ./tmp_keep
	# mv ./assemblies/assembly_local/local_assembly.fasta ./tmp_keep/
	# mv ./assemblies/assembly_local/local_flye.log ./tmp_keep/
	# rm -rf ./assemblies/assembly_local/*
	# mv ./tmp_keep/* ./assemblies/assembly_local/
	# rmdir ./tmp_keep

chmod +x 03_run_flye_local.sh
cd ..
scripts/03_run_flye_conda.sh
scripts/03_run_flye_module.sh
scripts/03_run_flye_local.sh
```

##Task 7: compare results in the log files
```
echo "Conda Flye Log"
tail -n 10 ./assemblies/assembly_conda/conda_flye.log
echo

echo "Module Flye Log"
tail -n 10 ./assemblies/assembly_module/module_flye.log
echo

echo "Local Flye Log"
tail -n 10 ./assemblies/assembly_local/local_flye.log
echo
```

##Task 8: build a pipeline
```
nano pipeline.sh 		#type all comments below into script
	# #!/bin/bash
	# set -ueo pipefail

	# echo "download data"
	# bash ./scripts/01_download_data.sh

	# echo "build flye locally"
	# bash ./scripts/flye_2.9.6_manual_build.sh

	# echo "build conda env"
	# bash ./scripts/flye_2.9.6_conda_install.sh

	# echo "run flye conda"
	# bash ./scripts/03_run_flye_conda.sh

	# echo "run flye module"
	# bash ./scripts/03_run_flye_module.sh

	# echo "run flye local"
	# bash ./scripts/03_run_flye_local.sh

	# echo "Conda Flye Log"
	# tail -n 10 ./assemblies/assembly_conda/conda_flye.log
	# echo

	# echo "Module Flye Log"
	# tail -n 10 ./assemblies/assembly_module/module_flye.log
	# echo

	# echo "Local Flye Log"
	# tail -n 10 ./assemblies/assembly_local/local_flye.log
	# echo

	# echo "complete!"

chmod +x pipeline.sh
```
##Task 9: delete and start over 
```
#deleted everything added initially
./pipeline.sh 	#from assignment 6 directory
echo "./data/SRR33939694.fastq" >> .gitignore 	#so do not push large file to github
```

##Task 10: document and reflection
```
This assignment was honestly pretty hard. I think doing a lot of different scripts that perform 
different tasks made this pretty difficult and I do not feel like I have a great grasp of doing 
a large amount of this kind of stuff together yet. I learned that there are numerous ways to run 
a specific program, depending on user preference (more or less). I think I like the module way 
because it seems more straightforward than having to do the manual route where you add it to 
your path. 
```
