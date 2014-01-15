#-------------------------------------------------------------------------
# Name - microbiome_workflow1.sh
# Desc - Merge all fasta files from directory, creates QIIME script and mapping file
# Author - Ranjit Kumar (ranjit58@gmail.com)
# University of Alabama at Birmingham
#-------------------------------------------------------------------------

#Usage : microbiome_workflow1.sh
#OR (with parameters for cluster job submission)
#Usage : microbiome_workflow1.sh test 4 4 
# Here test is name of script, 4 is 4hr (time) and 4 is 4GB RAM.


# This  program reads and convert all fasta files to a single fasta file "seqs.fna" in QIIME compatible format.
# The program also creates a sample mapping file, QIIME script , cluster.job file. The cluster.job is optional and can be used to submit the script on cluster for processing.  


#---- Reading the command line arguments (Used to generate cluster submisson script)--------
ANALYSIS_NAME=$1
#RAM=$2
#specify time in hr as 1/2/8/10 etc
#TIME=$3
RDP_CUTOFF=0.8    #USE 0.8 FOR 454 SEQUENCES, 0.5 for short Illumina sequences
RDP_MEMORY=4000   #4GB
#------------------------------------------------


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

#--- Creating a Cluster file for submitting script to cluster-------
#echo -e "\n----------- CREATING A CLUSTER JOB FILE------------------"
#echo '#$ -S /bin/bash'>cluster.job
#echo '#$ -cwd'>>cluster.job
#echo "#\$ -N $ANALYSIS_NAME">>cluster.job
#echo "#\$ -l h_rt=$TIME:00:00,s_rt=$TIME:00:00,vf=${RAM}G">>cluster.job
#echo '#$ -M rkumar@uab.edu'>>cluster.job
#echo '#$ -m eas'>>cluster.job
#echo 'sh script.sh'>>cluster.job
#echo -e "A cluster job file named \"cluster.job\" is generated"
#-------------------------------------------------------------------


#--- Creating another Cluster file for submitting script to cluster-
#echo -e "\n----------- CREATING ANOTHER CLUSTER JOB FILE------------"
#echo '#$ -S /bin/bash'>cluster_adv.job
#echo '#$ -cwd'>>cluster_adv.job
#echo "#\$ -N $ANALYSIS_NAME">>cluster_adv.job
#echo "#\$ -l h_rt=$TIME:00:00,s_rt=$TIME:00:00,vf=${RAM}G">>cluster_adv.job
#echo '#$ -M rkumar@uab.edu'>>cluster_adv.job
#echo '#$ -m eas'>>cluster_adv.job
#echo 'sh script_adv.sh'>>cluster_adv.job
#echo -e "Another cluster job file named \"cluster_adv.job\" is generated"
#-------------------------------------------------------------------

#--------------- Generating the QIIME script -----------------------
echo -e "\n----------- GENERATING THE QIIME SCRIPT -----------------"



echo '#----------------CHIMERA FILTERING USING USEARCH---------------'>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Chimera Filtering"'>>script.sh
#echo 'identify_chimeric_seqs.py -i seqs.fna -m usearch61 -o usearch_checked_chimeras/ -r /share/apps/ngs-ccts/QIIME-files-1.7/QIIME-1.7/gg_13_8_otus/rep_set/97_otus.fasta'>>script.sh
echo 'identify_chimeric_seqs.py -i seqs.fna -m usearch61 -o usearch_checked_chimeras/ --suppress_usearch61_ref'>>script.sh
echo 'filter_fasta.py -f seqs.fna -o seqs_chimeras_filtered.fna -s usearch_checked_chimeras/chimeras.txt -n'>>script.sh
echo 'mv seqs.fna seqs.fna.org'>>script.sh
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
echo 'pick_rep_set.py -i uclust_picked_otus/seqs_otus.txt -v -m most_abundant -l uclust_picked_otus/pick_rep_seq.log -f seqs.fna'>>script.sh
echo -e "">>script.sh

echo '#----- Assign taxonomy using RDP and create OTU table ---------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Assigning taxonomy using RDP"'>>script.sh
echo "assign_taxonomy.py -i seqs.fna_rep_set.fasta -m rdp -v -c $RDP_CUTOFF --rdp_max_memory $RDP_MEMORY -o rdp_assigned_taxonomy">>script.sh
echo 'make_otu_table.py -i uclust_picked_otus/seqs_otus.txt -v -t rdp_assigned_taxonomy/seqs.fna_rep_set_tax_assignments.txt -o otu_table_unsorted.biom'>>script.sh
echo -e "">>script.sh

echo '#---------------- Sort OTU table -------------------------------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running:  Sorting OTU table"'>>script.sh
echo '#Sort the OTU table/ taxonomy charts using sample ID'>>script.sh
echo '#sort_otu_table.py -s SampleID -m mapping.txt -i otu_table_fil_n10_unsorted.biom -o otu_table.biom'>>script.sh
echo '#Sort the OTU table/ taxonomy charts using external file \"sample_order.txt\" (containing all sample names in desired order)'>>script.sh
echo 'sort_otu_table.py -i otu_table_unsorted.biom -o otu_table.biom -l sample_order.txt'>>script.sh
echo -e "">>script.sh


echo '#----------- OTU table statistics ORG-------------------------------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: OTU table statistics"'>>script.sh
echo 'print_biom_table_summary.py -i otu_table.biom > otu_table.org.stats'>>script.sh
echo -e "">>script.sh

echo '#------- Summarizing taxa information(BEFORE FILTERING OTUs)-------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Summarizing taxa(Before filtering)"'>>script.sh
echo 'summarize_taxa.py -i otu_table.biom -o taxa_summary -L 2,3,4,5,6,7'>>script.sh
echo 'plot_taxa_summary.py -i taxa_summary/otu_table_L2.txt,taxa_summary/otu_table_L3.txt,taxa_summary/otu_table_L4.txt,taxa_summary/otu_table_L5.txt,taxa_summary/otu_table_L6.txt,taxa_summary/otu_table_L7.txt -o taxa_summary/taxa_summary_plots/ -l Phylum,Class,Order,Family,Genus,Species -d 300 -c bar,area'>>script.sh
echo -e "">>script.sh

echo '#------------------ Convert BIOM file to TXT file----------------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Converting BIOM file to TXT file"'>>script.sh
echo 'convert_biom.py -i otu_table.biom -o otu_table.txt -b --header_key taxonomy --output_metadata_id "ConsensusLineage"'>>script.sh
echo -e "">>script.sh


echo '#------------------ Create Normalized OTU table -----------------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Creating Normalized OTU table"'>>script.sh
echo 'merge_otu_seq.py otu_table.txt seqs.fna_rep_set.fasta normalized_otu.txt'>>script.sh
echo -e "">>script.sh

echo '#------------------ Filter OTU tables -----------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Creating Normalized OTU table"'>>script.sh
echo 'mkdir filter_heatmap'>>script.sh
echo 'filter_otu.sh'>>script.sh
echo '#heatmap_otu.sh'>>script.sh
echo 'filter_taxa.sh'>>script.sh
echo '#heatmap_taxa.sh'>>script.sh
echo -e "">>script.sh




echo '#--------------------- Filter OTUs @ 0.0005% --------------------'>>script.sh
echo '# Comment out the whole section if no filtering is needed'>>script.sh
echo "mv otu_table.biom otu_table.org.biom">>script.sh
echo "mv seqs.fna_rep_set.fasta seqs.fna_rep_set.org.fasta">>script.sh
echo "filter_otus_from_otu_table.py -i otu_table.org.biom -o otu_table.biom --min_count_fraction 0.000005">>script.sh
echo "filter_fasta.py -f seqs.fna_rep_set.org.fasta -o seqs.fna_rep_set.fasta -b otu_table.biom">>script.sh
echo -e "">>script.sh

echo '#------------- Summarizing taxa information (filtered OTUs)----'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Summarizing taxa(filtered)"'>>script.sh
echo 'summarize_taxa.py -i otu_table.biom -o taxa_summary_trim -L 2,3,4,5,6,7'>>script.sh
echo 'plot_taxa_summary.py -i taxa_summary_trim/otu_table_L2.txt,taxa_summary_trim/otu_table_L3.txt,taxa_summary_trim/otu_table_L4.txt,taxa_summary_trim/otu_table_L5.txt,taxa_summary_trim/otu_table_L6.txt,taxa_summary_trim/otu_table_L7.txt -o taxa_summary_trim/taxa_summary_plots/ -l Phylum,Class,Order,Family,Genus,Species -d 300 -c bar,area'>>script.sh
echo -e "">>script.sh

echo '#----------- OTU table statistics-------------------------------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: OTU table statistics"'>>script.sh
echo 'print_biom_table_summary.py -i otu_table.biom > otu_table.stats'>>script.sh
echo -e "">>script.sh


echo '#----------------------- Create OTU Heatmap ---------------------'>>script.sh
echo 'make_otu_heatmap_html.py -i otu_table.biom -o OTU_Heatmap/'>>script.sh
echo -e "">>script.sh

echo '#----------------------- Create OTU Network ---------------------'>>script.sh
echo 'make_otu_network.py -m mapping.txt -i otu_table.biom -o OTU_Network'>>script.sh
echo -e "">>script.sh

echo '#------------------ Convert BIOM file to TXT file----------------'>>script.sh
echo -e 'echo "Time: `date`"' >>script.sh
echo -e 'echo "Running: Converting BIOM file to TXT file"'>>script.sh
echo "mv otu_table.txt otu_table.org.txt">>script.sh
echo 'convert_biom.py -i otu_table.biom -o otu_table.txt -b --header_key taxonomy --output_metadata_id "ConsensusLineage"'>>script.sh
echo -e "">>script.sh

echo -e "The QIIME script \"script.sh\" is generated"
echo -e "\nProgram completed successfully...\n"
#-------------------------------------------------------------------

