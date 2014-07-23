#-------------------------------------------------------------------------
# Name - quality_check_after.sh
# Desc - Runs FASTQC on all fastq.gz files and store in folder "fastqc_afterqc"
# Author - Ranjit Kumar (ranjit58@gmail.com)
# University of Alabama at Birmingham
#-------------------------------------------------------------------------

#-----Running the fastqc runs on all the fastq.gz files from the supplied folder ------------------

# Reading commandline arguments
FWD_READ_FOLDER="$1"
REV_READ_FOLDER="$2"

#Check the commandline parameters.

if [ $# -lt 1 ]
then
  echo -e "\nERROR : Commandline arguments not found"
  echo -e "\nPlease run the program as \nquality_check_after.sh FWD_READ_FOLDER REV_READ_FOLDER"
  echo -e "\nTerminating the program...\n"
exit
fi

if [ ! -d $FWD_READ_FOLDER ] || [ "$FWD_READ_FOLDER" = "" ]
then
  echo -e "\nERROR : FOLDER containing the raw data \"${FWD_READ_FOLDER}\" is not found"
  echo -e "\nPlease run the program as \nquality_check_after.sh FWD_READ_FOLDER REV_READ_FOLDER"
#  echo -e "\nTerminating the program...\n"
#exit
else

# Reading the FWD READS

  rm -r fastqc_afterqcf
  mkdir fastqc_afterqcf

  echo -e "\nRunning the FASTQC program on all the fastq.gz files in folder \"${FWD_READ_FOLDER}\"\n"
  fastqc --nogroup --extract ${FWD_READ_FOLDER}*.fastq.gz -o fastqc_afterqcf
  echo -e "\nFastqc run completed from folder ${FWD_READ_FOLDER}\n"

  cd fastqc_afterqcf
  rm *_fastqc.zip

  echo -e "\n Extracting stats from all fastqc files, generating combined plot and reports\n"
  fastqcplot.sh
  extract_qc_stats.sh
  fastqcplot.sh
  report_overview.sh
  cd ..
  echo -e "\nFastqc analysis done. Please check the HTML report \"report_overview.sh\"\n"

fi

echo -e "-----------------------------------------------------\n"

if [ ! -d $REV_READ_FOLDER ] || [ "$REV_READ_FOLDER" = "" ]
then
  echo -e "\nERROR : FOLDER containing the raw data \"${REV_READ_FOLDER}\" is not found"
  echo -e "\nPlease run the program as \nquality_check_after.sh FWD_READ_FOLDER REV_READ_FOLDER"
#  echo -e "\nTerminating the program...\n"
#exit
else

# Reading the REV READS

  rm -r fastqc_afterqcr
  mkdir fastqc_afterqcr

  echo -e "\nRunning the FASTQC program on all the fastq.gz files in folder \"${REV_READ_FOLDER}\"\n"
  fastqc --nogroup --extract ${REV_READ_FOLDER}*.fastq.gz -o fastqc_afterqcr
  echo -e "\nFastqc run completed from folder ${REV_READ_FOLDER}\n"

  cd fastqc_afterqcr
  rm *_fastqc.zip

  echo -e "\n Extracting stats from all fastqc files, generating combined plot and reports\n"
  fastqcplot.sh
  extract_qc_stats.sh
  fastqcplot.sh
  report_overview.sh
  cd ..
  echo -e "\nFastqc analysis done. Please check the HTML report \"report_overview.sh\"\n"

fi

