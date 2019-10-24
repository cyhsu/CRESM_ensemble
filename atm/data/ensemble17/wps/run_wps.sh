#!/bin/bash
#-
#-	This scripts is provides a subroutine to 
#-						 automatic process the WPS
#-						 by the downloading gfs files.
#-
#-	CopyRight : C.Y. Hsu @TAMU 2017/09/23
#--------------------------------------------------

#-- Set up the Work Directory 
CUR_WORK=`pwd`
t0=$1
t1=$2

echo "      ... wps -- time step : " $1 $t0 
echo "      ... wps -- time step : " $2 $t1
#--  Load Request Module  --
module load WPS/3.5.1-intel-2015B-dmpar

#--  Start the WPS process : 1. data time  --
cp namelist.wps.sample namelist.wps
cp namelist.input.sample namelist.input

syear=`date --date="$t0" +%Y`
smonth=`date --date="$t0" +%m`
sday=`date --date="$t0" +%d`
shour=`date --date="$t0" +%H`
sdate=`date --date="$t0" +"%F_%H:%M:%S"`

eyear=`date --date="$t1" +%Y`
emonth=`date --date="$t1" +%m`
eday=`date --date="$t1" +%d`
ehour=`date --date="$t1" +%H`
edate=`date --date="$t1" +"%F_%H:%M:%S"`

sed -i "s/2017-08-24_12:00:00/$sdate/g" namelist.wps
sed -i "s/2017-08-31_12:00:00/$edate/g" namelist.wps


sed -i -e "6s/2010/$syear/" namelist.input
sed -i -e "7s/01/$smonth/" namelist.input
sed -i -e "8s/01/$sday/" namelist.input
sed -i -e "9s/12/$shour/" namelist.input

sed -i -e "12s/2010/$eyear/" namelist.input
sed -i -e "13s/01/$emonth/" namelist.input
sed -i -e "14s/04/$eday/" namelist.input
sed -i -e "15s/00/$ehour/" namelist.input

#--  swtich : if file_break == 0, download is not done
#--  swtich : if file_break == 1, wps is ready
file_break=0
while [ $file_break -eq 0 ]
do
	if [ -f ../*pgrb2f240 ]; then 
		file_break=1
		echo "      ...  ..."
	else
		echo "      ...  *f240.grib2 file is not found (ensemble17)  ..."
		echo "      ...  wait for it  ....  "  `date +"%F %H:%M:%S"`
		echo " "
		sleep 15
	fi
done	
rm -rf  wps_run.[eo]*
bsub < wps_run.pbs
##-- submit a job for CRESM after WPS
JIDi=`bjobs |grep eWPS_00|awk -v OFS='\t' '{print $1}'`
JIDb=`bjobs |grep eWPS_17|awk -v OFS='\t' '{print $1}'`
cd ../../../../cpl/ensemble17/
bsub -w "done($JIDb)" < cresm_job_run.pbs
