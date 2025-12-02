#### Group Project ####
### Morgan Wood 	11/19/2025

##Step 1: set up project directory 
#everything within HPC
```
cd scr10/BIOCOMPUTING
mkdir group_project
mkdir scripts
nano 00_setup.sh
#type all below into setup script
#!/bin/bash

set -ueo pipefail

# set scratch space for data
SCR_DIR="${HOME}/scr10"  # main writable scratch

# set project directory in scratch space
PROJECT_DIR="${SCR_DIR}/BIOCOMPUTING/group_project"

# set database directory
DB_DIR="${PROJECT_DIR}/database"

# make directories for this project
mkdir -p "${PROJECT_DIR}/data/raw"
mkdir -p "${PROJECT_DIR}/data/clean"
mkdir -p "${PROJECT_DIR}/output"
mkdir -p "${PROJECT_DIR}/logs"
mkdir -p "${DB_DIR}/metaphlan"
mkdir -p "${DB_DIR}/prokka"
#end script 

chmod +x 00_setup.sh
bash 00_setup.sh
touch 01_download.sh 02_qc.sh 03_assemble.sh 04_annotate.sh 05_coverage.sh 06_profile.sh 
cd ../data
nano accessions.txt
#add in accessions.txt: 
SRR31654314
SRR31654324
SRR31654305
SRR31654343
SRR31654339
SRR31654352
SRR31654355
SRR31654385
SRR31654365
SRR31654382
#end text file
```

##Step 2: Download data
```
cd ../scripts
nano 01_download.sh
#type all below into script 
#!/bin/bash
#SBATCH --job-name=download_data
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=mrwood01@wm.edu
#SBATCH -o /sciclone/home/mrwood01/scr10/BIOCOMPUTING/group_project/logs/download_%j.out
#SBATCH -e /sciclone/home/mrwood01/scr10/BIOCOMPUTING/group_project/logs/download_%j.err

set -ueo pipefail

# get conda
N_CORES=6
module load miniforge3
eval "$(conda shell.bash hook)"

# DOWNLOAD RAW READS #############################################################

# set filepath vars
SCR_DIR="${HOME}/scr10" # change to main writeable scratch space if not on W&M HPC
PROJECT_DIR="${SCR_DIR}/BIOCOMPUTING/group_project"
DB_DIR="${PROJECT_DIR}/database"
DL_DIR="${PROJECT_DIR}/data/raw"
SRA_DIR="${PROJECT_DIR}/SRA"

# if SRA_DIR doens't exist, create it
[ -d "$SRA_DIR" ] || mkdir -p "$SRA_DIR"


# download the accession(s) listed in `./data/accessions.txt`
# only if they don't exist
for ACC in $(cat ~/scr10/BIOCOMPUTING/group_project/accessions.txt)
do

if [ ! -f "${SRA_DIR}/${ACC}/${ACC}.sra" ]; then
prefetch --output-directory "${SRA_DIR}" "$ACC"
fasterq-dump "${SRA_DIR}/${ACC}/${ACC}.sra" --outdir "$DL_DIR" --skip-technical --force --temp "${SCR_DIR}/tmp"
fi

done


# compress all downloaded fastq files (if they haven't been already)
if ls ${DL_DIR}/*.fastq >/dev/null 2>&1; then
gzip ${DL_DIR}/*.fastq
fi

# DOWNLOAD DATABASES #############################################################

# metaphlan is easiest to use via conda
# and metaphlan can install its own database to use
conda env list | grep -q '^metaphlan4-env' || mamba create -y -n metaphlan4-env -c bioconda -c conda-forge metaphlan

# look for the metaphlan database, only download if it does not exist already
if [ ! -f "${DB_DIR}/metaphlan/mpa_latest" ]; then
conda activate metaphlan4-env
# install the metaphlan database using N_CORES
# N_CORES is set in the pipeline.slurm script
metaphlan --install --db_dir "${DB_DIR}/metaphlan" --nproc $N_CORES
conda deactivate
fi


# prokka (also using conda, also installs its own database)
conda env list | grep -q '^prokka-env' || mamba create -y -n prokka-env -c conda-forge -c bioconda prokka
conda activate prokka-env
export PROKKA_DB=${DB_DIR}/prokka
prokka --setupdb --dbdir $PROKKA_DB
conda deactivate
#end file script 
sbatch 01_download.sh
```

##Step 3: quality control 
```
nano 03_qc.sh 
#type all below into script 
#!/bin/bash

set -euo pipefail

SCR_DIR="${HOME}/scr10" # change to main writeable scratch space if not on W&M HPC
PROJECT_DIR="${SCR_DIR}/BIOCOMPUTING/group_project"
DB_DIR="${PROJECT_DIR}/database"
DL_DIR="${PROJECT_DIR}/data/raw"
QC_DIR="${PROJECT_DIR}/data/clean"
SRA_DIR="${PROJECT_DIR}/SRA"

for fwd in ${DL_DIR}/*_1.fastq.gz;do rev=${fwd/_1.fastq.gz/_2.fastq.gz};outfwd=${fwd/.fastq.gz/_qc.fastq.gz};outrev=${rev/.fastq.gz/_qc.fastq.gz};fastp -i $fwd -o $outfwd -I $rev -O $outrev -j /dev/null -h /dev/null -n 0 -l 100 -e 20;done

mv ${DL_DIR}/*_qc.fastq.gz ${QC_DIR}
# all QC files will be in $DL_DIR and have *_qc.fastq.gz naming pattern
#end script 

chmod +x 02_qc.sh
bash 02_qc.sh
```

##Step 4: assemble 
```
nano 03_assemble_template.sh
#type all below into script 

#!/bin/bash
#SBATCH --job-name=REPLACEME_assembly
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=mrwood01@wm.edu               
#SBATCH -o /sciclone/home/mrwood01/scr10/BIOCOMPUTING/group_project/logs/assembly_%j.out 
#SBATCH -e /sciclone/home/mrwood01/scr10/BIOCOMPUTING/group_project/logs/assembly_%j.err

#set filebath vars
SCR_DIR="${HOME}/scr10"
PROJECT_DIR="${SCR_DIR}/BIOCOMPUTING/group_project"
DB_DIR="${PROJECT_DIR}/database"
DL_DIR="${PROJECT_DIR}/data/clean"
SRA_DIR="${PROJECT_DIR}/SRA"
CONTIG_DIR="${PROJECT_DIR}/contigs"

mkdir -p $CONTIG_DIR

for fwd in ${DL_DIR}/*REPLACEME*1_qc.fastq.gz
do

# derive input and output variables
rev=${fwd/_1_qc.fastq.gz/_2_qc.fastq.gz}
filename=$(basemane $fwd)
samplename=$(echo ${filename%%_*})
outdir=$(echo ${CONTIG_DIR}/${samplename})

#run spades with mostly default options
spades.py -1 $fwd -2 $rev -o $outdir -t 20 --meta
done
#end script 

#have to submit job for each accession (10 jobs total)
cd .. #back to group_project directory
for i in $(cat ./accessions.txt); do cat ./scripts/03_assemble_template.sh | sed "s/REPLACEME/${i}/g" > ./scripts/${i}_assemble.slurm;done 
#^this creates file per accession to run assembly for each 
#create for loop to submit all 10 jobs 
for i in ./scripts/SRR*.slurm; do sbatch ${i}; done
```

##Step 5: annotate 
```
cd scripts 	#back into scripts directory
nano 04_annotate.sh
#type all below into script 
#!/bin/bash
#SBATCH --job-name=REPLACEME_Annotate
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=1-00:00:00 # each should only take ~30-60 minutes
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=mrwood01@wm.edu
#SBATCH -o /sciclone/home/mrwood01/scr10/BIOCOMPUTING/group_project/logs/annotate_%j.out
#SBATCH -e /sciclone/home/mrwood01/scr10/BIOCOMPUTING/group_project/logs/annotate_%j.err

set -ueo pipefail

# set filepath vars
SCR_DIR="${HOME}/scr10"
PROJECT_DIR="${SCR_DIR}/BIOCOMPUTING/group_project"
DB_DIR="${PROJECT_DIR}/database"
QC_DIR="${PROJECT_DIR}/data/clean"
SRA_DIR="${SCR_DIR}/SRA"
CONTIG_DIR="${PROJECT_DIR}/contigs"
ANNOT_DIR="${PROJECT_DIR}/annotations"

# load prokka
module load miniforge3
eval "$(conda shell.bash hook)"
conda activate prokka-env

for fwd in ${QC_DIR}/REPLACEME_1_qc.fastq.gz

do

# derive input and output variables
rev=${fwd/_1_qc.fastq.gz/_2_qc.fastq.gz}
filename=$(basename $fwd)
samplename=$(echo ${filename%%_*})
contigs=$(echo ${CONTIG_DIR}/${samplename}/contigs.fasta)
outdir=$(echo ${ANNOT_DIR}/${samplename})
contigs_safe=${contigs/.fasta/.safe.fasta}

# rename fasta headers to account for potentially too-long names (or spaces)
seqtk rename <(cat $contigs | sed 's/ //g') contig_ > $contigs_safe

# run prokka to predict and annotate genes
prokka $contigs_safe --outdir $outdir --prefix $samplename --cpus 20 --kingdom Bacteria --metagenome --evalue 1e-05 --locustag $samplename --force

done

conda deactivate && conda deactivate
#end script 
#must submit each file 10 times as own slurm jobs
cd .. #back to group_project directory 
for i in $(cat ./accessions.txt); do cat ./scripts/04_annotate_template.sh | sed "s/REPLACEME/${i}/g" >> ./scripts/${i}_annotate.slurm;done
for i in ./scripts/*_annotate.slurm; do sbatch ${i}; done
```

##Step 6: coverage 
```
cd scripts 	#back into scripts directory 
nano 05_coverage.sh 
#type all below into script 
#!/bin/bash
#SBATCH --job-name=GP_coverage
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=USER@wm.edu
#SBATCH -o /sciclone/home/mrwood01/scr10/BIOCOMPUTING/group_project/logs/coverage_%j.out
#SBATCH -e /sciclone/home/mrwood01/scr10/BIOCOMPUTING/group_project/logs/coverage_%j.err

set -ueo pipefail

# filepath vars
SCR_DIR="${HOME}/scr10"
PROJECT_DIR="${SCR_DIR}/BIOCOMPUTING/group_project"
QC_DIR="${PROJECT_DIR}/data/clean"
CONTIG_DIR="${PROJECT_DIR}/contigs"
ANNOT_DIR="${PROJECT_DIR}/annotations"
MAP_DIR="${PROJECT_DIR}/mappings"
COV_DIR="${PROJECT_DIR}/coverm"

mkdir -p "${MAP_DIR}" "${COV_DIR}"

# load conda
module load miniforge3
eval "$(conda shell.bash hook)"

# check if coverm-env exists, if not, create it
if ! conda env list | awk '{print $1}' | grep -qx "subread-env"; then     echo "[setup] creating subread-env with mamba";     mamba create -y -n subread-env -c bioconda -c conda-forge subread bowtie2 samtools; fi

# activate env
conda activate subread-env

# main loop
for fwd in ${QC_DIR}/*1_qc.fastq.gz
do
    rev=${fwd/_1_qc.fastq.gz/_2_qc.fastq.gz}
    filename=$(basename "$fwd")
    samplename=$(echo "${filename%%_*}")
    contigs="${CONTIG_DIR}/${samplename}/contigs.fasta"
    contigs_safe=${contigs/.fasta/.safe.fasta}
    gff="${ANNOT_DIR}/${samplename}/${samplename}.gff"
    bam="${MAP_DIR}/${samplename}.bam"
    cov_out="${COV_DIR}/${samplename}_gene_tpm.tsv"

    echo "[sample] ${samplename}"

    # index contigs if needed
        echo "  [index] bowtie2-build ${contigs_safe}"
        bowtie2-build "${contigs_safe}" "${contigs_safe}"

    # map reads to contigs
        echo "  [map] mapping reads"
        bowtie2 -x "${contigs_safe}" -1 "$fwd" -2 "$rev" -p 8 \
          2> "${MAP_DIR}/${samplename}.bowtie2.log" \
        | samtools view -b - \
        | samtools sort -@ 8 -o "${bam}"
        samtools index "${bam}"

 # run featureCounts per gene (CDS), then compute TPM
    counts="${COV_DIR}/${samplename}_gene_counts.txt"
    tpm_out="${COV_DIR}/${samplename}_gene_tpm.tsv"

    echo "  [featureCounts] counting reads per CDS (locus_tag)"
    featureCounts \
      -a "${gff}" \
      -t CDS \
      -g locus_tag \
      -p -B -C \
      -T 20 \
      -o "${counts}" \
      "${bam}"

    echo "  [TPM] calculating TPM"
    awk 'BEGIN{OFS="\t"}
         NR<=2 {next}                           # skip header lines
         {
           id=$1; len=$6; cnt=$(NF);           # Geneid, Length, sample count is last column
           if (len>0) {
             rpk = cnt/(len/1000);
             RPK[id]=rpk; LEN[id]=len; CNT[id]=cnt; ORDER[++n]=id; SUM+=rpk;
           }
         }
         END{
           print "gene_id","length","counts","TPM";
           for (i=1;i<=n;i++){
             id=ORDER[i];
             tpm = (SUM>0 ? (RPK[id]/SUM)*1e6 : 0);
             printf "%s\t%d\t%d\t%.6f\n", id, LEN[id], CNT[id], tpm;
           }
         }' "${counts}" > "${tpm_out}"

    echo "  [done] ${tpm_out}"

    echo "  [done] ${cov_out}"

# join the coverage estimation info back to the annotation file

ann="${ANNOT_DIR}/${samplename}/${samplename}.tsv"
joined="${ANNOT_DIR}/${samplename}/${samplename}_IN.with_cov.tsv" #CHANGE IN TO YOUR INITIAL

echo "  [join] adding coverage columns to annotation TSV"
awk -v FS='\t' -v OFS='\t' -v keycol='locus_tag' '
  # Read TPM table: gene_id  length  counts  TPM
  NR==FNR {
    if (FNR==1) next
    id=$1; LEN[id]=$2; CNT[id]=$3; TPM[id]=$4
    next
  }
  # On the annotation header, find which column is locus_tag
  FNR==1 {
    for (i=1;i<=NF;i++) if ($i==keycol) K=i
    if (!K) { print "ERROR: no \"" keycol "\" column in annotation header" > "/dev/stderr"; exit 1 }
    print $0, "cov_length_bp", "cov_counts", "cov_TPM"
    next
  }
  # Append coverage fields if we have them
  {
    id=$K
    print $0, (id in LEN? LEN[id]:"NA"), (id in CNT? CNT[id]:"0"), (id in TPM? TPM[id]:"0")
  }
' "${tpm_out}" "${ann}" > "${joined}"

echo "  [done] ${joined}"

done
#end script 
sbatch 05_coverage.sh #submit job to slurm 
cd ..
#files ended up in annotations directory, so moved to output directory via for loop
for f in $(find annotations -type f -name "*_MRW.with_cov.tsv"); do
    mv "$f" output/
done

```

##set up output directory in login node to push to github 
```
cd ~/BIOCOMPUTING
mkdir group_project
cd ~/scr10/BIOCOMPUTING/group_project
mv ./output ~/BIOCOMPUTING/group_project
cd ~/BIOCOMPUTING/group_project
nano README.md
``` 
#paste this entire document/script into README.md for github 

##summary of project: 
# This project covered metagenomics assembly and annotation of data/sequences from a gut microbiome study
# focused on healthy aging. Each group member ran the same scripts, but changed a minimum of one thing within
# one of the scripts. For my portion, I changed the evalue in Step 5 (04_annotate.sh) using the Prokka program. 
# I changed the evalue to 1e-05, while the default is 1e-09. Increasing the size of the evalue essentially makes 
# Prokka less picky when annotating the assembled genome, so it may become less accurate. Another group member 
# changed the evalue in the opposite direction to make Prokka more accurate. Our goal for each group member changing different 
# parts of this pipeline allows us to analyze the differences in the output files each of us get. Our main 
# focus during analysis is the amount of annotated vs. hypothetical proteins that are present and which 
# changes in the pipeline can elicit differences in this ratio. This project overall was super fun and nice to 
# see how this class has come full circle and apply what we've learned to real world data.  
