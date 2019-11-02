FROM jupyter/scipy-notebook:1386e2046833

ARG NB_USER=jovyan
ARG NB_UID=1000

USER root

# Re-configure so some man pages get installed (see https://unix.stackexchange.com/questions/480459/docker-debianstretch-slim-install-man-and-view-manpages):
RUN sed -i '/path-exclude \/usr\/share\/man/d' /etc/dpkg/dpkg.cfg.d/docker && \
    sed -i '/path-exclude \/usr\/share\/groff/d' /etc/dpkg/dpkg.cfg.d/docker

# Install man-db first so we can see mdbtools-doc manpages:
RUN apt-get update && apt-get install -yq --no-install-recommends man-db && \
    apt-get install -yq --no-install-recommends \
    mdbtools \
    && rm -rf /var/lib/apt/lists/*

RUN conda install --quiet --yes appmode && \
    jupyter nbextension     enable --py --sys-prefix appmode && \
    jupyter serverextension enable --py --sys-prefix appmode

RUN conda install --quiet --yes bash_kernel && \
    python -m bash_kernel.install

#RUN conda install --quiet --yes fileupload && \
#    jupyter nbextension enable --py widgetsnbextension && \
#    jupyter nbextension install --user --py fileupload && \
#    jupyter nbextension enable  --user --py fileupload

# Copy files into place:
COPY . ${HOME}
RUN chown -R ${NB_UID} ${HOME}

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

#RUN jupyter trust 01-Ident-O-Matic.ipynb

