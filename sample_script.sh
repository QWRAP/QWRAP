#----------------CHIMERA FILTERING USING USEARCH---------------
echo "Time: `date`"
echo "Running: Chimera Filtering"
identify_chimeric_seqs.py -i seqs.fna -m usearch61 -o usearch_checked_chimeras/ --suppress_usearch61_ref
filter_fasta.py -f seqs.fna -o seqs_chimeras_filtered.fna -s usearch_checked_chimeras/chimeras.txt -n
mv seqs.fna seqs.fna.org
mv seqs_chimeras_filtered.fna seqs.fna

#------------------------- Pick OTUs -------------------------
echo "Time: `date`"
echo "Running: OTU picking"
pick_otus.py -i seqs.fna -s 0.97 -v
#pick_otus.py -i seqs.fna -s 0.99 -v
#pick_otus.py -i seqs.fna -s 1 -v

#------------------ Pick representative of OTUs --------------
echo "Time: `date`"
echo "Running: Picking representative of OTUs"
pick_rep_set.py -i uclust_picked_otus/seqs_otus.txt -v -m most_abundant -l uclust_picked_otus/pick_rep_seq.log -f seqs.fna

#----- Assign taxonomy using RDP and create OTU table ---------
echo "Time: `date`"
echo "Running: Assigning taxonomy using RDP"
assign_taxonomy.py -i seqs.fna_rep_set.fasta -m rdp -v -c 0.8 --rdp_max_memory 4000 -o rdp_assigned_taxonomy
make_otu_table.py -i uclust_picked_otus/seqs_otus.txt -v -t rdp_assigned_taxonomy/seqs.fna_rep_set_tax_assignments.txt -o otu_table_unsorted.biom

#---------------- Sort OTU table -------------------------------
echo "Time: `date`"
echo "Running:  Sorting OTU table"
#Sort the OTU table/ taxonomy charts using sample ID
#sort_otu_table.py -s SampleID -m mapping.txt -i otu_table_fil_n10_unsorted.biom -o otu_table.biom
#Sort the OTU table/ taxonomy charts using external file \"sample_order.txt\" (containing all sample names in desired order)
sort_otu_table.py -i otu_table_unsorted.biom -o otu_table.biom -l sample_order.txt

#----------- OTU table statistics ORG-------------------------------
echo "Time: `date`"
echo "Running: OTU table statistics"
print_biom_table_summary.py -i otu_table.biom > otu_table.org.stats

#------- Summarizing taxa information(BEFORE FILTERING OTUs)-------
echo "Time: `date`"
echo "Running: Summarizing taxa(Before filtering)"
summarize_taxa.py -i otu_table.biom -o taxa_summary -L 2,3,4,5,6,7
plot_taxa_summary.py -i taxa_summary/otu_table_L2.txt,taxa_summary/otu_table_L3.txt,taxa_summary/otu_table_L4.txt,taxa_summary/otu_table_L5.txt,taxa_summary/otu_table_L6.txt,taxa_summary/otu_table_L7.txt -o taxa_summary/taxa_summary_plots/ -l Phylum,Class,Order,Family,Genus,Species -d 300 -c bar,area

#------------------ Convert BIOM file to TXT file----------------
echo "Time: `date`"
echo "Running: Converting BIOM file to TXT file"
convert_biom.py -i otu_table.biom -o otu_table.txt -b --header_key taxonomy --output_metadata_id "ConsensusLineage"

#------------------ Create Normalized OTU table -----------------
echo "Time: `date`"
echo "Running: Creating Normalized OTU table"
merge_otu_seq.py otu_table.txt seqs.fna_rep_set.fasta normalized_otu.txt

#------------------ Filter OTU tables -----------
echo "Time: `date`"
echo "Running: Creating Normalized OTU table"
mkdir filter_heatmap
filter_otu.sh
#heatmap_otu.sh
filter_taxa.sh
#heatmap_taxa.sh

#--------------------- Filter OTUs @ 0.0005% --------------------
# Comment out the whole section if no filtering is needed
mv otu_table.biom otu_table.org.biom
mv seqs.fna_rep_set.fasta seqs.fna_rep_set.org.fasta
filter_otus_from_otu_table.py -i otu_table.org.biom -o otu_table.biom --min_count_fraction 0.000005
filter_fasta.py -f seqs.fna_rep_set.org.fasta -o seqs.fna_rep_set.fasta -b otu_table.biom

#------------- Summarizing taxa information (filtered OTUs)----
echo "Time: `date`"
echo "Running: Summarizing taxa(filtered)"
summarize_taxa.py -i otu_table.biom -o taxa_summary_trim -L 2,3,4,5,6,7
plot_taxa_summary.py -i taxa_summary_trim/otu_table_L2.txt,taxa_summary_trim/otu_table_L3.txt,taxa_summary_trim/otu_table_L4.txt,taxa_summary_trim/otu_table_L5.txt,taxa_summary_trim/otu_table_L6.txt,taxa_summary_trim/otu_table_L7.txt -o taxa_summary_trim/taxa_summary_plots/ -l Phylum,Class,Order,Family,Genus,Species -d 300 -c bar,area

#----------- OTU table statistics-------------------------------
echo "Time: `date`"
echo "Running: OTU table statistics"
print_biom_table_summary.py -i otu_table.biom > otu_table.stats

#----------------------- Create OTU Heatmap ---------------------
make_otu_heatmap_html.py -i otu_table.biom -o OTU_Heatmap/

#----------------------- Create OTU Network ---------------------
make_otu_network.py -m mapping.txt -i otu_table.biom -o OTU_Network

#------------------ Convert BIOM file to TXT file----------------
echo "Time: `date`"
echo "Running: Converting BIOM file to TXT file"
mv otu_table.txt otu_table.org.txt
convert_biom.py -i otu_table.biom -o otu_table.txt -b --header_key taxonomy --output_metadata_id "ConsensusLineage"

