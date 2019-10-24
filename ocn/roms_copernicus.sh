#!/bin/bash
#-   Downloading the Marine Copernicus analysis and forecast data  
#-       - horizontal resolution : 0.083 x 0.083
#-       - temporal resolution : daily-mean
#-       - vertical resolution : 75 layers
#-       - from today to 9 days after
#---
#--- @C.Y. Hsu (2017-09-20)
#===================================================================
source ~/.bashrc
#--  B4 initial the code  --
##--  PARAMETERS from cpl_gom.sh  --
t0=$1
t1=$2
DEFU_DIR=`pwd`
WORK_DIR=$DEFU_DIR/ocn

echo "DEFU_DIR " $DEFU_DIR
echo "WORK_DIR " $WORK_DIR

##--  ENVIRONMENTAL SET UP  --
module purge
module load intel/2015a netCDF-Fortran/4.4.0-intel-2015a Anaconda/2-4.0.0 
source activate chsu1
export PYROMS_GRIDID_FILE=$WORK_DIR/grid/gridid.txt

##--  PARAMETER SET UP : ..download process.. --
motu_dir='/home/chsu1/scratch/GOM_FORECAST/ocn/Copernicus/motu-client-python/'
motu_py=$motu_dir"motu-client.py"
username='chsu1'; 
password='Gisr@2017'
http_m='http://nrtcmems.mercator-ocean.fr/motu-web/Motu'
http_s='GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS'
http_d='global-analysis-forecast-phy-001-024'
leftlow_corner_lon=-101
leftlow_corner_lat=10 
rightup_corner_lon=-75
rightup_corner_lat=35
z0=0.494; z1=5727.9171
var0='zos'; var1='thetao'; var2='so'; var3='uo'; var4='vo'
odir=$WORK_DIR/input/previous 
ofile=`echo $t0"_"$t1".nc"| sed -s 's/ ..:00:00//g'| sed -s 's/-//g'`

#-- DOWNLOAD : ..Copernicus analysis/forecast data.. --
python $motu_py -u $username -p $password -m $http_m -s $http_s -d $http_d -x $leftlow_corner_lon -X $rightup_corner_lon -y $leftlow_corner_lat -Y $rightup_corner_lat -t $t0 -T $t1 -z $z0 -Z $z1 -v $var0 -v $var1 -v $var2 -v $var3 -v $var4 -o $odir -f $ofile

##- .. Record the simulation ..
echo ' '; echo ' '
ftime=`ls -l $odir/$ofile | awk '{print $6 $7}'`
ftime=`date -d $ftime +%b%d`
ntime=`date +%b%d`
if [ $ntime == $ftime ]; then 
	echo "Processing the simulation begins from "`date +%F ` "successful."
else 
	mail -s "GOM Forecast Report on ada" bbsx@hotmail.com <<< "Dear System Administrator, the GOM Auto-Forecast system is suspended since download process is not working."
	echo "Processing the simulation begins from "`date +%F ` " UNSUCCESSFUL."
	exit 1
fi

echo ' '; echo ' '


##- .. POST-PROCESS for PYROMS ..
nfile='./input/copernicus_forecast.nc'
ncrename -d longitude,lon -v longitude,lon "$odir"/"$ofile" 
ncrename -d latitude,lat -v latitude,lat "$odir"/"$ofile" 
ncrename -d depth,z -v depth,z "$odir"/"$ofile" 
ncrename -d time,ocean_time -v time,ocean_time "$odir"/"$ofile" 
ncrename -v thetao,temp -v so,salt -v uo,u -v vo,v -v zos,ssh "$odir"/"$ofile" 

##--  Copernicus (Time Units change) and XROMS SST update  --
##--  Change the time to units = 'days since 1900-01-01 00:00:00'
cd $WORK_DIR
sed -i "s/previous\/.*nc/previous\/`date -d "$t0" +%Y%m%d`*.nc/" xroms.py
ipython xroms.py

ncks -O -d lon,1,-2 -d lat,1,-2 "$odir"/"$ofile" "$nfile"

num=`ncdump -h $nfile |grep ocean_time|head -1|awk '{print $3}'`
for tid in $(eval echo {0..$((num-1))})
do
	nfid=`printf ./input/copernicus_forecast_%02d.nc $tid`
	echo " "
	ncks -O -h -d ocean_time,$tid $nfile $nfid
done
rm -rf $nfile

##--  PYROMS RUN  --
if [ ! -f ./grid/copernicus_grid.nc ]; then 
	echo '...The Grid File of copernicus is not existed...'
	echo 'So, boy, do you want to create one by me or do it by yourself?'
	read -p 'Yes -- me, No -- yourself : ' grid_answer
	if [ 'Yes' == "$grid_answer" ]; then 
		ncks -d ocean_time,0 -v temp "$odir"/"$ofile" "./copernicus_grid.nc"
	else
		echo '!! Friendly reminder that the size of the grid point (x-1:x+1,y-1:y+1) is larger than data point (x,y) !!'
		echo '!! Remember, you need to run "make_remap_weights_file.py" before working on ini/bdry condition.'
		exit 1
	fi
fi

echo " "; echo " "; echo "...  Build initial condition for ROMS  ..."
ipython make_ic_file.py
echo " "; echo " "; echo "...  Build boundary condition for ROMS  ..."
ipython make_bdry_file.py

outnc='./ic_bdry/copernicus_forecast_bdry_GOM_Copernicus.nc'
ncrcat -O -h ./ic_*/*_??_bd*nc $outnc
rm -rf ./ic_*/*_??_bdry*nc

cp ./ic*/copernicus_forecast_00_ic_GOM_Copernicus.nc ./ic_bdry/copernicus_forecast_ic_GOM_Copernicus.nc
##--  revise routine_run_01.ocn.in ((i.e. ocean.in))  --
cp routine_run_01.ocn.in.sample routine_run_01.ocn.in
hh=`awk "BEGIN {print $(date -d "$t0" +%H)/24}" |sed 's/0.//'`
TIME_REF=`date -d "$t0" +%Y%m%d`"."$hh
sed -i "s/20170922.5/$TIME_REF/g" routine_run_01.ocn.in 

##--  Revise ocean_time for ini/bdry  --
ipython ic_bdry.py
echo "done, finish all of the ocean process"
