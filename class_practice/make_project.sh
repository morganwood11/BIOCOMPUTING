#!/bin/bash

##recreating directory structure I just completed after deletion 

#make new directories within practice/
mkdir data data/clean data/raw output scripts

#make files asked for in varying directories within class_practice (main)\
touch README.md workflow.sh data/metadata.csv scripts/01_QC.sh scripts/02_assemble.sh 
scripts/03_bin.sh scripts/04_refine.sh scripts/05_annotate.sh

#add comments to README.md
nano README.md

echo "#My new project"

echo "Raw data are in ./data/raw"

echo "All scripts are in ./scripts"

echo "./workflow.sh contains ordered instructions for running scripts"

#save in script called make_project.sh
touch make_project.sh


