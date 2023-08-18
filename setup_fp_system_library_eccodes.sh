#!/bin/bash -e

#-----------------------------------------------------------------------------------------
# NOTE:
# sudo apt-get install python-dev   # for python2.x
# sudo apt-get install python3-dev  # for python3.x
# sudo apt-get install cmake
#-----------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------
# Script information
script_name='FP ENVIRONMENT - SYSTEM LIBRARIES GENERIC - ECCODES'
script_version="1.0.0"
script_date='2022/05/18'

# Define library name, archive and repository
library_clean=true
library_name='eccodes'
library_archive_generic='eccodes.tar.gz'
library_archive_reference='eccodes-2.20.0-Source.tar.gz'
library_archive_address='https://confluence.ecmwf.int/download/attachments/45757960/'

# Define library building root and source path
generic_path_building_destination=$HOME/fp_system_libs_generic
generic_path_building_source=$HOME/fp_system_libs_generic/source
generic_file_env='fp_system_libs_generic_eccodes'

generic_path_installer_exec=$(pwd)
generic_path_installer_archive=$(pwd)

# Define deps
library_deps_hdf5_main=${generic_path_building_destination}/hdf5
library_deps_netcdf_main=${generic_path_building_destination}/netcdf-c
library_deps_hdf5_bin=${library_deps_hdf5_main}/bin/
library_deps_hdf5_lib=${library_deps_hdf5_main}/lib/
library_deps_netcdf_lib=${library_deps_netcdf_main}/lib/

# Define export flags and settings
export PATH=${library_deps_hdf5_bin}:$PATH
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${library_deps_hdf5_lib}
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${library_deps_netcdf_lib}

# Define library line command
library_cmd_archive_remove_source='rm -rf %LIBRARY_PATH_BUILDING_SOURCE'
library_cmd_archive_remove_destination='rm -rf %LIBRARY_PATH_BUILDING_DESTINATION'
library_cmd_archive_download_local='cp %LIBRARY_ARCHIVE_LINK_LOCAL %LIBRARY_ARCHIVE_BUILDING_SOURCE'
library_cmd_archive_download_remote='wget %LIBRARY_ARCHIVE_LINK_REMOTE -O %LIBRARY_ARCHIVE_BUILDING_SOURCE'
library_cmd_archive_unzip="tar -xzvf %LIBRARY_ARCHIVE_BUILDING_SOURCE -C %LIBRARY_PATH_BUILDING_SOURCE --strip-components=1"

library_cmd_archive_configure='cmake ../../eccodes -DENABLE_NETCDF=ON -DNETCDF_PATH=%LIBRARY_DEPS_NETCDF_MAIN -DCMAKE_INSTALL_PREFIX=%LIBRARY_PATH_BUILDING_DESTINATION'
library_cmd_archive_build='make'
library_cmd_archive_install='make install'
# ----------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------
# Info script start
echo " ==================================================================================="
echo " ==> "$script_name" (Version: "$script_version" Release_Date: "$script_date")"
echo " ==> START ..."
# ----------------------------------------------------------------------------------------

 # ----------------------------------------------------------------------------------------
# Info start
echo " ===> BUILDING LIBRARY "${library_name}" ..."

# Create library path for installer executables and archive
if [ ! -d "${generic_path_installer_exec}" ]; then
	mkdir -p ${generic_path_installer_exec}
fi
if [ ! -d "${generic_path_installer_archive}" ]; then
	mkdir -p ${generic_path_installer_archive}
fi

# Define and create library path for building source and destination
library_path_building_source=${generic_path_building_source}/${library_name}/
library_path_building_build=${generic_path_building_source}/${library_name}/build/
library_path_building_destination=${generic_path_building_destination}/${library_name}

if ${library_clean}; then
	if [ -d "${library_path_building_source}" ]; then
		rm -rf ${library_path_building_source}
	fi
	if [ -d "${library_path_building_destination}" ]; then
		rm -rf ${library_path_building_destination}
	fi
	if [ -d "${library_path_building_build}" ]; then
		rm -rf ${library_path_building_build}
	fi
fi


if [ ! -d "${library_path_building_source}" ]; then
	mkdir -p ${library_path_building_source}
fi

if [ ! -d "${library_path_building_destination}" ]; then
	mkdir -p ${library_path_building_destination}
fi

if [ ! -d "${library_path_building_build}" ]; then
	mkdir -p ${library_path_building_build}
fi

# Define library path bin, include and lib
library_path_bin=${library_path_building_destination}/bin/
library_path_include=${library_path_building_destination}/include/
library_path_lib=${library_path_building_destination}/lib/
library_path_definition=${library_path_building_destination}/share/eccodes/definitions/
# ----------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------
# Check library on local repository
if [ ! -d "${library_path_bin}" -a ! -d "${library_path_lib}" ]; then

	# ----------------------------------------------------------------------------------------
	# Check archive availability
	echo " ====> CHECK ARCHIVE "${library_archive_reference}" ... "

	# Define library remote and local link(s)
	library_archive_link_remote=${library_archive_address}/${library_archive_reference}
	library_archive_link_local=${generic_path_installer_archive}/${library_archive_reference}

	if [ -f "$library_archive_link_local" ]; then
		library_cmd_archive_download_selected=${library_cmd_archive_download_local}
		echo " ====> CHECK ARCHIVE "${library_archive_reference}" ... FOUND IN LOCAL REPOSITORY "
	else 
		library_cmd_archive_download_selected=${library_cmd_archive_download_remote}
		echo " ====> CHECK ARCHIVE "${library_archive_reference}" ... NOT FOUND IN LOCAL REPOSITORY. IT WILL SEARCH IN REMOTE REPOSITORY"
	fi
	# ----------------------------------------------------------------------------------------

	# ----------------------------------------------------------------------------------------
	# Download archive source(s)
	echo " ====> DOWNLOAD ARCHIVE "${library_archive_reference}" ... "

	# Define archive source path and file_name
	library_archive_building_source=${library_path_building_source}${library_archive_generic}

	# Define download command-line
	library_cmd_archive_download_filled=${library_cmd_archive_download_selected/'%LIBRARY_ARCHIVE_LINK_LOCAL'/$library_archive_link_local}
	library_cmd_archive_download_filled=${library_cmd_archive_download_filled/'%LIBRARY_ARCHIVE_LINK_REMOTE'/$library_archive_link_remote}
	library_cmd_archive_download_filled=${library_cmd_archive_download_filled/'%LIBRARY_ARCHIVE_BUILDING_SOURCE'/$library_archive_building_source}

	# Execute command-line
	if ! ${library_cmd_archive_download_filled} ; then
		# Info tag end (failed)
		echo " ====> DOWNLOAD ARCHIVE ... FAILED. ERRORS IN EXECUTING $library_cmd_archive_download_filled COMMAND-LINE"
		exit
	else
		# Info tag end (completed)
		echo " ====> DOWNLOAD ARCHIVE ${library_cmd_archive_download_filled} ... DONE"
	fi
	# ----------------------------------------------------------------------------------------

	# ----------------------------------------------------------------------------------------
	# Unzip archive source(s)
	echo " ====> UNZIP ARCHIVE "${library_archive_generic}" ... "

	# Define archive source path and file_name
	library_archive_building_source=${library_path_building_source}${library_archive_generic}

	# Define download command-line
	library_cmd_archive_unzip=${library_cmd_archive_unzip/'%LIBRARY_ARCHIVE_BUILDING_SOURCE'/$library_archive_building_source}
	library_cmd_archive_unzip=${library_cmd_archive_unzip/'%LIBRARY_PATH_BUILDING_SOURCE'/$library_path_building_source}

	# Execute command-line
	if ! ${library_cmd_archive_unzip} > /dev/null ; then
		# Info tag end (failed)
		echo " ====> UNZIP ARCHIVE ... FAILED. ERRORS IN EXECUTING $library_cmd_archive_unzip COMMAND-LINE"
		exit
	else
		# Info tag end (completed)
		echo " ====> UNZIP ARCHIVE ${library_archive_generic} ... DONE"
	fi
	# ----------------------------------------------------------------------------------------

	# ----------------------------------------------------------------------------------------
	# Configure archive source(s)
	echo " ====> CONFIGURE ARCHIVE "${library_archive_generic}" ... "

	# Define download command-line
	library_cmd_archive_configure=${library_cmd_archive_configure/'%LIBRARY_PATH_BUILDING_DESTINATION'/$library_path_building_destination}
	library_cmd_archive_configure=${library_cmd_archive_configure/'%LIBRARY_DEPS_NETCDF_MAIN'/$library_deps_netcdf_main}
	
	if [ ! -d "${library_deps_hdf5_main}" ]; then
		echo " ===> LIBRARY HDF5 NOT FOUND. EXIT"
		exit
	fi
	if [ ! -d "${library_deps_netcdf_main}" ]; then
		echo " ===> LIBRARY NETCDF NOT FOUND. EXIT"
		exit
	fi
	
	# Execute command-line
	cd $library_path_building_build
	echo $pwd
	if ! ${library_cmd_archive_configure} ; then
		# Info tag end (failed)
		echo " ====> CONFIGURE ARCHIVE ... FAILED. ERRORS IN EXECUTING $library_cmd_archive_configure COMMAND-LINE"
		exit
	else
		# Info tag end (completed)
		echo " ====> CONFIGURE ARCHIVE ${library_cmd_archive_configure} ... DONE"
	fi
	# ----------------------------------------------------------------------------------------


	# ----------------------------------------------------------------------------------------
	# Build archive source(s)
	echo " ====> BUILD ARCHIVE "${library_archive_generic}" ... "

	# Execute command-line
	cd $library_path_building_build
	if ! ${library_cmd_archive_build} ; then
		# Info tag end (failed)
		echo " ====> BUILD ARCHIVE ... FAILED. ERRORS IN EXECUTING $library_cmd_archive_build COMMAND-LINE"
		exit
	else
		# Info tag end (completed)
		echo " ====> BUILD ARCHIVE ${library_archive_generic} ... DONE"
	fi
	# ----------------------------------------------------------------------------------------

	# ----------------------------------------------------------------------------------------
	# Install archive source(s)
	echo " ====> INSTALL ARCHIVE "${library_archive_generic}" ... "

	# Execute command-line
	cd $library_path_building_build
	if ! ${library_cmd_archive_install} ; then
		# Info tag end (failed)
		echo " ====> INSTALL ARCHIVE ... FAILED. ERRORS IN EXECUTING $library_cmd_archive_install COMMAND-LINE"
		exit
	else
		# Info tag end (completed)
		echo " ====> INSTALL ARCHIVE ${library_archive_generic} ... DONE"
	fi
	# ----------------------------------------------------------------------------------------


	# ----------------------------------------------------------------------------------------
	# Create environmental file
	echo " ====> CREATE ENVIRONMENTAL FILE ... "

	# Delete old version of environmetal file
	cd $generic_path_building_destination

	if [ -f $generic_file_env ] ; then
		rm $generic_file_env
	fi

	# Export LIBRARY PATH(S)
	echo "LD_LIBRARY_PATH="'$LD_LIBRARY_PATH'":${library_path_lib}" >> $generic_file_env
	echo "export LD_LIBRARY_PATH" >> $generic_file_env

	# Export BINARY PATH(S)
	echo "PATH=${library_path_bin}:"'$PATH'"" >> $generic_file_env
	echo "export PATH" >> $generic_file_env
	
	# Export ECCODES DEFINITION PATH(S)
	echo "ECCODES_DEFINITION_PATH=${library_path_definition}" >> $generic_file_env
	echo "export ECCODES_DEFINITION_PATH" >> $generic_file_env
	
	echo " ====> CREATE ENVIRONMENTAL FILE ... DONE"
	# ----------------------------------------------------------------------------------------
	
	# ----------------------------------------------------------------------------------------
	# Info end
    echo " ===> BUILDING LIBRARY "${library_name}" ... DONE"
    # ----------------------------------------------------------------------------------------
    
else

	# ----------------------------------------------------------------------------------------
	# Info end
    echo " ===> BUILDING LIBRARY "${library_name}" ... SKIPPED. LIBRARY PREVIOUSLY INSTALLED"
    # ----------------------------------------------------------------------------------------
    
fi
# ----------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------
# Info script end
echo " ==> ... END"
echo " ==> Bye, Bye"
echo " ==================================================================================="
# ----------------------------------------------------------------------------------------


