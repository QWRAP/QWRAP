#-------------------------------------------------------------------------
# Name - quality_check_filterdata.sh
# Desc - Runs FASTQC on all fastq.gz files and store in folder "fastqc_filterdata"
# Author - Ranjit Kumar (ranjit58@gmail.com)
# University of Alabama at Birmingham
#-------------------------------------------------------------------------

#-----Running the fastqc runs on all the fastq.gz files from the supplied folder ------------------
# Run the program as
#quality_check_filterdata.sh FWD_READ_FOLDER



# Reading commandline arguments
FWD_READ_FOLDER="$1"
#REV_READ_FOLDER="$2"

#Check the commandline parameters.

if [ $# -lt 1 ]
then
  echo -e "\nERROR : Commandline arguments not found"
  echo -e "\nPlease run the program as \nquality_check_filterdata.sh FWD_READ_FOLDER"
  echo -e "\nTerminating the program...\n"
exit
fi

if [ ! -d $FWD_READ_FOLDER ] || [ "$FWD_READ_FOLDER" = "" ]
then
  echo -e "\nERROR : FOLDER containing the filtered data \"${FWD_READ_FOLDER}\" is not found"
  echo -e "\nPlease run the program as \nquality_check_filterdata.sh FWD_READ_FOLDER"
#  echo -e "\nTerminating the program...\n"
#exit
else

# Reading the FWD READS

  rm -rf fastqc_filterdata
  mkdir fastqc_filterdata

  echo -e "\nRunning the FASTQC program on all the fastq files in folder \"${FWD_READ_FOLDER}\"\n"
  fastqc --nogroup ${FWD_READ_FOLDER}/*.fastq -o fastqc_filterdata
  echo -e "\nFastqc run completed from folder ${FWD_READ_FOLDER}\n"

  cd fastqc_filterdata
  rm -f *_fastqc.zip

  echo -e "\n Extracting stats from all fastqc files, generating combined plot and reports\n"
  fastqcplot.sh
  extract_qc_stats.sh
  fastqcplot.sh
  report_overview.sh
  cd ..
  echo -e "\nFastqc analysis done. Please check the HTML report \"FASTQC_overview.html\"\n"

fi

echo -e "-----------------------------------------------------\n"


