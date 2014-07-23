#----------------CHIMERA FILTERING USING USEARCH---------------
echo "Time: `date`"
echo "Running: Chimera Filtering"
identify_chimeric_seqs.py -i seqs.fna -m usearch61 -o usearch_checked_chimeras/ -r /share/apps/ngs-ccts/QIIME-files-1.7/QIIME-1.7/gg_13_8_otus/rep_set/97_otus.fasta
filter_fasta.py -f seqs.fna -o seqs_chimeras_filtered.fna -s usearch_checked_chimeras/chimeras.txt -n
mv seqs.fna seqs.fna.chim
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
pick_rep_set.py -i uclust_picked_otus/seqs_otus.txt -v -m most_abundant -l uclust_picked_otus/pick_rep_seq.log -f seqs.fna -o seqs.fna_rep_set_org.fasta

#----- Assign taxonomy using RDP and create OTU table ---------
echo "Time: `date`"
echo "Running: Assigning taxonomy using RDP"
assign_taxonomy.py -i seqs.fna_rep_set_org.fasta -m rdp -v -c 0.8 --rdp_max_memory 4000 -o rdp_assigned_taxonomy
make_otu_table.py -i uclust_picked_otus/seqs_otus.txt -v -t rdp_assigned_taxonomy/seqs.fna_rep_set_org_tax_assignments.txt -o otu_table_unsorted_org.biom

#---------------- Sort OTU table -------------------------------
echo "Time: `date`"
echo "Running:  Sorting OTU table"
#Sort the OTU table/ taxonomy charts using external file \"sample_order.txt\" (containing all sample names in desired order)
sort_otu_table.py -i otu_table_unsorted_org.biom -o otu_table_org.biom -l sample_order.txt

#----------- OTU table statistics ORG-------------------------------
echo "Time: `date`"
echo "Running: OTU table statistics"
print_biom_table_summary.py -i otu_table_org.biom > otu_table_org.stats.txt

#------- Summarizing taxa information(ORG)-------
echo "Time: `date`"
echo "Running: Summarizing taxa(Before filtering)"
summarize_taxa.py -i otu_table_org.biom -o taxa_summary_org -L 2,3,4,5,6,7
plot_taxa_summary.py -i taxa_summary_org/otu_table_org_L2.txt,taxa_summary_org/otu_table_org_L3.txt,taxa_summary_org/otu_table_org_L4.txt,taxa_summary_org/otu_table_org_L5.txt,taxa_summary_org/otu_table_org_L6.txt,taxa_summary_org/otu_table_org_L7.txt -o taxa_summary_org/taxa_summary_plots/ -l Phylum,Class,Order,Family,Genus,Species -d 300 -c bar,area

#------------------ Convert BIOM file to TXT file----------------
echo "Time: `date`"
echo "Running: Converting BIOM file to TXT file"
convert_biom.py -i otu_table_org.biom -o otu_table_org.txt -b --header_key taxonomy --output_metadata_id "ConsensusLineage"

#------------------ Create Normalized OTU table -----------------
echo "Time: `date`"
echo "Running: Creating Normalized OTU table"
merge_otu_seq.py otu_table_org.txt seqs.fna_rep_set_org.fasta normalized_otu_org.txt

#------------------ Select top OTUs -----------
echo "Time: `date`"
mkdir top_otu_taxa_org
top_otu_org.sh
top_taxa_org.sh

echo "Program completed successfully..."
