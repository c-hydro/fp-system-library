# Flood-PROOFS System Libraries (`fp-system-library`)

`fp-system-library` is a collection of bash scripts used to **download, compile and install** third-party libraries required by the **Flood-PROOFS Tools** and **Flood-PROOFS Models** (e.g. **HMC**, **S3M**, and post-processing utilities).

The scripts install libraries in a **user folder** (no root installation required) and, when needed, generate an environment file to setup:

- `PATH`
- `LD_LIBRARY_PATH`

---

## Contents

- [Flood-PROOFS ecosystem](#flood-proofs-ecosystem)
- [Repository overview](#repository-overview)
- [Supported platforms](#supported-platforms)
- [Prerequisites](#prerequisites)
- [Setup scripts](#setup-scripts)
- [Install HMC system libraries (zlib + hdf5 + netcdf4)](#install-hmc-system-libraries-zlib--hdf5--netcdf4)
- [Install other libraries](#install-other-libraries)
- [Using the environment file](#using-the-environment-file)
- [GCC-9 vs GCC-15 notes (Ubuntu 20.04)](#gcc-9-vs-gcc-15-notes-ubuntu-2004)
- [Troubleshooting](#troubleshooting)
- [Changelog](#changelog)
- [License](#license)

---

## Flood-PROOFS ecosystem

Flood-PROOFS components can be grouped into:

### FloodProofs Tools
Utilities and supporting software used to prepare input data, manage workflows and handle pre/post-processing steps (e.g., ingestion, format conversion, gridding, orchestration, I/O utilities).

### FloodProofs Models
Numerical models and simulation components used to produce hydrological and cryospheric forecasts (e.g. **HMC**, **S3M**).

---

## Repository overview

This repository hosts multiple *standalone* installer scripts.  
Each script typically follows this workflow:

1. download source archives
2. extract archives into a `source/` folder
3. compile sources
4. install outputs into a dedicated prefix folder
5. (optional) create an environment file exporting `PATH` and `LD_LIBRARY_PATH`

---

## Supported platforms

The scripts are designed and tested mainly for:

- Linux (Ubuntu / Debian family)
- 64-bit systems

Other distributions may work but can require additional dependencies.

---

## Prerequisites

Install base build tools and common dependencies (Ubuntu/Debian):

```bash
sudo apt-get update

sudo apt-get install -y \
  gcc g++ gfortran \
  make m4 \
  wget curl \
  libcurl4-openssl-dev \
  pkg-config
```

Some libraries may require extra packages (see [Troubleshooting](#troubleshooting)).

---

## Setup scripts

This repository provides setup scripts for different libraries and dependency stacks.

### Core compression / scientific I/O
- `setup_fp_system_library_zlib.sh` → zlib
- `setup_fp_system_library_hdf4.sh` → HDF4
- `setup_fp_system_library_hdf5.sh` → HDF5
- `setup_fp_system_library_nc4.sh` → NetCDF4 stack (netcdf-c + netcdf-fortran)

### Geospatial stack
- `setup_fp_system_library_proj.sh` → PROJ
- `setup_fp_system_library_geos.sh` → GEOS
- `setup_fp_system_library_gdal.sh` → GDAL

### GRIB / meteorological stack
- `setup_fp_system_library_eccodes.sh` → ECMWF ecCodes
- `setup_fp_system_library_jasper.sh` → JasPer
- `setup_fp_system_library_openjpeg.sh` → OpenJPEG

### UDUNITS and auxiliary dependencies
- `setup_fp_system_library_udunits.sh` → UDUNITS2

### Model-related stacks
- `setup_fp_system_library_hmc.sh` → HMC required stack (zlib + hdf5 + netcdf4)
- `setup_fp_system_library_s3m.sh` → S3M required stack

### Other utilities
- `setup_fp_system_library_mrt.sh` → MRT
- `setup_fp_system_library_antlr.sh` → ANTLR 2.7.7 (used for linking with some applications, e.g. NCO)

---

## Install HMC system libraries (zlib + hdf5 + netcdf4)

The main script for the HMC dependency stack is:

```bash
setup_fp_system_library_hmc.sh
```

### What it installs

The script downloads, compiles and installs in this order:

1. **zlib**
2. **HDF5** (built with zlib support)
3. **netCDF-C** (built with HDF5 support → netCDF-4 enabled)
4. **netCDF-Fortran** (linked to netCDF-C)

At the end, it generates an environment file exporting:

- `LD_LIBRARY_PATH`
- `PATH`

### Default install folder

If no arguments are provided, libraries are installed in:

```bash
$HOME/fp_system_libs_hmc
```

### Default environment filename

The environment file created is:

```bash
$HOME/fp_system_libs_hmc/fp_system_libs_hmc
```

### Run installation (default)

```bash
bash setup_fp_system_library_hmc.sh
```

### Run installation (custom folder)

```bash
bash setup_fp_system_library_hmc.sh /path/to/install/folder
```

### Run installation (custom folder + env filename)

```bash
bash setup_fp_system_library_hmc.sh /path/to/install/folder my_env_file
```

### Conservative versions (GCC-9 and GCC-15 compatible)

The script is aligned with the following conservative versions:

- **zlib**: 1.3.1
- **HDF5**: 1.12.1 (stable series)
- **netCDF-C**: 4.7.4
- **netCDF-Fortran**: 4.5.4

---

## Install other libraries

All other scripts can be executed similarly:

```bash
bash <setup_script_name>.sh
```

Examples:

```bash
bash setup_fp_system_library_zlib.sh
bash setup_fp_system_library_hdf5.sh
bash setup_fp_system_library_nc4.sh
bash setup_fp_system_library_gdal.sh
bash setup_fp_system_library_proj.sh
bash setup_fp_system_library_eccodes.sh
```

> **Note**: some libraries require additional system packages (for example `libtiff-dev`, `libjpeg-dev`, `libxml2-dev`, `libssl-dev`).
> If compilation fails, check the error message and install missing packages.

---

## Using the environment file

After a successful build, enable libraries by sourcing the generated environment file:

```bash
source <INSTALL_PREFIX>/<ENV_FILENAME>
```

Example:

```bash
source $HOME/fp_system_libs_hmc/fp_system_libs_hmc
```

### Quick validation

```bash
which h5dump
which ncdump
which nc-config
which nf-config

h5dump --version || true
ncdump --version || true
nc-config --all || true
nf-config --all || true
```

---

## GCC-9 vs GCC-15 notes (Ubuntu 20.04)

### GCC-9 (default on Ubuntu 20.04)
Ubuntu 20.04 provides GCC 9.x by default and it is suitable for most builds.

### GCC-15 on Ubuntu 20.04
Ubuntu 20.04 does not provide `gcc-15` packages in the default repositories.

To compile using **GCC-15** you can:

- build inside Docker using an **Ubuntu 20.04 container + isolated GCC-15 toolchain**, or
- use a newer Ubuntu container (24.04+) but **this may generate binaries that do not run on Ubuntu 20.04** due to `glibc` mismatch.

**Recommended approach for Ubuntu 20.04 runtime compatibility:**

- use Docker `ubuntu:20.04`
- build/install GCC-15 inside the container (isolated prefix)
- compile libraries into a host-mounted directory

---

## Troubleshooting

### Missing build dependencies
If a library fails during `configure`, install missing prerequisites.

Examples (Ubuntu/Debian):

```bash
sudo apt-get install -y \
  libxml2-dev \
  libssl-dev \
  zlib1g-dev
```

### Shared libraries not found at runtime
If you get:

```text
error while loading shared libraries: libnetcdf.so: cannot open shared object file
```

ensure you sourced the environment file:

```bash
source <INSTALL_PREFIX>/<ENV_FILENAME>
echo $LD_LIBRARY_PATH
```

### Mixed compiler installations
Do not mix different compilers (e.g. GCC-9 and GCC-15) into the same install directory.
If switching compiler/toolchain, use a clean prefix folder.

---

## Changelog

See `CHANGELOG.rst` (or the `Changelog` section maintained in this repository).

---

## License

This repository is released under the MIT License (see `LICENSE`).
