#-------------------------------------------------------------------------
# Name - report_mirobiome.sh
# Desc - Generates a webpage containing links for all the analysis and some explanation
# Author - Ranjit Kumar (ranjit58@gmail.com)
# University of Alabama at Birmingham
#-------------------------------------------------------------------------



echo -e "\nCreating directory report_files for storing HTML report specific files in the current directory ...";
mkdir report_files
cp `which report_microbiome.sh | sed -e 's/report_microbiome.sh//g'`/oinw.gif report_files/

#----------Start:Report Overview-------------------#
cat <<EOF >microbiome_report.html
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<!-- saved from url=(0105)microbiome_report.html -->
  <meta http-equiv="Content-Type"
 content="text/html; charset=ISO-8859-1">
  <title>microbiome_results
</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;">&nbsp;
</span>
<h1
 style="text-align: center; font-weight: normal; margin-left: 40px; color: white; background-color: rgb(102, 102, 102); font-family: Verdana;"><a
 name="Index"></a>Microbiome Analysis Results
EOF

#echo `pwd | perl -pe 's/^.*\//(/g' | perl -pe 's/_analysis/)/g'` >>microbiome_report.html

cat <<EOF >>microbiome_report.html
</h1>
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;">
  <h2><span style="font-weight: normal; color: rgb(153, 0, 0);">Results</span></h2>
  
  <ol>
  <li>
  <p><a  href="report_files/initial_overview.html">Initial
   Sequence Overview</a></p>
  </li>

  <li>
    <p><a  href="report_files/quality_control.html">Quality
Control</a></p>
  </li>
  <li>
    <p><a  href="report_files/sample_mapping.html">Mapping file and Analysis workflow</a></p>
  </li>
<li>
    <p><a  href="report_files/results_otu.html">Results: OTU tables (Normalized and Filtered)</a></p>
  </li>

  <li>
    <p><a  href="report_files/summarize_taxonomy.html">Summarize
OTUs by Taxonomic distrubution</a> </p>
  </li>
  <li>
    <p><a  href="report_files/alpha_diversity.html">Diversity
within a sample (Alpha Diversity)</a></p>
  </li>
  <li>
    <p><a  href="report_files/beta_diversity.html">Diversity
between samples (Beta Diversity)</a></p>
  </li>
  <li>
    <p><a href="report_files/advance_analysis.html">Further
advanced analysis and statistical tests</a></p>
  </li>
<li>
    <p><a  href="report_files/results_otu_org.html"> Original OTU tables and files </a></p>
  </li>
  <li>
    <p><a  href="report_files/references_faqs.html">References
and FAQs</a></p>
  </li>
</ol>
</div>
<ol
 style="margin-left: 40px; background-color: white; font-family: Verdana;">
</ol>
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;">
<img style="width: 14px; height: 13px;" alt="" src="report_files/oinw.gif">
This
will open the webpage or graphs in a new browser tab/window<br>
</div>
<br style="font-family: Verdana;">
<br style="font-family: Verdana;">
</body>
</html>
EOF
#----------End:Report Overview-------------------#



#----------Start:Initial Sequencing Overview-------------------#

cat <<EOF >report_files/initial_overview.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Initial Overview</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"><a href ="../microbiome_report.html" >Home</a> -&gt; Initial Sequence Overview<br><br></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Samples_and_sequencing_overview"></a> &nbsp;
Initial Sequence Overview</h2>
      </td>
    </tr>
  </tbody>
</table>
<span style="color: black;">
This
section describes the&nbsp;samples and their sequencing statistics
as they come from the sequencing machines. <br>
<br>
<h3> FASTQ READS </h3>
The table below&nbsp;shows the number of
samples,&nbsp;sequences per
sample and&nbsp;their initial quality statistics.<br><br>
</span>

EOF

if [ -e fastqc_rawdata/qcstats.txt ]; then
echo -e '<table style="text-align: left; width: 900px; height: 61px;margin-left: 60px;" border="1" cellpadding="2" cellspacing="1">'>>report_files/initial_overview.html
echo -e "<thead><tr><th>Count</th><th>Sample Name</th><th>Sequences </th><th>Read Length </th> <th>GC Content </th><th> FastQC Plots</th></tr> </thead><tbody>">>report_files/initial_overview.html
COUNT=1;

while read line
do
	arrIN=(${line/// })
fastqclink=${arrIN[0]/.fastq.gz/}
echo "<tr><td>${COUNT}</td><td>${arrIN[0]}</td><td>${arrIN[1]}</td><td>${arrIN[2]}</td><td>${arrIN[3]}</td><td><a href=\"../fastqc_rawdata/${fastqclink}_fastqc/fastqc_report.html\" target=\"_blank\">FASTQC</a><img style=\"width: 14px; height: 13px;\" alt=\"\" src=\"oinw.gif\"></tr>">>report_files/initial_overview.html
COUNT=$(($COUNT + 1 ));
done <fastqc_rawdata/qcstats.txt

echo "</tbody></table>">>report_files/initial_overview.html
fi
if [ -e fastqc_rawdata/qcstats.txt ]; then
cat <<EOF >>report_files/initial_overview.html

<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="../fastqc_rawdata/FASTQCplot.png"><br>
<br>
Dowload the raw dataset (tab delimited format, right click -> save link as)<br>
<ol>
  <li>
	<a href="../fastqc_rawdata/qcstats.txt" target="_blank">Sample stats file</a>
  </li>
  <li>
	<a href="../fastqc_rawdata/qcplot.txt" target="_blank">Per base sequence quality file</a>
</li>
</ol>
<br>
EOF
fi

if [ -e fastqc_beforeqcf/qcstats.txt ]; then
echo -e '<table style="text-align: left; width: 900px; height: 61px;margin-left: 60px;" border="1" cellpadding="2" cellspacing="1">'>>report_files/initial_overview.html
echo -e "<thead><tr><th>Count</th><th>Sample Name</th><th>Sequences </th><th>Read Length </th> <th>GC Content </th><th> FastQC Plots</th></tr> </thead><tbody>">>report_files/initial_overview.html
COUNT=1;

while read line
do
        arrIN=(${line/// })
fastqclink=${arrIN[0]/.fastq.gz/}
echo "<tr><td>${COUNT}</td><td>${arrIN[0]}</td><td>${arrIN[1]}</td><td>${arrIN[2]}</td><td>${arrIN[3]}</td><td><a href=\"../fastqc_beforeqcf/${fastqclink}_fastqc/fastqc_report.html\" target=\"_blank\">FASTQC</a><img style=\"width: 14px; height: 13px;\" alt=\"\" src=\"oinw.gif\"></tr>">>report_files/initial_overview.html
COUNT=$(($COUNT + 1 ));
done <fastqc_beforeqcf/qcstats.txt

echo "</tbody></table>">>report_files/initial_overview.html
fi
if [ -e fastqc_beforeqcf/qcstats.txt ]; then
cat <<EOF >>report_files/initial_overview.html

<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="../fastqc_beforeqcf/FASTQCplot.png"><br>
<br>
Dowload the raw dataset (tab delimited format, right click -> save link as)<br>
<ol>
  <li>
        <a href="../fastqc_beforeqcf/qcstats.txt" target="_blank">Sample stats file</a>
  </li>
  <li>
        <a href="../fastqc_beforeqcf/qcplot.txt" target="_blank">Per base sequence quality file</a>
</li>
</ol>
<br>
EOF
fi

if [ -d fastqc_beforeqcr ]; then

cat <<EOF >>report_files/initial_overview.html
<span style="color: black;">
<h3> REV READS </h3>
The table below&nbsp;shows the number of
samples,&nbsp;sequences per
sample and&nbsp;their initial quality statistics.<br><br>
</span>

EOF

if [ -e fastqc_beforeqcr/qcstats.txt ]; then
echo -e '<table style="text-align: left; width: 900px; height: 61px;margin-left: 60px;" border="1" cellpadding="2" cellspacing="1">'>>report_files/initial_overview.html
echo -e "<thead><tr><th>Count</th><th>Sample Name</th><th>Sequences </th><th>Read Length </th> <th>GC Content </th><th> FastQC Plots</th></tr> </thead><tbody>">>report_files/initial_overview.html
COUNT=1;

while read line
do
        arrIN=(${line/// })
fastqclink=${arrIN[0]/.fastq.gz/}
echo "<tr><td>${COUNT}</td><td>${arrIN[0]}</td><td>${arrIN[1]}</td><td>${arrIN[2]}</td><td>${arrIN[3]}</td><td><a href=\"../fastqc_beforeqcr/${fastqclink}_fastqc/fastqc_report.html\" target=\"_blank\">FASTQC</a><img style=\"width: 14px; height: 13px;\" alt=\"\" src=\"oinw.gif\"></tr>">>report_files/initial_overview.html
COUNT=$(($COUNT + 1 ));
done <fastqc_beforeqcr/qcstats.txt

echo "</tbody></table>">>report_files/initial_overview.html
fi
cat <<EOF >>report_files/initial_overview.html

<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="../fastqc_beforeqcr/FASTQCplot.png"><br>
<br>
Dowload the raw dataset (tab delimited format, right click -> save link as)<br>
<ol>
  <li>
        <a href="../fastqc_beforeqcr/qcstats.txt" target="_blank">Sample stats file</a>
  </li>
  <li>
        <a href="../fastqc_beforeqcr/qcplot.txt" target="_blank">Per base sequence quality file</a>
</li>
</ol>
<br>
EOF
fi

echo "</div>">>report_files/initial_overview.html


#----------Ends:Initial Overview------------------------------#


#----------Start:Quality Control------------------------------#

cat <<EOF >report_files/quality_control.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Quality Control</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"><a href ="../microbiome_report.html" >Home</a> -&gt; Quality Control<br><br></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Quality_Control"></a> &nbsp;
Quality Control</h2>
      </td>
    </tr>
  </tbody>
</table>
After Applying the QC steps, the table below shows the number of samples, sequences per
sample and their quality statistics.
</span><br><br>
EOF

if [ -e fastqc_filterdata/qcstats.txt ]; then
echo -e '<table style="text-align: left; width: 900px; height: 61px;margin-left: 60px;" border="1" cellpadding="2" cellspacing="1">'>>report_files/quality_control.html
echo -e "<thead><tr><th>Count</th><th>Sample Name</th><th>Sequences </th><th>Read Length </th> <th>GC Content </th><th> FastQC Plots</th></tr> </thead><tbody>">>report_files/quality_control.html
COUNT=1;
while read line
do
        arrIN=(${line/// })
fastqclink=${arrIN[0]/.fastq/}
echo -e "<tr><td>${COUNT}</td><td>${arrIN[0]}</td><td>${arrIN[1]}</td><td>${arrIN[2]}</td><td>${arrIN[3]}</td><td><a href=\"../fastqc_filterdata/${fastqclink}_fastqc/fastqc_report.html\" target=\"_blank\">FASTQC</a><img style=\"width: 14px; height: 13px;\" alt=\"\" src=\"oinw.gif\"></tr>">>report_files/quality_control.html
COUNT=$(($COUNT + 1 ));
done <fastqc_filterdata/qcstats.txt
echo "</tbody></table>">>report_files/quality_control.html
fi
cat <<EOF >>report_files/quality_control.html

<br>
<br>
<br>

The individual quality plots from all samples are combined below to
provide a overview merged quality plot. The plot shows the mean Qscore vs base position for all samples.<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="../fastqc_filterdata/FASTQCplot.png"><br>
<br>
Dowload the raw dataset after applying QC measures (tab delimited format, right click -> save link as)<br>
<ol>
  <li>
        <a href="../fastqc_filterdata/qcstats.txt" target="_blank">Sample stats file</a>
  </li>
  <li>
        <a href="../fastqc_filterdata/qcplot.txt" target="_blank">Per base sequence quality file</a>
</li>
</ol>
<br>

EOF
#----------End:Quality Control------------------------------#

#----------Start:Sample selected and mapping file ------------------------------#

cat <<EOF >report_files/sample_mapping.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Sample selected and mapping information</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"><a href ="../microbiome_report.html" >Home</a> -&gt; Mapping file and Analysis workflow<br><br></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Sample selected for analysis and mapping information"></a> &nbsp; Mapping file and Analysis workflow</h2>
      </td>
    </tr>
  </tbody>
</table>
<span style="color: black;">This section describes the sample mapping information (sample attributes). </span><br
 style="color: black;">
<br style="color: black;">
EOF
cat <<EOF >>report_files/sample_mapping.html

<span style="color: black;"><b>-------------Mapping file</b></span>


EOF

echo -e "-----------------------------------------------</br>">>report_files/sample_mapping.html
if [ -e mapping.txt ]; then
while read line
do
echo -e "$line<br>">>report_files/sample_mapping.html
done <mapping.txt
fi
echo -e "----------------------------------------------------------------------------------</br>">>report_files/sample_mapping.html

cat <<EOF >>report_files/sample_mapping.html

<br></br><br></br>
<b> Data analysis workflow</b>
<br><br>
The data analysis workflow is going to generate two set of results. 
<br>First set is the original OTU tables and other files on which no rarefaction (sample size normalization) and no rare OTU filtering was applied. All the files and folder generated in this step has suffix "_org" (original). This was used to generate taxonomy charts. This step is performed by script "script.sh". It includes the following steps
<ul><li>Chimera Filtering using program "Usearch".</li>
<li>OTU Clustering at 97% sequence similarity using program "uclust".</li>
<li>Picking representative of OTUs based on abundance.</li>
<li>Assigning taxonomy to OTUs using RDP classifier (threshold 0.8) using Greengenes database.</li>
<li>Sorting OTU table based on file "sample_order.txt".</li>
<li>Summarizing OTUs into taxonomic groups.</li>
<li>Creating Normalized OTU table i.e. converting raw numbers from OTU table into proportion and also merging the taxa information in a single file.</li>
<li>A filtered list of top 10, top 25 and top 100 OTUs and taxa are generated.</li>
</ul>
<br>
Second set might appeal to most users. Here the OTU table is rarified to user supplied sample depth (or minimum sample depth present across the samples). The OTUs are then filtered which had average abundance <0.0005%. This generated a new filtered OTU table. All files and folder generated at this step has suffix "_fil". This was used to generate taxonomy bar charts, OTU Multiple Sequence Alignment, phylogenetic tree, alpha diversity, beta diversity etc. This step is achieved by script "script_adv.sh". It includes the following steps
<ul>
<li>The OTU table is rarified to user specified (or minimum) sample size.</li>
<li>Rare OTUs are filtered at abundance level < 0.0005%.</li>
<li>Summarizing OTUs into taxonomic groups.</li>
<li>Creating Normalized OTU table i.e. converting raw numbers from OTU table into proportion and also merging the taxa information in a single file.</li>
<li>A filtered list of top 10, top 25 and top 100 OTUs and taxa are generated.</li>
<li>Generates a multiple sequence alignment ofOTUs using the program "PYNAST" and creates a phylogenetic tree using the program "FASTTREE"</li>
<li>Calculates alpha diversity (using chao1, observed species, PD whole tree, shannon, and simpson diversity indices) and generates plots.</li>
<li>Calculates beta diversity (using bray curtis, unweighted unifrac, and weighted
unifrac distances) and generates plots.</li>
<li>Generates a UPGMA tree of all samples.</li>
</ul>
</br>
In the report the results based on normalized and filtered data is reported (steps 4-7). The unfiltered data and results are reported in (Step 9 - "Original OTU tables and files") only.
</br></br></br>
Dowload the raw files (tab delimited format, right click -> save link as)<br>
<ol>
  <li>
        <a href="../mapping.txt" target="_blank">Mapping File</a>
</li>
</ol>
EOF

#----------Ends:Sample selected and mapping file ------------------------------#



#----------Start:Results: OTU tables (Normalized and Filtered)---#
cat <<EOF >report_files/results_otu.html
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Results: OTU tables (Normalized and Filtered)</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"><a href ="../microbiome_report.html" >Home</a> -&gt; Results: OTU tables (Normalized and Filtered)
<br><br></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;">&nbsp;
Results: OTU tables (Normalized and Filtered)</h2>
      </td>
    </tr>
  </tbody>
</table>
<span style="color: black;">The term OTU stands for
Operational Taxonomic Unit. Traditionally, In 16S sequencing using 454
technology (produces&nbsp;reads of length 200 ~ 500 bases)&nbsp;
the reads which are very similar in sequence (~97%) are clustered
together and the most abundunt sequence of the cluster is selected and
called OTU. This OTU sequence and the abundance information proceeds
futher in the analysis. It is assumed that at if full length 16S
sequences are clustered with 97% identity, the resulting clusters
(OTUs) may be the representative of species. This will help us to merge
strain level differences and also take care of very small
errors&nbsp;associated with sequencing technology.<br>
<br>
Sometime, when we are dealing with short Illumina sequences, we may choose to cluster it at higher percentage like 99%, or 100%. Taxomonic
identification of these&nbsp;OTU sequences were done using RDP classifier
against <a
 href="http://qiime.org/home_static/dataFiles.html"
 target="_blank">Greengenes 16S databases</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif">.<br>
<br>

Briefly, the filtered sequences are clustered (97% identity) and then OTU tables are generated. Since OTU tables have different sample depth, it was rarified at a minimum (or user specified) sample depth. The OTU table is filtered where OTU abundunce < 0.0005%. The final filtered OTU table is used to generate Taxonomy charts and to calculate Aplha and Beta diversity.<br><br>
<span style="font-weight: bold; color: rgb(153, 0, 0);">Download
the raw dataset</span> (tab delimited text format)<br>
</span>
<ol>

<li><a href="../otu_table_fil.stats.txt"
 target="_blank">Sequence Stats</a> - This file has sequence statistics used in the analysis. The file can be opened in any text editer (Notepad)</li>

  <li><a href="../otu_table_fil.txt" target="_blank">OTU table</a>
- This file has the&nbsp;list of all OTUs identified in the current
analysis. It also include the raw count of reads for each OTU in 
each sample. Each OTU has the taxonomic information identified.
This file is also present in <a
 href="../otu_table_fil.biom" target="_blank">.biom format</a>.</li>
  <li><a href="../seqs.fna_rep_set_fil.fasta"
 target="_blank">OTU
fasta sequence</a> - This file has list of all OTU
sequences present in the OTU table.</li>
 <li><a href="../pynast_aligned/seqs.fna_rep_set_fil_aligned.fasta" target="_blank">OTU
Multiple sequence alignment</a> - The MSA was generated using PYNAST. Later the MSA was filtered to remove common gaps generateing a <a href="../filtered_alignment/seqs.fna_rep_set_fil_aligned_pfiltered.fasta" target="_blank">filtered alignment file.</a> </li>

<li><a href="../phylogeny.tre" target="_blank">OTU
phylogenetic tree</a> - The phylogenetic tree of all OTUs.</li>
</ol>
<br><br>
<span style="font-weight: bold; color: rgb(153, 0, 0);">Download
in-house processed dataset </span> (tab delimited text format)<br>
</span>
<ol>
<li><a href="../normalized_otu_fil.txt"> OTU table (Normalized)</a> - The OTU table present above
is normalised (converted into proportion) and the actual 16S sequence 
is also mapped into it.</li>
<li>Filtered OTU table (Normalized) - The normalized OTU table present above is filtered to select the top/most abundunt OTUs</li>
<ul>
<li><a href="../top_otu_taxa_fil/normalized_otu_top10.txt"> Top10 OTU</a> </li>
<li><a href="../top_otu_taxa_fil/normalized_otu_top25.txt"> Top25 OTU</a> </li>
<li><a href="../top_otu_taxa_fil/normalized_otu_top50.txt"> Top50 OTU</a> </li>
<li><a href="../top_otu_taxa_fil/normalized_otu_top100.txt"> Top100 OTU</a> </li>

</ul>

</ol>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
</div>
</body>
</html>

EOF





#----------End:Results: OTU table,16S Sequence and Taxonomic Identification---#


#----------Start:Original OTU tables and files ---#
cat <<EOF >report_files/results_otu_org.html
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Original OTU tables and files </title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"><a href ="../microbiome_report.html" >Home</a> -&gt; Original OTU tables and files
<br><br></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;">&nbsp;
Original OTU tables and files</h2>
      </td>
    </tr>
  </tbody>
</table>
<span style="color: black;">
Here, the filtered sequences are clustered (97% identity) and then OTU tables are generated. The OTU tables have raw numbers and this is not normalized for different sample depth. This data is not filtered for rare OTUs. The OTU table is used to generate Taxonomy charts<br><br>
<span style="font-weight: bold; color: rgb(153, 0, 0);">Download
the raw dataset</span> (tab delimited text format)<br>
</span>
<ol>

<li><a href="../otu_table_org.stats.txt"
 target="_blank">Sequence Stats</a> - This file has sequence statistics used in the analysis. The file can be opened in any text editer (Notepad)</li>

  <li><a href="../otu_table_org.txt" target="_blank">OTU table</a>
- This file has the&nbsp;list of all OTUs identified in the current
analysis. It also include the raw count of reads for each OTU in
each sample. Each OTU has the taxonomic information identified.
This file is also present in <a
 href="../otu_table_org.biom" target="_blank">.biom format</a>.</li>
  <li><a href="../seqs.fna_rep_set_org.fasta"
 target="_blank">OTU
fasta sequence</a> - This file has list of all OTU
sequences present in the OTU table.</li>
</ol>
<br><br>
<span style="font-weight: bold; color: rgb(153, 0, 0);">Download
in-house processed dataset </span> (tab delimited text format)<br>
</span>
<ol>
<li><a href="../normalized_otu_org.txt"> OTU table (Normalized)</a> - The OTU table present above
is normalised (converted into proportion) and the actual 16S sequence
is also mapped into it.</li>
<li>Filtered OTU table (Normalized) - The normalized OTU table present above is filtered to select the top/most abundunt OTUs</li>
<ul>
<li><a href="../top_otu_taxa_org/normalized_otu_top10.txt"> Top10 OTU</a> </li>
<li><a href="../top_otu_taxa_org/normalized_otu_top25.txt"> Top25 OTU</a> </li>
<li><a href="../top_otu_taxa_org/normalized_otu_top50.txt"> Top50 OTU</a> </li>
<li><a href="../top_otu_taxa_org/normalized_otu_top100.txt"> Top100 OTU</a> </li>

</ul>

</ol>
<p><span style="font-weight: bold;"><span
 style="color: rgb(153, 0, 0);"></span></span></p></br>
<p><span style="font-weight: bold;"><span
 style="color: rgb(153, 0, 0);">Taxonomic
distribution plots</span> </span></p>
<p><a href="../taxa_summary_org/taxa_summary_plots/bar_charts.html"
 target="_blank">Bar Plot of Taxonomic
distribution</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></p>
<p><a
 href="../taxa_summary_org/taxa_summary_plots/area_charts.html"
 target="_blank">Area
Plot of Taxonomic
distribution</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"> &nbsp;
<br>
</p>
<br>
<br>

<span style="font-weight: bold; color: rgb(153, 0, 0);"> OTUs categorised into taxonomy and filtered data - </span> The OTU table (at various taxonomic level) is filtered here to choose the top 10/25/50 taxa based on global abundunce.(tab
delimited format, right click -&gt; save link as)<br>
<br>

<table
 style="text-align: left; background-color: rgb(246, 246, 246);"
 border="1" cellpadding="5" cellspacing="2">
  <tbody>
    <tr>
      <td style="font-weight: bold;">Original taxonomy File (Level) </td>
      <td style="font-weight: bold;">Top10 Taxa </td>
      <td style="font-weight: bold;">Top25 Taxa </td>
      <td style="font-weight: bold;">Top50 Taxa </td>
    </tr>
    <tr>
      <td><a href="../taxa_summary_org/otu_table_org_L2.txt" >OTU table Level2 (phylum) </a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L2_top10.txt">Top10</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L2_top25.txt">Top25</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L2_top50.txt">Top50</a></td>
    </tr>

    <tr>
      <td><a href="../taxa_summary_org/otu_table_org_L3.txt" >OTU table Level3 (class) </a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L3_top10.txt">Top10</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L3_top25.txt">Top25</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L3_top50.txt">Top50</a></td>
    </tr>
    <tr>
      <td><a href="../taxa_summary_org/otu_table_org_L4.txt" >OTU table Level4 (order) </a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L4_top10.txt">Top10</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L4_top25.txt">Top25</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L4_top50.txt">Top50</a></td>
    </tr>
    <tr>
      <td><a href="../taxa_summary_org/otu_table_org_L5.txt" >OTU table Level5 (family) </a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L5_top10.txt">Top10</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L5_top25.txt">Top25</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L5_top50.txt">Top50</a></td>
    </tr>
    <tr>
      <td><a href="../taxa_summary_org/otu_table_org_L6.txt" >OTU table Level6 (genus) </a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L6_top10.txt">Top10</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L6_top25.txt">Top25</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L6_top50.txt">Top50</a></td>
    </tr>
    <tr>
      <td><a href="../taxa_summary_org/otu_table_org_L7.txt" >OTU table Level7 (species) </a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L7_top10.txt">Top10</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L7_top25.txt">Top25</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_org/otu_table_L7_top50.txt">Top50</a></td>
    </tr>
</tbody>
</table>
<br>
<br>
<br>
<br>

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
</div>
</body>
</html>

EOF

#end - Original OTU tables and files 

#----------Start:Summarize taxonomy ------------------------------#

cat <<EOF >report_files/summarize_taxonomy.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Summarize OTUs by Taxonomic distrubution</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"><a href ="../microbiome_report.html" >Home</a> -&gt; Results: OTU table, 16S Sequence and Taxonomic Identification
<br><br></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Summarize OTUs by Taxonomic distrubution"></a> &nbsp; Summarize taxonomies by Taxonomic distrubution</h2>
      </td>
    </tr>
  </tbody>
</table>

Summarize
Communities by Taxonomic Composition : Here the&nbsp;OTUs having
similar taxonomic composition are grouped together for all samples
and the results are presented as bar chart and area chart. The charts
are presented at different taxonomic levels like kingdom, phylum,
class, order, family.</p>
<p>Inside the plots, use mouse to view the taxonomic composition
of microbiome.&nbsp;</p>
<p>The identification like ">Root;k__Bacteria;p__Actinobacteria;c__Actinobacteria;o__Rubrobacterales;f__Rubrobacteraceae" means that it belongs to knigdom - bacteria, phylum - Actinobacteria,
class - Actinobacteria, order - Rubrobacterales and family -
Rubrobacteraceae.</span></p>
<p><span style="font-weight: bold;"><span
 style="color: rgb(153, 0, 0);"></span></span></p></br>
<p><span style="font-weight: bold;"><span
 style="color: rgb(153, 0, 0);">Taxonomic
distribution plots</span> </span></p>
<p><a href="../taxa_summary_fil/taxa_summary_plots/bar_charts.html"
 target="_blank">Bar Plot of Taxonomic
distribution</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></p>
<p><a
 href="../taxa_summary_fil/taxa_summary_plots/area_charts.html"
 target="_blank">Area
Plot of Taxonomic
distribution</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"> &nbsp;
<br>
</p>
<br>
<br>

<span style="font-weight: bold; color: rgb(153, 0, 0);"> OTUs categorised into taxonomy and filtered data - </span> The OTU table (at various taxonomic level) is filtered here to choose the top 10/25/50 taxa based on global abundunce.(tab
delimited format, right click -&gt; save link as)<br>
<br>

<table
 style="text-align: left; background-color: rgb(246, 246, 246);"
 border="1" cellpadding="5" cellspacing="2">
  <tbody>
    <tr>
      <td style="font-weight: bold;">Original taxonomy File (Level) </td>
      <td style="font-weight: bold;">Top10 Taxa </td>
      <td style="font-weight: bold;">Top25 Taxa </td>
      <td style="font-weight: bold;">Top50 Taxa </td>
    </tr>
    <tr>
      <td><a href="../taxa_summary_fil/otu_table_fil_L2.txt" >OTU table Level2 (phylum) </a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L2_top10.txt">Top10</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L2_top25.txt">Top25</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L2_top50.txt">Top50</a></td>
    </tr>

    <tr>
      <td><a href="../taxa_summary_fil/otu_table_fil_L3.txt" >OTU table Level3 (class) </a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L3_top10.txt">Top10</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L3_top25.txt">Top25</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L3_top50.txt">Top50</a></td>
    </tr>
    <tr>
      <td><a href="../taxa_summary_fil/otu_table_fil_L4.txt" >OTU table Level4 (order) </a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L4_top10.txt">Top10</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L4_top25.txt">Top25</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L4_top50.txt">Top50</a></td>
    </tr>
    <tr>
      <td><a href="../taxa_summary_fil/otu_table_fil_L5.txt" >OTU table Level5 (family) </a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L5_top10.txt">Top10</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L5_top25.txt">Top25</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L5_top50.txt">Top50</a></td>
    </tr>
    <tr>
      <td><a href="../taxa_summary_fil/otu_table_fil_L6.txt" >OTU table Level6 (genus) </a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L6_top10.txt">Top10</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L6_top25.txt">Top25</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L6_top50.txt">Top50</a></td>
    </tr>
    <tr>
      <td><a href="../taxa_summary_fil/otu_table_fil_L7.txt" >OTU table Level7 (species) </a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L7_top10.txt">Top10</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L7_top25.txt">Top25</a></td>
      <td>&nbsp;&nbsp;&nbsp;<a href="../top_otu_taxa_fil/otu_table_L7_top50.txt">Top50</a></td>
    </tr>



</tbody>
</table>
<br>
<br>
<br>
<br>



</div>
EOF
#----------End:Summarize taxonomy ------------------------------#

#----------Start:Summarize taxonomy (trimmed version) ------------------------------#

cat <<EOF >report_files/summarize_taxonomy_trimmed.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Summarize OTUs by Taxonomic distrubution (filtered)</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"><a href ="../microbiome_report.html" >Home</a> -&gt; Results: OTU table, 16S Sequence and Taxonomic Identification
<br><br></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Summarize OTUs by Taxonomic distrubution (filtered)"></a> &nbsp; Summarize taxonomies by Taxonomic distrubution (filtered)</h2>
      </td>
    </tr>
  </tbody>
</table>
This taxonomic distribution is trimmed version of original taxonomic distribution. Here, any taxonomic categories which has abundunce < 0.1% (in all samples) has been trimmed off (to filter very rare taxons).</br></br>
Summarize
Communities by Taxonomic Composition : Here the&nbsp;OTUs having
similar taxonomic composition are grouped together for all samples
and the results are presented as bar chart and area chart. The charts
are presented at different taxonomic levels like kingdom, phylum,
class, order, family.</p>
<p>Inside the plots, use mouse to view the taxonomic composition
of microbiome.&nbsp;</p>
<p>The identification like ">Root;k__Bacteria;p__Actinobacteria;c__Actinobacteria;o__Rubrobacterales;f__Rubrobacteraceae" means that it belongs to knigdom - bacteria, phylum - Actinobacteria,
class - Actinobacteria, order - Rubrobacterales and family -
Rubrobacteraceae.</span></p>
<p><span style="font-weight: bold;"><span
 style="color: rgb(153, 0, 0);"></span></span></p></br>
<p><span style="font-weight: bold;"><span
 style="color: rgb(153, 0, 0);">Taxonomic
distribution plots</span> </span></p>
<p><a href="../taxa_summary_trim/taxa_summary_plots/bar_charts.html"
 target="_blank">Bar Plot of Taxonomic
distribution</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></p>
<p><a
 href="../taxa_summary_trim/taxa_summary_plots/area_charts.html"
 target="_blank">Area
Plot of Taxonomic
distribution</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"> &nbsp;

<br>
</p>
<br>
<br>
<span style="font-weight: bold; color: rgb(153, 0, 0);">Dowload
the raw dataset
used for generating Taxonomy plots</span> (tab
delimited format, right click -&gt; save link as)<br>
<ol>
  <li> <a href="../taxa_summary_trim/otu_table_L2.txt" target="_blank">OTU table Level2 (phylum)</a> </li>
  <li> <a href="../taxa_summary_trim/otu_table_L3.txt" target="_blank">OTU table Level3 (class)</a> </li>
  <li> <a href="../taxa_summary_trim/otu_table_L4.txt" target="_blank">OTU table Level4 (order)</a> </li>
  <li> <a href="../taxa_summary_trim/otu_table_L5.txt" target="_blank">OTU table Level5 (family)</a> </li>
  <li> <a href="../taxa_summary_trim/otu_table_L6.txt" target="_blank">OTU table Level6 (genus)</a> </li>
  <li> <a href="../taxa_summary_trim/otu_table_L7.txt" target="_blank">OTU table Level7 (species)</a> </li>
</ol>
</div>
EOF
#----------End:Summarize taxonomy (trimmed) ------------------------------#
 



#----------Start:Alpha diversity--------------------------------#

cat <<EOF >report_files/alpha_diversity.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Diversity within a sample (Alpha Diversity)</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"><a href ="../microbiome_report.html" >Home</a> -&gt; Diversity within a sample (Alpha Diversity) <br><br></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Diversity within a sample (Alpha Diversity)"></a> &nbsp; Diversity within a sample (Alpha Diversity)</h2>
      </td>
    </tr>
  </tbody>
</table>

<span style="font-weight: bold; color: rgb(153, 0, 0);">Alpha
diversity</span> is used to
measure the diversity within a sample. Here we have implemented five
commonly used matrices to measure the diversity.They are<br>
<ol>
  <li>Observed_species (measure richness only)</li>
  <li>Chao1</li>
  <li>Shannon</li>
  <li>Simpson</li>
  <li>PD_whole_tree (include phylogeny).</li>
</ol>
Alpha divesity was calculated for all diversity matrices mentioned above and organised in form of a table (column represent different diversity matrice and rows represent sample name).</br></br>
<b> <a href="../alpha_div.txt">Download</a></b> the alpha diversity calculations. [The file is tab delimited and can be viewed in
excel]<br>
<br><br><br>
<span style="font-weight: bold; color: rgb(153, 0, 0);">Rarefaction
curve</span>
- Rarefaction curves plot the number of individuals sampled versus the
number of species. They're used to determine species diversity (# of
species in a community) and species richness (# of species in a given
area). When the curve starts to level off, you can assume you've
reached the approximate number of different species. Here a random
sample is genereated (without replacement) with 10% , 20%, 30% to 100%
sequences and alpha diversity is calculated for each random sample.When
the curve starts to level off, you can assume you've reached the
approximate number of different species.<br>
<br>
This rarefaction curve is dynamic in nature, please select a metric
type and category to view the results.<br>
<br>
<a
 href="../alpha_rarefac/alpha_rarefaction_plots/rarefaction_plots.html"
 target="_blank">View the Rarefaction
curve</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></span>&nbsp;&nbsp;
</span><br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
</div>
</body>
</html>



EOF

#----------End:Alpha Diversity ------------------------------#



#----------Start:Beta Diversity--------------------------------#


cat <<EOF >report_files/beta_diversity_old.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Sample selected and mapping information</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"><a href ="../microbiome_report.html" >Home</a> -&gt; Diversity between samples (Beta Diversity)<br><br></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Diversity between samples (Beta Diversity)"></a> &nbsp; Diversity between samples (Beta Diversity)</h2>
      </td>
    </tr>
  </tbody>
</table>

<span style="color: rgb(153, 0, 0); font-weight: bold;">Beta
diversity</span>
is a term for the comparison of samples to each other. A beta diversity
metric does not calculate a value for each sample. Rather, it
calculates a distance between a pair of samples. &nbsp;If you have
many
samples (for example 3 control and 3 treatment), a beta diversity
metric will return a matrix of the distances of all samples to all
other samples. <br>
Here three different types of matrices (bray-curtis,unweighted unifrac, weighted unifrac were used to measure beta diversity.<br>
<br>
Bray-curtis is a non-phylogeny based method which takes abundance into account to calculate dissimilarity. UniFrac is a method which uses phylogenetic information among OTU sequences to calculate a distance between samples. The method can be used in
two modes.<br>
<ol>
  <li>Un-weighted (Qualitative) - It depends upon&nbsp;the
present and absence of OTUs (not actual abundane data) between samples and their phylogenetic
distances.</li>
  <li>Weighted (Qualitative) - It includes the abundance
information alongwith the presence and absence of OTUs between samples
and their phylogenetic distances.</li>
</ol>
Here principle coordinate analysis (PCoA) are used to vizualize
the distances between the sample. Here principle coordinate analysis
(PCoA) are used to vizualize
the distances between the samples in a 2D plot and 3D plot. <br>
<br>
<br>
<br>
<h3 style="font-weight: bold; text-align: center;"><span
 style="color: rgb(153, 0, 0);">PCoA (un-weighted) - 2D
Plots&nbsp;&nbsp;<a
 href="../beta_div/unweighted_unifrac_2d_continuous/unweighted_unifrac_pc_2D_PCoA_plots.html"
 target="_blank"><img
 style="border: 0px solid ; width: 36px; height: 36px;"
 alt="open_in_new_window" src="oinw.gif"></a>
</span></h3>
<iframe
 style="border: 2px solid rgb(0, 0, 0); width: 100%; height: 700px;"
 src="../beta_div/unweighted_unifrac_2d_continuous/unweighted_unifrac_pc_2D_PCoA_plots.html"
 scrolling="auto"></iframe><br>
<br>
<a
 href="../beta_div/unweighted_unifrac_3d_continuous/unweighted_unifrac_pc_3D_PCoA_plots.html"
 target="_blank">Click here</a> to view PCoA
(un-weighted)&nbsp;plot in 3D [this program need Java, so please
grant the permission if asked]<br>
<br>
<br>
<h3 style="font-weight: bold; text-align: center;"><br>
<span style="color: rgb(153, 0, 0);"></span></h3>
<h3 style="font-weight: bold; text-align: center;"><span
 style="color: rgb(153, 0, 0);">PCoA (weighted) - 2D
Plots&nbsp;&nbsp;<a
 href="../beta_div/weighted_unifrac_2d_continuous/weighted_unifrac_pc_2D_PCoA_plots.html"
 target="_blank"><img
 style="border: 0px solid ; width: 36px; height: 36px;"
 alt="open_in_new_window" src="oinw.gif"></a>
</span></h3>
<iframe
 style="border: 2px solid rgb(0, 0, 0); width: 100%; height: 700px;"
 src="../beta_div/weighted_unifrac_2d_continuous/weighted_unifrac_pc_2D_PCoA_plots.html"
 scrolling="auto"></iframe><br>
<br>
<a
 href="../beta_div/weighted_unifrac_3d_continuous/weighted_unifrac_pc_3D_PCoA_plots.html"
 target="_blank">Click here</a> to view PCoA (weighted)
plot in 3D [this program needs Java&nbsp;, so please grant the
permission if asked]<br>
<br>
<br>
<br>
<br>
</div>
EOF


cat <<EOF >report_files/beta_diversity.html
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Diversity between samples (Beta Diversity)</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"><a href ="../microbiome_report.html" >Home</a> -&gt; Diversity between samples (Beta Diversity)<br><br></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Diversity between samples (Beta Diversity)"></a>&nbsp;
Diversity between samples (Beta Diversity)</h2>
      </td>
    </tr>
  </tbody>
</table>
<span style="color: rgb(153, 0, 0); font-weight: bold;">Beta
diversity</span>
is a term for the comparison of samples to each other. A beta diversity
metric does not calculate a value for each sample. Rather, it
calculates a distance between a pair of samples. &nbsp;If you have
many
samples (for example 3 control and 3 treatment), a beta diversity
metric will return a matrix of the distances of all samples to all
other samples. <br><br>
Here three different matrices are used (bray-curtis, unweighted unifrac and weighted unnifrac) to measure
diversity.<br>
<a href ="http://www.econ.upf.edu/~michael/stanford/maeb5.pdf">Bray-curtis</a> is a non-phylogeny based method which takes abundance into account to calculate dissimilarity. <a href ="http://bmf.colorado.edu/unifrac/tutorial.psp">UniFrac</a> is a method which uses phylogenetic information among OTUs to calculate the distance between bacterial communities. The method can be used in
two modes. Un-weighted (Qualitative) unifrac depends upon&nbsp;the
present and absence of OTUs between samples and their phylogenetic
distances. Weighted (Qualitative) unifrac includes the abundance
information alongwith the presence and absence of OTUs between samples
and their phylogenetic distances.
<ol>
</ol>
Beta divesity was calculated for all three diversity matrices mentioned
above and organised in form of a matrix table.<br>
<br style="color: rgb(102, 0, 0);">
<span style="font-weight: bold; color: rgb(153, 0, 0);">Results
in tabular format</span> [The files are tab delimited and can be viewed using excel]
<span style="text-decoration: underline;"><span
 style="font-weight: bold;"></span></span><br>
<ol>
  <li><a href="../beta_div_matrices/bray_curtis_otu_table_even.txt">Bray-curtis
diversity</a></li>
  <li><a
 href="../beta_div_matrices/unweighted_unifrac_otu_table_even.txt">Unweighted
Unifrac</a></li>
  <li><a
 href="../beta_div_matrices/weighted_unifrac_otu_table_even.txt">Weighted
Unifrac</a></li>
</ol>
<br style="color: rgb(153, 0, 0);"></br></br>
<span style="font-weight: bold; color: rgb(153, 0, 0);">Principal
Coordinate analysis (PCoA)</span><br>
<br>
Here principle coordinate analysis (PCoA) are used to vizualize
the distances between the sample. PCoA are used to vizualize
the distances between the samples in a 2D plot and 3D plot. In the table "dm" stands for distance matrix and "pc" stands for principal component file used for generating plots. Both 2D and 3D plots are calculated as continuous and discrete. 3D plot requires JAVA. Tree can be visualized using software <a href="http://tree.bio.ed.ac.uk/software/figtree/" target="_blank">FigTree</a<br>
<br><br><br>
<table
 style="text-align: left; background-color: rgb(246, 246, 246); "
 border="1" cellpadding="5" cellspacing="2">
  <tbody>
    <tr>
      <td style="font-weight: bold;">Beta Diversity
matrices (dm pc)</td>
      <td style="font-weight: bold;">2D plot</td>
      <td style="font-weight: bold;">3D plot (Emperor)</td>
      <td style="font-weight: bold;">UPGMA Tree</td>
    </tr>
    <tr>
      <td>Bray-Curtis ( <a
 href="../beta_div/bray_curtis_dm.txt" target="_blank">dm</a>
&nbsp;<a href="../beta_div/bray_curtis_pc.txt"
 target="_blank">pc</a> )</td>
      <td style="text-align: center;"><a
 href="../beta_div/bray_curtis_2d_continuous/bray_curtis_pc_2D_PCoA_plots.html"
 target="_blank">Link</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></td>
 <td style="text-align: center;"><a
  href="../beta_div/emperor_bray/index.html"
   target="_blank">Link</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></td>
<td style="text-align: center;"><a
  href="../beta_div/beta_div_bray.tre"
   target="_blank">Link</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></td>

    </tr>

<tr>
      <td>Unweighted Unifrac Analysis ( <a
 href="../beta_div/unweighted_unifrac_dm.txt" target="_blank">dm</a>
      <a href="../beta_div/unweighted_unifrac_pc.txt"
 target="_blank">pc</a> )</td>
      <td style="text-align: center;"><a
 href="../beta_div/unweighted_unifrac_2d_continuous/unweighted_unifrac_pc_2D_PCoA_plots.html"
 target="_blank">Link</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></td>
  <td style="text-align: center;"><a
    href="../beta_div/emperor_unif_unw/index.html"
       target="_blank">Link</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></td>
<td style="text-align: center;"><a
  href="../beta_div/beta_div_unw.tre"
   target="_blank">Link</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></td>

    </tr>
    <tr>
      <td>Weighted Unifrac Analysis (<a
 href="../beta_div/weighted_unifrac_dm.txt" target="_blank">dm</a>
      <a href="../beta_div/weighted_unifrac_pc.txt"
 target="_blank">pc</a> )</td>
      <td style="text-align: center;"><a
 href="../beta_div/weighted_unifrac_2d_continuous/weighted_unifrac_pc_2D_PCoA_plots.html"
 target="_blank">Link</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></td>
  <td style="text-align: center;"><a
    href="../beta_div/emperor_unif_wei/index.html"
       target="_blank">Link</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></td>
<td style="text-align: center;"><a
  href="../beta_div/beta_div_w.tre"
   target="_blank">Link</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></td>

    </tr>

  </tbody>
</table>
&nbsp;<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
</div>
</body>
</html>
EOF
#----------End:Beta Diversity--------------------------------#


#----------Start:Advance analysis--------------------------------#


cat <<EOF >report_files/advance_analysis.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Sample selected and mapping information</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"><a href ="../microbiome_report.html" >Home</a> -&gt; Further advanced analysis and statistical tests<br><br></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Further advanced analysis and statistical tests"></a> &nbsp; Further advanced analysis and statistical tests</h2>
      </td>
    </tr>
  </tbody>
</table>

Many different aspects of microbiome analysis can be explored further using more sophisticated statustical analysis available in the QIIME package or using R . For example
<ol>
  <li>Is there any statistical difference
between&nbsp;biological samples (control vs treatment or different
groups) based on taxonomic distribution of microbiome?&nbsp;</li>
  <li>What OTUs (species) are differentially abundant between two
groups of samples?</li>
  <li>What are the top most OTUs (or species) &nbsp;present
in a particular sample or group?</li>
  <li>What are the rare OTUs present in a particular sample or
group?</li>
  <li>OTU correlation : Is there a correlation exists between
OTUs and other arrtibutes of sample like pH or other environmental
conditions.</li>
  <li>How a group of samples behave when exposed
to&nbsp;different condition?</li>
  <li>Can we generate heatmaps with phylogenetic tree and other
attributes?</li>
  <li>Can we find what&nbsp;OTUs are shared between different
samples?</li>
  <li>How different&nbsp;samples can be group together?</li>
  <li>Can we measure alpha and beta diversity using different
matrices?
  </li>
</ol>

</div>
EOF


#----------End:Advance analysis--------------------------------tyle="width: 14px; height: 13px;" alt="" src="oinw.gif"><img style="width: 14px; height: 13px;" alt="" src="oinw.gif">



#----------Start:References and FAQs--------------------------------#




cat <<EOF >report_files/references_faqs.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Sample selected and mapping information</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"><a href ="../microbiome_report.html" >Home</a> -&gt; References and FAQs<br><br></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="References and FAQs"></a> &nbsp; References and FAQs</h2>
      </td>
    </tr>
  </tbody>
</table>

</span></p>
<div style="text-align: left;"><span
 style="font-weight: bold;">
<h3 style="font-weight: bold; text-align: left;"><span
 style="color: rgb(153, 0, 0);">References&nbsp;&nbsp;
</span></h3>
</span></div>
Major part of the analysis done here was carried using QIIME package
for microbial population analysis. However many other aspects of
analysis were&nbsp;done using R, bash script, Perl and other
bioinformatics packages like FASTQC, FASTX, GALAXY.&nbsp;
<ol>
  <li><a
 href="http://www.nature.com/nmeth/journal/v7/n5/full/nmeth.f.303.html" target="_blank">QIIME</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif">
allows analysis of high-throughput community
sequencing data<br>
J Gregory Caporaso, Justin Kuczynski, Jesse Stombaugh, Kyle
Bittinger, Frederic D Bushman, Elizabeth K Costello, Noah Fierer,
Antonio Gonzalez Pena, Julia K Goodrich, Jeffrey I Gordon, Gavin A
Huttley, Scott T Kelley, Dan Knights, Jeremy E Koenig, Ruth E Ley,
Catherine A Lozupone, Daniel McDonald, Brian D Muegge, Meg Pirrung,
Jens Reeder, Joel R Sevinsky, Peter J Turnbaugh, William A Walters,
Jeremy Widmann, Tanya Yatsunenko, Jesse Zaneveld and Rob Knight; Nature
Methods, 2010; doi:10.1038/nmeth.f.303</li>
  <li><a
 href="http://www.bioinformatics.babraham.ac.uk/projects/fastqc/" target="_blank">FASTQC</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></li>
  <li><a href="http://hannonlab.cshl.edu/fastx_toolkit/" target="_blank">FASTX</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></li>
  <li><a href="http://cran.r-project.org/" target="_blank">R</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></li>
  <li><a href="http://www.perl.org/" target="_blank">PERL</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"></li>
</ol>
<br><h3 style="text-align: left;"><span
 style="color: rgb(153, 0, 0);">Tutorial&nbsp;&nbsp;&nbsp;</span></h3>
<br>
Here are the workflow on microbiome analysis <a
 href="https://dl.dropbox.com/u/428435/poster-microbiome.pptx"
 target="_blank">PPT</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"> &nbsp;<a
 href="https://dl.dropbox.com/u/428435/poster-microbiome.pdf"
 target="_blank">PDF</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"><br>
<br>
<br>
<span style="font-weight: bold;"><a
 name="What_is_Alpha_diversity"></a>What is Alpha
diversity</span> - It is
used to measure the diversity within a sample. For measuring alpha
diversity, two major factors taken into account are richness and
evenness. <br>
Richness is a measure of &nbsp;number of
&nbsp;species present in a
sample. <br>
Evenness is a measure of relative abundance of different
species that make up the richness in that area.
Evenness is ranged from zero to one. When evenness is close to zero, it
indicates that most of the individuals belongs to one or a few
species/categories. When the evenness is close to one, it indicates
that each species/categories consists of the same number of individuals.<br>
<br>
Consider this example of finding the alpha diversity in two samples.<br>
<br>
<table valign="top"
 style="border: 0pt solid rgb(163, 163, 163); direction: ltr; border-collapse: collapse; background-color: rgb(237, 237, 237);"
 border="1" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 1.2569in;">
Flower Species </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9083in;">
Sample 1 </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9in;">
Sample 2 </th>
    </tr>
    <tr>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 1.2569in;">
Daisy </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9083in;">
300 </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9in;">
20 </th>
    </tr>
    <tr>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 1.2569in;">
Dandelion </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9083in;">
335 </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9in;">
49 </th>
    </tr>
    <tr>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 1.2569in;">
Buttercup </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9083in;">
365 </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9in;">
931 </th>
    </tr>
    <tr>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 1.2569in;">
Total </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9083in;">
1000 </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9in;">
1000 </th>
    </tr>
  </tbody>
</table>
<br>
Here both samples have the same richness (3 species) and
the same total number of individuals (1000). However, the first sample
has more evenness than the second.
This is because the total number of individuals in the sample is quite
evenly
distributed between the three species.<br>
As species richness and evenness increase, so
diversity increases.<br>
<br>
Several
biodiversity indices have been developed that mathematically combine
the effects of richness and eveness. Each has its merits, and may put
more or less emphasis upon richness or eveness.<br>
<br>
A diversity
index is a quantitative measure that reflects how many different types
(such as species) there are in a dataset, and simultaneously takes into
account how evenly the basic entities (such as individuals) are
distributed among those types. The value of a diversity index increases
both when the number of types increases and when evenness increases.
For a given number of types, the value of a diversity index is
maximized when all types are equally abundant.<br>
<br>
Observed_species index measures species richness (S), which is the
total number of species found in an environment/sample.<br>
Simpson's index (D) is the probability that two randomly selected
individuals belong to two different species/categories.<br>
Shannon-Wiener
index (H) is measuring the order/disorder in a particular system. This
order is characterized by the number of individuals found for each
species/category in the sample. A high species diversity may indicate
generally a healthy environment.<br>
<br>
The list of indexes supported here are &nbsp;<span
 style="font-weight: bold;">ACE,
berger_parker_d, brillouin_d, chao1, chao1_confidence, dominance,
doubles, equitability, fisher_alpha, heip_e, kempton_taylor_q,
margalef, mcintosh_d, mcintosh_e, menhinick, michaelis_menten_fit,
observed_species, osd, reciprocal_simpson, robbins, shannon, simpson,
simpson_e, singles, strong, PD_whole_tree</span><br>
<br>
<br>
<br>
<span style="font-weight: bold;">Rarefaction curve</span>
-
Rarefaction curves plot the number of individuals sampled versus the
number of species. They're used to determine species diversity (# of
species in a community) and species richness (# of species in a given
area). When the curve starts to level off, you can assume you've
reached the approximate number of different species. Here a random
sample is genereated (without replacement) with 10% , 20%, 30% to 100%
sequences and alpha diversity is calculated for each random sample.When
the curve starts to level off, you can assume you've reached the
approximate number of different species.<br>
<br>
This rarefaction curve is dynamic in nature, please select a metric
type and category to view the results.<br>
<br>
<br>
Source : &nbsp;<br>
<a href="http://en.wikipedia.org/wiki/Diversity_index" target="_blank">http://en.wikipedia.org/wiki/Diversity_index</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"><br>
<a href="http://www.countrysideinfo.co.uk/simpsons.htm" target="_blank">http://www.countrysideinfo.co.uk/simpsons.htm</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"><br>
<a href="http://aquafind.com/articles/Biodiversity-Indices.php" target="_blank">http://aquafind.com/articles/Biodiversity-Indices.php</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"><br>
<a href="http://qiime.org/scripts/alpha_diversity.html" target="_blank">qiime.org/scripts/alpha_diversity.html</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"><br>
<br>
<br>
<a href="#Index"><br>
<span style="font-weight: bold;"><a
 name="What_is_Beta_diversity"></a>What is Beta
diversity</span> - It is a term for the comparison of samples to
each other. A beta diversity metric does not calculate a value for each
sample. Rather, it calculates a distance between a pair of
samples.&nbsp; If you have many samples (for example 3 control and
3 treatment), a beta diversity metric will return a matrix of the
distances of all samples to all other samples.<br>
There are different types of matrices which can be used to measure
diversity like bray-curtis, unifrac etc.<br>
Different typr of matrices supported here are <br>
<span style="font-weight: bold;">abund_jaccard,
binary_chisq, binary_chord, binary_euclidean, binary_hamming,
binary_jaccard, binary_lennon, binary_ochiai, binary_otu_gain,
binary_pearson, binary_sorensen_dice, bray_curtis, canberra, chisq,
chord, euclidean, gower, hellinger, kulczynski, manhattan,
morisita_horn, pearson, soergel, spearman_approx, specprof, unifrac,
unifrac_g, unifrac_g_full_tree, unweighted_unifrac,
unweighted_unifrac_full_tree, weighted_normalized_unifrac,
weighted_unifrac</span><br>
<br>
<br>
Here we generally use the UniFrac matrix to calculate the beta
diversity. UniFrac is a method to calculate a distance measure between
bacterial communities using phylogenetic information. The method can be
used in two modes.<br>
<ol>
  <li>Un-weighted (Qualitative) - It depends upon the present and
absence of OTUs between samples and their phylogenetic distances.</li>
  <li>Weighted (Qualitative) - It includes the abundance
information alongwith the presence and absence of OTUs between samples
and their phylogenetic distances.</li>
</ol>
Here principle coordinate analysis (PCoA) are used to vizualize the
distances between the sample. Here principle coordinate analysis (PCoA)
are used to vizualize the distances between the samples in a 2D plot
and 3D plot. <br>
<br>
Source<br>
<a href="http://www.wernerlab.org/teaching/qiime/overview/f" 
 target="_blank">http://www.wernerlab.org/teaching/qiime/overview/f</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"><br>
<a
 href="http://qiime.org/tutorials/tutorial.html#compute-beta-diversity-and-generate-beta-diversity-plots" target="_blank">http://qiime.org/tutorials/tutorial.html#compute-beta-diversity-and-generate-beta-diversity-plots</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"><br>
<a href="http://en.wikipedia.org/wiki/UniFrac" target="_blank">http://en.wikipedia.org/wiki/UniFrac</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"><br>
<a href="http://bmf2.colorado.edu/unifrac/tutorial.psp" target="_blank">http://bmf2.colorado.edu/unifrac/tutorial.psp</a><img style="width: 14px; height: 13px;" alt="" src="oinw.gif"><br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
</div>
</body>
</html>
EOF

#----------Start:References and FAQs--------------------------------#



echo -e "\nReport generated in current folder as 'microbiome_report.html'. Use any browser (Firefox, Chrome etc) to open the file.\n"
