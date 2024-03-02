#!/bin/sh

if [ $# -ne 1 -a $# -ne 2 ]
then
   echo "usage: $0 SHELL_SCRIPT [TEST_FILE_PATH]"
   exit 1
fi

if [ `basename $1` = $1 ]
then
    PROG=./$1
else
    PROG=$1
fi
if [ ! -e $PROG ]
then
    echo "cannot find $PROG"
    exit 1
fi

testDir=`dirname $0`/tests
outDir="$HOME/tmp"
mkdir -p $outDir

if [ $# -ne 2 ]
then
   cmpTests=$testDir/*.test
else
    cmpTests=$2
fi

for t in $cmpTests
do
    base=`basename $t .test`
    out="$outDir/$base.out"
    gold=$testDir/$base.out
    args=`echo $base | perl -pe 's/[^\-]+\-//; s/[^\d]+/ /;'`
    sh $PROG $args < $t > $out
    if cmp $gold $out > /dev/null
    then
	echo "`basename $t` ok"
	rm $out
    else
	echo "test $t failed; output in $out"
	echo "run 'diff $gold $out' to see differences"
    fi
done



