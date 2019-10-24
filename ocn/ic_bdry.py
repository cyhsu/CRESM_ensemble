from netCDF4 import Dataset, num2date, date2num
from scipy.interpolate import interp2d 
from glob import glob
import numpy as np, os 
lists = glob('./ic_bdry/copernicus*.nc')
for fid in lists:
	nc = Dataset(fid,'r+')
	tm = nc.variables['ocean_time']
	tim= num2date(tm[:],tm.units)
	units = 'seconds since '+tim[0].strftime('%Y-%m-%d %H:%M:%S')
	tm.units = units
	tm[:] = date2num(tim,tm.units)
	nc.close()
