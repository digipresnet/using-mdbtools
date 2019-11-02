FROM jupyter/scipy-notebook:1386e2046833

USER root

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    mdbtools \
    && rm -rf /var/lib/apt/lists/*

RUN conda install --quiet --yes appmode && \
    jupyter nbextension     enable --py --sys-prefix appmode && \
    jupyter serverextension enable --py --sys-prefix appmode

#RUN conda install --quiet --yes fileupload && \
#    jupyter nbextension enable --py widgetsnbextension && \
#    jupyter nbextension install --user --py fileupload && \
#    jupyter nbextension enable  --user --py fileupload

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

#RUN jupyter trust 01-Ident-O-Matic.ipynb

