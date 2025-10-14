#!/bin/bash
set -ueo pipefail

echo "download data"
bash ./scripts/01_download_data.sh

echo "build flye locally"
bash ./scripts/flye_2.9.6_manual_build.sh

echo "build conda env"
bash ./scripts/flye_2.9.6_conda_install.sh

echo "run flye conda"
bash ./scripts/03_run_flye_conda.sh

echo "run flye module"
bash ./scripts/03_run_flye_module.sh

echo "run flye local"
bash ./scripts/03_run_flye_local.sh

echo "Conda Flye Log"
tail -n 10 ./assemblies/assembly_conda/conda_flye.log
echo

echo "Module Flye Log"
tail -n 10 ./assemblies/assembly_module/module_flye.log
echo

echo "Local Flye Log"
tail -n 10 ./assemblies/assembly_local/local_flye.log
echo

echo "complete!"
