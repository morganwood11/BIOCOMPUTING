#!/bin/bash

set -ueo pipefail

# set scratch space for data IO
SCR_DIR="${HOME}/scr10"  # main writable scratch

# set project directory in scratch space
PROJECT_DIR="${SCR_DIR}/BIOCOMPUTING/lessons/lesson_08"

# set database directory
DB_DIR="${SCR_DIR}/database"

# make directories for this project
mkdir -p "${PROJECT_DIR}/data/raw"
mkdir -p "${PROJECT_DIR}/data/clean"
mkdir -p "${PROJECT_DIR}/output"
mkdir -p "${DB_DIR}/metaphlan"
mkdir -p "${DB_DIR}/prokka"
