FROM jupyter/datascience-notebook:6fb3eca57bd3

USER $NB_USER

RUN pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --user && \
    # can modify or enable additional extensions here
    jupyter nbextension enable spellchecker/main --user

# Remove distutil package because pip do not remove them safely and 
# I need a newer version to fix security bug
RUN conda remove pyyaml -y

# Install from requirements.txt file
COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt && \
    fix-permissions /home/$NB_USER
