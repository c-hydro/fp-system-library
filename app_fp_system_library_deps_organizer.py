#!/usr/bin/python3
"""
FP Library - Deps organizer

__date__ = '20220523'
__version__ = '1.0.0'
__author__ =
        'Fabio Delogu (fabio.delogu@cimafoundation.org'

__library__ = 'FP Library'

General command line:
python3 app_fp_system_library_organizer_deps.py

Version(s):
20220523 (1.0.0) --> First release
"""

# -------------------------------------------------------------------------------------
# Complete library
import logging
import os
import time
import glob
from copy import deepcopy
# -------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------
# Algorithm information
alg_version = '1.0.0'
alg_release = '2022-05-23'
alg_name = 'FP Library - Deps organizer'
# Algorithm parameter(s)
time_format = '%Y-%m-%d %H:%M'

# Algorithm logger
logger = logging.getLogger(__name__)
logger_format = "[%(filename)s:%(lineno)s - %(funcName)20s() ] %(message)s"
logger.setLevel(logging.DEBUG)

logging.basicConfig(
    level=logging.INFO,
    format=logger_format,
    handlers=[logging.FileHandler("app_fp_system_library_deps_organizer.log"), logging.StreamHandler()]
)

# Algorithm setting(s)
tag_start_expected = ['LD_LIBRARY_PATH', 'PATH', 'ECCODES_DEFINITION_PATH', 'GEOS_DIR', 'GDAL_DATA', 'PROJ_LIB']
tag_end_expected = ['export']
# -------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------
# Script Main
def main(fp_library_env_folder='fp_system_libs_generic',
         fp_library_env_file_src='fp_system_libs_generic_*', fp_library_env_file_dst='fp_system_libs_generic'):

    # -------------------------------------------------------------------------------------
    # Info algorithm
    logging.info(' ============================================================================ ')
    logging.info(' ==> ' + alg_name + ' (Version: ' + alg_version + ' Release_Date: ' + alg_release + ')')
    logging.info(' ==> START ... ')
    logging.info(' ')

    # Time algorithm information
    start_time = time.time()
    # -------------------------------------------------------------------------------------

    # -------------------------------------------------------------------------------------
    # Define file deps source and destination
    logging.info(' ---> Define file deps source and destination ... ')
    fp_library_env_path_src = os.path.join(fp_library_env_folder, fp_library_env_file_src)
    fp_library_env_path_dst = os.path.join(fp_library_env_folder, fp_library_env_file_dst)

    # Search file deps source
    file_src_list = glob.glob(fp_library_env_path_src)
    # Info
    logging.info(' ---> Define file deps source and destination ... DONE')
    # -------------------------------------------------------------------------------------

    # -------------------------------------------------------------------------------------
    # Organize file deps source
    logging.info(' ---> Organize file deps source and destination ... ')
    file_list_src_start, file_list_src_end = [], []
    for file_src_step in file_src_list:

        file_list_step_start, file_list_step_end = get_file_data(file_src_step)
        file_list_src_start.extend(file_list_step_start)
        file_list_src_start = list(set(file_list_src_start))

        file_list_src_end.extend(file_list_step_end)
        file_list_src_end = list(set(file_list_src_end))

    file_list_src_start = sorted(file_list_src_start)
    file_list_src_end = sorted(file_list_src_end)
    # Info
    logging.info(' ---> Organize file deps source and destination ... DONE')
    # -------------------------------------------------------------------------------------

    # -------------------------------------------------------------------------------------
    # Organize file deps destination
    logging.info(' ---> Write file deps destination ... ')
    file_list_dst = file_list_src_start + file_list_src_end
    # Write file deps destination
    write_file_data(fp_library_env_path_dst, file_list_dst)
    # Info
    logging.info(' ---> Write file deps destination ... DONE')
    # -------------------------------------------------------------------------------------

    # -------------------------------------------------------------------------------------
    # Info algorithm
    time_elapsed = round(time.time() - start_time, 1)

    logging.info(' ')
    logging.info(' ==> ' + alg_name + ' (Version: ' + alg_version + ' Release_Date: ' + alg_release + ')')
    logging.info(' ==> TIME ELAPSED: ' + str(time_elapsed) + ' seconds')
    logging.info(' ==> ... END')
    logging.info(' ==> Bye, Bye')
    logging.info(' ============================================================================ ')
    # -------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
# Method to write file data
def write_file_data(file_path, file_data):
    file_folder, file_name = os.path.split(file_path)
    if not os.path.exists(file_folder):
        os.makedirs(file_folder)
    if os.path.exists(file_path):
        os.remove(file_path)

    with open(file_path, 'w') as file_handle:
        for file_item in file_data:
            file_handle.write("%s\n" % file_item)
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
# Method to get file data
def get_file_data(file_name, tag_start=None, tag_end=None):

    if tag_start is None:
        tag_start = deepcopy(tag_start_expected)
    if tag_end is None:
        tag_end = deepcopy(tag_end_expected)

    file_list_start, file_list_end = [], []
    with open(file_name) as file_handle:
        for file_line in file_handle:
            file_line = file_line.rstrip()
            for tag_step in tag_start:
                if file_line.startswith(tag_step):
                    file_list_start.append(file_line)
            for tag_step in tag_end:
                if file_line.startswith(tag_step):
                    file_list_end.append(file_line)
    return file_list_start, file_list_end
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
# Call script from external library
if __name__ == '__main__':

    fp_path_root = os.path.expanduser('~')
    fp_folder_env = 'fp_system_libs_generic'
    fp_file_env_tmpl_src = 'fp_system_libs_generic_*'
    fp_file_env_tmpl_dst = 'fp_system_libs_generic'

    fp_path_env = os.path.join(fp_path_root, fp_folder_env)

    main(fp_library_env_folder=fp_path_env,
         fp_library_env_file_src=fp_file_env_tmpl_src, fp_library_env_file_dst=fp_file_env_tmpl_dst)
# ----------------------------------------------------------------------------

