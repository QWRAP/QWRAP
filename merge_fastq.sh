#-------------------------------------------------------------------------
# Name - merge_fastq.sh 
# Desc - Quality filter and Merge the forward and reverse direction fastq files
# Author - Ranjit Kumar (ranjit58@gmail.com)
#-------------------------------------------------------------------------

# The program requires five command line arguments
# Usage : merge_fastq.sh Paired_Filelist FWD_TRIM REV_TRIM USEARCH_MAXDIFF USEARCH_MINOVERLAP
# Example : merge_fastq.sh Paired_Filelist.txt 250 250 25 100

#Counting command line arguments
if [ $# != 5 ]
then
  echo -e "\nERROR : Five commandline arguments not found"
  echo -e "\nPlease run the program as \nmerge_fastq.sh Paired_Filelist FWD_TRIM REV_TRIM USEARCH_MAXDIFF USEARCH_MINOVERLAP"
  echo -e "\nTerminating the program...\n"
exit
fi


#------READING COMMANDLINE PARAMETERS ----------------------------------
FWD_TRIM=$2
REV_TRIM=$3
USEARCH_MAXDIFF=$4
USEARCH_MINOVERLAP=$5

MERGED_FASTQ=MERGED_FASTQ
#--------------------------------

Paired_Filelist=$1

# Little cleanup
rm -f temp_*.fastq
rm -rf MERGED_FASTQ

mkdir $MERGED_FASTQ

#Step 0 - Check the commandline parameters.

if [ "$1" = '' ] 
then
  echo -e "\nERROR : Commandline arguments not found"
  echo -e "\nPlease run the program as \nmerge_fastq.sh Paired_Filelist"
  echo -e "\nTerminating the program...\n"
exit
fi

#Step 1 - Creating a pairwise mapping file based on contents of rawdataset

if [ ! -e $Paired_Filelist ]
then 
  echo -e "\nERROR : File containing the paired names was not found"
  echo -e "\nPlease run the program as \nmerge_fastq.sh Paired_Filelist"
  echo -e "\nTerminating the program...\n"
exit

else 
 echo -e "\nReading the content of file ${Paired_Filelist}..."

 while read line
do
    ARR=($line)
    echo -e "\n\nProcessing file pair: $line"
    echo -e "----------------------------"
    echo -e "Copying..."
    cp ${ARR[0]} temp_F.fastq.gz
    cp ${ARR[1]} temp_R.fastq.gz

    echo -e "Uncompressing..."
    gunzip temp_F.fastq.gz
    gunzip temp_R.fastq.gz
    
    echo -e "Trimming the reads: Fwd - ${FWD_TRIM} bases, Rev - ${FWD_TRIM} bases..."
    fastx_trimmer -l ${FWD_TRIM} -i temp_F.fastq -o temp_FT.fastq -Q 33
    fastx_trimmer -l ${REV_TRIM} -i temp_R.fastq -o temp_RT.fastq -Q 33

    echo -e "Merging the reads using USEARCH..."
    echo -e "----------USEARCH STATS-----------"
    usearch -fastq_mergepairs temp_FT.fastq -reverse temp_RT.fastq -fastqout temp_M.fastq -fastq_maxdiffs ${USEARCH_MAXDIFF} -fastq_minovlen ${USEARCH_MINOVERLAP}
    echo -e "----------USEARCH STATS ENDS------\n"

    echo -e "Converting fastq to fasta  ..."
    fastq_to_fasta -r -i temp_M.fastq -o `echo ${ARR[2]}|sed -e 's/fastq.gz/fasta/g'` -Q33
    
    echo -e "Compressing and moving the fastq file..."
    gzip temp_M.fastq 
    mv temp_M.fastq.gz ${MERGED_FASTQ}/${ARR[2]}

    echo -e "Cleaning the temporary files...."
    rm temp_F.fastq
    rm temp_R.fastq
    rm temp_FT.fastq
    rm temp_RT.fastq

done <${Paired_Filelist}

echo -e "\n******************** DONE **************************************"
echo -e "\nAll files processed\nThe merged fastq files are stored in folder ${MERGED_FASTQ} &"
echo -e "The fasta files are stored in current directory\n"
fi

