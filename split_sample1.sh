#-------------------------------------------------------------------------
# Name - split_sample1.sh
# Desc - The program extracts all fastq.gz files in 1 folde and create a editable mapping file
# Author - Ranjit Kumar (ranjit58@gmail.com)
#-------------------------------------------------------------------------

# Run the program as
# split_sample1.sh RAWDATA_FOLDER_NAME RUN_NAME
# Example :  split_sample1.sh RAW_DATA R16

# READING PATH for RAW data
DIR="$1"
RUN_NAME="$2"
# Mapping file name
MAP="${RUN_NAME}_mapping.txt"

TMP="${RUN_NAME}_OVERVIEW"
#---------------------------------------------------------------------------

echo -e "\nProcessing please wait...\n"

if [ ! -e $DIR ]
then
  echo -e "ERROR : FOLDER containing the raw data ${DIR} is not found"
  echo -e "\nPlease run the program as \nsplit_sample1.sh RAWDATA_FOLDER_NAME RUN_NAME"
  echo -e "\nTerminating the program...\n"
exit
fi

if [ -e $TMP ]
then
  echo -e "ERROR : FOLDER containing the ${TMP} exists which should not be present"
  echo -e "\nPlease run the program as \nsplit_sample1.sh RAWDATA_FOLDER_NAME RUN_NAME"
  echo -e "\nTerminating the program...\n"
exit
fi

# Step 1 : Create a temp file TEMP_ALL_FATSA and copy all fastq.gz files here.

mkdir ${TMP}
mkdir ${TMP}/FORWARD
mkdir ${TMP}/REVERSE
find $DIR/ -name "*R1_001.fastq.gz" -type f -print0|xargs -0 -I {} cp {} ${TMP}/FORWARD/
find $DIR/ -name "*R2_001.fastq.gz" -type f -print0|xargs -0 -I {} cp {} ${TMP}/REVERSE/

# remove baalncer and undetermined sequences
find $TMP/ -name "*Balancer*.fastq.gz" -type f -print0|xargs -0 -I {} rm {}
find $TMP/ -name "*Undetermined*.fastq.gz" -type f -print0|xargs -0 -I {} rm {}

echo -e "Created a folder \"${TMP}\" with all fastq.gz files, which can be used for overview analysis"

# checking and removing preexisting mapping file
if [ -e $MAP ]
then
  mv $MAP $MAP.bak
  echo -e "A pre-exisiting mapping file \"${MAP}\" is found and is renamed as ${MAP}.bak\"\n"
fi

echo -e "Creating the mapping file \"${MAP}\""

#cd $TMP

#for file in $( ls *.fastq.gz); do echo -ne "$file\t">>../${MAP}; echo -e "group1\t$file" | sed -e 's/_//g'>>../${MAP}; done

#echo -e "\nReading the content of folder \"${DIR}\"\n"
ls ${DIR}/*.fastq.gz | paste - - > ${MAP}.tmp

echo -e "Predicting the merged file name and removing underscore..."

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
  echo -e "${ARR[0]}\t${ARR[1]}\t${COMMON_NAME}\tGroup1">> $MAP

  done < ${MAP}.tmp
rm ${MAP}.tmp

echo -e "The mapping file \"${MAP}\" is succesfully created. It has 3 columns. The first column is the forward read and the second column is the reverse read. Third column is the predicted name which can be assigned to the sample. Fourth column is the group the sample belongs to. Please edit the third and fourth column to desired name and then srun script sample_split2.sh\n"

