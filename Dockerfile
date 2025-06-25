FROM python:3.12-slim

# Install Python 3.12 packages
RUN pip install --no-cache-dir jupyterlab jupyterlab-deck numpy numba jax pyarrow awkward pybind11

# Download and build Python 3.13 (with --disable-gil)
ENV PYTHON_VERSION=3.13.5

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        wget \
        ca-certificates \
        libssl-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libffi-dev \
        zlib1g-dev \
        curl \
        git && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz && \
    tar -xf Python-${PYTHON_VERSION}.tar.xz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --prefix=/usr/local --disable-gil --enable-optimizations --with-ensurepip=install && \
    make -j"$(nproc)" && \
    make altinstall && \
    cd .. && rm -rf Python-${PYTHON_VERSION}*

# Install Python 3.13 packages
RUN pip3.13 install --no-cache-dir numpy

# Set up the working directory
COPY notebooks/ /notebooks/
RUN chown -R root:root /notebooks/

# Expose Jupyter port
EXPOSE 8888

# Turn off Jupyter announcements
RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

# Start Jupyter Lab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--no-browser", "--notebook-dir=/notebooks", "/notebooks/presentation.ipynb"]
