#!/usr/bin/expect
eval spawn ssh chsu1@ada-ftn2 "./scratch/GOM_FORECAST/cpl/run/routine_run_emsemble/GEFS/atm/download.sh"
expect "word:"
send "Gisr@2018\r"
expect eof
exit
