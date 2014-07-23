
#---------------------Rarifying OTU table-------------------
echo "Time: `date`"
echo "Running: Rarefaction of OTU tables"
single_rarefaction.py -i otu_table_org.biom -o otu_table_even.biom -d 23164


#--------------------- Filter OTUs @ 0.0005% --------------------
echo "Time: `date`"
echo "Running: Filtering OTUs at 0.0005% abundance"
filter_otus_from_otu_table.py -i otu_table_even.biom -o otu_table_fil.biom --min_count_fraction 0.00005
filter_fasta.py -f seqs.fna_rep_set_org.fasta -o seqs.fna_rep_set_fil.fasta -b otu_table_fil.biom

#------------- Summarizing taxa information (filtered)----
echo "Time: `date`"
echo "Running: Summarizing taxa(filtered)"
summarize_taxa.py -i otu_table_fil.biom -o taxa_summary_fil -L 2,3,4,5,6,7
plot_taxa_summary.py -i taxa_summary_fil/otu_table_fil_L2.txt,taxa_summary_fil/otu_table_fil_L3.txt,taxa_summary_fil/otu_table_fil_L4.txt,taxa_summary_fil/otu_table_fil_L5.txt,taxa_summary_fil/otu_table_fil_L6.txt,taxa_summary_fil/otu_table_fil_L7.txt -o taxa_summary_fil/taxa_summary_plots/ -l Phylum,Class,Order,Family,Genus,Species -d 300 -c bar,area

#----------- OTU table statistics-------------------------------
echo "Time: `date`"
echo "Running: OTU table statistics"
print_biom_table_summary.py -i otu_table_fil.biom > otu_table_fil.stats.txt

#----------------------- Create OTU Heatmap ---------------------
make_otu_heatmap_html.py -i otu_table_fil.biom -o OTU_fil_Heatmap/

#----------------------- Create OTU Network ---------------------
make_otu_network.py -m mapping.txt -i otu_table_fil.biom -o OTU_fil_Network

#------------------ Convert BIOM file to TXT file----------------
echo "Time: `date`"
echo "Running: Converting BIOM file to TXT file"
convert_biom.py -i otu_table_fil.biom -o otu_table_fil.txt -b --header_key taxonomy --output_metadata_id "ConsensusLineage"

#------------------ Create Normalized OTU table -----------------
echo "Time: `date`"
echo "Running: Creating Normalized OTU table"
merge_otu_seq.py otu_table_fil.txt seqs.fna_rep_set_fil.fasta normalized_otu_fil.txt

#------------------ Select top OTUs -----------
echo "Time: `date`"
mkdir top_otu_taxa_fil
top_otu_fil.sh
top_taxa_fil.sh


#---------------------Align/filter/tree-------------------
echo "Time: `date`"
echo "Running: Sequence Alignment"
align_seqs.py -i seqs.fna_rep_set_fil.fasta -v
echo "Time: `date`"
echo "Running: Filtering Sequece Alignment"
filter_alignment.py -i pynast_aligned/seqs.fna_rep_set_fil_aligned.fasta -v -o filtered_alignment
echo "Time: `date`"
echo "Running: Making Phylogenetic tree"
make_phylogeny.py -i filtered_alignment/seqs.fna_rep_set_fil_aligned_pfiltered.fasta -v -o phylogeny.tre

#------------- Calculate alpha div and generate plots -------
echo "Time: `date`"
echo "Running: Calculating Alpha diversity and plots"
# Calculate the alpha div for given matrices : chao1,observed_species,PD_whole_tree,shannon,simpson
alpha_diversity.py -i otu_table_fil.biom -o alpha_div.txt -m chao1,observed_species,PD_whole_tree,shannon,simpson -t phylogeny.tre
# Creates a parameters files and run alpha diversity through plots
echo "alpha_diversity:metrics shannon,simpson,PD_whole_tree,chao1,observed_species" > alpha_params.txt
alpha_rarefaction.py -i otu_table_fil.biom -p alpha_params.txt -m mapping.txt -o alpha_rarefac -v -t phylogeny.tre

#-------------Calculate Beta div and generate plots ---------
echo "Time: `date`"
echo "Running: Calculating Beta diversity and plots"
echo "beta_diversity:metrics  bray_curtis,unweighted_unifrac,weighted_unifrac" > beta_params.txt
beta_diversity_through_plots.py -i otu_table_fil.biom -m mapping.txt -p beta_params.txt -o beta_div -v -t phylogeny.tre
# calculate beta div values for given three matrices : bray_curtis,unweighted_unifrac,weighted_unifrac
beta_diversity.py -i otu_table_fil.biom -m bray_curtis,unweighted_unifrac,weighted_unifrac -o beta_div_matrices -t phylogeny.tre
# Draw emperor plots
make_emperor.py -i beta_div/bray_curtis_pc.txt -m mapping.txt -o beta_div/emperor_bray
make_emperor.py -i beta_div/weighted_unifrac_pc.txt -m mapping.txt -o beta_div/emperor_unif_wei
make_emperor.py -i beta_div/unweighted_unifrac_pc.txt -m mapping.txt -o beta_div/emperor_unif_unw

#------------- Generate UPGMA tree ---------------------------
echo "Time: `date`"
echo "Running: Generating UPGMA trees"
upgma_cluster.py -i beta_div/unweighted_unifrac_dm.txt -o beta_div/beta_div_unw.tre
upgma_cluster.py -i beta_div/weighted_unifrac_dm.txt -o beta_div/beta_div_w.tre
upgma_cluster.py -i beta_div/bray_curtis_dm.txt -o beta_div/beta_div_bray.tre
