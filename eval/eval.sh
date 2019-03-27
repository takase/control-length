#!/bin/bash

#$1: directory contains references and systems
#$2: the source part of test data
#$3: the number of characters for ROUGE calculation (output is trimmed by this number)
#$4: directory contains make_rouge.py and prepare4rouge-simple.pl
#$5: path to ROUGE script (ROUGE-1.5.5.pl)

export BASEDir=$4
export ROUGE=$5
cd $1
rm -fr $1/tmp_GOLD
rm -fr $1/tmp_SYSTEM
rm -fr $1/tmp_OUTPUT
mkdir -p $1/tmp_GOLD
mkdir -p $1/tmp_SYSTEM

python2.7 $BASEDir/DUC/make_rouge.py --base $1 --gold tmp_GOLD --system tmp_SYSTEM --input $2
perl $BASEDir/DUC/prepare4rouge-simple.pl tmp_SYSTEM tmp_GOLD tmp_OUTPUT

cd tmp_OUTPUT

echo "LIMITED LENGTH"
perl $ROUGE/ROUGE-1.5.5.pl -m -b $3 -n 2 -w 1.2 -e $ROUGE -a settings.xml
