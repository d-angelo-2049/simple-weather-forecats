FROM nvidia/cuda:10.0-devel-ubuntu18.04

# set timezone to Asia/Tokyo
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# install miniconda 
ENV MINICONDA_VERSION py37_23.1.0-1
ENV CONDA_DIR /opt/conda

RUN apt update && \
    apt install -y curl && \
    curl -sLo ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-$MINICONDA_VERSION-Linux-x86_64.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh

# Activate conda in non-interactive shell
RUN /opt/conda/bin/conda init bash


# create a new conda environment and activate it
COPY ./tensorflow-py3_7.yaml /tmp/tensorflow-py3_7.yaml
RUN $CONDA_DIR/bin/conda env create -f /tmp/tensorflow-py3_7.yaml
ENV PATH $CONDA_DIR/envs/tensorflow-py3_7/bin:$PATH
RUN echo "conda activate tensorflow-py3_7" >> ~/.bashrc


# clean packages
RUN /opt/conda/bin/conda clean --all --yes

# expose port 8888 for JupytorLab
EXPOSE 8888

# set the working directory to /simple-cla
WORKDIR /simple-weather-forecats

# mount the current directory on the host to WORKDIR
COPY . /simple-weather-forecats

SHELL ["/bin/bash", "-c", "source ~/.bashrc && conda activate tensorflow-py3_7"]
