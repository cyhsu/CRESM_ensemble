from netCDF4 import Dataset, num2date, date2num
from scipy.interpolate import interp2d 
from glob import glob
import numpy as np, os 

os.system('cp ./ic_bdry/xroms_sst.nc.sample ./ic_bdry/xroms_sst.nc')
units = 'days since 1900-01-01 00:00:00'


#-- Load Original Data --
lists = glob('./input/previous/20180901*.nc')
fid = lists[0]; print('load ocn file (xroms.py) : '+fid)
nc  = Dataset(fid,'r+')
tm  = nc.variables['ocean_time']; tim = num2date(tm[:],tm.units)
tm.units = units; tm[:] = date2num(tim,units)
lon = nc.variables['lon'][:]
lat = nc.variables['lat'][:]
sst = nc.variables['temp'][:,0]
nc.close()


#-- Interpolate to XROMS grid and save --
fid = './ic_bdry/xroms_sst.nc'
nc  = Dataset(fid,'r+')
xc  = nc.variables['xc'][0,:]
yc  = nc.variables['yc'][:,0]
mask= nc.variables['mask'][:]
xroms = np.array([ np.ma.masked_where(mask==0, interp2d(lon,lat,
		  np.ma.array(sst[tid],fill_value=np.nan))(xc,yc)) 
		  for tid in range(len(tim)) ])
tmp = nc.variables['time']
tmp[:len(tim)] = date2num(tim,tmp.units)
tmp = nc.variables['SST']
tmp[:len(tim)] = xroms
nc.close()
