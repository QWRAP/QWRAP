#! /bin/bash
#-------------------------------------------------------------------------
# Name - merge_reads_F_R.sh 
# Desc - Create
# Author - Ranjit Kumar (ranjit58@gmail.com)
#-------------------------------------------------------------------------


# The program reads two folders containing the forward reads and reverse reads seperately and merge them into a single TEMP folder

# Reading commandline arguments
FWD_READ="$1"
REV_READ="$2"


#Check the commandline parameters.

if [ $# != 2 ] 
then
  echo -e "\nERROR : Commandline arguments not found"
  echo -e "\nPlease run the program as \nmerge_reads_F_R.sh FWD_READ REV_READ"
  echo -e "\nTerminating the program...\n"
exit
fi

if [ ! -e $FWD_READ ]
then
  echo -e "\nERROR : FOLDER containing the raw data \"${FWD_READ}\" is not found"
  echo -e "\nPlease run the program as \nmerge_reads_F_R.sh FWD_READ REV_READ"
  echo -e "\nTerminating the program...\n"
exit
fi

if [ ! -e $REV_READ ]
then
  echo -e "\nERROR : FOLDER containing the raw data \"${REV_READ}\" is not found"
  echo -e "\nPlease run the program as \nmerge_reads_F_R.sh FWD_READ REV_READ"
  echo -e "\nTerminating the program...\n"
exit
fi

mkdir TEMP

echo -e "\nReading folders \"${FWD_READ}\" and \"${REV_READ}\"..."

find ${FWD_READ} -name "*fastq.gz" -type f -print0|xargs -0 -I {} cp {} TEMP/
find ${REV_READ} -name "*fastq.gz" -type f -print0|xargs -0 -I {} cp {} TEMP/

echo -e "\"TEMP\" folder created with all forward and reverse reads"
echo -e "--------------------------------------------\n"


