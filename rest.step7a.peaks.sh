# Resting state analysis - preprocessing for multi-echo data
# execute via:
# ./rest.fcon.overlap.step7.descriptives.sh s??
# July 2019 - HBT
# =========================== setup ============================
start=`date '+%m %d %Y at %H %M %S'`

set -e
jobs=4

# environment variables
export OMP_NUM_THREADS=$jobs
export MKL_NUM_THREADS=$jobs
export DYLD_FALLBACK_LIBRARY_PATH=/Users/khena/abin

# set up parameters
base_dir=/home/fMRI/projects/tempAttnAudT/
analysis_dir=${base_dir}analysis/univariate/rest_results/analysis/
onesamp_dir=$analysis_dir/onesamp_nat_wmr1_gsr0

cd $onesamp_dir

3dcalc -overwrite -a Multi.K1.b5.s0+tlrc'[0]' -expr 'step(a)' -prefix mask_Multi.K1.b5s0.nii
3dcalc -overwrite -a Multi.K1.b5.s5+tlrc'[0]' -expr 'step(a)' -prefix mask_Multi.K1.b5s5.nii
3dcalc -overwrite -a Multi.LC.b5.s0+tlrc'[0]' -expr 'step(a)' -prefix mask_Multi.LC.b5s0.nii
3dcalc -overwrite -a Multi.LC.b5.s5+tlrc'[0]' -expr 'step(a)' -prefix mask_Multi.LC.b5s5.nii

3dcalc -overwrite -a Single.K1.b5.s0+tlrc'[0]' -expr 'step(a)' -prefix mask_Single.K1.b5s0.nii
3dcalc -overwrite -a Single.K1.b5.s5+tlrc'[0]' -expr 'step(a)' -prefix mask_Single.K1.b5s5.nii
3dcalc -overwrite -a Single.LC.b5.s0+tlrc'[0]' -expr 'step(a)' -prefix mask_Single.LC.b5s0.nii
3dcalc -overwrite -a Single.LC.b5.s5+tlrc'[0]' -expr 'step(a)' -prefix mask_Single.LC.b5s5.nii

#################################################### Threshold the maps
########################## Multi Keren
# M K b5s0
3dBrickStat -mask Multi.K1.b5.s0+tlrc -non-zero -percentile 0 1 100 Multi.K1.b5.s0+tlrc'[0]' > percentiles_M.K1.b5s0.1D
hold=`cat percentiles_M.K1.b5s0.1D`; perc=($hold);
M_Kb5s0_p85=${perc[171]};

# M K b5s5
3dBrickStat -mask Multi.K1.b5.s5+tlrc -non-zero -percentile 0 1 100 Multi.K1.b5.s5+tlrc'[0]' > percentiles_M.K1.b5s5.1D
hold=`cat percentiles_M.K1.b5s5.1D`; perc=($hold);
M_Kb5s5_p85=${perc[171]};

########################## Single Keren
# S K b5s0
3dBrickStat -mask Single.K1.b5.s0+tlrc -non-zero -percentile 0 1 100 Single.K1.b5.s0+tlrc'[0]' > percentiles_S.K1.b5s0.1D
hold=`cat percentiles_S.K1.b5s0.1D`; perc=($hold);
S_Kb5s0_p85=${perc[171]};

# S K b5s5
3dBrickStat -mask Single.K1.b5.s5+tlrc -non-zero -percentile 0 1 100 Single.K1.b5.s5+tlrc'[0]' > percentiles_S.K1.b5s5.1D
hold=`cat percentiles_S.K1.b5s5.1D`; perc=($hold);
S_Kb5s5_p85=${perc[171]};

########################## Multi LC
# M L b5s0
3dBrickStat -mask Multi.LC.b5.s0+tlrc -non-zero -percentile 0 1 100 Multi.LC.b5.s0+tlrc'[0]' > percentiles_M.LC.b5s0.1D
hold=`cat percentiles_M.LC.b5s0.1D`; perc=($hold);
M_Lb5s0_p85=${perc[171]};

# M L b5s5
3dBrickStat -mask Multi.LC.b5.s5+tlrc -non-zero -percentile 0 1 100 Multi.LC.b5.s5+tlrc'[0]' > percentiles_M.LC.b5s5.1D
hold=`cat percentiles_M.LC.b5s5.1D`; perc=($hold);
M_Lb5s5_p85=${perc[171]};

########################## Single LC
# S L b5s0
3dBrickStat -mask Single.LC.b5.s0+tlrc -non-zero -percentile 0 1 100 Single.LC.b5.s0+tlrc'[0]' > percentiles_S.LC.b5s0.1D
hold=`cat percentiles_S.LC.b5s0.1D`; perc=($hold);
S_Lb5s0_p85=${perc[171]};

# S L b5s5
3dBrickStat -mask Single.LC.b5.s5+tlrc -non-zero -percentile 0 1 100 Single.LC.b5.s5+tlrc'[0]' > percentiles_S.LC.b5s5.1D
hold=`cat percentiles_S.LC.b5s5.1D`; perc=($hold);
S_Lb5s5_p85=${perc[171]};


for percentile in 85;
do
for base in 5;
do
for seed in 0 5;
do
    this_tile=M_Kb${base}s${seed}_p${percentile}
    3dcalc -overwrite -a Multi.K1.b$base.s$seed+tlrc -expr 'step(a)*ispositive(a-'${!this_tile}')' -prefix x.M.K1.b${base}s${seed}.p${percentile}.nii # Create mask
    3dcalc -overwrite -a Multi.K1.b$base.s$seed+tlrc -b x.M.K1.b${base}s${seed}.p${percentile}.nii -expr 'step(b)*(a)' -prefix thresh.M.K1.b${base}s${seed}.p${percentile} # Masked data

    this_tile=S_Kb${base}s${seed}_p${percentile}
    3dcalc -overwrite -a Single.K1.b$base.s$seed+tlrc -expr 'step(a)*ispositive(a-'${!this_tile}')' -prefix x.S.K1.b${base}s${seed}.p${percentile}.nii
    3dcalc -overwrite -a Single.K1.b$base.s$seed+tlrc -b x.S.K1.b${base}s${seed}.p${percentile}.nii -expr 'step(b)*(a)' -prefix thresh.S.K1.b${base}s${seed}.p${percentile}

    this_tile=M_Lb${base}s${seed}_p${percentile}
    3dcalc -overwrite -a Multi.LC.b$base.s$seed+tlrc -expr 'step(a)*ispositive(a-'${!this_tile}')' -prefix x.M.LC.b${base}s${seed}.p${percentile}.nii
    3dcalc -overwrite -a Multi.LC.b$base.s$seed+tlrc -b x.M.LC.b${base}s${seed}.p${percentile}.nii -expr 'step(b)*(a)' -prefix thresh.M.LC.b${base}s${seed}.p${percentile}

    this_tile=S_Lb${base}s${seed}_p${percentile}
    3dcalc -overwrite -a Single.LC.b$base.s$seed+tlrc -expr 'step(a)*ispositive(a-'${!this_tile}')' -prefix x.S.LC.b${base}s${seed}.p${percentile}.nii
    3dcalc -overwrite -a Single.LC.b$base.s$seed+tlrc -b x.S.LC.b${base}s${seed}.p${percentile}.nii -expr 'step(b)*(a)' -prefix thresh.S.LC.b${base}s${seed}.p${percentile}
done
done
done


#################################################### Find peaks

base_dir=/home/fMRI/projects/tempAttnAudT/
analysis_dir=${base_dir}analysis/univariate/rest_results/analysis/
onesamp_dir=$analysis_dir/onesamp_nat_wmr1_gsr0

out_rad=1
min_dist=6
thresh_val=.1

for perc in 85;
do
for base in 5;
do
for seed in 0 5;
do
for roi in K1 LC;
do
    3dcalc -overwrite -a thresh.M.${roi}.b${base}s${seed}.p${perc}+tlrc'[0]' -prefix thresh.M.${roi}.b${base}s${seed}.p${perc}+tlrc -datum short -expr 'a'
    3dmaxima -overwrite -input thresh.M.${roi}.b${base}s${seed}.p${perc}+tlrc -spheres_Nto1 -thresh ${thresh_val} -min_dist $min_dist -out_rad $out_rad -dset_coords -prefix peaks.M.${roi}.b${base}s${seed}.p${perc}+tlrc
    3dcalc -overwrite -a peaks.M.${roi}.b${base}s${seed}.p${perc}+tlrc -b mask_Multi.${roi}.b${base}s${seed}.nii -prefix rankedpeaks.M.${roi}.b${base}s${seed}.p${perc}+tlrc -expr 'step(b)*posval(a)'
    3dmaxima -overwrite -input thresh.M.${roi}.b${base}s${seed}.p${perc}+tlrc -spheres_Nto1 -thresh ${thresh_val} -min_dist $min_dist -dset_coords > peaks.M.${roi}.b${base}s${seed}.p${perc}.txt

    3dcalc -overwrite -a thresh.S.${roi}.b${base}s${seed}.p${perc}+tlrc'[0]' -prefix thresh.S.${roi}.b${base}s${seed}.p${perc}+tlrc -datum short -expr 'a'
    3dmaxima -overwrite -input thresh.S.${roi}.b${base}s${seed}.p${perc}+tlrc -spheres_1toN -thresh ${thresh_val} -min_dist $min_dist -out_rad $out_rad -dset_coords -prefix peaks.S.${roi}.b${base}s${seed}.p${perc}+tlrc
    3dcalc -overwrite -a peaks.S.${roi}.b${base}s${seed}.p${perc}+tlrc -b mask_Single.${roi}.b${base}s${seed}.nii -prefix rankedpeaks.S.${roi}.b${base}s${seed}.p${perc}+tlrc -expr 'step(b)*posval(a)'
    3dmaxima -overwrite -input thresh.S.${roi}.b${base}s${seed}.p${perc}+tlrc -spheres_1toN -thresh ${thresh_val} -min_dist $min_dist -dset_coords > peaks.S.${roi}.b${base}s${seed}.p${perc}.txt
done
done
done
done

#################################################### Format and compile peak data

out_file=compiled_peaks_wmr1_gsr0.txt
header="X,Y,Z,Value,Prep,ROI,Perc,Base,Seed"
echo $header > $out_file
hold_fileA=holdA.txt
hold_fileB=holdB.txt

for perc in 85;
do
for base in 5;
do
for seed in 0 5;
do
for roi in K1 LC;
do
for prep in M S;
do
    awk '{OFS=","} {sub(/\(/,""); print $0,"'${prep}'","'${roi}'",'${perc}','${base}','${seed}'} NR==23{exit}' < peaks.${prep}.${roi}.b${base}s${seed}.p${perc}.txt | grep 'val' >> $hold_fileA
done
done
done
done
done

awk '{sub(/\) : val = /,","); print}' < $hold_fileA > $hold_fileB
awk '{gsub(/.50 /,".50,"); print}' < $hold_fileB > $hold_fileA
awk '{print $0}' < $hold_fileA >> $out_file


echo   "++++++++++++++++++++++++"
echo   "Housekeeping"
cp $out_file ../

rm x* hold* compiled*

cd ../../

end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end







