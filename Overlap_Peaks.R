# CSim analysis

# Load supplementary scripts & dependencies
setwd("/Users/hamid/Desktop/Research/+Scripts")
setwd("/Users/hamid/Desktop/+RESEARCH/+Scripts")

source("jzBarPlot.s")
source("lineplotBand.s")
library(RColorBrewer)
library(TSdist)

# Load data
#setwd("/Users/hamid/Desktop/")
setwd("~/Desktop/+RESEARCH/fMRI/LC Methods/Analyses")
peaks = read.csv("compiled_peaks.txt", header=T, sep=",")
peaks$Cluster = 1:20

n_peaks = 20
dist_crit = EuclideanDistance(c(0,0,0),c(7,7,7))
"12.12436" # Within a Euclidean distance of 12.12436, we consider peaks to be part of the same cluster

# Split data
peaks.M.K.b0s0.p85 = peaks[peaks$Prep == 'M' & peaks$ROI == 'K1' &
                             peaks$Base == 0 & peaks$Seed == 0 & peaks$Perc == 85,]
peaks.M.K.b5s0.p85 = peaks[peaks$Prep == 'M' & peaks$ROI == 'K1' &
                             peaks$Base == 5 & peaks$Seed == 0 & peaks$Perc == 85,]
peaks.M.K.b0s5.p85 = peaks[peaks$Prep == 'M' & peaks$ROI == 'K1' &
                             peaks$Base == 0 & peaks$Seed == 5 & peaks$Perc == 85,]
peaks.M.K.b5s5.p85 = peaks[peaks$Prep == 'M' & peaks$ROI == 'K1' &
                             peaks$Base == 5 & peaks$Seed == 5 & peaks$Perc == 85,]
"peaks.M.K.b0s0.p90 = peaks[peaks$Prep == 'M' & peaks$ROI == 'K1' &
                             peaks$Base == 0 & peaks$Seed == 0 & peaks$Perc == 90,]
peaks.M.K.b5s0.p90 = peaks[peaks$Prep == 'M' & peaks$ROI == 'K1' &
                             peaks$Base == 5 & peaks$Seed == 0 & peaks$Perc == 90,]
peaks.M.K.b0s5.p90 = peaks[peaks$Prep == 'M' & peaks$ROI == 'K1' &
                             peaks$Base == 0 & peaks$Seed == 5 & peaks$Perc == 90,]
peaks.M.K.b5s5.p90 = peaks[peaks$Prep == 'M' & peaks$ROI == 'K1' &
                             peaks$Base == 5 & peaks$Seed == 5 & peaks$Perc == 90,]
peaks.M.K.b0s0.p95 = peaks[peaks$Prep == 'M' & peaks$ROI == 'K1' &
                             peaks$Base == 0 & peaks$Seed == 0 & peaks$Perc == 95,]
peaks.M.K.b5s0.p95 = peaks[peaks$Prep == 'M' & peaks$ROI == 'K1' &
                             peaks$Base == 5 & peaks$Seed == 0 & peaks$Perc == 95,]
peaks.M.K.b0s5.p95 = peaks[peaks$Prep == 'M' & peaks$ROI == 'K1' &
                             peaks$Base == 0 & peaks$Seed == 5 & peaks$Perc == 95,]
peaks.M.K.b5s5.p95 = peaks[peaks$Prep == 'M' & peaks$ROI == 'K1' &
                             peaks$Base == 5 & peaks$Seed == 5 & peaks$Perc == 95,]"

peaks.S.K.b0s0.p85 = peaks[peaks$Prep == 'S' & peaks$ROI == 'K1' &
                             peaks$Base == 0 & peaks$Seed == 0 & peaks$Perc == 85,]
peaks.S.K.b5s0.p85 = peaks[peaks$Prep == 'S' & peaks$ROI == 'K1' &
                             peaks$Base == 5 & peaks$Seed == 0 & peaks$Perc == 85,]
peaks.S.K.b0s5.p85 = peaks[peaks$Prep == 'S' & peaks$ROI == 'K1' &
                             peaks$Base == 0 & peaks$Seed == 5 & peaks$Perc == 85,]
peaks.S.K.b5s5.p85 = peaks[peaks$Prep == 'S' & peaks$ROI == 'K1' &
                             peaks$Base == 5 & peaks$Seed == 5 & peaks$Perc == 85,]
"peaks.S.K.b0s0.p90 = peaks[peaks$Prep == 'S' & peaks$ROI == 'K1' &
                             peaks$Base == 0 & peaks$Seed == 0 & peaks$Perc == 90,]
peaks.S.K.b5s0.p90 = peaks[peaks$Prep == 'S' & peaks$ROI == 'K1' &
                             peaks$Base == 5 & peaks$Seed == 0 & peaks$Perc == 90,]
peaks.S.K.b0s5.p90 = peaks[peaks$Prep == 'S' & peaks$ROI == 'K1' &
                             peaks$Base == 0 & peaks$Seed == 5 & peaks$Perc == 90,]
peaks.S.K.b5s5.p90 = peaks[peaks$Prep == 'S' & peaks$ROI == 'K1' &
                             peaks$Base == 5 & peaks$Seed == 5 & peaks$Perc == 90,]
peaks.S.K.b0s0.p95 = peaks[peaks$Prep == 'S' & peaks$ROI == 'K1' &
                             peaks$Base == 0 & peaks$Seed == 0 & peaks$Perc == 95,]
peaks.S.K.b5s0.p95 = peaks[peaks$Prep == 'S' & peaks$ROI == 'K1' &
                             peaks$Base == 5 & peaks$Seed == 0 & peaks$Perc == 95,]
peaks.S.K.b0s5.p95 = peaks[peaks$Prep == 'S' & peaks$ROI == 'K1' &
                             peaks$Base == 0 & peaks$Seed == 5 & peaks$Perc == 95,]
peaks.S.K.b5s5.p95 = peaks[peaks$Prep == 'S' & peaks$ROI == 'K1' &
                             peaks$Base == 5 & peaks$Seed == 5 & peaks$Perc == 95,]"

peaks.M.L.b0s0.p85 = peaks[peaks$Prep == 'M' & peaks$ROI == 'LC' &
                             peaks$Base == 0 & peaks$Seed == 0 & peaks$Perc == 85,]
peaks.M.L.b5s0.p85 = peaks[peaks$Prep == 'M' & peaks$ROI == 'LC' &
                             peaks$Base == 5 & peaks$Seed == 0 & peaks$Perc == 85,]
peaks.M.L.b0s5.p85 = peaks[peaks$Prep == 'M' & peaks$ROI == 'LC' &
                             peaks$Base == 0 & peaks$Seed == 5 & peaks$Perc == 85,]
peaks.M.L.b5s5.p85 = peaks[peaks$Prep == 'M' & peaks$ROI == 'LC' &
                             peaks$Base == 5 & peaks$Seed == 5 & peaks$Perc == 85,]
"peaks.M.L.b0s0.p90 = peaks[peaks$Prep == 'M' & peaks$ROI == 'LC' &
                             peaks$Base == 0 & peaks$Seed == 0 & peaks$Perc == 90,]
peaks.M.L.b5s0.p90 = peaks[peaks$Prep == 'M' & peaks$ROI == 'LC' &
                             peaks$Base == 5 & peaks$Seed == 0 & peaks$Perc == 90,]
peaks.M.L.b0s5.p90 = peaks[peaks$Prep == 'M' & peaks$ROI == 'LC' &
                             peaks$Base == 0 & peaks$Seed == 5 & peaks$Perc == 90,]
peaks.M.L.b5s5.p90 = peaks[peaks$Prep == 'M' & peaks$ROI == 'LC' &
                             peaks$Base == 5 & peaks$Seed == 5 & peaks$Perc == 90,]
peaks.M.L.b0s0.p95 = peaks[peaks$Prep == 'M' & peaks$ROI == 'LC' &
                             peaks$Base == 0 & peaks$Seed == 0 & peaks$Perc == 95,]
peaks.M.L.b5s0.p95 = peaks[peaks$Prep == 'M' & peaks$ROI == 'LC' &
                             peaks$Base == 5 & peaks$Seed == 0 & peaks$Perc == 95,]
peaks.M.L.b0s5.p95 = peaks[peaks$Prep == 'M' & peaks$ROI == 'LC' &
                             peaks$Base == 0 & peaks$Seed == 5 & peaks$Perc == 95,]
peaks.M.L.b5s5.p95 = peaks[peaks$Prep == 'M' & peaks$ROI == 'LC' &
                             peaks$Base == 5 & peaks$Seed == 5 & peaks$Perc == 95,]"

peaks.S.L.b0s0.p85 = peaks[peaks$Prep == 'S' & peaks$ROI == 'LC' &
                             peaks$Base == 0 & peaks$Seed == 0 & peaks$Perc == 85,]
peaks.S.L.b5s0.p85 = peaks[peaks$Prep == 'S' & peaks$ROI == 'LC' &
                             peaks$Base == 5 & peaks$Seed == 0 & peaks$Perc == 85,]
peaks.S.L.b0s5.p85 = peaks[peaks$Prep == 'S' & peaks$ROI == 'LC' &
                             peaks$Base == 0 & peaks$Seed == 5 & peaks$Perc == 85,]
peaks.S.L.b5s5.p85 = peaks[peaks$Prep == 'S' & peaks$ROI == 'LC' &
                             peaks$Base == 5 & peaks$Seed == 5 & peaks$Perc == 85,]
"peaks.S.L.b0s0.p90 = peaks[peaks$Prep == 'S' & peaks$ROI == 'LC' &
                             peaks$Base == 0 & peaks$Seed == 0 & peaks$Perc == 90,]
peaks.S.L.b5s0.p90 = peaks[peaks$Prep == 'S' & peaks$ROI == 'LC' &
                             peaks$Base == 5 & peaks$Seed == 0 & peaks$Perc == 90,]
peaks.S.L.b0s5.p90 = peaks[peaks$Prep == 'S' & peaks$ROI == 'LC' &
                             peaks$Base == 0 & peaks$Seed == 5 & peaks$Perc == 90,]
peaks.S.L.b5s5.p90 = peaks[peaks$Prep == 'S' & peaks$ROI == 'LC' &
                             peaks$Base == 5 & peaks$Seed == 5 & peaks$Perc == 90,]
peaks.S.L.b0s0.p95 = peaks[peaks$Prep == 'S' & peaks$ROI == 'LC' &
                             peaks$Base == 0 & peaks$Seed == 0 & peaks$Perc == 95,]
peaks.S.L.b5s0.p95 = peaks[peaks$Prep == 'S' & peaks$ROI == 'LC' &
                             peaks$Base == 5 & peaks$Seed == 0 & peaks$Perc == 95,]
peaks.S.L.b0s5.p95 = peaks[peaks$Prep == 'S' & peaks$ROI == 'LC' &
                             peaks$Base == 0 & peaks$Seed == 5 & peaks$Perc == 95,]
peaks.S.L.b5s5.p95 = peaks[peaks$Prep == 'S' & peaks$ROI == 'LC' &
                             peaks$Base == 5 & peaks$Seed == 5 & peaks$Perc == 95,]"

# Floor the XYZ coordinates, which gives us LPI (mm) in MNI_ANAT
peaks.M.K.b0s0.p85[c(1:3)]=floor(peaks.M.K.b0s0.p85[c(1:3)]); peaks.M.K.b5s0.p85[c(1:3)]=floor(peaks.M.K.b5s0.p85[c(1:3)])
peaks.M.K.b0s5.p85[c(1:3)]=floor(peaks.M.K.b0s5.p85[c(1:3)]); peaks.M.K.b5s5.p85[c(1:3)]=floor(peaks.M.K.b5s5.p85[c(1:3)])
peaks.M.L.b0s0.p85[c(1:3)]=floor(peaks.M.L.b0s0.p85[c(1:3)]); peaks.M.L.b5s0.p85[c(1:3)]=floor(peaks.M.L.b5s0.p85[c(1:3)])
peaks.M.L.b0s5.p85[c(1:3)]=floor(peaks.M.L.b0s5.p85[c(1:3)]); peaks.M.L.b5s5.p85[c(1:3)]=floor(peaks.M.L.b5s5.p85[c(1:3)])
peaks.S.K.b0s0.p85[c(1:3)]=floor(peaks.S.K.b0s0.p85[c(1:3)]); peaks.S.K.b5s0.p85[c(1:3)]=floor(peaks.S.K.b5s0.p85[c(1:3)])
peaks.S.K.b0s5.p85[c(1:3)]=floor(peaks.S.K.b0s5.p85[c(1:3)]); peaks.S.K.b5s5.p85[c(1:3)]=floor(peaks.S.K.b5s5.p85[c(1:3)])
peaks.S.L.b0s0.p85[c(1:3)]=floor(peaks.S.L.b0s0.p85[c(1:3)]); peaks.S.L.b5s0.p85[c(1:3)]=floor(peaks.S.L.b5s0.p85[c(1:3)])
peaks.S.L.b0s5.p85[c(1:3)]=floor(peaks.S.L.b0s5.p85[c(1:3)]); peaks.S.L.b5s5.p85[c(1:3)]=floor(peaks.S.L.b5s5.p85[c(1:3)])

# Which top n peaks are we considering?
peaks.M.K.b0s0.p85=peaks.M.K.b0s0.p85[1:n_peaks,]; peaks.M.K.b5s0.p85=peaks.M.K.b5s0.p85[1:n_peaks,]
peaks.M.K.b0s5.p85=peaks.M.K.b0s5.p85[1:n_peaks,]; peaks.M.K.b5s5.p85=peaks.M.K.b5s5.p85[1:n_peaks,]
peaks.M.L.b0s0.p85=peaks.M.L.b0s0.p85[1:n_peaks,]; peaks.M.L.b5s0.p85=peaks.M.L.b5s0.p85[1:n_peaks,]
peaks.M.L.b0s5.p85=peaks.M.L.b0s5.p85[1:n_peaks,]; peaks.M.L.b5s5.p85=peaks.M.L.b5s5.p85[1:n_peaks,]
peaks.S.K.b0s0.p85=peaks.S.K.b0s0.p85[1:n_peaks,]; peaks.S.K.b5s0.p85=peaks.S.K.b5s0.p85[1:n_peaks,]
peaks.S.K.b0s5.p85=peaks.S.K.b0s5.p85[1:n_peaks,]; peaks.S.K.b5s5.p85=peaks.S.K.b5s5.p85[1:n_peaks,]
peaks.S.L.b0s0.p85=peaks.S.L.b0s0.p85[1:n_peaks,]; peaks.S.L.b5s0.p85=peaks.S.L.b5s0.p85[1:n_peaks,]
peaks.S.L.b0s5.p85=peaks.S.L.b0s5.p85[1:n_peaks,]; peaks.S.L.b5s5.p85=peaks.S.L.b5s5.p85[1:n_peaks,]


# Calculate distances between peaks
# Within ROI, across prep
count.MK50_SK50=0
dist.MK50_SK50=matrix(0,nrow=n_peaks,ncol=n_peaks)
dist.MK50_SK50.which=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.M.K.b5s0.p85[ref,c(1:3)][[1]],peaks.M.K.b5s0.p85[ref,c(1:3)][[2]],peaks.M.K.b5s0.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.S.K.b5s0.p85[peak,c(1:3)][[1]],peaks.S.K.b5s0.p85[peak,c(1:3)][[2]],peaks.S.K.b5s0.p85[peak,c(1:3)][[3]])
    dist.MK50_SK50[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.MK50_SK50[ref,peak]<=dist_crit) {count.MK50_SK50=count.MK50_SK50+1; dist.MK50_SK50.which[ref,peak]=999}
  }
}
for (ref in 1:n_peaks) {peaks.M.K.b5s0.p85$SK50.Dist[ref]=min(dist.MK50_SK50[ref,]); peaks.S.K.b5s0.p85$MK50.Dist[ref]=min(dist.MK50_SK50[,ref])}
peaks.M.K.b5s0.p85$SK50.flag=0; peaks.S.K.b5s0.p85$MK50.flag=0; peaks.S.K.b5s0.p85$MK50.which=0; peaks.M.K.b5s0.p85$SK50.which=0;
for (ref in 1:n_peaks) { if (peaks.M.K.b5s0.p85$SK50.Dist[ref]<=dist_crit) { {peaks.M.K.b5s0.p85$SK50.flag[ref]=1} } }
for (ref in 1:n_peaks) { if (peaks.S.K.b5s0.p85$MK50.Dist[ref]<=dist_crit) { {peaks.S.K.b5s0.p85$MK50.flag[ref]=1} } }
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    {peaks.M.K.b5s0.p85$SK50.which[ref]=which.min(dist.MK50_SK50[ref,]); peaks.S.K.b5s0.p85$MK50.which[peak]=which.min(dist.MK50_SK50[peak,])}
  }
}
(mean(peaks.M.K.b5s0.p85$SK50.flag)+mean(peaks.S.K.b5s0.p85$MK50.flag))/2
"0.25" # 25% of the overall 20 peaks fall within dist_crit of a peak in the other map


count.MK55_SK55=0
dist.MK55_SK55=matrix(0,nrow=n_peaks,ncol=n_peaks)
dist.MK55_SK55.which=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.M.K.b5s5.p85[ref,c(1:3)][[1]],peaks.M.K.b5s5.p85[ref,c(1:3)][[2]],peaks.M.K.b5s5.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.S.K.b5s5.p85[peak,c(1:3)][[1]],peaks.S.K.b5s5.p85[peak,c(1:3)][[2]],peaks.S.K.b5s5.p85[peak,c(1:3)][[3]])
    dist.MK55_SK55[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.MK55_SK55[ref,peak]<=dist_crit) {count.MK55_SK55=count.MK55_SK55+1}
  }
}
for (ref in 1:n_peaks) {peaks.M.K.b5s5.p85$SK55.Dist[ref]=min(dist.MK55_SK55[ref,]); peaks.S.K.b5s5.p85$MK55.Dist[ref]=min(dist.MK55_SK55[,ref])}
peaks.M.K.b5s5.p85$SK55.flag=0; peaks.S.K.b5s5.p85$MK55.flag=0; peaks.S.K.b5s5.p85$MK55.which=0; peaks.M.K.b5s5.p85$SK55.which=0;
for (ref in 1:n_peaks) { if (peaks.M.K.b5s5.p85$SK55.Dist[ref]<=dist_crit) { {peaks.M.K.b5s5.p85$SK55.flag[ref]=1} } }
for (ref in 1:n_peaks) { if (peaks.S.K.b5s5.p85$MK55.Dist[ref]<=dist_crit) { {peaks.S.K.b5s5.p85$MK55.flag[ref]=1} } }
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    {peaks.M.K.b5s5.p85$SK55.which[ref]=which.min(dist.MK55_SK55[ref,]); peaks.S.K.b5s5.p85$MK55.which[peak]=which.min(dist.MK55_SK55[,peak])}
  }
}
(mean(peaks.M.K.b5s5.p85$SK55.flag)+mean(peaks.S.K.b5s5.p85$MK55.flag))/2
"0.2"

count.ML50_SL50=0
dist.ML50_SL50=matrix(0,nrow=n_peaks,ncol=n_peaks)
dist.ML50_SL50.which=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.M.L.b5s0.p85[ref,c(1:3)][[1]],peaks.M.L.b5s0.p85[ref,c(1:3)][[2]],peaks.M.L.b5s0.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.S.L.b5s0.p85[peak,c(1:3)][[1]],peaks.S.L.b5s0.p85[peak,c(1:3)][[2]],peaks.S.L.b5s0.p85[peak,c(1:3)][[3]])
    dist.ML50_SL50[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.ML50_SL50[ref,peak]<=dist_crit) {count.ML50_SL50=count.ML50_SL50+1; dist.ML50_SL50.which[ref,peak]=999}
  }
}
for (ref in 1:n_peaks) {peaks.M.L.b5s0.p85$SL50.Dist[ref]=min(dist.ML50_SL50[ref,]); peaks.S.L.b5s0.p85$ML50.Dist[ref]=min(dist.ML50_SL50[,ref])}
peaks.M.L.b5s0.p85$SL50.flag=0; peaks.S.L.b5s0.p85$ML50.flag=0; peaks.S.L.b5s0.p85$ML50.which=0; peaks.M.L.b5s0.p85$SL50.which=0;
for (ref in 1:n_peaks) { if (peaks.M.L.b5s0.p85$SL50.Dist[ref]<=dist_crit) { {peaks.M.L.b5s0.p85$SL50.flag[ref]=1} } }
for (ref in 1:n_peaks) { if (peaks.S.L.b5s0.p85$ML50.Dist[ref]<=dist_crit) { {peaks.S.L.b5s0.p85$ML50.flag[ref]=1} } }
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    {peaks.M.L.b5s0.p85$SL50.which[ref]=which.min(dist.ML50_SL50[ref,]); peaks.S.L.b5s0.p85$ML50.which[peak]=which.min(dist.ML50_SL50[,peak])}
  }
}
(mean(peaks.M.L.b5s0.p85$SL50.flag)+mean(peaks.S.L.b5s0.p85$ML50.flag))/2
"0.2"

if (dist.ML50_SL50[ref,peak]<=dist_crit) 
count.ML55_SL55=0
dist.ML55_SL55=matrix(0,nrow=n_peaks,ncol=n_peaks)
dist.ML55_SL55.which=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.M.L.b5s5.p85[ref,c(1:3)][[1]],peaks.M.L.b5s5.p85[ref,c(1:3)][[2]],peaks.M.L.b5s5.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.S.L.b5s5.p85[peak,c(1:3)][[1]],peaks.S.L.b5s5.p85[peak,c(1:3)][[2]],peaks.S.L.b5s5.p85[peak,c(1:3)][[3]])
    dist.ML55_SL55[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.ML55_SL55[ref,peak]<=dist_crit) {count.ML55_SL55=count.ML55_SL55+1}
  }
}
for (ref in 1:n_peaks) {peaks.M.L.b5s5.p85$SL55.Dist[ref]=min(dist.ML55_SL55[ref,]); peaks.S.L.b5s5.p85$ML55.Dist[ref]=min(dist.ML55_SL55[,ref])}
peaks.M.L.b5s5.p85$SL55.flag=0; peaks.S.L.b5s5.p85$ML55.flag=0; peaks.S.L.b5s5.p85$ML55.which=0; peaks.M.L.b5s5.p85$SL55.which=0;
for (ref in 1:n_peaks) { if (peaks.M.L.b5s5.p85$SL55.Dist[ref]<=dist_crit) { {peaks.M.L.b5s5.p85$SL55.flag[ref]=1} } }
for (ref in 1:n_peaks) { if (peaks.S.L.b5s5.p85$ML55.Dist[ref]<=dist_crit) { {peaks.S.L.b5s5.p85$ML55.flag[ref]=1} } }
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    if (dist.ML55_SL55[ref,peak]<=dist_crit) {peaks.M.L.b5s5.p85$SL55.which[ref]=peak; peaks.S.L.b5s5.p85$ML55.which[peak]=ref}
  }
}
(mean(peaks.M.L.b5s5.p85$SL55.flag)+mean(peaks.S.L.b5s5.p85$ML55.flag))/2
"0.2"









# Within prep, across ROI
count.MK50_ML50=0
dist.MK50_ML50=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.M.K.b5s0.p85[ref,c(1:3)][[1]],peaks.M.K.b5s0.p85[ref,c(1:3)][[2]],peaks.M.K.b5s0.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.M.L.b5s0.p85[peak,c(1:3)][[1]],peaks.M.L.b5s0.p85[peak,c(1:3)][[2]],peaks.M.L.b5s0.p85[peak,c(1:3)][[3]])
    dist.MK50_ML50[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.MK50_ML50[ref,peak]<=dist_crit) {count.MK50_ML50=count.MK50_ML50+1}
  }
}
count.MK50_ML50/n_peaks*2
"0.5"

count.MK55_ML55=0
dist.MK55_ML55=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.M.K.b5s5.p85[ref,c(1:3)][[1]],peaks.M.K.b5s5.p85[ref,c(1:3)][[2]],peaks.M.K.b5s5.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.M.L.b5s5.p85[peak,c(1:3)][[1]],peaks.M.L.b5s5.p85[peak,c(1:3)][[2]],peaks.M.L.b5s5.p85[peak,c(1:3)][[3]])
    dist.MK55_ML55[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.MK55_ML55[ref,peak]<=dist_crit) {count.MK55_ML55=count.MK55_ML55+1}
  }
}
count.MK55_ML55/n_peaks*2
"0.8"

count.SK50_SL50=0
dist.SK50_SL50=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.S.K.b5s0.p85[ref,c(1:3)][[1]],peaks.S.K.b5s0.p85[ref,c(1:3)][[2]],peaks.S.K.b5s0.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.S.L.b5s0.p85[peak,c(1:3)][[1]],peaks.S.L.b5s0.p85[peak,c(1:3)][[2]],peaks.S.L.b5s0.p85[peak,c(1:3)][[3]])
    dist.SK50_SL50[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.SK50_SL50[ref,peak]<=dist_crit) {count.SK50_SL50=count.SK50_SL50+1}
  }
}
count.SK50_SL50/n_peaks*2
"0.5"

count.SK55_SL55=0
dist.SK55_SL55=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.S.K.b5s5.p85[ref,c(1:3)][[1]],peaks.S.K.b5s5.p85[ref,c(1:3)][[2]],peaks.S.K.b5s5.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.S.L.b5s5.p85[peak,c(1:3)][[1]],peaks.S.L.b5s5.p85[peak,c(1:3)][[2]],peaks.S.L.b5s5.p85[peak,c(1:3)][[3]])
    dist.SK55_SL55[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.SK55_SL55[ref,peak]<=dist_crit) {count.SK55_SL55=count.SK55_SL55+1}
  }
}
count.SK55_SL55/n_peaks*2
"0.5"

# Within ROI & Prep, across blurring
count.MK50_MK55=0
dist.MK50_MK55=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.M.K.b5s0.p85[ref,c(1:3)][[1]],peaks.M.K.b5s0.p85[ref,c(1:3)][[2]],peaks.M.K.b5s0.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.M.K.b5s5.p85[peak,c(1:3)][[1]],peaks.M.K.b5s5.p85[peak,c(1:3)][[2]],peaks.M.K.b5s5.p85[peak,c(1:3)][[3]])
    dist.MK50_MK55[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.MK50_MK55[ref,peak]<=dist_crit) {count.MK50_MK55=count.MK50_MK55+1}
  }
}
count.MK50_MK55/n_peaks*2
"0.9"

count.SK50_SK55=0
dist.SK50_SK55=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.S.K.b5s0.p85[ref,c(1:3)][[1]],peaks.S.K.b5s0.p85[ref,c(1:3)][[2]],peaks.S.K.b5s0.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.S.K.b5s5.p85[peak,c(1:3)][[1]],peaks.S.K.b5s5.p85[peak,c(1:3)][[2]],peaks.S.K.b5s5.p85[peak,c(1:3)][[3]])
    dist.SK50_SK55[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.SK50_SK55[ref,peak]<=dist_crit) {count.SK50_SK55=count.SK50_SK55+1}
  }
}
count.SK50_SK55/n_peaks*2
"0.9"

count.ML50_ML55=0
dist.ML50_ML55=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.M.L.b5s0.p85[ref,c(1:3)][[1]],peaks.M.L.b5s0.p85[ref,c(1:3)][[2]],peaks.M.L.b5s0.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.M.L.b5s5.p85[peak,c(1:3)][[1]],peaks.M.L.b5s5.p85[peak,c(1:3)][[2]],peaks.M.L.b5s5.p85[peak,c(1:3)][[3]])
    dist.ML50_ML55[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.ML50_ML55[ref,peak]<=dist_crit) {count.ML50_ML55=count.ML50_ML55+1}
  }
}
count.ML50_ML55/n_peaks*2
"0.8"

count.SL50_SL55=0
dist.SL50_SL55=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.S.L.b5s0.p85[ref,c(1:3)][[1]],peaks.S.L.b5s0.p85[ref,c(1:3)][[2]],peaks.S.L.b5s0.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.S.L.b5s5.p85[peak,c(1:3)][[1]],peaks.S.L.b5s5.p85[peak,c(1:3)][[2]],peaks.S.L.b5s5.p85[peak,c(1:3)][[3]])
    dist.SL50_SL55[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.SL50_SL55[ref,peak]<=dist_crit) {count.SL50_SL55=count.SL50_SL55+1}
  }
}
count.SL50_SL55/n_peaks*2
"0.8"






count.SK50_MK55=0
dist.MK50_MK55=matrix(0,nrow=n_peaks,ncol=n_peaks)
for (ref in 1:n_peaks) {
  for (peak in 1:n_peaks) {
    peakA=c(peaks.S.K.b5s5.p85[ref,c(1:3)][[1]],peaks.S.K.b5s5.p85[ref,c(1:3)][[2]],peaks.S.K.b5s5.p85[ref,c(1:3)][[3]])
    peakB=c(peaks.S.L.b5s5.p85[peak,c(1:3)][[1]],peaks.S.L.b5s5.p85[peak,c(1:3)][[2]],peaks.S.L.b5s5.p85[peak,c(1:3)][[3]])
    dist.SK55_SL55[ref,peak]=EuclideanDistance(peakA,peakB)
    if (dist.SK55_SL55[ref,peak]<=dist_crit) {count.SK55_SL55=count.SK55_SL55+1}
  }
}
count.SK55_SL55/n_peaks*2
"0.9"






# Highest peak in M.K.b5s0.p85 -> S.K.b5s0.p85
for (peak in 1:20) {
  peakA=c(peaks.M.K.b5s0.p85[1,c(1:3)][[1]],peaks.M.K.b5s0.p85[1,c(1:3)][[2]],peaks.M.K.b5s0.p85[1,c(1:3)][[3]])
  peakB=c(peaks.S.K.b5s0.p85[peak,c(1:3)][[1]],peaks.S.K.b5s0.p85[peak,c(1:3)][[2]],peaks.S.K.b5s0.p85[peak,c(1:3)][[3]])
  dist[peak]=EuclideanDistance(peakA,peakB)
}
min(dist)
"0"
which.min(dist)
"1"
neighbor=which.min(dist)
peaks.M.K.b5s0.p85[1,c(1:3)]
"-1.5 -36.5 -21"
c(peaks.S.K.b5s0.p85[neighbor,c(1:3)][[1]],peaks.S.K.b5s0.p85[neighbor,c(1:3)][[2]],peaks.S.K.b5s0.p85[neighbor,c(1:3)][[3]])
"-1.5 -36.5 -21.0"
peaks.M.K.b5s0.p85[1,4]
"1.001706"
peaks.S.K.b5s0.p85[neighbor,4]
"0.738758"

# Highest peak in M.K.b5s5.p85 -> S.K.b5s5.p85
for (peak in 1:20) {
  peakA=c(peaks.M.K.b5s5.p85[1,c(1:3)][[1]],peaks.M.K.b5s5.p85[1,c(1:3)][[2]],peaks.M.K.b5s5.p85[1,c(1:3)][[3]])
  peakB=c(peaks.S.K.b5s5.p85[peak,c(1:3)][[1]],peaks.S.K.b5s5.p85[peak,c(1:3)][[2]],peaks.S.K.b5s5.p85[peak,c(1:3)][[3]])
  dist[peak]=EuclideanDistance(peakA,peakB)
}
min(dist)
"0"
which.min(dist)
"1"
neighbor=which.min(dist)
peaks.M.K.b5s5.p85[1,c(1:3)]
"-1.5 -36.5 -21"
c(peaks.S.K.b5s5.p85[neighbor,c(1:3)][[1]],peaks.S.K.b5s5.p85[neighbor,c(1:3)][[2]],peaks.S.K.b5s5.p85[neighbor,c(1:3)][[3]])
"-1.5 -36.5 -21.0"
peaks.M.K.b5s5.p85[1,4]
"1.058813"
peaks.S.K.b5s5.p85[neighbor,4]
"0.884236"

# Highest peak in M.L.b5s0.p85 -> S.L.b5s0.p85
for (peak in 1:20) {
  peakA=c(peaks.M.L.b5s0.p85[1,c(1:3)][[1]],peaks.M.L.b5s0.p85[1,c(1:3)][[2]],peaks.M.L.b5s0.p85[1,c(1:3)][[3]])
  peakB=c(peaks.S.L.b5s0.p85[peak,c(1:3)][[1]],peaks.S.L.b5s0.p85[peak,c(1:3)][[2]],peaks.S.L.b5s0.p85[peak,c(1:3)][[3]])
  dist[peak]=EuclideanDistance(peakA,peakB)
}
min(dist)
"6"
which.min(dist)
"1"
neighbor=which.min(dist)
peaks.M.L.b5s0.p85[1,c(1:3)]
"-1.5 -36.5 -24"
c(peaks.S.L.b5s0.p85[neighbor,c(1:3)][[1]],peaks.S.L.b5s0.p85[neighbor,c(1:3)][[2]],peaks.S.L.b5s0.p85[neighbor,c(1:3)][[3]])
"4.5 -36.5 -24.0"
peaks.M.L.b5s0.p85[1,4]
"0.7541"
peaks.S.L.b5s0.p85[neighbor,4]
"0.454096"

# Highest peak in M.L.b5s5.p85 -> S.L.b5s5.p85
for (peak in 1:20) {
  peakA=c(peaks.M.L.b5s5.p85[1,c(1:3)][[1]],peaks.M.L.b5s5.p85[1,c(1:3)][[2]],peaks.M.L.b5s5.p85[1,c(1:3)][[3]])
  peakB=c(peaks.S.L.b5s5.p85[peak,c(1:3)][[1]],peaks.S.L.b5s5.p85[peak,c(1:3)][[2]],peaks.S.L.b5s5.p85[peak,c(1:3)][[3]])
  dist[peak]=EuclideanDistance(peakA,peakB)
}
min(dist)
"3"
which.min(dist)
"1"
neighbor=which.min(dist)
peaks.M.L.b5s5.p85[1,c(1:3)]
"-1.5 -36.5 -24"
c(peaks.S.L.b5s5.p85[neighbor,c(1:3)][[1]],peaks.S.L.b5s5.p85[neighbor,c(1:3)][[2]],peaks.S.L.b5s5.p85[neighbor,c(1:3)][[3]])
"1.5 -36.5 -24.0"
peaks.M.L.b5s5.p85[1,4]
"0.987008"
peaks.S.L.b5s5.p85[neighbor,4]
"0.691859"

# Highest peak in M.K.b5s0.p85 -> M.L.b5s0.p85
for (peak in 1:20) {
  peakA=c(peaks.M.K.b5s0.p85[1,c(1:3)][[1]],peaks.M.K.b5s0.p85[1,c(1:3)][[2]],peaks.M.K.b5s0.p85[1,c(1:3)][[3]])
  peakB=c(peaks.M.L.b5s0.p85[peak,c(1:3)][[1]],peaks.M.L.b5s0.p85[peak,c(1:3)][[2]],peaks.M.L.b5s0.p85[peak,c(1:3)][[3]])
  dist[peak]=EuclideanDistance(peakA,peakB)
}
min(dist)
"3"
which.min(dist)
"1"
neighbor=which.min(dist)
peaks.M.K.b5s0.p85[1,c(1:3)]
"-1.5 -36.5 -21"
c(peaks.M.L.b5s0.p85[neighbor,c(1:3)][[1]],peaks.M.L.b5s0.p85[neighbor,c(1:3)][[2]],peaks.M.L.b5s0.p85[neighbor,c(1:3)][[3]])
"-1.5 -36.5 -24.0"
peaks.M.K.b5s0.p85[1,4]
"1.001706"
peaks.M.L.b5s0.p85[neighbor,4]
"0.7541"

# Highest peak in M.K.b5s5.p85 -> M.L.b5s5.p85
for (peak in 1:20) {
  peakA=c(peaks.M.K.b5s5.p85[1,c(1:3)][[1]],peaks.M.K.b5s5.p85[1,c(1:3)][[2]],peaks.M.K.b5s5.p85[1,c(1:3)][[3]])
  peakB=c(peaks.M.L.b5s5.p85[peak,c(1:3)][[1]],peaks.M.L.b5s5.p85[peak,c(1:3)][[2]],peaks.M.L.b5s5.p85[peak,c(1:3)][[3]])
  dist[peak]=EuclideanDistance(peakA,peakB)
}
min(dist)
"3"
which.min(dist)
"1"
neighbor=which.min(dist)
peaks.M.K.b5s5.p85[1,c(1:3)]
"-1.5 -36.5 -21"
c(peaks.M.L.b5s5.p85[neighbor,c(1:3)][[1]],peaks.M.L.b5s5.p85[neighbor,c(1:3)][[2]],peaks.M.L.b5s5.p85[neighbor,c(1:3)][[3]])
"-1.5 -36.5 -24.0"
peaks.M.K.b5s5.p85[1,4]
"1.058813"
peaks.M.L.b5s5.p85[neighbor,4]
"0.987008"

# Highest peak in S.K.b5s0.p85 -> S.L.b5s0.p85
for (peak in 1:20) {
  peakA=c(peaks.S.K.b5s0.p85[1,c(1:3)][[1]],peaks.S.K.b5s0.p85[1,c(1:3)][[2]],peaks.S.K.b5s0.p85[1,c(1:3)][[3]])
  peakB=c(peaks.S.L.b5s0.p85[peak,c(1:3)][[1]],peaks.S.L.b5s0.p85[peak,c(1:3)][[2]],peaks.S.L.b5s0.p85[peak,c(1:3)][[3]])
  dist[peak]=EuclideanDistance(peakA,peakB)
}
min(dist)
"6.708204"
which.min(dist)
"1"
neighbor=which.min(dist)
peaks.S.K.b5s0.p85[1,c(1:3)]
"-1.5 -36.5 -21"
c(peaks.S.L.b5s0.p85[neighbor,c(1:3)][[1]],peaks.S.L.b5s0.p85[neighbor,c(1:3)][[2]],peaks.S.L.b5s0.p85[neighbor,c(1:3)][[3]])
"4.5 -36.5 -24.0"
peaks.S.K.b5s0.p85[1,4]
"0.738758"
peaks.S.L.b5s0.p85[neighbor,4]
"0.454096"

# Highest peak in S.K.b5s5.p85 -> S.L.b5s5.p85
for (peak in 1:20) {
  peakA=c(peaks.S.K.b5s5.p85[1,c(1:3)][[1]],peaks.S.K.b5s5.p85[1,c(1:3)][[2]],peaks.S.K.b5s5.p85[1,c(1:3)][[3]])
  peakB=c(peaks.S.L.b5s5.p85[peak,c(1:3)][[1]],peaks.S.L.b5s5.p85[peak,c(1:3)][[2]],peaks.S.L.b5s5.p85[peak,c(1:3)][[3]])
  dist[peak]=EuclideanDistance(peakA,peakB)
}
min(dist)
"4.242641"
which.min(dist)
"1"
neighbor=which.min(dist)
peaks.S.K.b5s5.p85[1,c(1:3)]
"-1.5 -36.5 -21"
c(peaks.S.L.b5s5.p85[neighbor,c(1:3)][[1]],peaks.S.L.b5s5.p85[neighbor,c(1:3)][[2]],peaks.S.L.b5s5.p85[neighbor,c(1:3)][[3]])
"1.5 -36.5 -24"
peaks.S.K.b5s5.p85[1,4]
"0.884236"
peaks.S.L.b5s5.p85[neighbor,4]
"0.691859"









