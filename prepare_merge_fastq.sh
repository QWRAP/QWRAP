#-------------------------------------------------------------------------
# Name - prepare_merge_fastq.sh 
# Desc - Creates a mapping file with 3 columns. Each row has the location of fwd read, rev read and the predicted merged file name
# Author - Ranjit Kumar (ranjit58@gmail.com)
#-------------------------------------------------------------------------

RAW_FOLDER_NAME=$1

#Step 0 - Check the commandline parameters.

if [ "$1" = '' ] 
then
  echo -e "\nERROR : Commandline arguments not found"
  echo -e "\nPlease run the program as \nprepare_merge_fastq.sh RAWDATA_FOLDER_NAME"
  echo -e "\nTerminating the program...\n"
exit
fi

#Step 1 - Creating a pairwise mapping file based on contents of rawdataset

if [ ! -e $RAW_FOLDER_NAME ]
then 
  echo -e "ERROR : FOLDER containing the raw data is not found"
  echo -e "\nPlease run the program as \nprepare_merge_fastq.sh RAWDATA_FOLDER_NAME"
  echo -e "\nTerminating the program...\n"
exit

else 
 echo -e "\nReading the content of folder \"${RAW_FOLDER_NAME}\"\n"
 ls ${RAW_FOLDER_NAME}/*.fastq.gz | paste - - > Paired_Filelist.txt.tmp
 echo -e "Predicting the merged file name and removing underscore..."
 
 rm -f Paired_Filelist.txt
 while read line
  do
    ARR=($line)
    #echo ${#ARR[0]}
    FULL_NAME1="`echo ${ARR[0]}|sed -e 's/^.*\///g'`"
    FULL_NAME2="`echo ${ARR[1]}|sed -e 's/^.*\///g'`"
    COMMON_NAME=""
    FULL_LEN1=${#FULL_NAME1}
    #echo -e "${FULL_LEN1}"

    for (( i=1; i<=${FULL_LEN1}; i++ ))
      do
        #echo -e "$i"
        if [ ${FULL_NAME1:0:${i}} = ${FULL_NAME2:0:${i}} ]
          then
            COMMON_NAME="${FULL_NAME1:0:${i}}"
        fi
  done 
  COMMON_NAME="`echo ${COMMON_NAME}|sed -e 's/_//g'`"
  #echo -e "Common name is ${COMMON_NAME}"
  echo -e "${ARR[0]}\t${ARR[1]}\t${COMMON_NAME}.fastq.gz">>Paired_Filelist.txt

 done <Paired_Filelist.txt.tmp
 
 rm Paired_Filelist.txt.tmp
 
 echo -e "Processing complete. \"Paired_Filelist.txt\" is created with each line containing the location of forward read and reverse reads and the name of merged read. You can edit the names of merged file in a text editor. This file is tab delimited"
 echo -e "Sample entry of mapping file looks like(top 10 lines)...\n"
 echo -e "--------------------------------------------\n"
 head -10 Paired_Filelist.txt
 echo -e "--------------------------------------------\n"

fi
