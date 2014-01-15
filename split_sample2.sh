#-------------------------------------------------------------------------
# Name - split_sample2.sh
# Desc - The program reads a mapping file and organises the raw data into folders for each investigator
# Author - Ranjit Kumar (ranjit58@gmail.com)
#-------------------------------------------------------------------------

# Run the program as
# split_sample2.sh RAWDATA RUN_NAME MAPPING
# Example :  split_sample2.sh AW_DATA R20 MAPPING_FILE

# PATH for RAW data
DIR_RAW="$1"
RUN_NAME="$2"
MAP="$3"

DIR_MAPPED="${RUN_NAME}_raw_data_mapped"

DIR_ANALYSIS="${RUN_NAME}_analysis"
#---------------------------------------------------------------------------

echo -e "\nProcessing please wait...\n"

if [ ! -e $DIR_RAW ]
then
  echo -e "ERROR : FOLDER containing the raw data ${DIR_RAW} is not found"
  echo -e "\nPlease run the program as \nsplit_sample2.sh R20_UNASSIGNED R20 MAPPING_FILE"
  echo -e "\nTerminating the program...\n"
exit
fi

if [ -e $DIR_MAPPED ]
then
  echo -e "ERROR : FOLDER containing the ${DIR_MAPPED} exists which should not be present"
  echo -e "\nPlease run the program as \nsplit_sample2.sh R20_UNASSIGNED R20 MAPPING_FILE"
  echo -e "\nTerminating the program...\n"
exit
fi

if [ -e $DIR_ANALYSIS ]
then
  echo -e "ERROR : FOLDER containing the ${DIR_ANALYSIS} exists which should not be present"
  echo -e "\nPlease run the program as \nsplit_sample2.sh R20_UNASSIGNED R20 MAPPING_FILE"
  echo -e "\nTerminating the program...\n"
exit
fi


mkdir $DIR_MAPPED
mkdir $DIR_ANALYSIS

if [ -e $MAP ]; then
echo -e "Mapping file ${MAP} found and is being used for sample grouping\n"

### creates all folders for different projects
cut -f 4 ${MAP} |sort|uniq |xargs -I {} mkdir ${DIR_MAPPED}/{}
cut -f 4 ${MAP} |sort|uniq |xargs -I {} mkdir ${DIR_MAPPED}/{}/FORWARD
cut -f 4 ${MAP} |sort|uniq |xargs -I {} mkdir ${DIR_MAPPED}/{}/REVERSE
cut -f 4 ${MAP} |sort|uniq |xargs -I {} mkdir ${DIR_ANALYSIS}/{}_analysis
cut -f 4 ${MAP} |sort|uniq |xargs -I {} mkdir ${DIR_ANALYSIS}/{}_analysis/FORWARD
cut -f 4 ${MAP} |sort|uniq |xargs -I {} mkdir ${DIR_ANALYSIS}/{}_analysis/REVERSE

while read line
do
    ARR=($line)
    cp ${ARR[0]} $DIR_ANALYSIS/${ARR[3]}_analysis/FORWARD/${ARR[2]}F.fastq.gz
    cp ${ARR[1]} $DIR_ANALYSIS/${ARR[3]}_analysis/REVERSE/${ARR[2]}R.fastq.gz
    
    #cp ${DIR_RAW}/${ARR[0]} ${DIR_MAPPED}/${ARR[1]}/${ARR[2]}.fastq.gz
    cp ${ARR[0]} $DIR_MAPPED/${ARR[3]}/FORWARD/${ARR[2]}F.fastq.gz
    cp ${ARR[1]} $DIR_MAPPED/${ARR[3]}/REVERSE/${ARR[2]}R.fastq.gz


    #echo "moving files:   ${DIR_RAW}/${ARR[0]} ---> ${DIR_MAPPED}/${ARR[1]}/${ARR[2]}.fastq.gz"
done <${MAP}

echo -e "\n-------------------------------------------------------------\n"
echo -e "All files are renamed and moved to folder ${DIR_MAPPED} \n";
else 
echo "Mapping file \"${MAP}\" not found, Program Terminating..."

exit 0
fi
