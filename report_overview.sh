#-------------------------------------------------------------------------
# Name - report_overview.sh
# Desc - Creates a FASTQC report for all samples present inside a directory
# Author - Ranjit Kumar (ranjit58@gmail.com)
#-------------------------------------------------------------------------

#echo "Creating directory report_files for storing HTML report specific files in the current directory ...";
mkdir report_files
#cp ~/my-scripts/MAIS/arrow.png report_files/
cp `which report_overview.sh | sed -e 's/report_overview.sh//g'`/oinw.gif report_files/
#cp ~/my-scripts/MAIS/q.jpg report_files/

#----------Start:Initial Sequencing Overview-------------------#

cat <<EOF >FASTQC_overview.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>FASTQC Overview</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="FASTQC Overview"></a> &nbsp;
FASTQC Overview</h2>
      </td>
    </tr>
  </tbody>
</table>
<span style="color: black;">
This
section describes the&nbsp; all the samples and their sequencing statistics. <br>
<br>
The table below&nbsp;shows the number of
samples,&nbsp;sequences per
sample and&nbsp;their initial quality statistics.<br><br>
</span>

EOF

if [ -e qcstats.txt ]; then
echo -e '<table style="text-align: left; width: 900px; height: 61px;margin-left: 60px;" border="1" cellpadding="2" cellspacing="1">'>>FASTQC_overview.html
echo -e "<thead><tr><th>Count</th><th>Sample Name</th><th>Sequences </th><th>Read Length </th> <th>GC Content </th><th> FastQC Plots</th></tr> </thead><tbody>">>FASTQC_overview.html
COUNT=1;

while read line
do
	arrIN=(${line/// })
fastqclink=${arrIN[0]/.fastq.gz/}
echo "<tr><td>${COUNT}</td><td>${arrIN[0]}</td><td>${arrIN[1]}</td><td>${arrIN[2]}</td><td>${arrIN[3]}</td><td><a href=\"${fastqclink}_fastqc/fastqc_report.html\" target=\"_blank\">FASTQC</a></tr>">>FASTQC_overview.html
COUNT=$(($COUNT + 1 ));
done <qcstats.txt

echo "</tbody></table>">>FASTQC_overview.html
fi
cat <<EOF >>FASTQC_overview.html

<br>
<br>
<br>
<br>
The individual quality plots from all samples are combined below to
provide a overview merged quality plot. The plot shows the mean Qscore vs base position for all samples.<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="FASTQCplot.png"><br>
<br>
Dowload the raw dataset (tab delimited format, right click -> save link as)<br>
<ol>
  <li>
	<a href="qcstats.txt" target="_blank">Sample stats file</a>
  </li>
  <li>
	<a href="qcplot.txt" target="_blank">Per base sequence quality file</a>
</li>
</ol>
<br>
</div>

EOF

