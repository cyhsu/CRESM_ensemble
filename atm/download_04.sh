#!/bin/bash
#- 
#-		Goals : 
#-			1. Download GEFS files by wget
#-			2. Arrange files to ensemble directories
#-			3. 
#-		Usage : 
#-			download.sh $time_01 $time_02  
#-
#-		copyright : C.Y. Hsu (TAMU 2017-10-24 1st edit)
#-----------------------------------------------------------
echo ''
echo 'processing : download.sh'
echo ''
#-- parameters --
#WORK_DIR='/home/chsu1/scratch/GOM_FORECAST/cpl/run/routine_run_emsemble/GEFS/atm/tmp'
WORK_DIR='/home/chsu1/scratch/GOM_FORECAST/cpl/run/routine_run_emsemble/GEFS/atm'
opts="-N -q"

#-- move to work directory
cd $WORK_DIR

#-- time calculation begins --
strtm=$(date +%s)

wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f00
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f06
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f12
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f18
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f24
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f30
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f36
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f42
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f48
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f54
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f60
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f66
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f72
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f78
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f84
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f90
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f96
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f102
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f108
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f114
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f120
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f126
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f132
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f138
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f144
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f150
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f156
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f162
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f168
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f174
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f180
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f186
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f192
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f198
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f204
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f210
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f216
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f222
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f228
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f234
wget $opts ftp://ftpprd.ncep.noaa.gov:21/pub/data/nccf/com/gens/prod/gefs.20180901/12/pgrb2/gep04.t12z.pgrb2f240

#-- arrange files to an adopted directory.
mv gep04* $WORK_DIR/data/ensemble04

#-- time calculation ends --
endtm=$(date +%s)
HH=`echo $((endtm-strtm)) | awk '{printf "%02d",int($1/3600)}'`
MM=`echo $((endtm-strtm)) | awk '{printf "%02d",int(($1%3600)/60)}'`
SS=`echo $((endtm-strtm)) | awk '{printf "%02d",int($1%60)}'`
echo "gep04 - Total Time Coast : $HH:$MM:$SS"  >> time_calculation
#-----------------------------------

