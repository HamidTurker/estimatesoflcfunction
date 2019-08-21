# Load supplementary scripts & dependencies
library(signal)

setwd("/Users/hamid/Desktop/Research/fMRI/LC Methods/rest_results/analysis/PT")

subj = 17
n_iters = 10

##################################################################################################### M.K1
M.K1.s0 = read.csv(paste("seed_Keren1SD.ME.tAATs",as.character(subj),".blur0.txt", sep=""), header=F, sep=" ")
M.K1.s0 = M.K1.s0[,3:length(M.K1.s0)]

res_M.K1.s0=matrix(0,length(M.K1.s0[,1]),n_iters)
ROI_A=matrix(0,length(M.K1.s0[,1]),1)
ROI_B=matrix(0,length(M.K1.s0[,1]),1)
for (i in 1:n_iters) {
  if (length(M.K1.s0[1,]) %% 2 == 0) { # even number of voxels in ROI
    voxs = 1:length(M.K1.s0)
  
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
  
    ROI_A=matrix(0,length(M.K1.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+M.K1.s0[sample_A[j]][1]  
    }
    ROI_A=as.matrix(ROI_A/length(sample_A))
  
    ROI_B=matrix(0,length(M.K1.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+M.K1.s0[sample_B[j]][1]  
    }
    ROI_B=as.matrix(ROI_B/length(sample_B))
  
  } else {                             # uneven number of voxels in ROI
    voxs = 1:(length(M.K1.s0)-1)
  
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
  
    ROI_A=matrix(0,length(M.K1.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+M.K1.s0[sample_A[j]][1]
    }
    ROI_A=as.matrix((ROI_A+M.K1.s0[,length(M.K1.s0)])/(length(sample_A)+1))
  
    ROI_B=matrix(0,length(M.K1.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+M.K1.s0[sample_B[j]][1]
    }
    ROI_B=as.matrix((ROI_B+M.K1.s0[,length(M.K1.s0)])/(length(sample_B)+1))
  }
res_M.K1.s0[,i]=residuals(lm(ROI_B~ROI_A))
}

M.K1.s5 = read.csv(paste("seed_Keren1SD.ME.tAATs",as.character(subj),".blur5.txt", sep=""), header=F, sep=" ")
M.K1.s5 = M.K1.s5[,3:length(M.K1.s5)]

res_M.K1.s5=matrix(0,length(M.K1.s5[,1]),n_iters)
ROI_A=matrix(0,length(M.K1.s5[,1]),1)
ROI_B=matrix(0,length(M.K1.s5[,1]),1)
for (i in 1:n_iters) {
  if (length(M.K1.s5[1,]) %% 2 == 0) { # even number of voxels in ROI
    voxs = 1:length(M.K1.s5)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(M.K1.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+M.K1.s5[sample_A[j]][1]  
    }
    ROI_A=as.matrix(ROI_A/length(sample_A))
    
    ROI_B=matrix(0,length(M.K1.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+M.K1.s5[sample_B[j]][1]  
    }
    ROI_B=as.matrix(ROI_B/length(sample_B))
    
  } else {                             # uneven number of voxels in ROI
    voxs = 1:(length(M.K1.s5)-1)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(M.K1.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+M.K1.s5[sample_A[j]][1]
    }
    ROI_A=as.matrix((ROI_A+M.K1.s5[,length(M.K1.s5)])/(length(sample_A)+1))
    
    ROI_B=matrix(0,length(M.K1.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+M.K1.s5[sample_B[j]][1]
    }
    ROI_B=as.matrix((ROI_B+M.K1.s5[,length(M.K1.s5)])/(length(sample_B)+1))
  }
  res_M.K1.s5[,i]=residuals(lm(ROI_B~ROI_A))
}

##################################################################################################### S.K1
S.K1.s0 = read.csv(paste("seed_Keren1SD.SE.tAATs",as.character(subj),".blur0.txt", sep=""), header=F, sep=" ")
S.K1.s0 = S.K1.s0[,3:length(S.K1.s0)]

res_S.K1.s0=matrix(0,length(S.K1.s0[,1]),n_iters)
ROI_A=matrix(0,length(S.K1.s0[,1]),1)
ROI_B=matrix(0,length(S.K1.s0[,1]),1)
for (i in 1:n_iters) {
  if (length(S.K1.s0[1,]) %% 2 == 0) { # even number of voxels in ROI
    voxs = 1:length(S.K1.s0)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(S.K1.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+S.K1.s0[sample_A[j]][1]  
    }
    ROI_A=as.matrix(ROI_A/length(sample_A))
    
    ROI_B=matrix(0,length(S.K1.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+S.K1.s0[sample_B[j]][1]  
    }
    ROI_B=as.matrix(ROI_B/length(sample_B))
    
  } else {                             # uneven number of voxels in ROI
    voxs = 1:(length(S.K1.s0)-1)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(S.K1.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+S.K1.s0[sample_A[j]][1]
    }
    ROI_A=as.matrix((ROI_A+S.K1.s0[,length(S.K1.s0)])/(length(sample_A)+1))
    
    ROI_B=matrix(0,length(S.K1.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+S.K1.s0[sample_B[j]][1]
    }
    ROI_B=as.matrix((ROI_B+S.K1.s0[,length(S.K1.s0)])/(length(sample_B)+1))
  }
  res_S.K1.s0[,i]=residuals(lm(ROI_B~ROI_A))
}

S.K1.s5 = read.csv(paste("seed_Keren1SD.SE.tAATs",as.character(subj),".blur5.txt", sep=""), header=F, sep=" ")
S.K1.s5 = S.K1.s5[,3:length(S.K1.s5)]

res_S.K1.s5=matrix(0,length(S.K1.s5[,1]),n_iters)
ROI_A=matrix(0,length(S.K1.s5[,1]),1)
ROI_B=matrix(0,length(S.K1.s5[,1]),1)
for (i in 1:n_iters) {
  if (length(S.K1.s5[1,]) %% 2 == 0) { # even number of voxels in ROI
    voxs = 1:length(S.K1.s5)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(S.K1.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+S.K1.s5[sample_A[j]][1]  
    }
    ROI_A=as.matrix(ROI_A/length(sample_A))
    
    ROI_B=matrix(0,length(S.K1.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+S.K1.s5[sample_B[j]][1]  
    }
    ROI_B=as.matrix(ROI_B/length(sample_B))
    
  } else {                             # uneven number of voxels in ROI
    voxs = 1:(length(S.K1.s5)-1)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(S.K1.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+S.K1.s5[sample_A[j]][1]
    }
    ROI_A=as.matrix((ROI_A+S.K1.s5[,length(S.K1.s5)])/(length(sample_A)+1))
    
    ROI_B=matrix(0,length(S.K1.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+S.K1.s5[sample_B[j]][1]
    }
    ROI_B=as.matrix((ROI_B+S.K1.s5[,length(S.K1.s5)])/(length(sample_B)+1))
  }
  res_S.K1.s5[,i]=residuals(lm(ROI_B~ROI_A))
}

##################################################################################################### M.LC
M.LC.s0 = read.csv(paste("seed_LC.ME.tAATs",as.character(subj),".blur0.txt", sep=""), header=F, sep=" ")
if ( length(M.LC.s0) == 3 ) { M.LC.s0[,4]=M.LC.s0[,3] }
M.LC.s0 = data.frame(M.LC.s0[,3:length(M.LC.s0)])

res_M.LC.s0=matrix(0,length(M.LC.s0[,1]),n_iters)
ROI_A=matrix(0,length(M.LC.s0[,1]),1)
ROI_B=matrix(0,length(M.LC.s0[,1]),1)
for (i in 1:n_iters) {
  if (length(M.LC.s0[1,]) %% 2 == 0) { # even number of voxels in ROI
    voxs = 1:length(M.LC.s0)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(M.LC.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+M.LC.s0[sample_A[j]][1]  
    }
    ROI_A=as.matrix(ROI_A/length(sample_A))
    
    ROI_B=matrix(0,length(M.LC.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+M.LC.s0[sample_B[j]][1]  
    }
    ROI_B=as.matrix(ROI_B/length(sample_B))
    
  } else {                             # uneven number of voxels in ROI
    voxs = 1:(length(M.LC.s0)-1)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(M.LC.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+M.LC.s0[sample_A[j]][1]
    }
    ROI_A=as.matrix((ROI_A+M.LC.s0[,length(M.LC.s0)])/(length(sample_A)+1))
    
    ROI_B=matrix(0,length(M.LC.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+M.LC.s0[sample_B[j]][1]
    }
    ROI_B=as.matrix((ROI_B+M.LC.s0[,length(M.LC.s0)])/(length(sample_B)+1))
  }
  res_M.LC.s0[,i]=residuals(lm(ROI_B~ROI_A))
}

M.LC.s5 = read.csv(paste("seed_LC.ME.tAATs",as.character(subj),".blur5.txt", sep=""), header=F, sep=" ")
if ( length(M.LC.s5) == 3 ) { M.LC.s5[,4]=M.LC.s5[,3] }
M.LC.s5 = M.LC.s5[,3:length(M.LC.s5)]

res_M.LC.s5=matrix(0,length(M.LC.s5[,1]),n_iters)
ROI_A=matrix(0,length(M.LC.s5[,1]),1)
ROI_B=matrix(0,length(M.LC.s5[,1]),1)
for (i in 1:n_iters) {
  if (length(M.LC.s5[1,]) %% 2 == 0) { # even number of voxels in ROI
    voxs = 1:length(M.LC.s5)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(M.LC.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+M.LC.s5[sample_A[j]][1]  
    }
    ROI_A=as.matrix(ROI_A/length(sample_A))
    
    ROI_B=matrix(0,length(M.LC.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+M.LC.s5[sample_B[j]][1]  
    }
    ROI_B=as.matrix(ROI_B/length(sample_B))
    
  } else {                             # uneven number of voxels in ROI
    voxs = 1:(length(M.LC.s5)-1)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(M.LC.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+M.LC.s5[sample_A[j]][1]
    }
    ROI_A=as.matrix((ROI_A+M.LC.s5[,length(M.LC.s5)])/(length(sample_A)+1))
    
    ROI_B=matrix(0,length(M.LC.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+M.LC.s5[sample_B[j]][1]
    }
    ROI_B=as.matrix((ROI_B+M.LC.s5[,length(M.LC.s5)])/(length(sample_B)+1))
  }
  res_M.LC.s5[,i]=residuals(lm(ROI_B~ROI_A))
}

##################################################################################################### S.LC
S.LC.s0 = read.csv(paste("seed_LC.SE.tAATs",as.character(subj),".blur0.txt", sep=""), header=F, sep=" ")
if ( length(S.LC.s0) == 3 ) { S.LC.s0[,4]=S.LC.s0[,3] }
S.LC.s0 = S.LC.s0[,3:length(S.LC.s0)]

res_S.LC.s0=matrix(0,length(S.LC.s0[,1]),n_iters)
ROI_A=matrix(0,length(S.LC.s0[,1]),1)
ROI_B=matrix(0,length(S.LC.s0[,1]),1)
for (i in 1:n_iters) {
  if (length(S.LC.s0[1,]) %% 2 == 0) { # even number of voxels in ROI
    voxs = 1:length(S.LC.s0)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(S.LC.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+S.LC.s0[sample_A[j]][1]  
    }
    ROI_A=as.matrix(ROI_A/length(sample_A))
    
    ROI_B=matrix(0,length(S.LC.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+S.LC.s0[sample_B[j]][1]  
    }
    ROI_B=as.matrix(ROI_B/length(sample_B))
    
  } else {                             # uneven number of voxels in ROI
    voxs = 1:(length(S.LC.s0)-1)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(S.LC.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+S.LC.s0[sample_A[j]][1]
    }
    ROI_A=as.matrix((ROI_A+S.LC.s0[,length(S.LC.s0)])/(length(sample_A)+1))
    
    ROI_B=matrix(0,length(S.LC.s0[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+S.LC.s0[sample_B[j]][1]
    }
    ROI_B=as.matrix((ROI_B+S.LC.s0[,length(S.LC.s0)])/(length(sample_B)+1))
  }
  res_S.LC.s0[,i]=residuals(lm(ROI_B~ROI_A))
}

S.LC.s5 = read.csv(paste("seed_LC.SE.tAATs",as.character(subj),".blur5.txt", sep=""), header=F, sep=" ")
if ( length(S.LC.s5) == 3 ) { S.LC.s5[,4]=S.LC.s5[,3] }
S.LC.s5 = S.LC.s5[,3:length(S.LC.s5)]

res_S.LC.s5=matrix(0,length(S.LC.s5[,1]),n_iters)
ROI_A=matrix(0,length(S.LC.s5[,1]),1)
ROI_B=matrix(0,length(S.LC.s5[,1]),1)
for (i in 1:n_iters) {
  if (length(S.LC.s5[1,]) %% 2 == 0) { # even number of voxels in ROI
    voxs = 1:length(S.LC.s5)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(S.LC.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+S.LC.s5[sample_A[j]][1]  
    }
    ROI_A=as.matrix(ROI_A/length(sample_A))
    
    ROI_B=matrix(0,length(S.LC.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+S.LC.s5[sample_B[j]][1]  
    }
    ROI_B=as.matrix(ROI_B/length(sample_B))
    
  } else {                             # uneven number of voxels in ROI
    voxs = 1:(length(S.LC.s5)-1)
    
    this_sample = sample(voxs)
    sample_A = this_sample[1:(length(voxs)/2)]
    sample_B = this_sample[((length(voxs)/2)+1):length(voxs)]
    
    ROI_A=matrix(0,length(S.LC.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_A = ROI_A+S.LC.s5[sample_A[j]][1]
    }
    ROI_A=as.matrix((ROI_A+S.LC.s5[,length(S.LC.s5)])/(length(sample_A)+1))
    
    ROI_B=matrix(0,length(S.LC.s5[,1]),1)
    for (j in 1:length(sample_A)) {
      ROI_B = ROI_B+S.LC.s5[sample_B[j]][1]
    }
    ROI_B=as.matrix((ROI_B+S.LC.s5[,length(S.LC.s5)])/(length(sample_B)+1))
  }
  res_S.LC.s5[,i]=residuals(lm(ROI_B~ROI_A))
}

##################################################################################################### M.PT
M.PT.s0 = as.matrix(read.csv(paste("seed_PT.ME.tAATs",as.character(subj),"_medn_nat_seed0.WM_1.GSR_0.tproj.NTRP.frac.1D", sep=""), header=F, sep=" "))
M.PT.s5 = as.matrix(read.csv(paste("seed_PT.ME.tAATs",as.character(subj),"_medn_nat_seed5.WM_1.GSR_0.tproj.NTRP.frac.1D", sep=""), header=F, sep=" "))

model_M.PT.s0 = sgolayfilt(M.PT.s0, p=3)
model_M.PT.s5 = sgolayfilt(M.PT.s5, p=3)
newseed_M.PT.s0_withK1 = model_M.PT.s0+res_M.K1.s0
newseed_M.PT.s5_withK1 = model_M.PT.s5+res_M.K1.s5
newseed_M.PT.s0_withLC = model_M.PT.s0+res_M.LC.s0
newseed_M.PT.s5_withLC = model_M.PT.s5+res_M.LC.s5

##################################################################################################### S.PT
S.PT.s0 = as.matrix(read.csv(paste("seed_PT.SE.tAATs",as.character(subj),"_e2_nat_seed0.WM_1.GSR_0.tproj.NTRP.frac.1D", sep=""), header=F, sep=" "))
S.PT.s5 = as.matrix(read.csv(paste("seed_PT.SE.tAATs",as.character(subj),"_e2_nat_seed5.WM_1.GSR_0.tproj.NTRP.frac.1D", sep=""), header=F, sep=" "))

model_S.PT.s0 = sgolayfilt(S.PT.s0, p=3)
model_S.PT.s5 = sgolayfilt(S.PT.s5, p=3)
newseed_S.PT.s0_withK1 = model_S.PT.s0+res_S.K1.s0
newseed_S.PT.s5_withK1 = model_S.PT.s5+res_S.K1.s5
newseed_S.PT.s0_withLC = model_S.PT.s0+res_S.LC.s0
newseed_S.PT.s5_withLC = model_S.PT.s5+res_S.LC.s5

##################################################################################################### Write out
for (i in 1:n_iters) {
  write(newseed_M.PT.s0_withK1[,i], file=paste("control_tAATs",as.character(subj),".ME.PT.s0_withK1_seed",as.character(i),".txt", sep=""), sep="\n")
  write(newseed_M.PT.s5_withK1[,i], file=paste("control_tAATs",as.character(subj),".ME.PT.s5_withK1_seed",as.character(i),".txt", sep=""), sep="\n")
  write(newseed_M.PT.s0_withLC[,i], file=paste("control_tAATs",as.character(subj),".ME.PT.s0_withLC_seed",as.character(i),".txt", sep=""), sep="\n")
  write(newseed_M.PT.s5_withLC[,i], file=paste("control_tAATs",as.character(subj),".ME.PT.s5_withLC_seed",as.character(i),".txt", sep=""), sep="\n")
  write(newseed_S.PT.s0_withK1[,i], file=paste("control_tAATs",as.character(subj),".SE.PT.s0_withK1_seed",as.character(i),".txt", sep=""), sep="\n")
  write(newseed_S.PT.s5_withK1[,i], file=paste("control_tAATs",as.character(subj),".SE.PT.s5_withK1_seed",as.character(i),".txt", sep=""), sep="\n")
  write(newseed_S.PT.s0_withLC[,i], file=paste("control_tAATs",as.character(subj),".SE.PT.s0_withLC_seed",as.character(i),".txt", sep=""), sep="\n")
  write(newseed_S.PT.s5_withLC[,i], file=paste("control_tAATs",as.character(subj),".SE.PT.s5_withLC_seed",as.character(i),".txt", sep=""), sep="\n")
}
