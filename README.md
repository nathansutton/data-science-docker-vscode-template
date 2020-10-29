### Data science docker template
[Forked](caesarnine/data-science-docker-vscode-template) from Binal's excellent [work](https://binal.pub/2019/04/running-vscode-in-docker/).

#### Changes
- Removes VSCode, adds RStudio  
- Keeps JupyterLab and Conda package manager for Python
- Adds the AWS command line interface

#### Why is This Useful?

1. You can develop all your code in a fully specified environment, which makes it much easier to reproduce and deploy models and analysis.
2. You can (after enabling security) move your IDE to the data. Instead of transferring data back and forth you can develop where your data is stored.
3. Last - and most important for me - in industries like my own (healthcare), you work with highly regulated data that has to be stored securely, where having multiple copies of data on multiple laptops can pose an unacceptably large risk.

    Running containers like this within a secure environment with access to the data helps us to have an ideal development environment, while ensuring the protected data remains in a secure, single location with no unnecessary duplication.

#### How to Use This All

Clone this down and rename the folder to be your project name.
- Modify the `environment.yml` file to include all the Python packages you need.
- Modify the Dockerfile to add all the R packages you need.  

```
  Rscript -e "install.packages(c('tidyverse'))"
```

__Build the image__
```
docker build -t stack .
```

__Start up the integrated development environment__
This will spin up the container - starting up JupyerLab and Rstudio.
Rstudio will be running on:
http://localhost:8787 with a username and password of `rstudio`
JupyterLab will be running on:
http://localhost:8888 with a token of `local`

```
./docker-run.sh
```

__Run a given R script inside the container__
```
./docker-run.sh Rscript /code/hello-world.R
```

__Run a given Python script inside the container__
```
./docker-run.sh Rscript /code/hello-world.py
```
