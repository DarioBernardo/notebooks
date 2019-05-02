ARG BASE_CONTAINER=python:3.7
FROM $BASE_CONTAINER

RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
	curl \
    python3 \
    python3-pip \
 && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ARG NB_USER="dario"
ARG NB_UID="1000"
ARG NB_GID="100"


# Configure environment
ENV SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 

RUN pip install jupyterlab jupyterlab-git

ADD nb_setup/* /usr/local/lib/python3.7/site-packages/jupyter_contrib_nbextensions/setup/

RUN pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install && \
    jupyter nbextensions_configurator enable && \
    # can modify or enable additional extensions here
    jupyter nbextension enable spellchecker/main && \
    jupyter labextension install @jupyterlab/git && \
    jupyter serverextension enable --py jupyterlab_git && \
    jupyter labextension enable spellchecker/main
	
# Install from requirements.txt file
COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt 

RUN useradd -ms /bin/bash $NB_USER
USER $NB_UID
WORKDIR /home/$NB_USER
