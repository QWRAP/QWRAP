#-------------------------------------------------------------------------
# Name - microbiome_workflow2.sh
# Desc - Create QIIME Script for OTU alignment, phylogeny, Alpha div, Beta div, UPGMA tree, Jacknifing.
# Author - Ranjit Kumar (ranjit58@gmail.com)
# University of Alabama at Birmingham
#-------------------------------------------------------------------------

#Usage : microbiome_workflow2.sh EVEN_SAMPLE_DEPTH
# if a sampling depth is not provided in command line the minimum sample depth is calculated.

#---- Reading the command line arguments --------
EVEN_SAMPLE_DEPTH=$1
#------------------------------------------------

echo -e "\n#---------------------Align/filter/tree-------------------">script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Sequece Alignment"'>>script_adv.sh
echo 'align_seqs.py -i seqs.fna_rep_set.fasta -v'>>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Filtering Sequece Alignment"'>>script_adv.sh
echo 'filter_alignment.py -i pynast_aligned/seqs.fna_rep_set_aligned.fasta -v -o filtered_alignment'>>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Making Phylogenetic tree"'>>script_adv.sh
echo 'make_phylogeny.py -i filtered_alignment/seqs.fna_rep_set_aligned_pfiltered.fasta -v -o phylogeny.tre'>>script_adv.sh
echo -e "">>script_adv.sh

echo -e "#-------Use even sampling depth and rareify OTU table-------">>script_adv.sh
echo '#create a rarified OTU table from even sampling septh provided in commandline. If it is not provided, the minimum sampling depth is calcualted from file \"otu_table.stats\"'>>script_adv.sh

if [ "$EVEN_SAMPLE_DEPTH" = '' ]
then
  EVEN=$(cat otu_table.stats |head -8|tail -1|cut -d : -f 2|cut -d . -f 1| cut -d ' ' -f 2)
else
  EVEN=$EVEN_SAMPLE_DEPTH
fi
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Rarefaction of OTU tables"'>>script_adv.sh

echo -e "single_rarefaction.py -i otu_table.biom -o otu_table_even.biom -d $EVEN\n">>script_adv.sh


echo -e "#------------- Calculate alpha div and generate plots -------">>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Calculating Alpha diversity and plots"'>>script_adv.sh
echo '# Calculate the alpha div for given matrices : chao1,observed_species,PD_whole_tree,shannon,simpson'>>script_adv.sh
echo -e "alpha_diversity.py -i otu_table_even.biom -o alpha_div.txt -m chao1,observed_species,PD_whole_tree,shannon,simpson -t phylogeny.tre">>script_adv.sh
echo "# Creates a parameters files and run alpha diversity through plots">>script_adv.sh
echo 'echo "alpha_diversity:metrics shannon,simpson,PD_whole_tree,chao1,observed_species" > alpha_params.txt'>>script_adv.sh
echo -e "alpha_rarefaction.py -i otu_table_even.biom -p alpha_params.txt -m mapping.txt -o alpha_rarefac -v -t phylogeny.tre\n">>script_adv.sh


echo -e "#-------------Calculate Beta div and generate plots ---------">>script_adv.sh
echo -e 'echo "Time: `date`"' >>script_adv.sh
echo -e 'echo "Running: Calculating Beta diversity and plots"'>>script_adv.sh
echo 'echo "beta_diversity:metrics  bray_curtis,unweighted_unifrac,weighted_unifrac" > beta_params.txt'>>script_adv.sh
echo -e "beta_diversity_through_plots.py -i otu_table_even.biom -m mapping.txt -p beta_params.txt -o beta_div -v -t phylogeny.tre">>script_adv.sh
echo '# calculate beta div values for given three matrices : bray_curtis,unweighted_unifrac,weighted_unifrac'>>script_adv.sh
echo -e "beta_diversity.py -i otu_table_even.biom -m bray_curtis,unweighted_unifrac,weighted_unifrac -o beta_div_matrices -t phylogeny.tre">>script_adv.sh
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

echo -e "\n#---------------------Jack Knife-------------------------------">>script_adv.sh
echo -e '#echo "Time: `date`"' >>script_adv.sh
echo -e '#echo "Running: Jack Knifing"'>>script_adv.sh
echo "#for jacknife the value for -e should be 75% of $EVEN">>script_adv.sh
let EVEN_JACK=$EVEN*75/100
echo -e "#jackknifed_beta_diversity.py -i otu_table.txt -m mapping.txt -o beta_jacknife -e $EVEN_JACK -t phylogeny.tre\n">>script_adv.sh



