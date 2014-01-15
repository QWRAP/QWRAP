# in arguments provide the input file, output file and the numer which is the number of top rows used to be filtered. the gloabal abundance is used as a measure for sorting and selection

# process command line arguments
args <- commandArgs(TRUE)
input <- args[1]
output <- args[2]
rows <- as.numeric(args[3])

# read the raw data/OTU table
rawdata<-read.table(file=input,header=T,sep="\t",comment.char = "",check.names = FALSE,skip=1)
num_col <-ncol(rawdata)-2
sumofrows<-apply(rawdata[,2:num_col],1,sum)
rawdata_mod <- cbind(sumofrows,rawdata)
#edit(rawdata_mod2)
rawdata_mod2 <- rawdata_mod[order(-sumofrows),]
filtered_rows <- rawdata_mod2[1:min(rows,nrow(rawdata_mod2)),2:(ncol(rawdata)+1)]
#edit(resulttop50)
write.table(filtered_rows,file=output,sep="\t",row.names = FALSE)

