# Overlap analyses

# Load supplementary scripts & dependencies
setwd("/Users/hamid/Desktop/Research/+Scripts")
source("jzBarPlot.s")
source("lineplotBand.s")
library(RColorBrewer)

# Load in data
setwd("/Users/hamid/Desktop/Overlap")
#setwd("/Users/hamid/Desktop/Research/fMRI/LC Methods/rest_results/analysis/overlaps")
M.K1_LC.b5s0 = read.csv("compiled_M.K1_LC.b5s0.txt", header=T, sep=",")
M.K1_LC.b5s5 = read.csv("compiled_M.K1_LC.b5s5.txt", header=T, sep=",")
S.K1_LC.b5s0 = read.csv("compiled_S.K1_LC.b5s0.txt", header=T, sep=",")
S.K1_LC.b5s5 = read.csv("compiled_S.K1_LC.b5s5.txt", header=T, sep=",")
X.K1.b5s0 = read.csv("compiled_X.K1.b5s0.txt", header=T, sep=",")
X.K1.b5s5 = read.csv("compiled_X.K1.b5s5.txt", header=T, sep=",")
X.LC.b5s0 = read.csv("compiled_X.LC.b5s0.txt", header=T, sep=",")
X.LC.b5s5 = read.csv("compiled_X.LC.b5s5.txt", header=T, sep=",")
B.LC.b5s50 = read.csv("compiled_B.LC.b5s50.txt", header=T, sep=",")

PT.M.K1_LC.b5s0 = read.csv("compiled_PT.M.K1_LC.b5s0.txt", header=T, sep=",")
PT.M.K1_LC.b5s5 = read.csv("compiled_PT.M.K1_LC.b5s5.txt", header=T, sep=",")
PT.S.K1_LC.b5s0 = read.csv("compiled_PT.S.K1_LC.b5s0.txt", header=T, sep=",")
PT.S.K1_LC.b5s5 = read.csv("compiled_PT.S.K1_LC.b5s5.txt", header=T, sep=",")
PT.X.K1.b5s0 = read.csv("compiled_PT.X.K1.b5s0.txt", header=T, sep=",")
PT.X.K1.b5s5 = read.csv("compiled_PT.X.K1.b5s5.txt", header=T, sep=",")
PT.X.LC.b5s0 = read.csv("compiled_PT.X.LC.b5s0.txt", header=T, sep=",")
PT.X.LC.b5s5 = read.csv("compiled_PT.X.LC.b5s5.txt", header=T, sep=",")

M.K1_LC.b5s0$Perc = rep(0:99, 20)
M.K1_LC.b5s5$Perc = rep(0:99, 20)
S.K1_LC.b5s0$Perc = rep(0:99, 20)
S.K1_LC.b5s5$Perc = rep(0:99, 20)
X.K1.b5s0$Perc = rep(0:99, 20)
X.K1.b5s5$Perc = rep(0:99, 20)
X.LC.b5s0$Perc = rep(0:99, 20)
X.LC.b5s5$Perc = rep(0:99, 20)
B.LC.b5s50$Perc = rep(0:99, 20)

PT.M.K1_LC.b5s0$Perc = rep(0:99, 200)
PT.M.K1_LC.b5s5$Perc = rep(0:99, 200)
PT.S.K1_LC.b5s0$Perc = rep(0:99, 200)
PT.S.K1_LC.b5s5$Perc = rep(0:99, 200)
PT.X.K1.b5s0$Perc = rep(0:99, 200)
PT.X.K1.b5s5$Perc = rep(0:99, 200)
PT.X.LC.b5s0$Perc = rep(0:99, 200)
PT.X.LC.b5s5$Perc = rep(0:99, 200)

# Format stacks
stack.overlaps.method <- data.frame(
  subid = as.factor(rep(sort(unique(M.K1_LC.b5s0$Subj)), each=100)),
  perc = as.factor(rep(0:99)),
  prep = as.factor(rep(c('M','S'), each=100*20)),
  blur = as.factor(rep(c('b5s0','b5s5'), each=100*40)),
  dice = as.vector(c(M.K1_LC.b5s0$Dice, S.K1_LC.b5s0$Dice, M.K1_LC.b5s5$Dice, S.K1_LC.b5s5$Dice))
)

stack.overlaps.method.avg <- data.frame(
  prep = as.factor(rep(c('M','S'), each=100*2)),
  blur = as.factor(rep(c('b5s0','b5s5'), each=100)),
  perc = as.factor(rep(0:99)),
  dice = as.vector(with(stack.overlaps.method, tapply(dice, list(perc, blur), mean)))
)

stack.overlaps.prep <- data.frame(
  subid = as.factor(rep(sort(unique(M.K1_LC.b5s0$Subj)), each=100)),
  perc = as.factor(rep(0:99)),
  prep = as.factor(rep(c('K1','LC'), each=100*20)),
  blur = as.factor(rep(c('b5s0','b5s5'), each=100*40)),
  dice = as.vector(c(X.K1.b5s0$Dice, X.K1.b5s5$Dice, X.LC.b5s0$Dice, X.LC.b5s5$Dice))
)

stack.overlaps.prep.avg <- data.frame(
  prep = as.factor(rep(c('K1','LC'), each=100*2)),
  blur = as.factor(rep(c('b5s0','b5s5'), each=100)),
  perc = as.factor(rep(0:99)),
  dice = as.vector(with(stack.overlaps.prep, tapply(dice, list(perc, blur, prep), mean)))
)

# Format controls
stack.controls.method <- data.frame(
  subid = as.factor(rep(sort(unique(PT.M.K1_LC.b5s0$Subj)), each=100)),
  perc = as.factor(rep(0:99)),
  prep = as.factor(rep(c('M','S'), each=100*20)),
  blur = as.factor(rep(c('b5s0','b5s5'), each=100*40)),
  dice = as.vector(c(
    with(PT.M.K1_LC.b5s0, tapply(Dice, list(Perc,Subj), mean)),
    with(PT.S.K1_LC.b5s0, tapply(Dice, list(Perc,Subj), mean)),
    with(PT.M.K1_LC.b5s5, tapply(Dice, list(Perc,Subj), mean)),
    with(PT.S.K1_LC.b5s5, tapply(Dice, list(Perc,Subj), mean))
  ))
)

stack.controls.prep <- data.frame(
  subid = as.factor(rep(sort(unique(PT.M.K1_LC.b5s0$Subj)), each=100)),
  perc = as.factor(rep(0:99)),
  prep = as.factor(rep(c('K1','LC'), each=100*20)),
  blur = as.factor(rep(c('b5s0','b5s5'), each=100*40)),
  dice = as.vector(c(
    with(PT.X.K1.b5s0, tapply(Dice, list(Perc,Subj), mean)),
    with(PT.X.K1.b5s5, tapply(Dice, list(Perc,Subj), mean)),
    with(PT.X.LC.b5s5, tapply(Dice, list(Perc,Subj), mean)),
    with(PT.X.LC.b5s5, tapply(Dice, list(Perc,Subj), mean))
  ))
)


# Figures
text.cex = 1
linewidth = 4
prepColorA = 'green' #brewer.pal(5, 'Greys')[4]
prepColorB = 'red' #brewer.pal(5, 'Greys')[3]
stdColor = 'black'

lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = rep(linewidth,3), col = c(prepColorA,prepColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(prepColorA,prepColorB), fill = c(prepColorA,prepColorB), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = stdColor, lwd = linewidth), 
  plot.line = list(col = stdColor, lwd = linewidth), 
  plot.symbol = list(col = stdColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))

# Plot
lp.key.settings = list(x = .45, y = .95, corner = c(1,1), border = "black", reverse.rows = T, padding.text = 3, text = list(c("Multi", "Single"), cex = text.cex), rectangles = list(col = c(prepColorA,prepColorB), cex = .25*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(dice ~ perc | blur, group = prep, data = stack.overlaps.method, par.settings = lp.par.settings, key = lp.key.settings, xlab = 'Percentile', ylab = 'Overlap (Dice)', ylim = c(0,1), xlim = c(0, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 0, to = 100, by = 20)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .45, y = .95, corner = c(1,1), border = "black", reverse.rows = T, padding.text = 3, text = list(c("K1", "LC"), cex = text.cex), rectangles = list(col = c(prepColorA,prepColorB), cex = .25*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(dice ~ perc | blur, group = prep, data = stack.overlaps.prep, par.settings = lp.par.settings, key = lp.key.settings, xlab = 'Percentile', ylab = 'Overlap (Dice)', ylim = c(0,1), xlim = c(0, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 0, to = 100, by = 20)), y = list(tck = c(.5,0)))), type = 'l')


# Controls
# Figures
text.cex = 1
linewidth = 4
prepColorA = brewer.pal(5, 'Greys')[4]
prepColorB = brewer.pal(5, 'Greys')[3]
stdColor = 'black'

lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = rep(linewidth,3), col = c(prepColorA,prepColorB), lty = c(1,1)), 
  superpose.symbol = list(col = c(prepColorA,prepColorB), fill = c(prepColorA,prepColorB), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = stdColor, lwd = linewidth), 
  plot.line = list(col = stdColor, lwd = linewidth), 
  plot.symbol = list(col = stdColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))

# Plot
lp.key.settings = list(x = .45, y = .95, corner = c(1,1), border = "black", reverse.rows = T, padding.text = 3, text = list(c("Multi", "Single"), cex = text.cex), rectangles = list(col = c(prepColorA,prepColorB), cex = .25*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(dice ~ perc | blur, group = prep, data = stack.controls.method, par.settings = lp.par.settings, key = lp.key.settings, xlab = 'Percentile', ylab = 'Overlap (Dice)', ylim = c(0,1), xlim = c(0, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 0, to = 100, by = 20)), y = list(tck = c(.5,0)))), type = 'l')

lp.key.settings = list(x = .45, y = .95, corner = c(1,1), border = "black", reverse.rows = T, padding.text = 3, text = list(c("K1", "LC"), cex = text.cex), rectangles = list(col = c(prepColorA,prepColorB), cex = .25*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(dice ~ perc | blur, group = prep, data = stack.controls.prep, par.settings = lp.par.settings, key = lp.key.settings, xlab = 'Percentile', ylab = 'Overlap (Dice)', ylim = c(0,1), xlim = c(0, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 0, to = 100, by = 20)), y = list(tck = c(.5,0)))), type = 'l')



# True overlaps + Control overlaps
stack.method = stack.overlaps.method[!stack.overlaps.method$subid == 's17',]
stack.prep = stack.overlaps.prep[!stack.overlaps.prep$subid == 's17',]
stack.method$type = 'data'
stack.prep$type = 'data'
stack.controls.method$type = 'control'
stack.controls.prep$type = 'control'

method = merge.data.frame(stack.method, stack.controls.method, all=T)
prep = merge.data.frame(stack.prep, stack.controls.prep, all=T)

method$fac = 'M-data'
method$fac[method$prep == 'M' & method$type == 'control'] = 'M-control' 
method$fac[method$prep == 'S' & method$type == 'data'] = 'S-data' 
method$fac[method$prep == 'S' & method$type == 'control'] = 'S-control' 
prep$fac = 'K1-data'
prep$fac[prep$prep == 'K1' & prep$type == 'control'] = 'K1-control' 
prep$fac[prep$prep == 'LC' & prep$type == 'data'] = 'LC-data' 
prep$fac[prep$prep == 'LC' & prep$type == 'control'] = 'LC-control' 



# Controls
text.cex = 1
linewidth = 4
prepColorA = brewer.pal(5, 'Greys')[5]
prepColorB = 'green'
prepColorC = 'yellow'#brewer.pal(5, 'Greys')[3]
prepColorD = 'red'
stdColor = 'black'

lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = rep(linewidth,4), col = c(prepColorA,prepColorB,prepColorC,prepColorD), lty = c(1,1,2,2)), 
  superpose.symbol = list(col = c(prepColorA,prepColorB,prepColorC,prepColorD), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = stdColor, lwd = linewidth), 
  plot.line = list(col = stdColor, lwd = linewidth), 
  plot.symbol = list(col = stdColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray90"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))

# Plot
lp.key.settings = list(x = .45, y = .95, corner = c(1,1), border = "black", reverse.rows = T, padding.text = 3, text = list(c("M-cont", "M-data", "S-cont", "S-data"), cex = text.cex), rectangles = list(col = c(prepColorA,prepColorB,prepColorC,prepColorD), cex = .25*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(dice ~ perc | blur, group = fac, data = method, par.settings = lp.par.settings, key = lp.key.settings, xlab = 'Percentile', ylab = 'Overlap (Dice)', ylim = c(0,1), xlim = c(0, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 0, to = 100, by = 20)), y = list(tck = c(.5,0)))), type = 'l')

text.cex = 1
linewidth = 4
prepColorA = 'yellow'#brewer.pal(5, 'Greys')[3]
prepColorB = 'green'
prepColorC = brewer.pal(5, 'Greys')[5]
prepColorD = 'red'
stdColor = 'black'

lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = rep(linewidth,4), col = c(prepColorA,prepColorB,prepColorC,prepColorD), lty = c(1,1,2,2)), 
  superpose.symbol = list(col = c(prepColorA,prepColorB,prepColorC,prepColorD), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = stdColor, lwd = linewidth), 
  plot.line = list(col = stdColor, lwd = linewidth), 
  plot.symbol = list(col = stdColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray90"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))

lp.key.settings = list(x = .45, y = .95, corner = c(1,1), border = "black", reverse.rows = T, padding.text = 3, text = list(c("K1-cont", "K1-data", "LC-cont", "LC-data"), cex = text.cex), rectangles = list(col = c(prepColorA,prepColorB,prepColorC,prepColorD), cex = .25*c(1,1), lwd = rep(linewidth,2), height = .5, size = 2))
lineplotBand(dice ~ perc | blur, group = fac, data = prep, par.settings = lp.par.settings, key = lp.key.settings, xlab = 'Percentile', ylab = 'Overlap (Dice)', ylim = c(0,1), xlim = c(0, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 0, to = 100, by = 20)), y = list(tck = c(.5,0)))), type = 'l')


# iFC comparison figures
# ML50 vs MK50
stack.overlaps.ML50_MK50 <- data.frame(
  subid = as.factor(rep(sort(unique(M.K1_LC.b5s0$Subj)), each=100)),
  perc = as.factor(rep(0:99)),
  dice = as.vector(c(M.K1_LC.b5s0$Dice))
)

# ML50 vs ML55
stack.overlaps.ML50_ML55 <- data.frame(
  subid = as.factor(rep(sort(unique(B.LC.b5s50$Subj)), each=100)),
  perc = as.factor(rep(0:99)),
  dice = as.vector(c(B.LC.b5s50$Dice))
)

# ML50 vs SL50
stack.overlaps.ML50_SL50 <- data.frame(
  subid = as.factor(rep(sort(unique(X.LC.b5s0$Subj)), each=100)),
  perc = as.factor(rep(0:99)),
  dice = as.vector(c(X.LC.b5s0$Dice))
)

mean(stack.overlaps.ML50_MK50$dice[stack.overlaps.ML50_MK50$perc == 85])
"0.3195183"

mean(stack.overlaps.ML50_ML55$dice[stack.overlaps.ML50_ML55$perc == 85])
"0.9285702"

mean(stack.overlaps.ML50_SL50$dice[stack.overlaps.ML50_SL50$perc == 85])
"0.2027971"

# Figures
text.cex = 1
linewidth = 2.5
stdColor = 'black'
K1color='indianred4'
LCcolor='skyblue3'
Xcolor=brewer.pal(5, 'Greys')[4]

thiscolor=LCcolor
lp.par.settings = list(
  add.text = list(cex=text.cex), 
  superpose.line = list(lwd = rep(linewidth,3), col = c(thiscolor), lty = c(1,1)), 
  superpose.symbol = list(col = c(thiscolor), fill = c(thiscolor), pch = c(20,20)),
  axis.line = list(lwd = linewidth), 
  add.line = list(col = stdColor, lwd = linewidth), 
  plot.line = list(col = thiscolor, lwd = linewidth), 
  plot.symbol = list(col = stdColor, lwd = linewidth, cex=text.cex, pch = 16), 
  strip.border = list(col = rep("black",8), lwd = linewidth), 
  strip.background = list(col = "gray"), 
  par.ylab.text = list(cex=text.cex), 
  par.xlab.text = list(cex=text.cex), 
  par.strip.text = list(cex=text.cex),
  par.main.text = list(cex=text.cex),
  axis.text = list(cex=text.cex))


# Plot
lineplotBand(dice ~ perc, data = stack.overlaps.ML50_MK50, par.settings = lp.par.settings, xlab = 'Percentile', ylab = 'Overlap (Dice)', ylim = c(0,1), xlim = c(0, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 0, to = 100, by = 20)), y = list(tck = c(.5,0)))), type = 'l')
lineplotBand(dice ~ perc, data = stack.overlaps.ML50_ML55, par.settings = lp.par.settings, xlab = 'Percentile', ylab = 'Overlap (Dice)', ylim = c(0,1), xlim = c(0, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 0, to = 100, by = 20)), y = list(tck = c(.5,0)))), type = 'l')
lineplotBand(dice ~ perc, data = stack.overlaps.ML50_SL50, par.settings = lp.par.settings, xlab = 'Percentile', ylab = 'Overlap (Dice)', ylim = c(0,1), xlim = c(0, 100), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 100, by = 20), label = (seq(from = 0, to = 100, by = 20)), y = list(tck = c(.5,0)))), type = 'l')
