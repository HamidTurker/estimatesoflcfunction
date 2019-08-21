# Resting state analysis - create the probabilistic map of the traced LC ROIs
# execute via:
# ./rest.step3.tracedLCmap.sh
# 5 June 2019 - HBT
#
# =========================== setup ============================
start=`date '+%m %d %Y at %H %M %S'`

# Traced LC volumetric measurments
base_dir=/home/fMRI/projects/tempAttnAudT/analysis/univariate/rest_results
analysis_dir=${base_dir}/analysis
mkdir ${analysis_dir}/nm_volume
cd ${analysis_dir}/nm_volume

for subj in 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27
do

    3dBrickStat -volume -non-zero ${base_dir}/inTSE/tAATs${subj}/ME/rois/mask_LCoverlap.tAATs${subj}_rest_tse.frac.nii > tse.volume.tAATs${subj}.txt
    3dBrickStat -count -non-zero ${base_dir}/inTSE/tAATs${subj}/ME/rois/mask_LCoverlap.tAATs${subj}_rest_tse.frac.nii > tse.count.tAATs${subj}.txt
    3dBrickStat -sum -non-zero ${base_dir}/inTSE/tAATs${subj}/ME/rois/mask_LCoverlap.tAATs${subj}_rest_tse.frac.nii > tse.sum.tAATs${subj}.txt

    3dBrickStat -volume -non-zero ${base_dir}/tAATs${subj}/ME/rois/mask_LCoverlap.tAATs${subj}_rest_nat.frac.nii > nat.volume.tAATs${subj}.txt
    3dBrickStat -count -non-zero ${base_dir}/tAATs${subj}/ME/rois/mask_LCoverlap.tAATs${subj}_rest_nat.frac.nii > nat.count.tAATs${subj}.txt
    3dBrickStat -sum -non-zero ${base_dir}/tAATs${subj}/ME/rois/mask_LCoverlap.tAATs${subj}_rest_nat.frac.nii > nat.sum.tAATs${subj}.txt

done



end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end