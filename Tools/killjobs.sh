#!/bin/bash
kill -9 `ps |grep run_wps.sh|cut -d ' ' -f 1`
exit
