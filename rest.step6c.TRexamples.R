# Overlap analyses

# Load supplementary scripts & dependencies
setwd("/Users/hamid/Desktop/Research/+Scripts")
source("jzBarPlot.s")
source("lineplotBand.s")
library(RColorBrewer)

# Load in data
setwd("/Users/hamid/Desktop/Research/fMRI/LC Methods/rest_results/analysis/TRexamples")
ML50 = read.csv("seed_traceLC.tAATs9_medn_nat_seed0.WM_1.GSR_0.tproj.NTRP.frac.1D", header=F)
ML55 = read.csv("seed_traceLC.tAATs9_medn_nat_seed5.WM_1.GSR_0.tproj.NTRP.frac.1D", header=F)
SL50 = read.csv("seed_traceLC.tAATs9_e2_nat_seed0.WM_1.GSR_0.tproj.NTRP.frac.1D", header=F)
MK50 = read.csv("seed_Keren1SD.tAATs9_medn_mni_seed0.WM_1.GSR_0.tproj.NTRP.frac.1D", header=F)

ML50$TR = 1:202
ML55$TR = 1:202
SL50$TR = 1:202
MK50$TR = 1:202

# Figures
text.cex = 1
linewidth = 2.5
stdColor = 'black'

# ML50
LCcolor='blue'
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = rep(linewidth,3), col = c(LCcolor), lty = c(1,1)), 
  superpose.symbol = list(col = c(LCcolor), fill = c(LCcolor), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = stdColor, lwd = linewidth), 
  plot.line = list(col = LCcolor, lwd = linewidth), 
  plot.symbol = list(col = stdColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))

# Plot
lineplotBand(V1 ~ TR, data = ML50[ML50$TR >= 50 & ML50$TR <= 150,], par.settings = lp.par.settings, xlab = '', ylab = '', ylim = c(-210,210), xlim = c(1, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 50, to = 150, by = 20)), y = list(tck = c(.5,0)))), type = 'l')


# ML55
Xcolor=brewer.pal(5, 'Greys')[4]
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = rep(linewidth,3), col = c(Xcolor), lty = c(1,1)), 
  superpose.symbol = list(col = c(Xcolor), fill = c(Xcolor), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = stdColor, lwd = linewidth), 
  plot.line = list(col = Xcolor, lwd = linewidth), 
  plot.symbol = list(col = stdColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))

# Plot
lineplotBand(V1 ~ TR, data = ML55[ML55$TR >= 50 & ML55$TR <= 150,], par.settings = lp.par.settings, xlab = '', ylab = '', ylim = c(-210,210), xlim = c(1, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 50, to = 150, by = 20)), y = list(tck = c(.5,0)))), type = 'l')


# MK50
K1color='indianred4'
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = rep(linewidth,3), col = c(K1color), lty = c(1,1)), 
  superpose.symbol = list(col = c(K1color), fill = c(K1color), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = stdColor, lwd = linewidth), 
  plot.line = list(col = K1color, lwd = linewidth), 
  plot.symbol = list(col = stdColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))

# Plot
lineplotBand(V1 ~ TR, data = MK50[MK50$TR >= 50 & MK50$TR <= 150,], par.settings = lp.par.settings, xlab = '', ylab = '', ylim = c(-210,210), xlim = c(1, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 50, to = 150, by = 20)), y = list(tck = c(.5,0)))), type = 'l')


# SL50
sLCcolor='skyblue3'
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = rep(linewidth,3), col = c(sLCcolor), lty = c(1,1)), 
  superpose.symbol = list(col = c(sLCcolor), fill = c(sLCcolor), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = stdColor, lwd = linewidth), 
  plot.line = list(col = sLCcolor, lwd = linewidth), 
  plot.symbol = list(col = stdColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))

# Plot
lineplotBand(V1 ~ TR, data = SL50[SL50$TR >= 50 & SL50$TR <= 150,], par.settings = lp.par.settings, xlab = '', ylab = '', ylim = c(-210,210), xlim = c(1, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 50, to = 150, by = 20)), y = list(tck = c(.5,0)))), type = 'l')

