#!/usr/bin/ksh
#############################################################################
#
# Product        :  Employee Merge                                    
#                                                                          
# Name           :  employee_merge.sh                                             
#                                                                           
# Description    :  Provides site merge report to display current 
#                   master/alias status in a Clarify database. Additionally 
#                   provides merge function which reassigns appropriate 
#                   objects such as cases from the alias site to the 
#                   master.
#
# Usage          :  employee_merge.sh -i merge.ini [-merge] \
#                     [-cs server] [-cd database] [-cu user] [-cp password]
#                   
#                   -i merge.ini - specifies initialization file 'merge.ini'
#                   -merge       - instructs tool to perform merge
#                   -cs server   - Clarify server name
#                   -cd database - Clarify database name
#                   -cu user     - Clarify user name
#                   -cp password - Clarify password
#
#                   It is intended that you create initialization files to 
#                   suit your environment. The -cs, -cd, -cu, -cp options can 
#                   alternatively be specified in an initialization file. By 
#                   default, site_merge.sh generates a report. You must specify 
#                   -merge to perform the actual merge operation on the 
#                   database objects.
# 
#                   Refer to merge.ini for a template/example for an 
#                   initialization file.
#
# Example        :  employee_merge.sh -i test.ini
#                   
#                   Run merge report using parameters and database login 
#                   information specified in test.ini file.
# 
#                   employee_merge.sh -i test.ini -merge -cp passwd
#
#                   Run merge operation using parameters and database login 
#                   information specified in test.ini file, with the exception
#                   that the database password has been specified via the 
#                   command line.
#               
# Author         :  First Choice Software, Inc.                             
#                   8900 Business Park Drive
#                   Austin, TX  78759                                       
#                   (512) 418-2905                                          
#                                                                           
# Platforms      :  This version supports Clarify 4.5 and later             
#                                                                           
# Copyright (C)  1997 First Choice Software, Inc.                           
# All Rights Reserved                                                       
#############################################################################

#
# System environment
#
if [ $(uname) = "Windows_NT" ]; then
  DEVNUL=NUL
else
  DEVNUL=/dev/null
fi

#cd /home/clarify/merge

#
# Initialize globals
#
gServer=""
gDatabase=""
gUser=""
gPassword=""
gIni=""
gMerge="no"
gCBModule="employee_merge.cbs"
gCBRoutine="EmployeeMerge"

#############################################################################
# usage - print usage and exit
#############################################################################
usage() {
  #
  # usage - print usage statement and exit
  #
  # Input: none
  # Output: none
  # Return: none (exit)
  #
  echo "employee Merge"
  echo "Usage: employee_merge.sh -i merge.ini [options]"
  echo "  -i merge.ini (use merge.ini as initialization file)"
  echo "  -merge (perform merge operation, default is report only)"
  echo "  -cs Clarify server"
  echo "  -cd Clarify database"
  echo "  -cu Clarify login name"
  echo "  -cp Clarify password"
  exit 1
}

#############################################################################
# getOptions - parse command line
#############################################################################
getOptions() {
  #
  # Populate g* variables with command line options
  #
  # Input:
  #   $1 - command line option one
  #   $2 - command line option one
  #   ...
  #   $n - command line option N
  # Output:
  #   gServer - clarify server
  #   gDatabase - clarify database
  #   gUser -  clarify user name
  #   gPassword - clarify user name password
  #   gDir - event file directory name
  #   gSleep - seconds between event file scans
  #   gEraseEventFile - yes or no
  #   gGenAdminCase - yes or no
  #   gGenResultFile - yes or no
  #   gGenResultAdminCase - yes or no
  #   gPriorityFile - file name
  #   gWaitForReap - seconds between event file completion polls
  # Return:
  #   none
  #
  while [ "$#" != "0" ]; do
    case "$1" in
      -cs) gServer="$2"; shift; shift;;
      -cd) gDatabase="$2"; shift; shift;;
      -cu) gUser="$2"; shift; shift;;
      -cp) gPassword="$2"; shift; shift;;
      -i) gIni="$2"; shift; shift;;
      -merge) gMerge="yes"; shift;;
      -help) usage;;
      -?) usage;;
      *) usage;;
    esac
  done
}

#############################################################################
# verifyEnvironment() - verify execution environment and exit on error
#############################################################################
verifyEnvironment() {
  #
  # Verify execution environment and exit on error
  #
  # Input: 
  #   gServer - clarify server
  #   gDatabase - clarify database
  #   gUser -  clarify user name
  #   gPassword - clarify user name password
  #   gMerge - event file directory name
  # Output:
  #   none
  # Return:
  #   none
  #
  # Verify other params
  #
  [ "$gServer" = "" ] && genErrorExit gerrServer
  [ "$gDatabase" = "" ] && genErrorExit gerrDatabase
  [ "$gUser" = "" ] && genErrorExit gerrUser
  [ "$gPassword" = "" ] && genErrorExit gerrPassword
  [ "$gCBBatch" = "" ] && genErrorExit gerrCBBatch
 
  #
  # Verify cbbatch location
  #
  [ ! -x $gCBBatch ] && genErrorExit gerrCBBatchExe
}

#############################################################################
# genErrorExit() - write an error message and exit
#############################################################################
genErrorExit() {
  #
  # Print an error message and exit
  #
  # Input:
  #   $1 - message id
  #   $2 - message param one
  #   $3 - message param two
  #   ...
  #   $n - message param N
  # Output:
  #   none
  # Return:
  #   none
  #
  case $1 in
    gerrIniFile) usage;;
    gerrNoIniFile) msg="Cannot not read ini file '$gIni'";;
    gerrServer) msg="-cs or DBServer must be specified";;
    gerrDatabase) msg="-cd or DBName must be specified";;
    gerrUser) msg="-cu or DBUser must be specified";;
    gerrPassword) msg="-cp DBPassword must be specified";;
    gerrCBBatch) msg="Must specify CBBatch in ini file.";;
    gerrCBBatchExe) msg="Cannot not find executable $gCBBatch.";;
    gerrNoModule) msg="Cannot find cbbatch module $gCBModule.";;
    gerrNoExec) msg="\nError executing cbbatch routine $gCBRoutine.";;
    *) msg="unknown error tag '$1'";;
  esac

  echo "$msg" >&2
  exit 1
}

#---------------------------------------------------
# Main Execution
#---------------------------------------------------

#
# Fetch command line options
#
getOptions $@

#
# Load ini file
#
[ "$gIni" = "" ] && genErrorExit gerrIniFile
[ ! -r $gIni ] && genErrorExit gerrNoIniFile
. $gIni

#
# Merge parameters from ini file
#
[ "$gServer" = "" ] && gServer=$DBServer
[ "$gDatabase" = "" ] && gDatabase=$DBName
[ "$gUser" = "" ] && gUser=$DBUser
[ "$gPassword" = "" ] && gPassword=$DBPassword
gRptBanner=$RptBanner
gCBBatch=$CBBatch

#
# Export merge flag to merge.cbs
#
export FC_MERGE=$gMerge
export FC_BANNER="$gRptBanner"

#
# Verify execution environment
#
verifyEnvironment
#
# Run merge or report 
#
if [ $gMerge = "yes" ]; then
  echo "Running employee merge..."
else
  echo "Creating employee merge report..."
fi
cat <<! >clarify.env
login_name=$gUser
db_server=$gServer
db_name=$gDatabase
db_password=$gPassword
auto_login=TRUE
!
$gCBBatch -f merge.cbs -f $gCBModule -m $gCBModule -r $gCBRoutine >employee_merge.$$.tmp 2>&1

#rm -f clarify.env

#
# Verify execution. If "MERGEFILE" tag exists, the cb routine at 
# least got started.
#
logfile=$(grep "MERGEFILE:" employee_merge.$$.tmp | (read a b c; echo $b))
if [ "$logfile" = "" ]; then
  #
  # Startup failure
  #
  echo "---"
  cat employee_merge.$$.tmp 
  echo "---"
  # genErrorExit gerrNoExec
fi

echo "Merge report is $logfile"

#
# Verify execution. If "END" tag exists, the cb routine finished.
#
endflag=$(grep "^END " $logfile)
if [ "$endflag" = "" ]; then
  #
  # Execution failure
  #
  echo "---"
  cat employee_merge.$$.tmp 
  echo "---"
  #genErrorExit gerrNoExec
fi

rm employee_merge.$$.tmp
echo "Done!"

