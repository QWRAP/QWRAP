#!/usr/bin/python

#-------------------------------------------------------------------------
# Name - merge_otu_seq_norm.py otu_table.txt seqs.fna_rep_set.fasta normalized_otu.txt
# Desc - The program merge otu table and 16S sequence and convert the abundance information into proportion (i.e. normalize)
# Author - Ranjit Kumar (ranjit58@gmail.com)
# Source code - https://github.com/ranjit58/NGS/blob/master/merge_otu_seq_norm.py
#-------------------------------------------------------------------------

import re
import sys

# read the sequence file 
input_seq = open(sys.argv[2],"r")

print "\nReading fasta file ",sys.argv[2], ", please wait..."

# read the sequence fasta file and store it in a dictionary dict_seq
#print '[INFO]: Reading the sequence file and storing it to a dictionary'

dict_seq = {}
count=0
for line in input_seq:
  if re.match('>',line):  
    header=re.split('>| ',line)
    #print header[1]
    header_name=header[1]
  else:
    sequence = re.split('\n',line)
    #print sequence
    dict_seq[header[1]] = sequence[0]
    count +=1
input_seq.close()

print 'Data Stored in dictionary sucessfully. Total reads are ',count

# Loop to test dictionary
#for line in dict_seq:
#  print line,dict_seq[line]



input_otu=open(sys.argv[1],"r")
output=open(sys.argv[3],"w")

print "Reading OTU file ",sys.argv[1], "and counting number of reads  please wait..."

num_samples=0
readscount = {}
for line in input_otu:
  if re.match('#',line):
    if re.match('#OTU ID',line):
      linesplit = re.split('\t',line)
      for i in range(1,len(linesplit)-1):
        readscount[str(i)]=0

  else:
    line=line.rstrip('\n')
    linesplit = re.split('\t',line)
    for i in range(1,len(linesplit)-1):
      readscount[str(i)]= readscount[str(i)] + float(linesplit[i])


# Loop to test dictionary
#for depth in readscount:
#  print depth,readscount[depth]
    
    
input_seq.close()


# read the otu table
input_otu=open(sys.argv[1],"r")
print "Reading OTU file ",sys.argv[1], "and normalizing   please wait..."

for line in input_otu:
  if re.match('#',line):
    line=line.rstrip('\n')
    if re.match('#OTU ID',line):
      header=re.split('>| ',line)
      output.write(line + "\tOTU Sequence" + "\n")
    else:
      output.write(line + "\n")
  else:
    line=line.rstrip('\n')
    linesplit = re.split('\t',line)
    output.write(linesplit[0] + "\t")
    for i in range(1,len(linesplit)-1):
      otu_ratio = float(linesplit[i]) / readscount[str(i)]
      #print round(otu_ratio,4)*100,"\t",
      output.write(str(otu_ratio) + "\t")
    output.write(linesplit[len(linesplit)-1] + "\t" + dict_seq[linesplit[0]] + "\n")
  
input_seq.close()  

print "Normalized OTU file created - ",sys.argv[3], "\n"

