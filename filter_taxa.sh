R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L2.txt filter_heatmap/otu_table_L2_top10.txt 10' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L2.txt filter_heatmap/otu_table_L2_top25.txt 25' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L2.txt filter_heatmap/otu_table_L2_top50.txt 50' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L3.txt filter_heatmap/otu_table_L3_top10.txt 10' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L3.txt filter_heatmap/otu_table_L3_top25.txt 25' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L3.txt filter_heatmap/otu_table_L3_top50.txt 50' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L4.txt filter_heatmap/otu_table_L4_top10.txt 10' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L4.txt filter_heatmap/otu_table_L4_top25.txt 25' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L4.txt filter_heatmap/otu_table_L4_top50.txt 50' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L5.txt filter_heatmap/otu_table_L5_top10.txt 10' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L5.txt filter_heatmap/otu_table_L5_top25.txt 25' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L5.txt filter_heatmap/otu_table_L5_top50.txt 50' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L6.txt filter_heatmap/otu_table_L6_top10.txt 10' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L6.txt filter_heatmap/otu_table_L6_top25.txt 25' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L6.txt filter_heatmap/otu_table_L6_top50.txt 50' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L7.txt filter_heatmap/otu_table_L7_top10.txt 10' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L7.txt filter_heatmap/otu_table_L7_top25.txt 25' `which filter_taxa.R` filter_taxa.Rout
R CMD BATCH --no-save --no-restore '--args taxa_summary/otu_table_L7.txt filter_heatmap/otu_table_L7_top50.txt 50' `which filter_taxa.R` filter_taxa.Rout
rm filter_taxa.Rout
rm .RData
