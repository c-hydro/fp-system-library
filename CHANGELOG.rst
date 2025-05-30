=========
Changelog
=========

Version 1.0.6 [2025-02-25]
**************************
FIX: **setup_fp_system_library_nc4.sh**
    - Library nc4 set strip_components=1 in unzipping tar.gx archive (mismatch with the previous behaviours)

FIX: **setup_fp_system_library_s3m.sh**
    - Library hmc change the zlib version (3.1.3) and add flag to allow argument mismatch (fortran compiler)

FIX: **setup_fp_system_library_hdf5.sh**
    - Library hdf5 update the links of old (tested) and new (not tested) libraries according with other libraries and applications

Version 1.0.5 [2024-02-21]
**************************
FIX: **setup_fp_system_library_hmc.sh**
    - Library hmc change the zlib version (3.1.3) and add flag to allow argument mismatch (fortran compiler)

Version 1.0.4 [2024-01-26]
**************************
FIX: **setup_fp_system_library_eccodes.sh**
    - Library eccodes add some notes to prerequisites (fortran)

FIX: **setup_fp_system_library_proj.sh**
    - Library proj add some notes to prerequisites (libtiff and pkg-config)

FIX: **setup_fp_system_library_hdf4.sh**
    - Library hdf4 version set to 4.2.16 (to solve openjpeg linking)

FIX: **setup_fp_system_library_zlib.sh**
    - Library zlib version set to 1.3.1 

Version 1.0.3 [2023-08-18]
**************************
APP: **setup_fp_system_library_antlr.sh**
    - Script for installing antlr library 2.7.7 version (for linking to nco-5.1.7 application)   

FIX: **all bash scripts**
	- make commands set in root path and not in binaries path

Version 1.0.2 [2022-12-09]
**************************
FIX: **setup_fp_system_library_gdal.sh**
    - Add folder of geographical files to skip error4 in build gdal library


Version 1.0.1 [2022-10-27]
**************************
APP: **setup_fp_system_library_s3m.sh**
    - Script for installing s3m library  

FIX: **setup_fp_system_library_hmc.sh**
    - Library zlib version set to 1.2.13  
    
FIX: **setup_fp_system_library_zlib.sh**
    - Library zlib version set to 1.2.13  

Version 1.0.0 [2022-05-23]
**************************
APP: **app_fp_system_library_deps_organizer.py**
    - Script for merging library deps 
    
APP: **setup_fp_system_library_eccodes.sh**
    - Script for installing eccodes library  

APP: **setup_fp_system_library_gdal.sh**
    - Script for installing gdal library  

APP: **setup_fp_system_library_geos.sh**
    - Script for installing geos library  

APP: **setup_fp_system_library_hdf4.sh**
    - Script for installing hdf4 library  
    
APP: **setup_fp_system_library_hdf5.sh**
    - Script for installing hdf5 library  
    
APP: **setup_fp_system_library_hmc.sh**
    - Script for installing hmc library  
    	- [2022-05-10] Versione 1.7.1 provided in the fp-envs package 
    
APP: **setup_fp_system_library_jasper.sh**
    - Script for installing jasper library  
    
APP: **setup_fp_system_library_mrt.sh**
    - Script for installing mrt library
    
APP: **setup_fp_system_library_nc4.sh**
    - Script for installing nc4 library 

APP: **setup_fp_system_library_openjpeg.sh**
    - Script for installing openjpeg library 

APP: **setup_fp_system_library_proj.sh**
    - Script for installing proj library 

APP: **setup_fp_system_library_udunits.sh**
    - Script for installing udunits library 

APP: **setup_fp_system_library_zlib.sh**
    - Script for installing zlib library 
