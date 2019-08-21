# tempAttnAudT resting state ROI seed time series analyses
# By HBT, Oct 8 2018

# Load supplementary scripts & dependencies
setwd("/Users/hamid/Desktop/Research/+Scripts")
source("jzBarPlot.s")
source("lineplotBand.s")
library(RColorBrewer)

# Load data
setwd("/Users/hamid/Desktop/Research/fMRI/LC Methods/rest_results/ROI quality check/")
seeds.df = read.delim("compiled_ROIqualitycheck.WM_1.GSR_0.txt", header=T, sep=",")
dvars.df = read.delim("compiled_dvars_tproj.wmr1_gsr0.txt", header=T, sep=",")
dvars.df = read.delim("compiled_srms_tproj.wmr1_gsr0.txt", header=T, sep=",")


# Format to wide
seeds.wide.echo2.df <- data.frame(
  subj = factor(rep(c("7","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27"), each=202)),
  K1.b0 = as.vector(seeds.df$Beta[seeds.df$Prep == 'echo2' & seeds.df$ROI == 'K1' & seeds.df$Blur == 'Blur0']),
  K1.b5 = as.vector(seeds.df$Beta[seeds.df$Prep == 'echo2' & seeds.df$ROI == 'K1' & seeds.df$Blur == 'Blur5']),
  K2.b0 = as.vector(seeds.df$Beta[seeds.df$Prep == 'echo2' & seeds.df$ROI == 'K2' & seeds.df$Blur == 'Blur0']),
  K2.b5 = as.vector(seeds.df$Beta[seeds.df$Prep == 'echo2' & seeds.df$ROI == 'K2' & seeds.df$Blur == 'Blur5']),
  PT.b0 = as.vector(seeds.df$Beta[seeds.df$Prep == 'echo2' & seeds.df$ROI == 'PT' & seeds.df$Blur == 'Blur0']),
  PT.b5 = as.vector(seeds.df$Beta[seeds.df$Prep == 'echo2' & seeds.df$ROI == 'PT' & seeds.df$Blur == 'Blur5']),
  LC.b0 = as.vector(seeds.df$Beta[seeds.df$Prep == 'echo2' & seeds.df$ROI == 'LC' & seeds.df$Blur == 'Blur0']),
  LC.b5 = as.vector(seeds.df$Beta[seeds.df$Prep == 'echo2' & seeds.df$ROI == 'LC' & seeds.df$Blur == 'Blur5'])
)
seeds.wide.echo2.df$K1_LC.b0 = seeds.wide.echo2.df$K1.b0 - seeds.wide.echo2.df$LC.b0
seeds.wide.echo2.df$K1_LC.b5 = seeds.wide.echo2.df$K1.b5 - seeds.wide.echo2.df$LC.b5
seeds.wide.echo2.df$K2_LC.b0 = seeds.wide.echo2.df$K2.b0 - seeds.wide.echo2.df$LC.b0
seeds.wide.echo2.df$K2_LC.b5 = seeds.wide.echo2.df$K2.b5 - seeds.wide.echo2.df$LC.b5


seeds.wide.medn.df <- data.frame(
  subj = factor(rep(c("7","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27"), each=202)),
  K1.b0 = as.vector(seeds.df$Beta[seeds.df$Prep == 'medn' & seeds.df$ROI == 'K1' & seeds.df$Blur == 'Blur0']),
  K1.b5 = as.vector(seeds.df$Beta[seeds.df$Prep == 'medn' & seeds.df$ROI == 'K1' & seeds.df$Blur == 'Blur5']),
  K2.b0 = as.vector(seeds.df$Beta[seeds.df$Prep == 'medn' & seeds.df$ROI == 'K2' & seeds.df$Blur == 'Blur0']),
  K2.b5 = as.vector(seeds.df$Beta[seeds.df$Prep == 'medn' & seeds.df$ROI == 'K2' & seeds.df$Blur == 'Blur5']),
  PT.b0 = as.vector(seeds.df$Beta[seeds.df$Prep == 'medn' & seeds.df$ROI == 'PT' & seeds.df$Blur == 'Blur0']),
  PT.b5 = as.vector(seeds.df$Beta[seeds.df$Prep == 'medn' & seeds.df$ROI == 'PT' & seeds.df$Blur == 'Blur5']),
  LC.b0 = as.vector(seeds.df$Beta[seeds.df$Prep == 'medn' & seeds.df$ROI == 'LC' & seeds.df$Blur == 'Blur0']),
  LC.b5 = as.vector(seeds.df$Beta[seeds.df$Prep == 'medn' & seeds.df$ROI == 'LC' & seeds.df$Blur == 'Blur5'])
)
seeds.wide.medn.df$K1_LC.b0 = seeds.wide.medn.df$K1.b0 - seeds.wide.medn.df$LC.b0
seeds.wide.medn.df$K1_LC.b5 = seeds.wide.medn.df$K1.b5 - seeds.wide.medn.df$LC.b5
seeds.wide.medn.df$K2_LC.b0 = seeds.wide.medn.df$K2.b0 - seeds.wide.medn.df$LC.b0
seeds.wide.medn.df$K2_LC.b5 = seeds.wide.medn.df$K2.b5 - seeds.wide.medn.df$LC.b5




dvars.wide.wholebrain.df <- data.frame(
  subj = factor(rep(c("7","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27"), each=202)),
  TR = 1:202,
  SE.b0 = as.vector(dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'whole' & dvars.df$Blur == 0]),
  SE.b5 = as.vector(dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'whole' & dvars.df$Blur == 5]),
  ME.b0 = as.vector(dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'whole' & dvars.df$Blur == 0]),
  ME.b5 = as.vector(dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'whole' & dvars.df$Blur == 5])
)

dvars.stack.wholebrain.df <- data.frame(
  subj = factor(rep(c("7","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27"), each=202*4)),
  TR = factor(rep(c(1:202), 4)),
  prep = factor(rep(c("ME", "ME b5", "SE", "SE b5"), each=202)),
  dvars = as.vector(c(dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'whole' & dvars.df$Blur == 0],
                      dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'whole' & dvars.df$Blur == 5],
                      dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'whole' & dvars.df$Blur == 0],
                      dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'whole' & dvars.df$Blur == 5]))
)

with(dvars.stack.wholebrain.df, tapply(dvars, prep, mean))
"      ME    ME b5       SE    SE b5 
2.462974 2.454760 1.986980 2.172437  "

with(dvars.stack.wholebrain.df, tapply(dvars, prep, sd))
"      ME    ME b5       SE    SE b5 
2.537710 2.514619 2.106837 2.408402 "

dvars.stack2.wholebrain.df <- data.frame(
  subj = factor(rep(c("7","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27"), each=202*2)),
  TR = factor(rep(c(1:202), 2)),
  prep = factor(rep(c("ME", "SE"), each=202*2)),
  blur = factor(rep(c(0, 5), each=202)),
  dvars = as.vector(c(dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'whole' & dvars.df$Blur == 0],
                      dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'whole' & dvars.df$Blur == 5],
                      dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'whole' & dvars.df$Blur == 0],
                      dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'whole' & dvars.df$Blur == 5]))
)

with(dvars.stack2.wholebrain.df, tapply(dvars, list(prep,blur), mean))
"          0        5
ME 2.462974 2.454760
SE 1.986980 2.172437"

dvars_aov <- aov(dvars ~ prep*blur+Error(subj/(prep*blur)), data=dvars.stack2.wholebrain.df)
summary(dvars_aov)
"Error: subj
          Df Sum Sq Mean Sq F value Pr(>F)
prep       1    581   580.8   1.409  0.251
Residuals 18   7418   412.1               

Error: subj:blur
Df Sum Sq Mean Sq F value Pr(>F)
blur       1   31.7   31.73   0.391  0.540
prep:blur  1   37.9   37.88   0.467  0.503
Residuals 18 1460.8   81.15               

Error: Within
Df Sum Sq Mean Sq F value Pr(>F)
Residuals 16120  84028   5.213    "

dvars.wide.echo2.df <- data.frame(
  subj = factor(rep(c("7","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27"), each=202)),
  K1.b0 = as.vector(dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'K1' & dvars.df$Blur == 0]),
  K1.b5 = as.vector(dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'K1' & dvars.df$Blur == 5]),
  K2.b0 = as.vector(dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'K2' & dvars.df$Blur == 0]),
  K2.b5 = as.vector(dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'K2' & dvars.df$Blur == 5]),
  PT.b0 = as.vector(dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'PT' & dvars.df$Blur == 0]),
  PT.b5 = as.vector(dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'PT' & dvars.df$Blur == 5]),
  LC.b0 = as.vector(dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'LC' & dvars.df$Blur == 0]),
  LC.b5 = as.vector(dvars.df$Beta[dvars.df$Prep == 'SE' & dvars.df$ROI == 'LC' & dvars.df$Blur == 5])
)

dvars.wide.medn.df <- data.frame(
  subj = factor(rep(c("7","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27"), each=202)),
  K1.b0 = as.vector(dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'K1' & dvars.df$Blur == 0]),
  K1.b5 = as.vector(dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'K1' & dvars.df$Blur == 5]),
  K2.b0 = as.vector(dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'K2' & dvars.df$Blur == 0]),
  K2.b5 = as.vector(dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'K2' & dvars.df$Blur == 5]),
  PT.b0 = as.vector(dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'PT' & dvars.df$Blur == 0]),
  PT.b5 = as.vector(dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'PT' & dvars.df$Blur == 5]),
  LC.b0 = as.vector(dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'LC' & dvars.df$Blur == 0]),
  LC.b5 = as.vector(dvars.df$Beta[dvars.df$Prep == 'ME' & dvars.df$ROI == 'LC' & dvars.df$Blur == 5])
)

################################## Correlation
corr.echo2.df <- data.frame(
  subj = factor(rep(c("10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","7","9"), 16)),
  pair = factor(rep(c("K1,K2", "PT,K1", "PT,K2", "PT,LC", "LC,K1", "LC,K2","K1_LC,PT","K2_LC,PT"), each=40)),
  blur = factor(rep(c("blur0", "blur5"), each=20)),
  rho = c(as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) cor(seeds.wide.echo2.df$K1.b0, seeds.wide.echo2.df$K2.b0))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) cor(seeds.wide.echo2.df$K1.b5, seeds.wide.echo2.df$K2.b5))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) cor(seeds.wide.echo2.df$PT.b0, seeds.wide.echo2.df$K1.b0))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) cor(seeds.wide.echo2.df$PT.b5, seeds.wide.echo2.df$K1.b5))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) cor(seeds.wide.echo2.df$PT.b0, seeds.wide.echo2.df$K2.b0))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) cor(seeds.wide.echo2.df$PT.b5, seeds.wide.echo2.df$K2.b5))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) cor(seeds.wide.echo2.df$PT.b0, seeds.wide.echo2.df$LC.b0))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) cor(seeds.wide.echo2.df$PT.b5, seeds.wide.echo2.df$LC.b5))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) cor(seeds.wide.echo2.df$LC.b0, seeds.wide.echo2.df$K1.b0))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) cor(seeds.wide.echo2.df$LC.b5, seeds.wide.echo2.df$K1.b5))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) cor(seeds.wide.echo2.df$LC.b0, seeds.wide.echo2.df$K2.b0))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) cor(seeds.wide.echo2.df$LC.b5, seeds.wide.echo2.df$K2.b5))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), 
                           function(seeds.wide.echo2.df) cor(resid(lm(seeds.wide.echo2.df$K1.b0~seeds.wide.echo2.df$LC.b0)), 
                                                             resid(lm(seeds.wide.echo2.df$PT.b0~seeds.wide.echo2.df$LC.b0))))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), 
                           function(seeds.wide.echo2.df) cor(resid(lm(seeds.wide.echo2.df$K1.b5~seeds.wide.echo2.df$LC.b5)), 
                                                             resid(lm(seeds.wide.echo2.df$PT.b5~seeds.wide.echo2.df$LC.b5))))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), 
                           function(seeds.wide.echo2.df) cor(resid(lm(seeds.wide.echo2.df$K2.b0~seeds.wide.echo2.df$LC.b0)), 
                                                             resid(lm(seeds.wide.echo2.df$PT.b0~seeds.wide.echo2.df$LC.b0))))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), 
                           function(seeds.wide.echo2.df) cor(resid(lm(seeds.wide.echo2.df$K2.b5~seeds.wide.echo2.df$LC.b5)), 
                                                             resid(lm(seeds.wide.echo2.df$PT.b5~seeds.wide.echo2.df$LC.b5))))))
)
corr.echo2.df$zrho = atanh(corr.echo2.df$rho)

corr.medn.df <- data.frame(
  subj = factor(rep(c("10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","7","9"), 16)),
  pair = factor(rep(c("K1,K2", "PT,K1", "PT,K2", "PT,LC", "LC,K1", "LC,K2","K1_LC,PT","K2_LC,PT"), each=40)),
  blur = factor(rep(c("blur0", "blur5"), each=20)),
  rho = c(as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) cor(seeds.wide.medn.df$K1.b0, seeds.wide.medn.df$K2.b0))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) cor(seeds.wide.medn.df$K1.b5, seeds.wide.medn.df$K2.b5))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) cor(seeds.wide.medn.df$PT.b0, seeds.wide.medn.df$K1.b0))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) cor(seeds.wide.medn.df$PT.b5, seeds.wide.medn.df$K1.b5))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) cor(seeds.wide.medn.df$PT.b0, seeds.wide.medn.df$K2.b0))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) cor(seeds.wide.medn.df$PT.b5, seeds.wide.medn.df$K2.b5))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) cor(seeds.wide.medn.df$PT.b0, seeds.wide.medn.df$LC.b0))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) cor(seeds.wide.medn.df$PT.b5, seeds.wide.medn.df$LC.b5))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) cor(seeds.wide.medn.df$LC.b0, seeds.wide.medn.df$K1.b0))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) cor(seeds.wide.medn.df$LC.b5, seeds.wide.medn.df$K1.b5))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) cor(seeds.wide.medn.df$LC.b0, seeds.wide.medn.df$K2.b0))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) cor(seeds.wide.medn.df$LC.b5, seeds.wide.medn.df$K2.b5))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), 
                           function(seeds.wide.medn.df) cor(resid(lm(seeds.wide.medn.df$K1.b0~seeds.wide.medn.df$LC.b0)), 
                                                            resid(lm(seeds.wide.medn.df$PT.b0~seeds.wide.medn.df$LC.b0))))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), 
                           function(seeds.wide.medn.df) cor(resid(lm(seeds.wide.medn.df$K1.b5~seeds.wide.medn.df$LC.b5)), 
                                                            resid(lm(seeds.wide.medn.df$PT.b5~seeds.wide.medn.df$LC.b5))))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), 
                           function(seeds.wide.medn.df) cor(resid(lm(seeds.wide.medn.df$K2.b0~seeds.wide.medn.df$LC.b0)), 
                                                            resid(lm(seeds.wide.medn.df$PT.b0~seeds.wide.medn.df$LC.b0))))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), 
                           function(seeds.wide.medn.df) cor(resid(lm(seeds.wide.medn.df$K2.b5~seeds.wide.medn.df$LC.b5)), 
                                                            resid(lm(seeds.wide.medn.df$PT.b5~seeds.wide.medn.df$LC.b5))))))
)
corr.medn.df$zrho = atanh(corr.medn.df$rho)




############################################################################################## Analyses
# DVARS
# Controls
text.cex = 1
linewidth = 4
prepColorA = 'blue'
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
lineplotBand(dvars ~ TR | prep, data = dvars.stack.wholebrain.df, par.settings = lp.par.settings, xlab = 'TR', ylab = 'DVARS', ylim = c(0,4), xlim = c(0, 202), scales = list(x = list(tck = c(.5,0), at = seq(from = 0, to = 202, by = 20), label = (seq(from = 0, to = 202, by = 20)), y = list(tck = c(.5,0)))), type = 'l')



# Correlations ROI x DVARS
with(dvars.wide.wholebrain.df, tapply())


# Correlations between ROIs
tanh(with(corr.echo2.df, tapply(zrho, list(blur, pair), mean)))
"       K1_LC,PT     K1,K2  K2_LC,PT     LC,K1     LC,K2     PT,K1     PT,K2    PT,LC
blur0 0.3841274 0.8604198 0.4578820 0.1245218 0.1358187 0.3989005 0.4704524 0.157529
blur5 0.5841151 0.9440179 0.6494079 0.2442770 0.2783564 0.6137179 0.6794559 0.262087"

tanh(with(corr.echo2.df, tapply(zrho, list(blur, pair), sd)))
"       K1_LC,PT     K1,K2  K2_LC,PT     LC,K1     LC,K2     PT,K1     PT,K2     PT,LC
blur0 0.2238837 0.1920723 0.2516636 0.1573949 0.1826242 0.2235657 0.2544134 0.1656902
blur5 0.2520991 0.2108698 0.2722939 0.1628928 0.2063715 0.2565942 0.2776101 0.1894100"

tanh(with(corr.medn.df, tapply(zrho, list(blur, pair), mean)))
"       K1_LC,PT     K1,K2  K2_LC,PT     LC,K1     LC,K2     PT,K1     PT,K2     PT,LC
blur0 0.6276775 0.9474178 0.6817892 0.3424493 0.3939582 0.6835835 0.7375806 0.3659902
blur5 0.6609336 0.9617499 0.7172376 0.3899014 0.4349549 0.7197683 0.7709820 0.3887177"

tanh(with(corr.medn.df, tapply(zrho, list(blur, pair), sd)))
"       K1_LC,PT     K1,K2  K2_LC,PT     LC,K1     LC,K2     PT,K1     PT,K2     PT,LC
blur0 0.2488890 0.2937796 0.2854599 0.2657913 0.2866513 0.2270118 0.2485878 0.2818723
blur5 0.2525159 0.2750679 0.2856205 0.2690038 0.2936716 0.2235018 0.2450369 0.2769813"


summary(aov(tanh(zrho)~blur*pair+Error(subj/(blur*pair)), data=corr.echo2.df))
summary(aov(tanh(zrho)~blur*pair+Error(subj/(blur*pair)), data=corr.medn.df))


# Set up dataframe for ANOVA
mmr_se <- corr.echo2.df[corr.echo2.df$pair == 'PT,K1' | corr.echo2.df$pair == 'PT,LC',]
mmr_me <- corr.medn.df[corr.medn.df$pair == 'PT,K1' | corr.medn.df$pair == 'PT,LC',]
mmr_se$roi = 'K1'; mmr_se$roi[mmr_se$pair == 'PT,LC'] = 'LC';
mmr_me$roi = 'K1'; mmr_me$roi[mmr_me$pair == 'PT,LC'] = 'LC';
mmr_se$prep = 'SE'; mmr_me$prep = 'ME';
mmr <- merge(mmr_se, mmr_me, all=T)

# Main marginal means
with(mmr, tapply(zrho, list(roi), mean))
"       K1        LC 
0.7200448 0.3053184"
with(mmr, tapply(zrho, list(prep), mean))
"       ME        SE 
0.6342620 0.3911011"
with(mmr, tapply(zrho, list(blur), mean))
"    blur0     blur5 
0.4501970 0.5751662 "

# Two-way
with(mmr, tapply(zrho, list(roi, prep), mean))
"          ME        SE
K1 0.8714872 0.5686024
LC 0.3970369 0.2135999"
with(mmr, tapply(zrho, list(roi, blur), mean))
"       blur0     blur5
K1 0.6290755 0.8110141
LC 0.2713185 0.3393183"
with(mmr, tapply(zrho, list(prep, blur), mean))
"       blur0     blur5
ME 0.6097977 0.6587263
SE 0.2905962 0.4916060"

# Three-way
with(mmr, tapply(zrho, list(roi, prep, blur), mean))
", , blur0
          ME        SE
K1 0.8358103 0.4223407
LC 0.3837852 0.1588518

, , blur5
          ME       SE
K1 0.9071641 0.714864
LC 0.4102886 0.268348"

mmr_lreg <- lm(zrho ~ roi+prep+blur, data = mmr)
summary(mmr_lreg)
"lm(formula = zrho ~ roi + prep + blur, data = mmr)

Residuals:
Min       1Q   Median       3Q      Max 
-0.60806 -0.17596  0.00316  0.17169  0.60643 

Coefficients:
Estimate Std. Error t value Pr(>|t|)    
(Intercept)   0.7791     0.0384  20.291  < 2e-16 ***
roiLC        -0.4147     0.0384 -10.801  < 2e-16 ***
prepSE       -0.2432     0.0384  -6.333 2.45e-09 ***
blurblur5     0.1250     0.0384   3.255  0.00139 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2429 on 156 degrees of freedom
Multiple R-squared:  0.5175,	Adjusted R-squared:  0.5083 
F-statistic: 55.78 on 3 and 156 DF,  p-value: < 2.2e-16"

with(mmr, tapply(zrho, list(blur), mean))
"    blur0     blur5 
0.4501970 0.5751662 "

mmr_aov <- aov(zrho ~ roi*prep*blur+Error(subj/(roi*prep*blur)), data=mmr)
summary(mmr_aov)
"Error: subj
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals 19  3.192   0.168               

Error: subj:roi
Df Sum Sq Mean Sq F value   Pr(>F)    
roi        1  6.880   6.880   54.18 5.64e-07 ***
Residuals 19  2.413   0.127                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: subj:prep
Df Sum Sq Mean Sq F value   Pr(>F)    
prep       1  2.365  2.3651   27.06 5.07e-05 ***
Residuals 19  1.660  0.0874                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: subj:blur
Df Sum Sq Mean Sq F value   Pr(>F)    
blur       1 0.6247  0.6247   231.4 4.31e-12 ***
Residuals 19 0.0513  0.0027                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: subj:roi:prep
Df Sum Sq Mean Sq F value Pr(>F)
roi:prep   1 0.1427 0.14268   2.172  0.157
Residuals 19 1.2481 0.06569               

Error: subj:roi:blur
Df  Sum Sq Mean Sq F value   Pr(>F)    
roi:blur   1 0.12982 0.12982   72.79 6.36e-08 ***
Residuals 19 0.03388 0.00178                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: subj:prep:blur
Df  Sum Sq Mean Sq F value   Pr(>F)    
prep:blur  1 0.23129 0.23129   338.3 1.45e-13 ***
Residuals 19 0.01299 0.00068                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: subj:roi:prep:blur
Df  Sum Sq Mean Sq F value   Pr(>F)    
roi:prep:blur  1 0.04773 0.04773   24.28 9.34e-05 ***
Residuals     19 0.03735 0.00197                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1"
























mutinformation()
################################## Mutual Information
muin.echo2.df <- data.frame(
  subj = factor(rep(c("10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","7","9"), 12)),
  pair = factor(rep(c("K1,K2", "PT,K1", "PT,K2", "PT,LC", "LC,K1", "LC,K2"), each=40)),
  blur = factor(rep(c("blur0", "blur5"), each=20)),
  muin = c(as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) mutinformation(seeds.wide.echo2.df$K1.b0, seeds.wide.echo2.df$K2.b0))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) mutinformation(seeds.wide.echo2.df$K1.b5, seeds.wide.echo2.df$K2.b5))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) mutinformation(seeds.wide.echo2.df$PT.b0, seeds.wide.echo2.df$K1.b0))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) mutinformation(seeds.wide.echo2.df$PT.b5, seeds.wide.echo2.df$K1.b5))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) mutinformation(seeds.wide.echo2.df$PT.b0, seeds.wide.echo2.df$K2.b0))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) mutinformation(seeds.wide.echo2.df$PT.b5, seeds.wide.echo2.df$K2.b5))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) mutinformation(seeds.wide.echo2.df$PT.b0, seeds.wide.echo2.df$LC.b0))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) mutinformation(seeds.wide.echo2.df$PT.b5, seeds.wide.echo2.df$LC.b5))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) mutinformation(seeds.wide.echo2.df$LC.b0, seeds.wide.echo2.df$K1.b0))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) mutinformation(seeds.wide.echo2.df$LC.b5, seeds.wide.echo2.df$K1.b5))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) mutinformation(seeds.wide.echo2.df$LC.b0, seeds.wide.echo2.df$K2.b0))),
          as.vector(sapply(split(seeds.wide.echo2.df, seeds.wide.echo2.df$subj), function(seeds.wide.echo2.df) mutinformation(seeds.wide.echo2.df$LC.b5, seeds.wide.echo2.df$K2.b5))))
)

muin.medn.df <- data.frame(
  subj = factor(rep(c("10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","7","9"), 12)),
  pair = factor(rep(c("K1,K2", "PT,K1", "PT,K2", "PT,LC", "LC,K1", "LC,K2"), each=40)),
  blur = factor(rep(c("blur0", "blur5"), each=20)),
  muin = c(as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) mutinformation(seeds.wide.medn.df$K1.b0, seeds.wide.medn.df$K2.b0))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) mutinformation(seeds.wide.medn.df$K1.b5, seeds.wide.medn.df$K2.b5))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) mutinformation(seeds.wide.medn.df$PT.b0, seeds.wide.medn.df$K1.b0))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) mutinformation(seeds.wide.medn.df$PT.b5, seeds.wide.medn.df$K1.b5))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) mutinformation(seeds.wide.medn.df$PT.b0, seeds.wide.medn.df$K2.b0))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) mutinformation(seeds.wide.medn.df$PT.b5, seeds.wide.medn.df$K2.b5))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) mutinformation(seeds.wide.medn.df$PT.b0, seeds.wide.medn.df$LC.b0))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) mutinformation(seeds.wide.medn.df$PT.b5, seeds.wide.medn.df$LC.b5))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) mutinformation(seeds.wide.medn.df$LC.b0, seeds.wide.medn.df$K1.b0))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) mutinformation(seeds.wide.medn.df$LC.b5, seeds.wide.medn.df$K1.b5))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) mutinformation(seeds.wide.medn.df$LC.b0, seeds.wide.medn.df$K2.b0))),
          as.vector(sapply(split(seeds.wide.medn.df, seeds.wide.medn.df$subj), function(seeds.wide.medn.df) mutinformation(seeds.wide.medn.df$LC.b5, seeds.wide.medn.df$K2.b5))))
)
