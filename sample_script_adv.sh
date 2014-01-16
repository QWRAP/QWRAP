
#---------------------Align/filter/tree-------------------
echo "Time: `date`"
echo "Running: Sequece Alignment"
align_seqs.py -i seqs.fna_rep_set.fasta -v
echo "Time: `date`"
echo "Running: Filtering Sequece Alignment"
filter_alignment.py -i pynast_aligned/seqs.fna_rep_set_aligned.fasta -v -o filtered_alignment
echo "Time: `date`"
echo "Running: Making Phylogenetic tree"
make_phylogeny.py -i filtered_alignment/seqs.fna_rep_set_aligned_pfiltered.fasta -v -o phylogeny.tre

#-------Use even sampling depth and rareify OTU table-------
#create a rarified OTU table from even sampling septh provided in commandline. If it is not provided, the minimum sampling depth is calcualted from file \"otu_table.stats\"
echo "Time: `date`"
echo "Running: Rarefaction of OTU tables"
single_rarefaction.py -i otu_table.biom -o otu_table_even.biom -d 22986

#------------- Calculate alpha div and generate plots -------
echo "Time: `date`"
echo "Running: Calculating Alpha diversity and plots"
# Calculate the alpha div for given matrices : chao1,observed_species,PD_whole_tree,shannon,simpson
alpha_diversity.py -i otu_table_even.biom -o alpha_div.txt -m chao1,observed_species,PD_whole_tree,shannon,simpson -t phylogeny.tre
# Creates a parameters files and run alpha diversity through plots
echo "alpha_diversity:metrics shannon,simpson,PD_whole_tree,chao1,observed_species" > alpha_params.txt
alpha_rarefaction.py -i otu_table_even.biom -p alpha_params.txt -m mapping.txt -o alpha_rarefac -v -t phylogeny.tre

#-------------Calculate Beta div and generate plots ---------
echo "Time: `date`"
echo "Running: Calculating Beta diversity and plots"
echo "beta_diversity:metrics  bray_curtis,unweighted_unifrac,weighted_unifrac" > beta_params.txt
beta_diversity_through_plots.py -i otu_table_even.biom -m mapping.txt -p beta_params.txt -o beta_div -v -t phylogeny.tre
# calculate beta div values for given three matrices : bray_curtis,unweighted_unifrac,weighted_unifrac
beta_diversity.py -i otu_table_even.biom -m bray_curtis,unweighted_unifrac,weighted_unifrac -o beta_div_matrices -t phylogeny.tre
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

#---------------------Jack Knife-------------------------------
#echo "Time: `date`"
#echo "Running: Jack Knifing"
#for jacknife the value for -e should be 75% of 22986
#jackknifed_beta_diversity.py -i otu_table.txt -m mapping.txt -o beta_jacknife -e 17239 -t phylogeny.tre

