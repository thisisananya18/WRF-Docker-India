# WRF Docker Container
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies (NO jasper)
RUN apt-get update && apt-get install -y \
    gcc \
    gfortran \
    g++ \
    make \
    wget \
    curl \
    git \
    csh \
    m4 \
    perl \
    libnetcdf-dev \
    libnetcdff-dev \
    libpng-dev \
    zlib1g-dev \
    openmpi-bin \
    libopenmpi-dev \
    netcdf-bin \
    && apt-get clean \
    || apt-get install -y --fix-missing \
    gcc gfortran g++ make wget curl git csh m4 perl \
    libnetcdf-dev libnetcdff-dev libpng-dev zlib1g-dev \
    openmpi-bin libopenmpi-dev netcdf-bin \
    && apt-get clean

# Set environment variables (NO jasper)
ENV NETCDF=/usr
ENV HDF5=/usr/lib/x86_64-linux-gnu/hdf5/serial
ENV PATH=$PATH:/usr/lib/openmpi/bin
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu
ENV WRF_DIR=/wrf/WRF

# Create directories
RUN mkdir -p /wrf/WPS_GEOG

WORKDIR /wrf

# Copy compiled WRF and WPS
COPY WRF/ /wrf/WRF/
COPY WPS/ /wrf/WPS/

# Copy geographic data
COPY DATA/geog/WPS_GEOG_LOW_RES/ /wrf/WPS_GEOG/

# Copy all 4 domain configs
COPY runs/ /wrf/runs/

ENV PATH=$PATH:/wrf/WRF/main:/wrf/WPS

CMD ["/bin/bash"]
