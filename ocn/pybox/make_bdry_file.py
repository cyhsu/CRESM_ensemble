import matplotlib
matplotlib.use('Agg')

import subprocess
import os
import sys
from multiprocessing import Pool
from functools import partial
from glob import glob
import numpy as np
#import pdb

#increase the maximum number of open files allowed
#import resource
#resource.setrlimit(resource.RLIMIT_NOFILE, (3000,-1))

import pyroms
import pyroms_toolbox

from remap_bdry import remap_bdry
from remap_bdry_uv import remap_bdry_uv

dst_dir='./ic_bdry/'

def do_file(file, src_grd, dst_grd):
    zeta = remap_bdry(file, 'ssh', src_grd, dst_grd, dst_dir=dst_dir)
    dst_grd = pyroms.grid.get_ROMS_grid('GOM_Copernicus', zeta=zeta)
    remap_bdry(file, 'temp', src_grd, dst_grd, dst_dir=dst_dir)
    remap_bdry(file, 'salt', src_grd, dst_grd, dst_dir=dst_dir)
#    pdb.set_trace()
    remap_bdry_uv(file, src_grd, dst_grd, dst_dir=dst_dir)

    # merge file
    bdry_file = dst_dir + file.rsplit('/')[-1][:-3] + '_bdry_' + dst_grd.name + '.nc'

    out_file = dst_dir + file.rsplit('/')[-1][:-3] + '_ssh_bdry_' + dst_grd.name + '.nc'
    command = ('ncks', '-a', '-O', out_file, bdry_file) 
    subprocess.call(command)
    os.remove(out_file)
    out_file = dst_dir + file.rsplit('/')[-1][:-3] + '_temp_bdry_' + dst_grd.name + '.nc'
    command = ('ncks', '-a', '-A', out_file, bdry_file) 
    subprocess.call(command)
    os.remove(out_file)
    out_file = dst_dir + file.rsplit('/')[-1][:-3] + '_salt_bdry_' + dst_grd.name + '.nc'
    command = ('ncks', '-a', '-A', out_file, bdry_file) 
    subprocess.call(command)
    os.remove(out_file)
    out_file = dst_dir + file.rsplit('/')[-1][:-3] + '_u_bdry_' + dst_grd.name + '.nc'
    command = ('ncks', '-a', '-A', out_file, bdry_file) 
    subprocess.call(command)
    os.remove(out_file)
    out_file = dst_dir + file.rsplit('/')[-1][:-3] + '_v_bdry_' + dst_grd.name + '.nc'
    command = ('ncks', '-a', '-A', out_file, bdry_file) 
    subprocess.call(command)
    os.remove(out_file)

lst_file = glob('./input/copernicus_forecast_*.nc')
#lst_file ='./input/copernicus_forecast.nc'

print 'Build OBC file from the following file list:'
print lst_file
print ' '

src_grd_file = './grid/copernicus_grid.nc'
src_grd = pyroms_toolbox.Grid_HYCOM.get_nc_Grid_Copernicus(src_grd_file)
dst_grd = pyroms.grid.get_ROMS_grid('GOM_Copernicus')
#do_file(lst_file,src_grd=src_grd,dst_grd=dst_grd)

processes = 4
p = Pool(processes)
# Trick to pass more than one arg
partial_do_file = partial(do_file, src_grd=src_grd, dst_grd=dst_grd)
results = p.map(partial_do_file, lst_file)
