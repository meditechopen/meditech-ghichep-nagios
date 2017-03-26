#!/bin/bash
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

PROGNAME=`basename $0`
VERSION="version 0.93"
AUTHOR="by Radu MARINESCU radumar1001@yahoo.com"
#############################
# Program paths. If left empty the script tries to find the programs
# in the PATH. Fill in the correct paths only if needed.
#############################
#usually /bin/awk or /usr/bin/awk
AWK=""
#usually /bin/grep or /usr/bin/grep
GREP=""
#usually /bin/df
DF=""
#############################

if [ ${#AWK} == 0 ] #the variable AWK is not defined; trying to find awk in the PATH
then
	AWK=`which awk 2>&1`
	AWK_EXISTS=$?
	if [ "$AWK_EXISTS" != 0 ] || [ ${#AWK} == 0 ] #awk is not in the PATH or the variable AWK is empty
	then
		echo "Error! Can't find awk."
		exit 3
	fi	
fi

if [ ${#GREP} == 0 ] #the variable GREP is not defined; trying to find grep in the PATH
then
	GREP=`which grep 2>&1`
	GREP_EXISTS=$?
	if [ "$GREP_EXISTS" != 0 ] || [ ${#GREP} == 0 ] #grep is not in the PATH or the variable GREP is empty
	then
		echo "Error! Can't find grep."
		exit 3
	fi	
fi

if [ ${#DF} == 0 ] #the variable DF is not defined; trying to find df in the PATH
then
	DF=`which df 2>&1`
	DF_EXISTS=$?
	if [ "$DF_EXISTS" != 0 ] || [ ${#DF} == 0 ] #df is not in the PATH or the variable DF is empty
	then
		echo "Error! Can't find df."
		exit 3
	fi	
fi


#############################
# Functions
#############################

print_version() {
    echo "$VERSION $AUTHOR"
}


print_help() {
print_version $PROGNAME $VERSION
echo ""
echo "$PROGNAME is a Nagios plugin used to check disk used space by"
echo "processing the output of \"df\" command. It runs on UNIX, Linux"
echo "and BSD platforms and reports the following performance data:"
echo "- total disk space (Bytes)"
echo "- currently used disk space (Bytes)"
echo "- currently used disk space (%)"
echo " "
echo "$PROGNAME [-v] [-h] [-w UsedSpaceWarning] [-c UsedSpaceCritical] [-p Partition]"
echo " "
echo "Options:"
echo "  --version|-v)"
echo "    prints the program version"
echo "  --help|-h)"
echo "    prints this help information"
echo "  -w)"
echo "    warning threshold (in percents without % sign) for used space"
echo "  -c)"
echo "    critical threshold (in percents without % sign) for used space"
echo "  -p)"
echo "    disk partition to check"
echo " "
exit 3
}


# float number comparison
function fcomp() {
    $AWK -v n1=$1 -v n2=$2 'BEGIN{ if (n1<=n2) exit 0; exit 1}'
}


#formats bytes => KBytes, MBytes, GBytes, TBytes
function btokmgt() {
	if [ $1 -lt 1024 ] #Bytes
	then
		echo "${1}B"
	elif [ $1 -lt 1048576 ] #KBytes
	then
		echo "$1" | $AWK '{printf "%.1fKB", $1/1024}'
	elif [ $1 -lt 1073741824 ] #MBytes
	then
		echo "$1" | $AWK '{printf "%.1fMB", $1/1048576}'
	elif [ $1 -lt 1099511627776 ] #GBytes
	then
		echo "$1" | $AWK '{printf "%.1fGB", $1/1073741824}'
	elif [ $1 -lt 1125899906842624 ] #TBytes
	then
		echo "$1" | $AWK '{printf "%.1fTB", $1/1099511627776}'
	fi
}
#############################


if [ $# -lt 1 ]; then
    print_help
    exit 3
fi

while test -n "$1"; do
    case "$1" in
        --help|-h)
            print_help
            exit 3
            ;;
        --version|-v)
            print_version $PROGNAME $VERSION
            exit 3
            ;;
        -w)
            WarnSpace=$2
            shift
            ;;
        -c)
            CritSpace=$2
            shift
            ;;
        -p)
            Partition=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            print_help
            exit 3
            ;;
    esac
    shift
done

if [ ${#Partition} == 0 ]
	then
		echo "Error! You must specify a partition to check! Example: /var or / or /home"
		exit 3
fi

if fcomp $WarnSpace 0
then
    WarnSpace=0
fi
if fcomp 100 $WarnSpace
then
    WarnSpace=100
fi

if fcomp $CritSpace 0
then
    CritSpace=0
fi
if fcomp 100 $CritSpace
then
    CritSpace=100
fi

if fcomp $CritSpace $WarnSpace
then
    WarnSpace=$CritSpace
fi


USEDTXT=`$DF -P -B 1 $Partition 2>&1`
if [ $? != 0 ]
then
	echo "Error! Disk partition $Partition can't be checked. Does it exist?"
	exit 3
fi

SpaceTxt=`echo "$USEDTXT" | $GREP "${Partition}\$"`
SpaceTotal=`echo "$SpaceTxt" | $AWK '{print $2}'`
SpaceUsed=`echo "$SpaceTxt" | $AWK '{print $3}'`
SpaceFree=`echo "$SpaceTxt" | $AWK '{print $4}'`
SpaceUsedProc=`echo "$SpaceTxt" | $AWK '{printf "%.1f", $3*100/$2}'`
SpaceFreeProc=`echo "$SpaceTxt" | $AWK '{printf "%.1f", $4*100/$2}'`

WarnSpaceAbs=`echo "$SpaceTotal $WarnSpace" | $AWK '{printf "%d", $1*$2/100}'`
CritSpaceAbs=`echo "$SpaceTotal $CritSpace" | $AWK '{printf "%d", $1*$2/100}'`

SpaceTotal_F=`btokmgt $SpaceTotal`
SpaceUsed_F=`btokmgt $SpaceUsed`
SpaceFree_F=`btokmgt $SpaceFree`

PerfData1="${SpaceTotal}B"
PerfData2="${SpaceUsed}B"


if fcomp $SpaceUsedProc $WarnSpace
then
    echo "OK; $Partition: total ${SpaceTotal_F}, used ${SpaceUsed_F} (${SpaceUsedProc}%), free ${SpaceFree_F} (${SpaceFreeProc}%) | TotalSpace=$PerfData1;;;; UsedSpace=$PerfData2"
    exit 0
fi

if fcomp $WarnSpace $SpaceUsedProc && fcomp $SpaceUsedProc $CritSpace
then
    echo "Warning; $Partition: total ${SpaceTotal_F}, used ${SpaceUsed_F} (${SpaceUsedProc}%>${WarnSpace}%), free ${SpaceFree_F} (${SpaceFreeProc}%) | TotalSpace=$PerfData1;;;; UsedSpace=$PerfData2"
    exit 1
fi

if fcomp $CritSpace $SpaceUsedProc
then
    echo "CRITICAL; $Partition: total ${SpaceTotal_F}, used ${SpaceUsed_F} (${SpaceUsedProc}%>${CritSpace}%), free ${SpaceFree_F} (${SpaceFreeProc}%) | TotalSpace=$PerfData1;;;; UsedSpace=$PerfData2"
    exit 2
fi

#otherwise ... UNKNOWN
echo "UNKNOWN; $Partition: total ${SpaceTotal_F}, used ${SpaceUsed_F} (${SpaceUsedProc}%), free ${SpaceFree_F} (${SpaceFreeProc}%) | TotalSpace=$PerfData1;;;; UsedSpace=$PerfData2"
exit 3
