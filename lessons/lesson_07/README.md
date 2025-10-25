#search term on SRA (Oct 21, 2025)
dental plaque[All Fields] AND "human oral metagenome"[orgn] AND ("biomol dna"[Properties] AND "library layout paired"[Properties] AND "platform illumina"[Properties] AND "filetype fastq"[Properties])

#pipeline

#download accessions from SRA
fasterq-dump $(cat accession.txt | cut -f 1)

#download e coli reference genome 
datasets download genome taxon taxon "Escherichia coli" --reference --filename ./ref/ecoli.zip;
unzip ./ref/ecoli.zip -d ./ref

##run bbmap.sh
#assign reference variable
REF="ref/ncbi_dataset/data/GCF_000005845.2/GCF_000005845.2_ASM584v2_genomic.fna"
#aligning reads to reference e. coli genome via bbmap.sh
bbmap.sh ref=$REF in1=data/ERR10083819_1.fastq in2=data/ERR10083819_2.fastq out=./output/mapped_to_Ecoli.sam minid=0.95
