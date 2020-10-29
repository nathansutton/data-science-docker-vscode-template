#!/bin/bash
set -e

if [ $# -eq 0 ]
  then
    conda activate base
    rstudio-server start
    jupyter lab --ip=0.0.0.0 --NotebookApp.token='local' --allow-root --no-browser &> /dev/null
  else
    exec "$@"
fi
