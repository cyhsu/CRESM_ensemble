#!/bin/bash
DEFU_DIR=`pwd`
WORK_DIR=$DEFU_DIR/cpl/parameters_for_cpl
t0=$1
t1=$2
t0_year=`date -d "$t0" +%Y`
t0_mont=`date -d "$t0" +%m`
t0_dayt=`date -d "$t0" +%d`
t0_hour=`date -d "$t0" +%H`
t0_date=`date -d "$t0" +%Y%m%d`
t0_hr2s=$((`date -d "$t0" +%H` * 3600))
t1_year=`date -d "$t1" +%Y`

cd $WORK_DIR

#--  docn_ocn_in  --
echo "...  docn_ocn_in  ..."
cp docn_ocn_in.sample docn_ocn_in
sed -i "s/2017 2017 2017/$t0_year $t0_year $t1_year/" docn_ocn_in

#--  drv_in  --
echo "...  drv_in  ..."
cp drv_in.sample drv_in
sed -i -e "24s/2010/$t0_year/" drv_in
sed -i -e "25s/2010/$t0_year/" drv_in
sed -i -e "69s/20170922/$t0_date/" drv_in
sed -i -e "70s/43200/$t0_hr2s/" drv_in

#--  ocn_in  --
echo "...  ocn_in  ..."
cp ocn_in.sample ocn_in
sed -i -e "3s/2017/$t0_year/" ocn_in
sed -i -e "4s/09/$t0_mont/" ocn_in
sed -i -e "5s/22/$t0_dayt/" ocn_in
sed -i -e "6s/12/$t0_hour/" ocn_in

### #---------------------------------------------------------
### #-  Parameters set up  -
### #-  job id for wps  -
### for nruns in {00..20}
### do
### 	#-  Create a job file  -
### 	if [ $nruns == '00' ]; then
### 		run_dirc='central'
### 	else
### 		run_dirc='ensemble'$nruns
### 	fi
### 	cd ../$run_dirc/.
### 
### 	#-  Zip old files  -
### 	echo "Zip old files and put it in the background"
### 	fi01=`ls *atm.hi.*nc | head -1 |sed 's/.*hi.//'|sed 's/_12.*//'`
### 	di01=`date -d $fi01 +%Y%m%d`
### 	mkdir -p $di01; mv rsl.[oe]* TXGLO.atm.*nc TXGLO.cpl*nc TXGLO.ocn.*nc $di01
### 	zip -qr $di01 $di01 &
### 
### 	#-  Locate the job id of WPS
### 	echo "...  Submit a job  ..."
### 	JIDi=`bjobs |grep eWPS_00|awk -v OFS='\t' '{print $1}'`
### 	JIDb=`bjobs |grep eWPS_$nruns|awk -v OFS='\t' '{print $1}'`
### 
### 	#- If job id can be found, submit a job for coupled after it.
### 	#- If job id cannot be found, wait for it.
### 	file_break=0
### 	file_break_num=0
### 	while [ $file_break -eq 0 ]
### 	do
### 		if [ ! -z $JIDb ]; then
### 			file_break=1
### 			#-- Submit job which is running after wps
### 			if [ $nruns == '00' ]; then
### 				bsub -w "done($JIDi)" < cresm_job_run.pbs
### 			else
### 				bsub -w "done($JIDi)&&done($JIDb)" < cresm_job_run.pbs
### 			fi
### 		else
### 			echo "...     (cpl) NO JID for $run_dirc  ..."
### 			sleep 15
### 			file_break_num=$((file_break_num+1))
### 			JID=`bjobs |grep eWPS_$nruns|awk -v OFS='\t' '{print $1}'`
### 		fi
### 		if [ file_break_num == 40 ]; then  #- after 10 minutes, still no job id.
### 			file_break=1
### 			bsub < cresm_job_run.pbs
### 		fi
### 	done
### done
### echo "...  CRESM should be working now  ($t0, $t1)..."
