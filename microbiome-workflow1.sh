#-------------------------------------------------------------------------
# Name - microbiome_workflow1.sh
# Desc - Merge all fasta files from directory, creates QIIME script and mapping file
# Author - Ranjit Kumar (ranjit58@gmail.com)
# University of Alabama at Birmingham
#-------------------------------------------------------------------------

#Usage : microbiome_workflow1.sh

# This  program reads and convert all fasta files to a single fasta file "seqs.fna" in QIIME compatible format.
# The program also creates a sample mapping file, QIIME script , sample order.  


# Program parameters
RDP_CUTOFF=0.8    #USE 0.8 FOR 454 SEQUENCES, 0.5 for short Illumina sequences
RDP_MEMORY=4000   #4GB


#----- Combine all the  fasta file into single file seqs.fna -------
echo -e "\n----------- MERGING FASTA FILES -------------------------"
echo -e "\nReading all the fasta files from the current directory and merging into a single file \"seqs.fna\" file for the QIIME analysis"
echo -e "The name of the fasta files is treated as sample names in seqs.fna file."
combinefasta_qiime.pl `ls *.fasta` seqs.fna
echo -e "\nCreated a single fasta file \"seqs.fna\""
#-------------------------------------------------------------------


#--- Creating a MAPPING FILE ---------------------------------------
echo -e "\n----------- CREATING A MAPPING FILE----------------------"
echo -e "Reading all the fasta files from the current directory and creates a sample mapping file"
echo -e "#SampleID" >mapping.txt
echo '#Mapping file for the QIIME analysis'>>mapping.txt
for file in $( ls *.fasta ); do echo -e $file|sed -e 's/.fasta//g'>>mapping.txt; done
echo -e "A mapping file named \"mapping.txt\" is generated"
#-------------------------------------------------------------------

#--- Creating a FILE for sorting samples---------------------------------------
echo -e "\n----------- CREATING A SORTING FILE----------------------"
echo -e "Reading all the fasta files from the current directory and creates a sample sorting file"
rm -f sample_order.txt
for file in $( ls *.fasta ); do echo -e $file|sed -e 's/.fasta//g'>>sample_order.txt; done
echo -e "A sample ordering file named \"sample_order.txt\" is generated"
#-------------------------------------------------------------------


#--------------- Generating the QIIME script -----------------------
echo -e "\n----------- GENERATING THE QIIME SCRIPT -----------------"


echo '#----------------CHIMERA FILTERING USING USEARCH---------------'>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Chimera Filtering"'>>script.sh
# identify location of reference sequence from command print_qiime_config.py
echo -e "identify_chimeric_seqs.py -i seqs.fna -m usearch61 -o usearch_checked_chimeras/ -r `print_qiime_config.py |grep "assign_taxonomy_reference_seqs_fp:" | cut -f 2`">>script.sh

# this can be used to suppress the reference database reqirement
#echo 'identify_chimeric_seqs.py -i seqs.fna -m usearch61 -o usearch_checked_chimeras/ --suppress_usearch61_ref'>>script.sh
echo 'filter_fasta.py -f seqs.fna -o seqs_chimeras_filtered.fna -s usearch_checked_chimeras/chimeras.txt -n'>>script.sh
echo 'mv seqs.fna seqs.fna.chim'>>script.sh
echo 'mv seqs_chimeras_filtered.fna seqs.fna'>>script.sh
echo -e "">>script.sh

echo '#------------------------- Pick OTUs -------------------------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: OTU picking"'>>script.sh
echo 'pick_otus.py -i seqs.fna -s 0.97 -v'>>script.sh
echo '#pick_otus.py -i seqs.fna -s 0.99 -v'>>script.sh
echo '#pick_otus.py -i seqs.fna -s 1 -v'>>script.sh
echo -e "">>script.sh

echo '#------------------ Pick representative of OTUs --------------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Picking representative of OTUs"'>>script.sh
echo 'pick_rep_set.py -i uclust_picked_otus/seqs_otus.txt -v -m most_abundant -l uclust_picked_otus/pick_rep_seq.log -f seqs.fna -o seqs.fna_rep_set_org.fasta'>>script.sh
echo -e "">>script.sh

echo '#----- Assign taxonomy using RDP and create OTU table ---------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Assigning taxonomy using RDP"'>>script.sh
echo "assign_taxonomy.py -i seqs.fna_rep_set_org.fasta -m rdp -v -c $RDP_CUTOFF --rdp_max_memory $RDP_MEMORY -o rdp_assigned_taxonomy">>script.sh
echo 'make_otu_table.py -i uclust_picked_otus/seqs_otus.txt -v -t rdp_assigned_taxonomy/seqs.fna_rep_set_org_tax_assignments.txt -o otu_table_unsorted_org.biom'>>script.sh
echo -e "">>script.sh

echo '#---------------- Sort OTU table -------------------------------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running:  Sorting OTU table"'>>script.sh
echo '#Sort the OTU table/ taxonomy charts using external file \"sample_order.txt\" (containing all sample names in desired order)'>>script.sh
echo 'sort_otu_table.py -i otu_table_unsorted_org.biom -o otu_table_org.biom -l sample_order.txt'>>script.sh
echo -e "">>script.sh


echo '#----------- OTU table statistics ORG-------------------------------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: OTU table statistics"'>>script.sh
echo 'biom summarize-table -i otu_table_org.biom > otu_table_org.stats.txt'>>script.sh
echo -e "">>script.sh

echo '#------- Summarizing taxa information(ORG)-------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Summarizing taxa(Before filtering)"'>>script.sh
echo 'summarize_taxa.py -i otu_table_org.biom -o taxa_summary_org -L 2,3,4,5,6,7'>>script.sh
echo 'plot_taxa_summary.py -i taxa_summary_org/otu_table_org_L2.txt,taxa_summary_org/otu_table_org_L3.txt,taxa_summary_org/otu_table_org_L4.txt,taxa_summary_org/otu_table_org_L5.txt,taxa_summary_org/otu_table_org_L6.txt,taxa_summary_org/otu_table_org_L7.txt -o taxa_summary_org/taxa_summary_plots/ -l Phylum,Class,Order,Family,Genus,Species -d 300 -c bar,area'>>script.sh
echo -e "">>script.sh

echo '#------------------ Convert BIOM file to TXT file----------------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Converting BIOM file to TXT file"'>>script.sh
echo 'convert_biom.py -i otu_table_org.biom -o otu_table_org.txt -b --header_key taxonomy --output_metadata_id "ConsensusLineage"'>>script.sh
echo -e "">>script.sh


echo '#------------------ Create Normalized OTU table -----------------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Creating Normalized OTU table"'>>script.sh
echo 'merge_otu_seq.py otu_table_org.txt seqs.fna_rep_set_org.fasta normalized_otu_org.txt'>>script.sh
echo -e "">>script.sh

echo '#------------------ Select top OTUs -----------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo 'mkdir top_otu_taxa_org'>>script.sh
echo 'top_otu_org.sh'>>script.sh
echo 'top_taxa_org.sh'>>script.sh
echo -e "">>script.sh
echo -e 'echo "Program completed successfully..."'>>script.sh

echo -e "A script file named \"script.sh\" is generated"
 
echo -e "\nProgram completed successfully...\n"
#-------------------------------------------------------------------

