# the named rstudio image for versioning
FROM rocker/rstudio:latest

#############################################
# install miniconda3 for python environment #
#############################################

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl \
    default-jre \
    dpkg \
    git \
    grep \
    libglib2.0-0 \
    libsm6 \
    libpq-dev \
    libxext6 \
    libxml2-dev \
    libxrender1 \
    build-essential \
    libglpk-dev \
    libgfortran4 \
    mercurial \
    sed \
    subversion \
    unixodbc \
    unixodbc-dev \
    vim \
    zlib1g-dev \
    rhash \
    && apt-get autoremove -y  \
    && apt-get clean -y  \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL --compressed -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda2-4.6.14-Linux-x86_64.sh && \
    /bin/bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# load in the environment.yml file - this file controls what Python packages we install
COPY environment.yml /

# install the Python packages we specified into the base environment
RUN conda update -n base conda -y && conda env update

# aws cli
RUN \
  cd opt && \
  curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
  unzip awscliv2.zip && \
  aws/install

# extra packages
RUN \
  Rscript -e "install.packages(c('tidyverse'))" && \
  Rscript -e "install.packages('data.table', type = 'source', repos = 'https://Rdatatable.gitlab.io/data.table')" && \
  Rscript -e "install.packages(c('odbc'))" &&  \
  Rscript -e "install.packages('h2o', type='source', repos='http://h2o-release.s3.amazonaws.com/h2o/master/5237/R')"

#############################################
#          persistence of volumes           #
#############################################

VOLUME /code /data

#############################################
#     same container runs dev/prod          #
#############################################

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# document what ports we intend to expose
EXPOSE 8888 8787

# define entrypoint to use same environment for dev/prod
ENTRYPOINT ["docker-entrypoint.sh"]
