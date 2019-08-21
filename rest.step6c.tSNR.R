# tSNR analysis

# Load supplementary scripts & libraries
setwd("/Users/hamid/Desktop/Research/+Scripts")

source("jzBarPlot.s")
source("lineplotBand.s")
source("lineplot.s")
library(RColorBrewer)
library(lme4)
library(lmerTest)

# Load data: WM 1, GSR 0, Blur 0
setwd("~/Desktop/Research/fMRI/LC Methods/rest_results/analysis")
tsnr = data.frame(read.csv("compiled_tsnr_wmr1_gsr0_blur0.txt", header=T, sep=","))
tsnr$ROI = as.character(tsnr$ROI)
tsnr$ROI[tsnr$ROI == 'precentral'] = 'MC'
tsnr$ROI[tsnr$ROI == 'transtemp'] = 'AC'
tsnr$Subj = as.factor(tsnr$Subj)
tsnr$Prep = as.factor(tsnr$Prep)
tsnr$cond = as.factor(paste(tsnr$Prep, tsnr$Type, tsnr$ROI, sep="+"))

tsnr_ratio = tsnr[tsnr$Type == 'both' | tsnr$Type == 'medn',]
tsnr_ratio.wide <- data.frame(
  Subj = sort(unique(tsnr_ratio$Subj)),
  se.GM = tsnr$Beta[tsnr$ROI == 'GM' & tsnr$Type == 'both'],
  se.HPC = tsnr$Beta[tsnr$ROI == 'HPC' & tsnr$Type == 'both'],
  se.MC = tsnr$Beta[tsnr$ROI == 'MC' & tsnr$Type == 'both'],
  se.AC = tsnr$Beta[tsnr$ROI == 'AC' & tsnr$Type == 'both'],
  se.V1 = tsnr$Beta[tsnr$ROI == 'V1' & tsnr$Type == 'both'],
  se.vmPFC = tsnr$Beta[tsnr$ROI == 'vmPFC' & tsnr$Type == 'both'],
  se.LC = tsnr$Beta[tsnr$ROI == 'LC' & tsnr$Type == 'both'],
  se.WM = tsnr$Beta[tsnr$ROI == 'WM' & tsnr$Type == 'both'],
  me.GM = tsnr$Beta[tsnr$ROI == 'GM' & tsnr$Type == 'medn'],
  me.HPC = tsnr$Beta[tsnr$ROI == 'HPC' & tsnr$Type == 'medn'],
  me.MC = tsnr$Beta[tsnr$ROI == 'MC' & tsnr$Type == 'medn'],
  me.AC = tsnr$Beta[tsnr$ROI == 'AC' & tsnr$Type == 'medn'],
  me.V1 = tsnr$Beta[tsnr$ROI == 'V1' & tsnr$Type == 'medn'],
  me.vmPFC = tsnr$Beta[tsnr$ROI == 'vmPFC' & tsnr$Type == 'medn'],
  me.LC = tsnr$Beta[tsnr$ROI == 'LC' & tsnr$Type == 'medn'],
  me.WM = tsnr$Beta[tsnr$ROI == 'WM' & tsnr$Type == 'medn']
)

# ratio ME-ICA/RICOR+4thV- REPORTED
mean(tsnr_ratio.wide$me.GM / tsnr_ratio.wide$se.GM)
"2.367789"
sd(tsnr_ratio.wide$me.GM / tsnr_ratio.wide$se.GM)
"0.3950419"

mean(tsnr_ratio.wide$me.HPC / tsnr_ratio.wide$se.HPC)
"3.539763"
sd(tsnr_ratio.wide$me.HPC / tsnr_ratio.wide$se.HPC)
"0.8496505"

mean(tsnr_ratio.wide$me.LC / tsnr_ratio.wide$se.LC)
"2.868037"
sd(tsnr_ratio.wide$me.LC / tsnr_ratio.wide$se.LC)
"0.980213"

mean(tsnr_ratio.wide$me.MC / tsnr_ratio.wide$se.MC)
"2.311903"
sd(tsnr_ratio.wide$me.MC / tsnr_ratio.wide$se.MC)
"0.4568088"

mean(tsnr_ratio.wide$me.V1 / tsnr_ratio.wide$se.V1)
"1.956669"
sd(tsnr_ratio.wide$me.V1 / tsnr_ratio.wide$se.V1)
"0.428885"

mean(tsnr_ratio.wide$me.vmPFC / tsnr_ratio.wide$se.vmPFC)
"3.532071"
sd(tsnr_ratio.wide$me.vmPFC / tsnr_ratio.wide$se.vmPFC)
"1.009762"

mean(tsnr_ratio.wide$me.AC / tsnr_ratio.wide$se.AC)
"2.392953"
sd(tsnr_ratio.wide$me.AC / tsnr_ratio.wide$se.AC)
"0.437489"

mean(tsnr_ratio.wide$me.WM / tsnr_ratio.wide$se.WM)
"3.574986"
sd(tsnr_ratio.wide$me.WM / tsnr_ratio.wide$se.WM)
"0.6409892"

# Table of means and deviations - REPORTED
with(tsnr, tapply(Beta*1000, cond, mean))
"echo2+4v+AC       echo2+4v+GM      echo2+4v+HPC       echo2+4v+LC       echo2+4v+MC       echo2+4v+V1    echo2+4v+vmPFC       echo2+4v+WM     echo2+both+AC     echo2+both+GM    echo2+both+HPC     echo2+both+LC     echo2+both+MC     echo2+both+V1  echo2+both+vmPFC     echo2+both+WM 
1.3378715         1.2815439         1.1592722         1.1408471         1.4874769         1.2426675         0.5378652         1.9447720         1.5134592         1.3622313         1.2370960         1.2715736         1.5694857         1.3188196         0.5765626         2.0230670 
echo2+none+AC     echo2+none+GM    echo2+none+HPC     echo2+none+LC     echo2+none+MC     echo2+none+V1  echo2+none+vmPFC     echo2+none+WM    echo2+ricor+AC    echo2+ricor+GM   echo2+ricor+HPC    echo2+ricor+LC    echo2+ricor+MC    echo2+ricor+V1 echo2+ricor+vmPFC    echo2+ricor+WM 
1.3202753         1.2697952         1.1492856         1.1212894         1.4743635         1.2311640         0.5327654         1.9245955         1.4983258         1.3533498         1.2289184         1.2571185         1.5588462         1.3099494         0.5730332         2.0121495 
medn+medn+AC      medn+medn+GM     medn+medn+HPC      medn+medn+LC      medn+medn+MC      medn+medn+V1   medn+medn+vmPFC      medn+medn+WM 
3.5635355         3.1741730         4.2271120         3.5763607         3.5611655         2.5539960         1.9230435         7.1749505 "

with(tsnr, tapply(Beta*1000, cond, sd))
"echo2+4v+AC       echo2+4v+GM      echo2+4v+HPC       echo2+4v+LC       echo2+4v+MC       echo2+4v+V1    echo2+4v+vmPFC       echo2+4v+WM     echo2+both+AC     echo2+both+GM    echo2+both+HPC     echo2+both+LC     echo2+both+MC     echo2+both+V1  echo2+both+vmPFC     echo2+both+WM 
0.3162624         0.2437237         0.2589491         0.3747328         0.3457740         0.3034094         0.1549550         0.2644643         0.3813260         0.2756771         0.2911167         0.3771034         0.3802796         0.3323370         0.1762833         0.2811873 
echo2+none+AC     echo2+none+GM    echo2+none+HPC     echo2+none+LC     echo2+none+MC     echo2+none+V1  echo2+none+vmPFC     echo2+none+WM    echo2+ricor+AC    echo2+ricor+GM   echo2+ricor+HPC    echo2+ricor+LC    echo2+ricor+MC    echo2+ricor+V1 echo2+ricor+vmPFC    echo2+ricor+WM 
0.3102509         0.2410705         0.2564897         0.3706581         0.3411266         0.3018262         0.1530017         0.2613405         0.3773346         0.2740038         0.2885820         0.3775464         0.3790048         0.3321540         0.1750637         0.2801161 
medn+medn+AC      medn+medn+GM     medn+medn+HPC      medn+medn+LC      medn+medn+MC      medn+medn+V1   medn+medn+vmPFC      medn+medn+WM 
0.9641398         0.6369937         0.8555203         1.3832736         0.9510369         0.7686480         0.4286484         1.3309146 "

# Stats
tsnr = tsnr[!tsnr$ROI == 'WM',]

plot.design(Beta*1000 ~ Prep*Type*ROI, data=tsnr)
plot.design(Beta*1000 ~ cond, data=tsnr)
boxplot(Beta*1000 ~ Prep*Type*ROI, data=tsnr)

tsnr_echo2 = tsnr[tsnr$Prep == 'echo2',]
tsnr_echo2$ricor = 0
tsnr_echo2$fourthV = 0
tsnr_echo2$ricor[tsnr_echo2$Type == 'both' | tsnr_echo2$Type == 'ricor'] = 1
tsnr_echo2$fourthV[tsnr_echo2$Type == 'both' | tsnr_echo2$Type == '4v'] = 1
tsnr_echo2$ricor = as.factor(tsnr_echo2$ricor)
tsnr_echo2$fourthV = as.factor(tsnr_echo2$fourthV)
tsnr_echo2$Subj = as.factor(tsnr_echo2$Subj)
tsnr_echo2$Prep = as.factor(tsnr_echo2$Prep)
tsnr_echo2$ROI = as.factor(tsnr_echo2$ROI)
tsnr_echo2$cond = as.factor(paste(tsnr_echo2$Type, tsnr_echo2$ROI, sep = '+'))
plot.design(Beta*1000 ~ ricor*fourthV*ROI, data=tsnr_echo2)
plot.design(Beta*1000 ~ Type*ROI, data=tsnr_echo2)
plot.design(Beta*1000 ~ cond, data=tsnr_echo2)

sort(with(tsnr_echo2, tapply(Beta*1000, cond, mean)))
" none+vmPFC    4v+vmPFC ricor+vmPFC  both+vmPFC     none+LC       4v+LC    none+HPC      4v+HPC   ricor+HPC     none+V1    both+HPC       4v+V1    ricor+LC     none+GM 
  0.5327654   0.5378652   0.5730332   0.5765626   1.1212894   1.1408471   1.1492856   1.1592722   1.2289184   1.2311640   1.2370960   1.2426675   1.2571185   1.2697952 
both+LC       4v+GM    ricor+V1     both+V1     none+AC       4v+AC    ricor+GM     both+GM     none+MC       4v+MC    ricor+AC     both+AC    ricor+MC     both+MC 
1.2715736   1.2815439   1.3099494   1.3188196   1.3202753   1.3378715   1.3533498   1.3622313   1.4743635   1.4874769   1.4983258   1.5134592   1.5588462   1.5694857"

# Compare to rm-ANOVA
tsnr_lmer <- lmer(Beta ~ ricor*fourthV*ROI + (1|Subj), data=tsnr_echo2)
anova(tsnr_lmer)
"Type III Analysis of Variance Table with Satterthwaite's method
                      Sum Sq    Mean Sq NumDF DenDF  F value    Pr(>F)    
ricor             1.2870e-06 1.2870e-06     1   513  36.4147 3.059e-09 ***
fourthV           1.8000e-08 1.7900e-08     1   513   0.5064    0.4770    
ROI               4.6863e-05 7.8106e-06     6   513 221.0018 < 2.2e-16 ***
ricor:fourthV     0.0000e+00 3.0000e-10     1   513   0.0072    0.9323    
ricor:ROI         2.4200e-07 4.0400e-08     6   513   1.1424    0.3363    
fourthV:ROI       2.0000e-09 4.0000e-10     6   513   0.0108    1.0000    
ricor:fourthV:ROI 0.0000e+00 0.0000e+00     6   513   0.0002    1.0000    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1"

# REPORTED
tsnr_aov <- aov(Beta ~ ricor*fourthV*ROI+Error(Subj/(ricor*fourthV*ROI)), data=tsnr_echo2)
summary(tsnr_aov)
"Error: Subj
          Df    Sum Sq   Mean Sq F value Pr(>F)
Residuals 19 3.228e-05 1.699e-06               

Error: Subj:ricor
Df    Sum Sq   Mean Sq F value   Pr(>F)    
ricor      1 1.287e-06 1.287e-06   91.01 1.12e-08 ***
Residuals 19 2.687e-07 1.410e-08                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: Subj:fourthV
Df    Sum Sq  Mean Sq F value   Pr(>F)    
fourthV    1 1.790e-08 1.79e-08   142.2 2.89e-10 ***
Residuals 19 2.392e-09 1.26e-10                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: Subj:ROI
Df    Sum Sq   Mean Sq F value Pr(>F)    
ROI         6 4.686e-05 7.811e-06   50.48 <2e-16 ***
Residuals 114 1.764e-05 1.550e-07                   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: Subj:ricor:fourthV
Df    Sum Sq   Mean Sq F value Pr(>F)  
ricor:fourthV  1 2.557e-10 2.557e-10    5.67 0.0279 *
Residuals     19 8.568e-10 4.509e-11                 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: Subj:ricor:ROI
Df    Sum Sq   Mean Sq F value Pr(>F)    
ricor:ROI   6 2.422e-07 4.037e-08   21.82 <2e-16 ***
Residuals 114 2.110e-07 1.850e-09                   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: Subj:fourthV:ROI
Df    Sum Sq   Mean Sq F value  Pr(>F)    
fourthV:ROI   6 2.289e-09 3.816e-10   6.377 8.2e-06 ***
Residuals   114 6.821e-09 5.980e-11                    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: Subj:ricor:fourthV:ROI
Df    Sum Sq   Mean Sq F value Pr(>F)
ricor:fourthV:ROI   6 3.990e-11 6.652e-12   0.246   0.96
Residuals         114 3.085e-09 2.706e-11 "


tsnr_MEvSE = tsnr[tsnr$Type == 'both' | tsnr$Type == 'medn',]
plot.design(Beta*1000 ~ Type*ROI, data=tsnr_MEvSE)
plot.design(Beta*1000 ~ cond, data=tsnr_MEvSE)

tsnr_aov <- aov(Beta ~ Type*ROI+Error(Subj/(Type*ROI)), data=tsnr_MEvSE)
summary(tsnr_aov)
"Error: Subj
          Df    Sum Sq   Mean Sq F value Pr(>F)
Residuals 19 5.494e-05 2.891e-06               

Error: Subj:Type
Df    Sum Sq   Mean Sq F value   Pr(>F)    
Type       1 2.693e-04 2.693e-04   279.3 8.09e-13 ***
Residuals 19 1.832e-05 9.600e-07                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: Subj:ROI
Df    Sum Sq  Mean Sq F value Pr(>F)    
ROI         6 6.177e-05 1.03e-05   37.37 <2e-16 ***
Residuals 114 3.141e-05 2.75e-07                   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Error: Subj:Type:ROI
Df    Sum Sq   Mean Sq F value Pr(>F)    
Type:ROI    6 2.113e-05 3.521e-06   23.85 <2e-16 ***
Residuals 114 1.683e-05 1.480e-07                   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 "


tsnr_ricor_both = tsnr[tsnr$Type == 'both' | tsnr$Type == 'ricor',]
plot.design(Beta*1000 ~ Type*ROI, data=tsnr_ricor_both)
plot.design(Beta*1000 ~ cond, data=tsnr_ricor_both)
t.test(tsnr_ricor_both$Beta[tsnr_ricor_both$Type == 'both'],tsnr_ricor_both$Beta[tsnr_ricor_both$Type == 'ricor'])
"	Welch Two Sample t-test
t = 0.19037, df = 277.99, p-value = 0.8492
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
-9.298711e-05  1.128976e-04
sample estimates:
mean of x   mean of y 
0.001264175 0.001254220 "

tsnr_4v_both = tsnr[tsnr$Type == 'both' | tsnr$Type == '4v',]
plot.design(Beta*1000 ~ Type*ROI, data=tsnr_4v_both)
plot.design(Beta*1000 ~ cond, data=tsnr_4v_both)
t.test(tsnr_4v_both$Beta[tsnr_4v_both$Type == 'both'],tsnr_4v_both$Beta[tsnr_4v_both$Type == '4v'])
"	Welch Two Sample t-test
t = 1.8803, df = 275.8, p-value = 0.06112
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
-4.438371e-06  1.934909e-04
sample estimates:
mean of x   mean of y 
0.001264175 0.001169649 "

