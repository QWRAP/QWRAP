R CMD BATCH --no-save --no-restore '--args normalized_otu.txt filter_heatmap/normalized_otu_top10.txt 10' `which filter_otu.R` filter_otu.Rout
R CMD BATCH --no-save --no-restore '--args normalized_otu.txt filter_heatmap/normalized_otu_top25.txt 25' `which filter_otu.R` filter_otu.Rout
R CMD BATCH --no-save --no-restore '--args normalized_otu.txt filter_heatmap/normalized_otu_top50.txt 50' `which filter_otu.R` filter_otu.Rout
R CMD BATCH --no-save --no-restore '--args normalized_otu.txt filter_heatmap/normalized_otu_top100.txt 100' `which filter_otu.R` filter_otu.Rout
rm filter_otu.Rout
rm .RData
