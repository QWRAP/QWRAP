#-------------------------------------------------------------------------
# Name - check_qwrap.sh
# Desc - Check whether QWRAP and other dependencies are present in the path.
# Author - Ranjit Kumar (ranjit58@gmail.com)
#-------------------------------------------------------------------------

# Usage : check_qwrap.sh

echo -e ""

# Testing QWRAP
OUTPUT=$(quality_check_rawdata.sh 2>&1)
if [[ $OUTPUT =~ 'command not found' ]]; then
    echo -e "Checking QWRAP: Failed"
else
    echo -e "Checking QWRAP: Success"
fi

# Testing FASTQC
OUTPUT=$(fastqc -h 2>&1)
if [[ $OUTPUT =~ 'command not found' ]]; then 
    echo -e "Checking FASTQC: Failed"
else
    echo -e "Checking FASTQC: Success"
fi

# Testing FASTX
OUTPUT=$(fastx_trimmer -h 2>&1)
if [[ $OUTPUT =~ 'command not found' ]]; then
    echo -e "Checking FASTX: Failed"
else
    echo -e "Checking FASTX: Success"
fi

# Testing USEARCH
OUTPUT=$(usearch61 2>&1)
if [[ $OUTPUT =~ 'command not found' ]]; then
    echo -e "Checking USEARCH: Failed"
else
    echo -e "Checking USEARCH: Success"
fi

# Testing R
OUTPUT=$(R RHOME 2>&1)
if [[ $OUTPUT =~ 'command not found' ]]; then
    echo -e "Checking R: Failed"
else
    echo -e "Checking R: Success"
fi

echo -e ""

