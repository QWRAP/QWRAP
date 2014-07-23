#-------------------------------------------------------------------------
# Name - extract_qc_stats.sh
# Desc - 
# Author - Ranjit Kumar (ranjit58@gmail.com)
#-------------------------------------------------------------------------


#find -name "fastqc_data.txt" -type f |xargs -I {} head -10 {}|egrep -w 'Filename|Total Sequences|Sequence length|^%GC' |cut -f 2| sed "s/\n/\t/"

# remove presxisting files

rm -f qcstats.txt
touch qcstats.txt
rm -f qcplot.txt
touch qcplot.txt

echo -e "\nGenerating statistics for fastqc output files listed below\n"
for file in $(find -name "fastqc_data.txt" -type f );
do
    echo -e "$file"
    egrep -w 'Filename|Total Sequences|Sequence length|^%GC' $file |cut -f 2| tr "\n" "\t" >>qcstats.txt
    echo  >>qcstats.txt
  
done

echo -e "\nGenerated a stats file "qcstats.txt" containing statistics for fastqc output files.\n"


echo -e "\nGenerating plots data for fastqc output files listed below\n"
counter=0
for file in $(find -name "fastqc_data.txt" -type f );

do
    echo -e "$file"
    if [ $counter -eq 0 ]; then
	{
	newfile=${file/_fastqc\/fastqc_data.txt/};
	newfile=${newfile/.\//};
	echo -e "base\t${newfile}">>qcplot.txt
	A=$(grep -P -n "#Base\tMean" $file | cut -f 1 -d ":")
	B=$(grep -P -n ">>Per tile sequence quality" $file | cut -f 1 -d ":")
	C=$(($B-2))
	D=$(($C-$A))
	head -$C $file|tail -$D|cut -f 1,2 >>qcplot.txt
	
	}
    else
	{
        newfile=${file/_fastqc\/fastqc_data.txt/};
        newfile=${newfile/.\//};
	echo -e "$newfile">>temp.txt
        A=$(grep -P -n "#Base\tMean" $file | cut -f 1 -d ":")
        B=$(grep -P -n ">>Per tile sequence quality" $file | cut -f 1 -d ":")
        C=$(($B-2))
        D=$(($C-$A))
        head -$C $file|tail -$D|cut -f 2 >>temp.txt
        paste qcplot.txt temp.txt>temp2.txt
        rm qcplot.txt
	mv temp2.txt qcplot.txt
        rm temp.txt
	}
    fi
counter=2;
done
echo -e "\nGenerated a plots data file "qcplot.txt" for generating plots for fastqc output files.\n"
