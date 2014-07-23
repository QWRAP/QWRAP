#-------------------------------------------------------------------------
# Name - microbiome_workflow2.sh
# Desc - Create QIIME Script for Rarefaction, OTU filtering, OTU alignment, phylogeny, Alpha div, Beta div, UPGMA tree, Jacknifing.
# Author - Ranjit Kumar (ranjit58@gmail.com)
# University of Alabama at Birmingham
#-------------------------------------------------------------------------

#Usage : microbiome_workflow2.sh EVEN_SAMPLE_DEPTH
# if a sampling depth is not provided in command line the minimum sample depth is calculated.

#---- Reading the command line arguments --------
EVEN_SAMPLE_DEPTH=$1
#------------------------------------------------

echo -e "\n#---------------------Calculating Even sampling depth-------------------">script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo '#create a rarified OTU table from even sampling septh provided in commandline. If it is not provided, the minimum sampling depth is calcualted from file \"otu_table.stats\"'>>script_adv.sh

if [ "$EVEN_SAMPLE_DEPTH" = '' ]
then
  EVEN=$(cat otu_table_org.stats.txt |head -8|tail -1|cut -d : -f 2|cut -d . -f 1| cut -d ' ' -f 2)
else
  EVEN=$EVEN_SAMPLE_DEPTH
fi
echo -e "">>script_adv.sh


echo -e "\n#---------------------Rarifying OTU table-------------------">script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Rarefaction of OTU tables"'>>script_adv.sh
echo -e "single_rarefaction.py -i otu_table_org.biom -o otu_table_even.biom -d $EVEN\n">>script_adv.sh
echo -e "">>script_adv.sh


echo '#--------------------- Filter OTUs @ 0.0005% --------------------'>>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Filtering OTUs at 0.0005% abundance"'>>script_adv.sh
echo "filter_otus_from_otu_table.py -i otu_table_even.biom -o otu_table_fil.biom --min_count_fraction 0.00005">>script_adv.sh
echo "filter_fasta.py -f seqs.fna_rep_set_org.fasta -o seqs.fna_rep_set_fil.fasta -b otu_table_fil.biom">>script_adv.sh
echo -e "">>script_adv.sh

echo '#------------- Summarizing taxa information (filtered)----'>>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Summarizing taxa(filtered)"'>>script_adv.sh
echo 'summarize_taxa.py -i otu_table_fil.biom -o taxa_summary_fil -L 2,3,4,5,6,7'>>script_adv.sh
echo 'plot_taxa_summary.py -i taxa_summary_fil/otu_table_fil_L2.txt,taxa_summary_fil/otu_table_fil_L3.txt,taxa_summary_fil/otu_table_fil_L4.txt,taxa_summary_fil/otu_table_fil_L5.txt,taxa_summary_fil/otu_table_fil_L6.txt,taxa_summary_fil/otu_table_fil_L7.txt -o taxa_summary_fil/taxa_summary_plots/ -l Phylum,Class,Order,Family,Genus,Species -d 300 -c bar,area'>>script_adv.sh
echo -e "">>script_adv.sh

echo '#----------- OTU table statistics-------------------------------'>>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: OTU table statistics"'>>script_adv.sh
echo 'print_biom_table_summary.py -i otu_table_fil.biom > otu_table_fil.stats.txt'>>script_adv.sh
echo -e "">>script_adv.sh


echo '#----------------------- Create OTU Heatmap ---------------------'>>script_adv.sh
echo 'make_otu_heatmap_html.py -i otu_table_fil.biom -o OTU_fil_Heatmap/'>>script_adv.sh
echo -e "">>script_adv.sh

echo '#----------------------- Create OTU Network ---------------------'>>script_adv.sh
echo 'make_otu_network.py -m mapping.txt -i otu_table_fil.biom -o OTU_fil_Network'>>script_adv.sh
echo -e "">>script_adv.sh

echo '#------------------ Convert BIOM file to TXT file----------------'>>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Converting BIOM file to TXT file"'>>script_adv.sh
echo 'convert_biom.py -i otu_table_fil.biom -o otu_table_fil.txt -b --header_key taxonomy --output_metadata_id "ConsensusLineage"'>>script_adv.sh
echo -e "">>script_adv.sh

echo '#------------------ Create Normalized OTU table -----------------'>>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Creating Normalized OTU table"'>>script_adv.sh
echo 'merge_otu_seq.py otu_table_fil.txt seqs.fna_rep_set_fil.fasta normalized_otu_fil.txt'>>script_adv.sh
echo -e "">>script_adv.sh

echo '#------------------ Select top OTUs -----------'>>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo 'mkdir top_otu_taxa_fil'>>script_adv.sh
echo 'top_otu_fil.sh'>>script_adv.sh
echo 'top_taxa_fil.sh'>>script_adv.sh
echo -e "">>script_adv.sh

echo -e "\n#---------------------Align/filter/tree-------------------">>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Sequence Alignment"'>>script_adv.sh
echo 'align_seqs.py -i seqs.fna_rep_set_fil.fasta -v'>>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Filtering Sequece Alignment"'>>script_adv.sh
echo 'filter_alignment.py -i pynast_aligned/seqs.fna_rep_set_fil_aligned.fasta -v -o filtered_alignment'>>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Making Phylogenetic tree"'>>script_adv.sh
echo 'make_phylogeny.py -i filtered_alignment/seqs.fna_rep_set_fil_aligned_pfiltered.fasta -v -o phylogeny.tre'>>script_adv.sh
echo -e "">>script_adv.sh

echo -e "#------------- Calculate alpha div and generate plots -------">>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Calculating Alpha diversity and plots"'>>script_adv.sh
echo '# Calculate the alpha div for given matrices : chao1,observed_species,PD_whole_tree,shannon,simpson'>>script_adv.sh
echo -e "alpha_diversity.py -i otu_table_fil.biom -o alpha_div.txt -m chao1,observed_species,PD_whole_tree,shannon,simpson -t phylogeny.tre">>script_adv.sh
echo "# Creates a parameters files and run alpha diversity through plots">>script_adv.sh
echo 'echo "alpha_diversity:metrics shannon,simpson,PD_whole_tree,chao1,observed_species" > alpha_params.txt'>>script_adv.sh
echo -e "alpha_rarefaction.py -i otu_table_fil.biom -p alpha_params.txt -m mapping.txt -o alpha_rarefac -v -t phylogeny.tre\n">>script_adv.sh


echo -e "#-------------Calculate Beta div and generate plots ---------">>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Calculating Beta diversity and plots"'>>script_adv.sh
echo 'echo "beta_diversity:metrics  bray_curtis,unweighted_unifrac,weighted_unifrac" > beta_params.txt'>>script_adv.sh
echo -e "beta_diversity_through_plots.py -i otu_table_fil.biom -m mapping.txt -p beta_params.txt -o beta_div -v -t phylogeny.tre">>script_adv.sh
echo '# calculate beta div values for given three matrices : bray_curtis,unweighted_unifrac,weighted_unifrac'>>script_adv.sh
echo -e "beta_diversity.py -i otu_table_fil.biom -m bray_curtis,unweighted_unifrac,weighted_unifrac -o beta_div_matrices -t phylogeny.tre">>script_adv.sh

echo '# Draw emperor plots'>>script_adv.sh
echo -e "make_emperor.py -i beta_div/bray_curtis_pc.txt -m mapping.txt -o beta_div/emperor_bray">>script_adv.sh
echo -e "make_emperor.py -i beta_div/weighted_unifrac_pc.txt -m mapping.txt -o beta_div/emperor_unif_wei">>script_adv.sh
echo -e "make_emperor.py -i beta_div/unweighted_unifrac_pc.txt -m mapping.txt -o beta_div/emperor_unif_unw">>script_adv.sh

echo -e "\n#------------- Generate UPGMA tree ---------------------------">>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Generating UPGMA trees"'>>script_adv.sh
echo -e "upgma_cluster.py -i beta_div/unweighted_unifrac_dm.txt -o beta_div/beta_div_unw.tre">>script_adv.sh
echo -e "upgma_cluster.py -i beta_div/weighted_unifrac_dm.txt -o beta_div/beta_div_w.tre">>script_adv.sh
echo -e "upgma_cluster.py -i beta_div/bray_curtis_dm.txt -o beta_div/beta_div_bray.tre">>script_adv.sh




