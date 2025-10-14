#!/bin/bash
set -ueo pipefail

git clone https://github.com/fenderglass/Flye
cd Flye
make
cd ..
mv ./Flye ~/programs/
