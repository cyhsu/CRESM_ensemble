#!/bin/bash
#-
#- Routine to download the GFS 7 days forecast.
#-
#- C.Y. Hsu @ 2017-09-21 TAMU
#--------------------------------------------

#--  B4 initial the code  --
##--  PARAMETERS from cpl_gom.sh  --
DEFU_DIR=`pwd`
WORK_DIR=$DEFU_DIR/atm
WORK_WPS=$WORK_DIR/data/wps
today=`date -d "$1" +%Y%m%d`
tyear=`date -d "$1" +%Y`

cd $WORK_DIR
##-- DOWNLOAD GFS FORECAST : pre-process  --
echo "...  Download GFS Forecast  ..."
cp download_GFS_12.csh download.csh
echo "	ATM WORK_DIR" $WORK_DIR
echo "	today" $today
echo "	tyear" $tyear
sed -i "s/20170824/$today/g" download.csh
sed -i "s/2017/$tyear/g" download.csh 
	#--  DOWNLOAD GFS FORECAST : download data under ada-ftn1  --
	#--  change expect "interact" to "expect eof"  --
	#--  while loop is adding for crontab 2017-10-05  --
./gfs_run.sh
file_break=0
while [ $file_break -eq 0 ]
do
	if [ -f *f216.grib2 ]; then
		file_break=1
	else 
		echo "...  *f216.grib2 file is not found  ..."
		echo "...  wait for it  ....  "  `date +"%F %H:%M:%S"`
		echo " "
		sleep 30
	fi
done

##--  MOVE : old GFS data to its own directory  --
cd $WORK_DIR/data
ftim=`ls *.grib2 |head -1|sed 's/.*0p25.//' | sed 's/.f000.*//'`
mkdir -p "old/$ftim" 
mv *grib2 "old/$ftim" 
zip -r "old/$ftim" "old/$ftim" &

##--  MOVE : new GFS data to the "data directory"  --
mv ../*grib2 .

##--  Pre-WRF : WPS  --
echo "...  run wps  ..."
cd $WORK_WPS 
./run_wps.sh
echo "done" 
echo " "
echo " "
echo " "

