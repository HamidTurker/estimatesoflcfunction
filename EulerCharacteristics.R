# Euler Characteristics

# Load supplementary scripts & dependencies
setwd("/Users/hamid/Desktop/Research/+Scripts")

source("jzBarPlot.s")
source("lineplotBand.s")
source("lineplot.s")
library(RColorBrewer)

# Load data
setwd("~/Desktop/Research/fMRI/LC Methods/rest_results/analysis/onesamp_nat_wmr1_gsr0/euler_characteristics")
MK50 = read.csv("euler_chars_Multi.K1.b5.s0.csv", header=F, sep=",")
MK55 = read.csv("euler_chars_Multi.K1.b5.s5.csv", header=F, sep=",")
ML50 = read.csv("euler_chars_Multi.LC.b5.s0.csv", header=F, sep=",")
ML55 = read.csv("euler_chars_Multi.LC.b5.s5.csv", header=F, sep=",")

SK50 = read.csv("euler_chars_Single.K1.b5.s0.csv", header=F, sep=",")
SK55 = read.csv("euler_chars_Single.K1.b5.s5.csv", header=F, sep=",")
SL50 = read.csv("euler_chars_Single.LC.b5.s0.csv", header=F, sep=",")
SL55 = read.csv("euler_chars_Single.LC.b5.s5.csv", header=F, sep=",")

names(MK50)=c("tstat","EC"); names(SK50)=c("tstat","EC")
names(MK55)=c("tstat","EC"); names(SK55)=c("tstat","EC")
names(ML50)=c("tstat","EC"); names(SL50)=c("tstat","EC")
names(ML55)=c("tstat","EC"); names(SL55)=c("tstat","EC")

MK50$label = as.factor("MK50"); SK50$label = as.factor("SK50")
MK55$label = as.factor("MK55"); SK55$label = as.factor("SK55")
ML50$label = as.factor("ML50"); SL50$label = as.factor("SL50")
ML55$label = as.factor("ML55"); SL55$label = as.factor("SL55")

MK50=MK50[MK50$tstat >= -1,]; SK50=SK50[SK50$tstat >= -1,]
MK55=MK55[MK55$tstat >= -1,]; SK55=SK55[SK55$tstat >= -1,]
ML50=ML50[ML50$tstat >= -1,]; SL50=SL50[SL50$tstat >= -1,]
ML55=ML55[ML55$tstat >= -1,]; SL55=SL55[SL55$tstat >= -1,]

# Peak Euler Characteristics are at the following t-statistics (use to threshold our group level iFC maps)
MK50$tstat[which(MK50$EC == max(MK50$EC))]
"4.88"
MK55$tstat[which(MK55$EC == max(MK55$EC))]
"4.96"
SK50$tstat[which(SK50$EC == max(SK50$EC))]
"3.67"
SK55$tstat[which(SK55$EC == max(SK55$EC))]
"3.99"

ML50$tstat[which(ML50$EC == max(ML50$EC))]
"3.01 3.27"
ML55$tstat[which(ML55$EC == max(ML55$EC))]
"3.17"
SL50$tstat[which(SL50$EC == max(SL50$EC))]
"2.89"
SL55$tstat[which(SL55$EC == max(SL55$EC))]
"3.02 3.07"


# LC vs K1
ML50_MK50 = merge(ML50[ML50$tstat >= -1,],MK50[ML50$tstat >= -1,],all=T)
ML55_MK55 = merge(ML55[ML50$tstat >= -1,],MK55[ML50$tstat >= -1,],all=T)
SL50_SK50 = merge(SL50[ML50$tstat >= -1,],SK50[ML50$tstat >= -1,],all=T)
SL55_SK55 = merge(SL55[ML50$tstat >= -1,],SK55[ML50$tstat >= -1,],all=T)

# Blur vs No Blur
MK55_MK50 = merge(MK55[ML50$tstat >= -1,],MK50[ML50$tstat >= -1,],all=T)
ML55_ML50 = merge(ML55[ML50$tstat >= -1,],ML50[ML50$tstat >= -1,],all=T)
SK55_SK50 = merge(SK55[ML50$tstat >= -1,],SK50[ML50$tstat >= -1,],all=T)
SL55_SL50 = merge(SL55[ML50$tstat >= -1,],SL50[ML50$tstat >= -1,],all=T)

# ME vs SE
MK50_SK50 = merge(MK50[ML50$tstat >= -1,],SK50[ML50$tstat >= -1,],all=T)
ML50_SL50 = merge(ML50[ML50$tstat >= -1,],SL50[ML50$tstat >= -1,],all=T)
MK55_SK55 = merge(MK55[ML50$tstat >= -1,],SK55[ML50$tstat >= -1,],all=T)
ML55_SL55 = merge(ML55[ML50$tstat >= -1,],SL55[ML50$tstat >= -1,],all=T)

# All ECs in one dataframe
all_A = merge(SL50[SL50$tstat >= -1,], ML50[ML50$tstat >= -1,],all=T)
all_B = merge(ML55[ML55$tstat >= -1,] ,MK50[MK50$tstat >= -1,],all=T)
all_ECs = merge(all_A, all_B, all=T)
all_ECs$group = 'A'
all_ECs$group[all_ECs$label == 'ML50'] = 'B'
all_ECs$group[all_ECs$label == 'ML55'] = 'C'
all_ECs$group[all_ECs$label == 'MK50'] = 'D'

# Reported lineplot
scale_length = 801
from_label = -1

ColorA = 'skyblue2'
ColorB = 'blue'
ColorC = brewer.pal(5, 'Greys')[3]
ColorD = 'indianred4'

text.cex = 1
linewidth = c(3,3,3,3)
baseColor = brewer.pal(5, 'Greys')[3]
stdColor = 'black'
ylims = c(-900,800)
xlims = c(-600,600)

lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB,ColorC,ColorD), lty = c(1,1,1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB,ColorC,ColorD), fill = c(ColorA,ColorB,ColorC,ColorD), pch = c(20,20,20,20)),
  axis.line = list(lwd = 2), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 2, text = list(c("SE LC", "ME LC", "ME LC b5", "ME K1"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB,ColorC,ColorD), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .8, size = 4))
lineplotBand(EC~tstat, data = all_ECs, groups = group, par.settings = lp.par.settings, key = lp.key.settings, xlab = '', ylab = '', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')


# Paired lineplots
text.cex = 1
ColorA = 'indianred4' # LC ME
ColorA = 'indianred1' # LC SE
ColorB = 'indianred4' # LC ME
ColorB = 'indianred1' # LC SE

ColorA = 'royalblue3' # K1 ME
ColorA = 'steelblue1' # K1 SE
ColorB = 'royalblue3' # K1 ME
ColorB = 'steelblue1' # K1 SE
linewidth = c(1.5,4) # 1.5 = no blur; 4 = 5mm blur
baseColor = brewer.pal(5, 'Greys')[3]
stdColor = 'black'
ylims = c(-950,999)


# LC vs K1
ColorA = 'royalblue3'; ColorB = 'indianred4'; linewidth = c(2,2)
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB), fill = c(ColorA,ColorB), pch = c(20,20)),
  axis.line = list(lwd = 2), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 2, text = list(c("ME LC","ME K1"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(EC~tstat, data = ML50_MK50, groups = label, par.settings = lp.par.settings, key = lp.key.settings, xlab = '', ylab = '', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

ColorA = 'royalblue3'; ColorB = 'indianred4'; linewidth = c(2,2)
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB), fill = c(ColorA,ColorB), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 2, text = list(c("ME LC 5mm","ME K1 5mm"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(EC~tstat, data = ML55_MK55, groups = label, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

ColorA = 'royalblue3'; ColorB = 'indianred4'; linewidth = c(2,2)
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB), fill = c(ColorA,ColorB), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 2, text = list(c("SE LC","SE K1"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(EC~tstat, data = SL50_SK50, groups = label, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

ColorA = 'royalblue3'; ColorB = 'indianred4'; linewidth =  c(2,2)
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB), fill = c(ColorA,ColorB), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 2, text = list(c("SE LC 5mm","SE K1 5mm"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(EC~tstat, data = SL55_SK55, groups = label, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')


# Blur vs No Blur
ColorA = 'royalblue3'; ColorB = brewer.pal(5, 'Greys')[3]; linewidth = c(2,2)
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB), fill = c(ColorA,ColorB), pch = c(20,20)),
  axis.line = list(lwd = 2), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("ME LC 5mm","ME LC"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(EC~tstat, data = ML55_ML50, groups = label, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

ColorA = 'indianred4'; ColorB = brewer.pal(5, 'Greys')[3]; linewidth = c(2,2)
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB), fill = c(ColorA,ColorB), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("ME K1 5mm","ME K1"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(EC~tstat, data = MK55_MK50, groups = label, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

ColorA = 'indianred4'; ColorB = brewer.pal(5, 'Greys')[3]; linewidth = c(2,2)
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB), fill = c(ColorA,ColorB), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("SE K1 5mm","SE K1"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(EC~tstat, data = SK55_SK50, groups = label, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

ColorA = 'royalblue3'; ColorB = brewer.pal(5, 'Greys')[3]; linewidth = c(2,2)
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB), fill = c(ColorA,ColorB), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("SE LC 5mm","SE LC"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(EC~tstat, data = SL55_SL50, groups = label, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')


# ME vs SE
ColorA = 'royalblue3'; ColorB = 'skyblue'; linewidth = c(2,2)
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB), fill = c(ColorA,ColorB), pch = c(20,20)),
  axis.line = list(lwd = 2), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("ME LC","SE LC"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(EC~tstat, data = ML50_SL50, groups = label, par.settings = lp.par.settings, key = lp.key.settings, xlab = '', ylab = '', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

ColorA = 'indianred4'; ColorB = 'indianred2'; linewidth = c(2,2)
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB), fill = c(ColorA,ColorB), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("ME K1","SE K1"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(EC~tstat, data = MK50_SK50, groups = label, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

ColorA = 'indianred4'; ColorB = 'indianred2'; linewidth = c(2,2)
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB), fill = c(ColorA,ColorB), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("ME K1 5mm","SE K1 5mm"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(EC~tstat, data = MK55_SK55, groups = label, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

ColorA = 'royalblue3'; ColorB = 'skyblue'; linewidth = c(2,2)
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = linewidth, col = c(ColorA,ColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(ColorA,ColorB), fill = c(ColorA,ColorB), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("ME LC 5mm","SE LC 5mm"), cex = text.cex), rectangles = list(col = c(ColorA,ColorB), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(EC~tstat, data = ML55_SL55, groups = label, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')


# Create difference curves
# LC vs K1
diff.ML50_MK50 = data.frame(tstat=seq(from_label,7,.01), diff = ML50$EC-MK50$EC)
diff.ML55_MK55 = data.frame(tstat=seq(from_label,7,.01), diff = ML55$EC-MK55$EC)
diff.SL50_SK50 = data.frame(tstat=seq(from_label,7,.01), diff = SL50$EC-SK50$EC)
diff.SL55_SK55 = data.frame(tstat=seq(from_label,7,.01), diff = SL55$EC-SK55$EC)

# Blur vs No Blur
diff.MK55_MK50 = data.frame(tstat=seq(from_label,7,.01), diff = MK55$EC-MK50$EC)
diff.ML55_ML50 = data.frame(tstat=seq(from_label,7,.01), diff = ML55$EC-ML50$EC)
diff.SK55_SK50 = data.frame(tstat=seq(from_label,7,.01), diff = SK55$EC-SK50$EC)
diff.SL55_SL50 = data.frame(tstat=seq(from_label,7,.01), diff = SL55$EC-SL50$EC)

# ME vs SE
diff.MK50_SK50 = data.frame(tstat=seq(from_label,7,.01), diff = MK50$EC-SK50$EC)
diff.ML50_SL50 = data.frame(tstat=seq(from_label,7,.01), diff = ML50$EC-SL50$EC)
diff.MK55_SK55 = data.frame(tstat=seq(from_label,7,.01), diff = MK55$EC-SK55$EC)
diff.ML55_SL55 = data.frame(tstat=seq(from_label,7,.01), diff = ML55$EC-SL55$EC)

# t-stats for comparisons (i.e., what's the t-stat where the maps are maximally different?)
diff.ML50_MK50.abs = abs(diff.ML50_MK50)
diff.ML50_MK50.abs$tstat[which(diff.ML50_MK50.abs$diff == max(diff.ML50_MK50.abs))]
"3.51"

diff.ML50_SL50.abs = abs(diff.ML50_SL50)
diff.ML50_SL50.abs$tstat[which(diff.ML50_SL50.abs$diff == max(diff.ML50_SL50.abs))]
"1.74"

max(diff.ML50_SL50)
"866"
min(diff.ML50_SL50)
"-1199"

diff.ML55_ML50.abs = abs(diff.ML55_ML50)
diff.ML55_ML50.abs$tstat[which(diff.ML55_ML50.abs$diff == max(diff.ML55_ML50.abs))]
"2.16"

# Lineplot
text.cex = 1
linewidth = 2
baseColor = brewer.pal(5, 'Greys')[5]
stdColor = 'black'
ylims = c(-1250,1200)

lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = rep(linewidth,2), col = c(baseColor), lty = c(1,1,1)), 
  superpose.symbol = list(col = c(baseColor), fill = c(baseColor), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = baseColor, lwd = linewidth), 
  plot.line = list(col = baseColor, lwd = linewidth), 
  plot.symbol = list(col = baseColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))

# LC vs K1
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("ML50_MK50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(diff~tstat, data = diff.ML50_MK50, par.settings = lp.par.settings, xlab = '', ylab = '', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("ML55_MK55"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(diff~tstat, data = diff.ML55_MK55, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic Difference', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("SL50_SK50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(diff~tstat, data = diff.SL50_SK50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic Difference', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("SL55_SK55"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(diff~tstat, data = diff.SL55_SK55, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic Difference', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

# Blur vs No Blur
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("MK55_MK50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(diff~tstat, data = diff.MK55_MK50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic Difference', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("ML55_ML50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(diff~tstat, data = diff.ML55_ML50, par.settings = lp.par.settings, xlab = '', ylab = '', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("SK55_SK50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(diff~tstat, data = diff.SK55_SK50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic Difference', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("SL55_SL50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(diff~tstat, data = diff.SL55_SL50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic Difference', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

# ME vs SE
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("MK50_SK50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(diff~tstat, data = diff.MK50_SK50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic Difference', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("ML50_SL50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(diff~tstat, data = diff.ML50_SL50, par.settings = lp.par.settings, xlab = '', ylab = '', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("MK55_SK55"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(diff~tstat, data = diff.MK55_SK55, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic Difference', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("ML55_SL55"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(diff~tstat, data = diff.ML55_SL55, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = 'Euler Characteristic Difference', ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = scale_length, by = 100), label = as.ordered(seq(from = from_label, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')


# Absolute Euler Characteristic Differences
# LC vs K1
ylims=c(-30,500)
ylabel="Absolute EC Difference"
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("diff.ML50_MK50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(abs(diff)~tstat, data = diff.ML50_MK50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = ylabel, ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 1401, by = 100), label = as.ordered(seq(from = -7, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("diff.ML55_MK55"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(abs(diff)~tstat, data = diff.ML55_MK55, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = ylabel, ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 1401, by = 100), label = as.ordered(seq(from = -7, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("diff.SL50_SK50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(abs(diff)~tstat, data = diff.SL50_SK50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = ylabel, ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 1401, by = 100), label = as.ordered(seq(from = -7, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("diff.SL55_SK55"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(abs(diff)~tstat, data = diff.SL55_SK55, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = ylabel, ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 1401, by = 100), label = as.ordered(seq(from = -7, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

# Blur vs No Blur
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("diff.MK55_MK50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(abs(diff)~tstat, data = diff.MK55_MK50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = ylabel, ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 1401, by = 100), label = as.ordered(seq(from = -7, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("diff.ML55_ML50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(abs(diff)~tstat, data = diff.ML55_ML50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = ylabel, ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 1401, by = 100), label = as.ordered(seq(from = -7, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("diff.SK55_SK50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(abs(diff)~tstat, data = diff.SK55_SK50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = ylabel, ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 1401, by = 100), label = as.ordered(seq(from = -7, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("diff.SL55_SL50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(abs(diff)~tstat, data = diff.SL55_SL50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = ylabel, ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 1401, by = 100), label = as.ordered(seq(from = -7, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

# ME vs SE
lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("diff.MK50_SK50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(abs(diff)~tstat, data = diff.MK50_SK50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = ylabel, ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 1401, by = 100), label = as.ordered(seq(from = -7, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("diff.ML50_SL50"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(abs(diff)~tstat, data = diff.ML50_SL50, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = ylabel, ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 1401, by = 100), label = as.ordered(seq(from = -7, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("diff.MK55_SK55"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(abs(diff)~tstat, data = diff.MK55_SK55, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = ylabel, ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 1401, by = 100), label = as.ordered(seq(from = -7, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .05, y = .98, corner = c(0,1), border = "black", reverse.rows = F, padding.text = 3, text = list(c("diff.ML55_SL55"), cex = text.cex), rectangles = list(col = c(baseColor), cex = .75*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(abs(diff)~tstat, data = diff.ML55_SL55, par.settings = lp.par.settings, key = lp.key.settings, xlab = 't stat', ylab = ylabel, ylim = ylims, scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 1401, by = 100), label = as.ordered(seq(from = -7, to = 7, by = 1)), y = list(tck = c(.5,0)))), type = 'l')

