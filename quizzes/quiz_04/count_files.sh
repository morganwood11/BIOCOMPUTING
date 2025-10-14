#!/bin/bash
set -ueo pipefail

DIR=$1

ls -1lA $1 | grep -v "^d" | wc -l
