# One-Samp ttest correlations

# Load supplementary scripts & dependencies
setwd("/Users/hamid/Desktop/Research/+Scripts")
source("jzBarPlot.s")
source("lineplotBand.s")
library(RColorBrewer)
library(infotheo)
library(entropy)

# Load data
setwd("/Users/hamid/Desktop/Research/fMRI/LC Methods/rest_results/analysis/onesamp_nat_wmr1_gsr0_noLC")

# Correlations between maps
dump.M.K1.b5s5.p85.MK55_MK50 = as.numeric(as.character(unlist(read.csv("dump_p85.MK50_MK55.MK55.txt", header=F))))
dump.M.K1.b5s0.p85.MK55_MK50 = as.numeric(as.character(unlist(read.csv("dump_p85.MK50_MK55.MK50.txt", header=F))))
cor(dump.M.K1.b5s5.p85.MK55_MK50,dump.M.K1.b5s0.p85.MK55_MK50)
"0.9924693"
disc = discretize2d(dump.M.K1.b5s5.p85.MK55_MK50,dump.M.K1.b5s0.p85.MK55_MK50, numBins1 = 10, numBins2 = 10)
mi.empirical(disc)
"1.150674"

dump.M.LC.b5s0.p85.ML50_MK50 = as.numeric(as.character(unlist(read.csv("dump_p85.ML50_MK50.ML50.txt", header=F))))
dump.M.K1.b5s0.p85.ML50_MK50 = as.numeric(as.character(unlist(read.csv("dump_p85.ML50_MK50.MK50.txt", header=F))))
cor(dump.M.LC.b5s0.p85.ML50_MK50,dump.M.K1.b5s0.p85.ML50_MK50)
"-0.08024379"
disc = discretize2d(dump.M.LC.b5s0.p85.ML50_MK50,dump.M.K1.b5s0.p85.ML50_MK50, numBins1 = 10, numBins2 = 10)
mi.empirical(disc)
"0.1393072"

dump.S.K1.b5s0.p85.SK50_MK50 = as.numeric(as.character(unlist(read.csv("dump_p85.SK50_MK50.SK50.txt", header=F))))
dump.M.K1.b5s0.p85.SK50_MK50 = as.numeric(as.character(unlist(read.csv("dump_p85.SK50_MK50.MK50.txt", header=F))))
cor(dump.S.K1.b5s0.p85.SK50_MK50,dump.M.K1.b5s0.p85.SK50_MK50)
"-0.1887068"
disc = discretize2d(dump.S.K1.b5s0.p85.SK50_MK50,dump.M.K1.b5s0.p85.SK50_MK50, numBins1 = 10, numBins2 = 10)
mi.empirical(disc)
"0.08854555"

dump.M.LC.b5s5.p85.ML55_MK55 = as.numeric(as.character(unlist(read.csv("dump_p85.ML55_MK55.ML55.txt", header=F))))
dump.M.K1.b5s5.p85.ML55_MK55 = as.numeric(as.character(unlist(read.csv("dump_p85.ML55_MK55.MK55.txt", header=F))))
cor(dump.M.LC.b5s5.p85.ML55_MK55,dump.M.K1.b5s5.p85.ML55_MK55)
"-0.0531868"
disc = discretize2d(dump.M.LC.b5s5.p85.ML55_MK55,dump.M.K1.b5s5.p85.ML55_MK55, numBins1 = 10, numBins2 = 10)
mi.empirical(disc)
"0.200354"

dump.S.K1.b5s5.p85.SK55_MK55 = as.numeric(as.character(unlist(read.csv("dump_p85.SK55_MK55.SK55.txt", header=F))))
dump.M.K1.b5s5.p85.SK55_MK55 = as.numeric(as.character(unlist(read.csv("dump_p85.SK55_MK55.MK55.txt", header=F))))
cor(dump.S.K1.b5s5.p85.SK55_MK55,dump.M.K1.b5s5.p85.SK55_MK55)
"-0.1452681"
disc = discretize2d(dump.S.K1.b5s5.p85.SK55_MK55,dump.M.K1.b5s5.p85.SK55_MK55, numBins1 = 10, numBins2 = 10)
mi.empirical(disc)
"0.1098371"

dump.M.LC.b5s0.p85.ML55_ML50 = as.numeric(as.character(unlist(read.csv("dump_p85.ML50_ML55.ML50.txt", header=F))))
dump.M.LC.b5s5.p85.ML55_ML50 = as.numeric(as.character(unlist(read.csv("dump_p85.ML50_ML55.ML55.txt", header=F))))
cor(dump.M.LC.b5s5.p85.ML55_ML50,dump.M.LC.b5s0.p85.ML55_ML50)
"0.9778555"
disc = discretize2d(dump.M.LC.b5s5.p85.ML55_ML50,dump.M.LC.b5s0.p85.ML55_ML50, numBins1 = 10, numBins2 = 10)
mi.empirical(disc)
"0.5561691"

dump.S.LC.b5s0.p85.SL50_ML50 = as.numeric(as.character(unlist(read.csv("dump_p85.SL50_ML50.SL50.txt", header=F))))
dump.M.LC.b5s0.p85.SL50_ML50 = as.numeric(as.character(unlist(read.csv("dump_p85.SL50_ML50.ML50.txt", header=F))))
cor(dump.S.LC.b5s0.p85.SL50_ML50,dump.M.LC.b5s0.p85.SL50_ML50)
"-0.2822884"
disc = discretize2d(dump.S.LC.b5s0.p85.SL50_ML50,dump.M.LC.b5s0.p85.SL50_ML50, numBins1 = 10, numBins2 = 10)
mi.empirical(disc)
"0.07631708"

dump.S.LC.b5s5.p85.SL55_ML55 = as.numeric(as.character(unlist(read.csv("dump_p85.SL55_ML55.SL55.txt", header=F))))
dump.M.LC.b5s5.p85.SL55_ML55 = as.numeric(as.character(unlist(read.csv("dump_p85.SL55_ML55.ML55.txt", header=F))))
cor(dump.S.LC.b5s5.p85.SL55_ML55,dump.M.LC.b5s5.p85.SL55_ML55)
"-0.2323954"
disc = discretize2d(dump.S.LC.b5s5.p85.SL55_ML55,dump.M.LC.b5s5.p85.SL55_ML55, numBins1 = 10, numBins2 = 10)
mi.empirical(disc)
"0.1657509"

dump.S.K1.b5s0.p85.SK55_SK50 = as.numeric(as.character(unlist(read.csv("dump_p85.SK50_SK55.SK50.txt", header=F))))
dump.S.K1.b5s5.p85.SK55_SK50 = as.numeric(as.character(unlist(read.csv("dump_p85.SK50_SK55.SK55.txt", header=F))))
cor(dump.S.K1.b5s5.p85.SK55_SK50,dump.S.K1.b5s0.p85.SK55_SK50)
"0.8180272"
disc = discretize2d(dump.S.K1.b5s5.p85.SK55_SK50,dump.S.K1.b5s0.p85.SK55_SK50, numBins1 = 10, numBins2 = 10)
mi.empirical(disc)
"0.4207996"

dump.S.LC.b5s0.p85.SL50_SK50 = as.numeric(as.character(unlist(read.csv("dump_p85.SL50_SK50.SL50.txt", header=F))))
dump.S.K1.b5s0.p85.SL50_SK50 = as.numeric(as.character(unlist(read.csv("dump_p85.SL50_SK50.SK50.txt", header=F))))
cor(dump.S.LC.b5s0.p85.SL50_SK50,dump.S.K1.b5s0.p85.SL50_SK50)
"-0.2095843"
disc = discretize2d(dump.S.LC.b5s0.p85.SL50_SK50,dump.S.K1.b5s0.p85.SL50_SK50, numBins1 = 10, numBins2 = 10)
mi.empirical(disc)
"0.08044887"

dump.S.LC.b5s5.p85.SL55_SK55 = as.numeric(as.character(unlist(read.csv("dump_p85.SL55_SK55.SL55.txt", header=F))))
dump.S.K1.b5s5.p85.SL55_SK55 = as.numeric(as.character(unlist(read.csv("dump_p85.SL55_SK55.SK55.txt", header=F))))
cor(dump.S.LC.b5s5.p85.SL55_SK55,dump.S.K1.b5s5.p85.SL55_SK55)
"-0.06851311"
disc = discretize2d(dump.S.LC.b5s5.p85.SL55_SK55,dump.S.K1.b5s5.p85.SL55_SK55, numBins1 = 10, numBins2 = 10)
mi.empirical(disc)
"0.08527796"

dump.S.LC.b5s5.p85.SL55_SL50 = as.numeric(as.character(unlist(read.csv("dump_p85.SL50_SL55.SL55.txt", header=F))))
dump.S.LC.b5s0.p85.SL55_SL50 = as.numeric(as.character(unlist(read.csv("dump_p85.SL50_SL55.SL50.txt", header=F))))
cor(dump.S.LC.b5s5.p85.SL55_SL50,dump.S.LC.b5s0.p85.SL55_SL50)
"0.746399"
disc = discretize2d(dump.S.LC.b5s5.p85.SL55_SL50,dump.S.LC.b5s0.p85.SL55_SL50, numBins1 = 10, numBins2 = 10)
mi.empirical(disc)
"0.1985238"

# Bland-Altman plots (Tukey's Mean Difference plots)
library(BlandAltmanLeh)
bland.altman.plot(dump.M.K1.b5s5.p85.MK55_MK50,dump.M.K1.b5s0.p85.MK55_MK50,graph.sys="ggplot2")
bland.altman.plot(dump.M.LC.b5s0.p85.ML50_MK50,dump.M.K1.b5s0.p85.ML50_MK50,graph.sys="ggplot2")
bland.altman.plot(dump.S.K1.b5s0.p85.SK50_MK50,dump.M.K1.b5s0.p85.SK50_MK50,graph.sys="ggplot2")
bland.altman.plot(dump.M.LC.b5s5.p85.ML55_MK55,dump.M.K1.b5s5.p85.ML55_MK55,graph.sys="ggplot2")
bland.altman.plot(dump.S.K1.b5s5.p85.SK55_MK55,dump.M.K1.b5s5.p85.SK55_MK55,graph.sys="ggplot2")
bland.altman.plot(dump.M.LC.b5s5.p85.ML55_ML50,dump.M.LC.b5s0.p85.ML55_ML50,graph.sys="ggplot2")
bland.altman.plot(dump.S.LC.b5s0.p85.SL50_ML50,dump.M.LC.b5s0.p85.SL50_ML50,graph.sys="ggplot2")
bland.altman.plot(dump.S.LC.b5s5.p85.SL55_ML55,dump.M.LC.b5s5.p85.SL55_ML55,graph.sys="ggplot2")
bland.altman.plot(dump.S.K1.b5s5.p85.SK55_SK50,dump.S.K1.b5s0.p85.SK55_SK50,graph.sys="ggplot2")
bland.altman.plot(dump.S.LC.b5s0.p85.SL50_SK50,dump.S.K1.b5s0.p85.SL50_SK50,graph.sys="ggplot2")
bland.altman.plot(dump.S.LC.b5s5.p85.SL55_SK55,dump.S.K1.b5s5.p85.SL55_SK55,graph.sys="ggplot2")
bland.altman.plot(dump.S.LC.b5s5.p85.SL55_SL50,dump.S.LC.b5s0.p85.SL55_SL50,graph.sys="ggplot2")

BA.MK55_MK50 = cbind(dump.M.K1.b5s5.p85.MK55_MK50,dump.M.K1.b5s0.p85.MK55_MK50)
BA.ML50_MK50 = cbind(dump.M.LC.b5s0.p85.ML50_MK50,dump.M.K1.b5s0.p85.ML50_MK50)
BA.SK50_MK50 = cbind(dump.S.K1.b5s0.p85.SK50_MK50,dump.M.K1.b5s0.p85.SK50_MK50)
BA.ML55_MK55 = cbind(dump.M.LC.b5s5.p85.ML55_MK55,dump.M.K1.b5s5.p85.ML55_MK55)
BA.SK55_MK55 = cbind(dump.S.K1.b5s5.p85.SK55_MK55,dump.M.K1.b5s5.p85.SK55_MK55)
BA.ML55_ML50 = cbind(dump.M.LC.b5s5.p85.ML55_ML50,dump.M.LC.b5s0.p85.ML55_ML50)
BA.SL50_ML50 = cbind(dump.S.LC.b5s0.p85.SL50_ML50,dump.M.LC.b5s0.p85.SL50_ML50)
BA.SL55_ML55 = cbind(dump.S.LC.b5s5.p85.SL55_ML55,dump.M.LC.b5s5.p85.SL55_ML55)
BA.SK55_SK50 = cbind(dump.S.K1.b5s5.p85.SK55_SK50,dump.S.K1.b5s0.p85.SK55_SK50)
BA.SL50_SK50 = cbind(dump.S.LC.b5s0.p85.SL50_SK50,dump.S.K1.b5s0.p85.SL50_SK50)
BA.SL55_SK55 = cbind(dump.S.LC.b5s5.p85.SL55_SK55,dump.S.K1.b5s5.p85.SL55_SK55)
BA.SL55_SL50 = cbind(dump.S.LC.b5s5.p85.SL55_SL50,dump.S.LC.b5s0.p85.SL55_SL50)

BA.SL55_SL50.coor = data.frame(
  x = as.numeric((BA.SL55_SL50[,1]+BA.SL55_SL50[,2])/2),
  y = as.numeric(BA.SL55_SL50[,1]-BA.SL55_SL50[,2]))

BA.SL55_SK55.coor = data.frame(
  x = as.numeric((BA.SL55_SK55[,1]+BA.SL55_SK55[,2])/2),
  y = as.numeric(BA.SL55_SK55[,1]-BA.SL55_SK55[,2]))

BA.SL50_SK50.coor = data.frame(
  x = as.numeric((BA.SL50_SK50[,1]+BA.SL50_SK50[,2])/2),
  y = as.numeric(BA.SL50_SK50[,1]-BA.SL50_SK50[,2]))

BA.SK55_SK50.coor = data.frame(
  x = as.numeric((BA.SK55_SK50[,1]+BA.SK55_SK50[,2])/2),
  y = as.numeric(BA.SK55_SK50[,1]-BA.SK55_SK50[,2]))

BA.SL55_ML55.coor = data.frame(
  x = as.numeric((BA.SL55_ML55[,1]+BA.SL55_ML55[,2])/2),
  y = as.numeric(BA.SL55_ML55[,1]-BA.SL55_ML55[,2]))

BA.SL50_ML50.coor = data.frame(
  x = as.numeric((BA.SL50_ML50[,1]+BA.SL50_ML50[,2])/2),
  y = as.numeric(BA.SL50_ML50[,1]-BA.SL50_ML50[,2]))

BA.ML55_ML50.coor = data.frame(
  x = as.numeric((BA.ML55_ML50[,1]+BA.ML55_ML50[,2])/2),
  y = as.numeric(BA.ML55_ML50[,1]-BA.ML55_ML50[,2]))

BA.SK55_MK55.coor = data.frame(
  x = as.numeric((BA.SK55_MK55[,1]+BA.SK55_MK55[,2])/2),
  y = as.numeric(BA.SK55_MK55[,1]-BA.SK55_MK55[,2]))

BA.ML55_MK55.coor = data.frame(
  x = as.numeric((BA.ML55_MK55[,1]+BA.ML55_MK55[,2])/2),
  y = as.numeric(BA.ML55_MK55[,1]-BA.ML55_MK55[,2]))

BA.SK50_MK50.coor = data.frame(
  x = as.numeric((BA.SK50_MK50[,1]+BA.SK50_MK50[,2])/2),
  y = as.numeric(BA.SK50_MK50[,1]-BA.SK50_MK50[,2]))

BA.ML50_MK50.coor = data.frame(
  x = as.numeric((BA.ML50_MK50[,1]+BA.ML50_MK50[,2])/2),
  y = as.numeric(BA.ML50_MK50[,1]-BA.ML50_MK50[,2]))

BA.MK55_MK50.coor = data.frame(
  x = as.numeric((BA.MK55_MK50[,1]+BA.MK55_MK50[,2])/2),
  y = as.numeric(BA.MK55_MK50[,1]-BA.MK55_MK50[,2]))

"logBA.MK55_MK50.coor = data.frame(
  x = as.numeric((log2(BA.MK55_MK50[,1])+log2(BA.MK55_MK50[,2]))/2),
  y = as.numeric(log2(BA.MK55_MK50[,1])-log2(BA.MK55_MK50[,2])))"



# FIGURES
text.cex = 2
linewidth = 2.5
K1color = 'indianred4'
LCcolor = 'skyblue4'
Xcolor = brewer.pal(5, 'Greys')[4]


################### Keren
ylims = c(-.25,0.5)
xlims = c(0,1)

# BA.SK55_SK50.coor
data = BA.SK55_SK50.coor
xy.par.settings = list(
  plot.symbol = list(col = K1color, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=2, lty=1)
  panel.xyplot(x,y)
  panel.abline(mean(data$y), lwd=4)
  panel.abline(mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")

# BA.SK55_MK55.coor (flipped to represent MK55 minus SK55)
data = BA.SK55_MK55.coor
xy.par.settings = list(
  plot.symbol = list(col = K1color, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=2, lty=1)
  panel.xyplot(x,y)
  panel.abline(-1*(mean(data$y)), lwd=4)
  panel.abline(-1*(mean(data$y))+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(-1*(mean(data$y))-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(-1*y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")

# BA.MK55_MK50.coor
data = BA.MK55_MK50.coor
xy.par.settings = list(
  plot.symbol = list(col = K1color, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=2, lty=1)
  panel.xyplot(x,y)
  panel.abline(mean(data$y), lwd=4)
  panel.abline(mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")

# BA.SK50_MK50.coor (flipped to represent MK50 minus SK50)
data = BA.SK50_MK50.coor
xy.par.settings = list(
  plot.symbol = list(col = K1color, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=2, lty=1)
  panel.xyplot(x,y)
  panel.abline(-1*mean(data$y), lwd=4)
  panel.abline(-1*mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(-1*mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(-1*y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")



################### LC
ylims = c(-.45,0.45)
xlims = c(0.001,0.999)

# BA.SL55_SL50.coor
data = BA.SL55_SL50.coor
xy.par.settings = list(
  plot.symbol = list(col = LCcolor, lwd = linewidth, cex=text.cex, pch = 20), 
  par.ylab.text = list(cex=text.cex),
  axis.line = list(lwd = 2),
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=2, lty=1)
  panel.xyplot(x,y)
  panel.abline(mean(data$y), lwd=4)
  panel.abline(mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")

# BA.SL55_ML55.coor (flipped to represent ML55 minus SL55)
data = BA.SL55_ML55.coor
xy.par.settings = list(
  plot.symbol = list(col = LColor, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=2, lty=1)
  panel.xyplot(x,y)
  panel.abline(-1*mean(data$y), lwd=4)
  panel.abline(-1*mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(-1*mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(-1*y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")

# BA.SL50_ML50.coor (flipped to represent ML50 minus SL50)
data = BA.SL50_ML50.coor
xy.par.settings = list(
  plot.symbol = list(col = LCcolor, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=2, lty=1)
  panel.xyplot(x,y)
  panel.abline(-1*mean(data$y), lwd=4)
  panel.abline(-1*mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(-1*mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(-1*y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")

################### K1 vs LC
ylims = c(-.45,0.45)
xlims = c(0,1)

# BA.SL55_SK55.coor
data = BA.SL55_SK55.coor
xy.par.settings = list(
  plot.symbol = list(col = Xcolor, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=2, lty=1)
  panel.xyplot(x,y)
  panel.abline(mean(data$y), lwd=4)
  panel.abline(mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")

# BA.SL50_SK50.coor
data = BA.SL50_SK50.coor
xy.par.settings = list(
  plot.symbol = list(col = Xcolor, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=2, lty=1)
  panel.xyplot(x,y)
  panel.abline(mean(data$y), lwd=4)
  panel.abline(mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")

# BA.ML55_MK55.coor
data = BA.ML55_MK55.coor
xy.par.settings = list(
  plot.symbol = list(col = Xcolor, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=2, lty=1)
  panel.xyplot(x,y)
  panel.abline(mean(data$y), lwd=4)
  panel.abline(mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")

# BA.ML50_MK50.coor
data = BA.ML50_MK50.coor
xy.par.settings = list(
  plot.symbol = list(col = Xcolor, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=2, lty=1)
  panel.xyplot(x,y)
  panel.abline(mean(data$y), lwd=4)
  panel.abline(mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")


#### Reported figures
ylims = c(-.35,0.35)
xlims = c(0,.4)

text.cex = 0.8
linewidth = 2.5
K1color = 'indianred4'
LCcolor = 'skyblue4'
Xcolor = brewer.pal(5, 'Greys')[4]

# BA.SL50_ML50.coor (Flipped for ML50 minus SL50)
data = BA.SL50_ML50.coor
xy.par.settings = list(
  plot.symbol = list(col = 'skyblue3', lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = linewidth),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=3, lty=1, col='black')
  panel.xyplot(x,y)
  panel.abline(-1*mean(data$y), lwd=4)
  panel.abline(-1*mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(-1*mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(-1*y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")

# ML50 minus MK50
data = BA.ML50_MK50.coor
xy.par.settings = list(
  plot.symbol = list(col = K1color, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=3, lty=1, col='black')
  panel.xyplot(x,y)
  panel.abline(mean(data$y), lwd=4)
  panel.abline(mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")

# ML55 minus ML50 (Flipped for ML50 minus ML55)
data = BA.ML55_ML50.coor
xy.par.settings = list(
  plot.symbol = list(col = Xcolor, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=3, lty=1, col='black')
  panel.xyplot(x,y)
  panel.abline(-1*mean(data$y), lwd=4)
  panel.abline(-1*mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(-1*mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(-1*y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")


ylims = c(-.045,0.02)
xlims = c(0,.4)

# ML55 minus ML50 (Flipped for ML50 minus ML55)
data = BA.ML55_ML50.coor
xy.par.settings = list(
  plot.symbol = list(col = Xcolor, lwd = linewidth, cex=text.cex, pch = 20), 
  strip.background = list(col = "gray90"),
  axis.line = list(lwd = 2),
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
xy.panel = function(x, y){
  panel.lmline(x,y, lwd=3, lty=1, col='black')
  panel.xyplot(x,y)
  panel.abline(-1*mean(data$y), lwd=4)
  panel.abline(-1*mean(data$y)+1.96*sd(data$y), lwd=3, lty=2)
  panel.abline(-1*mean(data$y)-1.96*sd(data$y), lwd=3, lty=2)}
xyplot(-1*y~x, data=data, panel = xy.panel, par.settings = xy.par.settings, ylim = ylims, xlim = xlims, ylab="",xlab="",type="p")
