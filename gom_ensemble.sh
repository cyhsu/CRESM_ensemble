#!/bin/bash
#-
#- This code is used to automatic process the CPL over GOM.
#- Basically is for "FORECAST", but this code can be also working 
#- on the selected period with some modification.
#-
#- .......I am not going to share my code this time....... 
#-
#-	C.Y. Hsu @TAMU 2017-10-03 
#---------------------------------------------------------------
source ~/.bashrc

cd /home/chsu1/scratch/GOM_FORECAST/cpl/run/routine_run_emsemble/GEFS
DEFU_DIR=`pwd`
WORK_DIR=$DEFU_DIR/cpl_gom

echo $DEFU_DIR 	#>  cresm_gefs.log
echo $WORK_DIR 	#>> cresm_gefs.log
echo `date +"%F"`	#>> cresm_gefs.log

cd $DEFU_DIR
#- release the space
find ./* -name 'std.*' -delete
find ./*/* -name '*.log' -delete
find ./* -name 'TXGLO.[oa]*nc' -delete

# clear; mv *.log old_log/.
#- Parameters
t0="2018-09-01 12:00:00"
#t0=`date +"%F 12:00:00"`
to=`date --date="$t0 10 days" +"%F %H:%M:%S"`
t1=`date --date="$t0  6 days" +"%F %H:%M:%S"`
echo "Processing the data from $t0 to $t1"

#- cpl : only change the parameters
echo " RUN CPL "
sh $DEFU_DIR/cpl/parameters_for_cpl/cpl_run.sh "$t0" "$t1"  #>& cpl.log

##- ocn : download and make initial/boundary condition for ROMS
echo " RUN Pre-ROMS"
sh $DEFU_DIR/ocn/roms_copernicus.sh "$t0" "$to" #> ocn.log 
##sh $DEFU_DIR/ocn/roms_copernicus.sh "$t0" "$t1" #>& ocn.log &

##- atm : central - download, initial/boundary, submit a job for CRESM
echo " RUN Pre-WRF "
sh $DEFU_DIR/atm/run_atm_00.sh "$t0" "$t1" #> atm_00.log
#sh $DEFU_DIR/atm/run_atm_00.sh "$t0" "$t1" #>& atm_00.log

##- atm : ensemble "s" - download, initial/boundary, submit a job for CRESM
echo " RUN Pre-WRF "
sh $DEFU_DIR/atm/run_atm.sh "$t0" "$t1" #> atm_ensemble.log
#sh $DEFU_DIR/atm/run_atm.sh "$t0" "$t1" #>& ensemble.log


##- job description: 
##- 		
##-	set up the output directory.
##-	share folder : clear folder.
folder_share='/scratch/user/chsu1/share/GEFS/'
dirc=`date -d "$t0" +"%F"`; 
echo $dirc
sed -i "40s/abc.*/abc=$dirc/" ./cpl/central/cresm_job_run.pbs
sed -i "40s/abc.*/abc=$dirc/" ./cpl/ensemble??/cresm_job_run.pbs
cd $folder_share; mkdir -p $dirc; dirc=`date -d "7 days ago" +"%F"`; #rm -rf $dirc
