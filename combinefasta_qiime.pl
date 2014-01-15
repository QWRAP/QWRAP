#!/usr/bin/perl -w

#-------------------------------------------------------------------------
# Name - combinefasta_qiime.pl
# Desc - Readsa set of fasta files from the current directory and merge them into a single file "seqs.fna"
# Author - Ranjit Kumar (ranjit58@gmail.com)
#-------------------------------------------------------------------------

#Usage : To convert four fasta files like (sample 1 sample2 sample3 sample4 )into one big file seqs.fna, provide all filename as arguments. last argument is the name of output file and all earlier arguments are input file for ex.  perl combinefasta_qiime.pl sample1 sample2 sample3 sample4 seqs.fna

#count num of arguments i.e fatsa files given in command line

print "Total fasta files given in arguments is $#ARGV\n";

#in a for loop iterating over all fasta files, read fasta file and write it to one big file with changes

$count=0; # A counter for fasta files.

open(OUT,">$ARGV[$#ARGV]") or die "can't create output file >$ARGV[$#ARGV]";

while($count<$#ARGV)
{

	#read content of each file and wrtie to file OUTPUT seqs.fna
	open(INPUT,"$ARGV[$count]") or die "can't read fasta file $ARGV[$count]";
	while(<INPUT>)
	{
		$header=$ARGV[$count];
                $header=~ s/\.fasta//g;
                #print "***** $header ******"; 
                $_ =~ s/\>/\>$header\_/;
		print OUT $_;
	}

print "Completed reading and writing $ARGV[$count]\n";

$count++;

}
