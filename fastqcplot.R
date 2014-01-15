png(filename = "FASTQCplot.png",width = 1000, height = 700)
raw_data <- read.table(file="qcplot.txt",header=T,sep="\t",fill=TRUE)  #read file
cc<-ncol(raw_data)  #count column
cr<-nrow(raw_data)  #count row
cr5 = cr+100          #add 5 to cr, for creating space for label

usable<- raw_data[,2:cc]     #store usable data for plot
cc<-ncol(usable)  #count column

plot(c(1:cr), type="l", main = "FASTQC plot for all samples", ylab = "Q Score", xlab= "base position", ylim= c(1,41),xlim=c(1,cr5),col="white",xaxs = "i",yaxs="i")
gcc<- 40
gcr<- cr5-1
grid(gcr,gcc)
lines(rep(30,cr),col="black",lty=2)
lines(rep(20,cr),col="black",lty=2)
lines(rep(10,cr),col="black",lty=2)

colors <- rainbow(cc) # get array of colors

for (i in 1:cc)
{
	lines(usable[,i],col=colors[i])
}
lcr<- cr+1
legend(lcr,39,names(usable), col=colors,cex=1.3, lty=1, lwd=1)
#legend(1,30,names(usable), col=colors,cex=0.9, lty=1, lwd=1)
dev.off()

