####Morgan Wood 			10/22/2025

###Assignment 7: SLURM job submission and public data 

##Task 1: setup assignment 7 directory 
```
bora
#password
cd BIOCOMPUTING/assignments/assignment_07
touch assignment_7_pipeline.slurm
mkdir data data/clean data/dog_reference data/raw output scripts
touch ./scripts/{01_download_data.sh,02_clean_reads.sh,03_map_reads.sh}

#organizing scratch10 space because files are large 
cd
cd scr10
mkdir BIOCOMPUTING BIOCOMPUTING/{assignments,lessons}
cd BIOCOMPUTING/assignments
mkdir assignment_0{1..8}
touch assignment_01/README.md assignment_02/README.md assignment_03/README.md assignment_04/README.md assignment_05/README.md assignment_06/README.md assignment_07/README.md assignment_08/README.md
mkdir data data/clean data/raw data/dog_reference
#/sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07 is pwd; for reference later 
cd ~/BIOCOMPUTING/assignments/assignment_07
```

##Task 2: download sequence data
```
#go to ncbi 
#search: ("gut metagenome"[Organism] OR gut microbiome[All Fields]) AND "human gut metagenome"[orgn] AND ("biomol dna"[Properties] AND "strategy wgs"[Properties] AND "library layout paired"[Properties] AND "platform illumina"[Properties] AND "filetype fastq"[Properties])
#click send to run selector 
#in filters list on left, click allergy
#when allergy pops up below, click yes
#click metadata to download csv file 
#save file to desktop 
#using filezilla: move to ~/BIOCOMPUTING/assignments/assignment_07/data

nano ./scripts/01_download_data.sh
#type all below into script: 
#!/bin/bash
set -ueo pipefail

#download sra accession files and move to ./data/raw
for ACC in $(cat ./data/A7_SRAruntable.csv | cut -d',' -f 1 | head -n 11 | tail -n +2);do fasterq-dump "$ACC" -O /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/raw;done

#download dog reference genome and move to reference directory
datasets download genome taxon "Canis lupus familiaris" --reference --filename /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/dog_reference/dog.zip
unzip /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/dog_reference/dog.zip -d /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/dog_reference
#exit file

chmod +x 01_download_data.sh
```

##Task 3: clean up raw reads
```
nano ./scripts/02_clean_reads.sh
#type all below into script: 
#!bin/bash
set -euo pipefail
	
mkdir -p /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/clean

# clean up reads, put them in the clean directory 
for FWD in /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/raw/*_1.fastq;do echo $FWD;REV=${FWD/_1.fastq/_2.fastq}; echo $REV; OUTFWD=${FWD/raw/clean};OUTREV=${REV/raw/clean}; fastp --in1 "$FWD" --in2 "$REV" --out1 "$OUTFWD" --out2 "$OUTREV" --json /dev/null --html /dev/null --average_qual 20; done
chmod +x 02_clean_reads.sh
```

##Task 4/5: map reads to dog genome; extract matched reads
```
nano ./scripts/03_map_reads.sh
#type all below into script: 
#!/bin/bash
set -ueo pipefail

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
#exit file
chmod +x 03_map_reads.sh
```

##Task 6: submit job to SLURM
```
nano assignment_7_pipeline.slurm
#type all below into script: 
#!/bin/bash
#SBATCH --job-name=assignment_07
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=1-00:00:00
#SBATCH --mem=120G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=mrwood01@wm.edu
#SBATCH -o /sciclone/home/mrwood01/BIOCOMPUTING/assignments/assignment_07/output/assignment_07_%j.out
#SBATCH -e /sciclone/home/mrwood01/BIOCOMPUTING/assignments/assignment_07/output/assignment_07_%j.err

################SETUP##################
set -euo pipefail

#locate directory where job was submitted from
cd $SLURM_SUBMIT_DIR

#load programs needed
export PATH=$PATH:/sciclone/home/mrwood01/programs
export PATH=$PATH:/sciclone/home/mrwood01/programs/fastp
export PATH=$PATH:/sciclone/home/mrwood01/programs/datasets
export PATH=$PATH:/sciclone/home/mrwood01/programs/sratoolkit.3.2.1-ubuntu64/bin
module load miniforge3
source "$(dirname $(dirname $(which conda)))/etc/profile.d/conda.sh"
conda activate bbmap-env

#run scripts
bash ./scripts/01_download_data.sh
bash ./scripts/02_clean_reads.sh
bash ./scripts/03_map_reads.sh

conda deactivate
#exit file

sbatch assignment_7_pipeline.slurm 		#Submitted batch job 222208
```

##Task 8: Inspect your results
```
cd scripts
nano ./scripts/create_table.sh
#type all below into script:

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
#exit file

chmod +x create_table.sh
bash ./scripts/create_table.sh
cat ./output/dog_mapping_summary.tsv
#below is table produced: 
Sample_ID	QC_Reads	Dog_Mapped_Reads	Percent_Dog
SRR27117388	0	669	0
SRR27117389	0	3379	0
SRR27117390	0	1741	0
SRR27117391	0	1573	0
SRR27117392	0	1472	0
SRR27117393	0	2363	0
SRR27117394	0	1115	0
SRR27117395	0	967		0
SRR27117396	0	1161	0
SRR27117397	0	1710	0
```

##Task 9: document everything 
Overall, this was definitely more difficult but very good for beginning to see how submitting jobs 
and running genome mapping will look like when it comes time to do similar things with my sequencing 
reads. I had to submit three times total because I kept messing up, and I had to adjust and move all 
of my huge files into the scr10 space. That was nice at least because I got a little exposure with 
calling between storage space, scripts, and the login node. My job also took approximately 
20 hours to complete. I definitely could use more practice with this because it feels so new and hard, 
but also this is the first time so I know I will get better over time. I enjoyed it though, it was 
honestly kind of cool that we can do this stuff. 

#moving all big files to .gitignore to push to github
# find . -type f -size +100M | sed 's|^\./||' >> .gitignore
