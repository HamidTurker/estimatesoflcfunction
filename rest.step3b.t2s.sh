# Resting state analysis - create the probabilistic map of the traced LC ROIs
# execute via:
# ./rest.step3b.t2s.sh
# 5 June 2019 - HBT
#
# =========================== setup ============================
start=`date '+%m %d %Y at %H %M %S'`

# Create ideal t2* map
base_dir=/home/fMRI/projects/tempAttnAudT/analysis/univariate/rest_results
analysis_dir=${base_dir}/analysis
atlas_dir=/usr/lib/afni/bin/
mkdir ${analysis_dir}/t2s
cd ${analysis_dir}/t2s

for subj in 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27; do
#gunzip $base_dir/tAATs${subj}/ME/tAATs${subj}_t2svm_ss.nii.gz

    3dresample -rmode Li -overwrite -master $base_dir/tAATs${subj}/ME/mprage-BET.25-noskull_do.nii -dxyz 3 3 3 -input $base_dir/tAATs${subj}/ME/tAATs${subj}_t2svm_ss.nii -prefix tAATs${subj}_t2svm_ss.resamp.nii
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $base_dir/tAATs${subj}/ME/transform_deob_epi2mni.1D -input tAATs${subj}_t2svm_ss.resamp.nii -prefix tAATs${subj}_t2svm_ss.mni.nii -master $base_dir/tAATs${subj}/abtemplate.nii.gz -mast_dxyz 3 3 3
done

# Mean t2* map
3dmerge -overwrite -gmean -prefix t2s_mean.nii tAATs*.mni.nii

# SD t2* map
3dMean -overwrite -non_zero -sd -prefix t2s_sd.nii tAATs*.nii
#3dresample -overwrite -master ${atlas_dir}/MNIa_caez_N27+tlrc -prefix t2s_sd.nii -input t2s_sd.nii
3dcalc -overwrite -a ${atlas_dir}/MNIa_caez_N27+tlrc -b t2s_sd.nii -expr 'step(a)*b' -prefix t2s_sd_step.nii

3dMean -overwrite -sd -prefix xt2s_sd.nii xtAATs*.nii

# t2* ROI stats
for subj in 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27; do
    subj_name="tAATs"$subj
    rest_dir=$base_dir/${subj_name}/ME
    roi_dir=/home/fMRI/projects/tempAttnAudT/analysis/rois/$subj_name/

    # Resamp masks
    3dresample -rmode NN -input $rest_dir/rois/mask_WM_min2.${subj_name}_nat.nii -prefix mask.WM.nii -master $rest_dir/tAATs${subj}_t2svm_ss.nii
    3dresample -rmode NN -input ${roi_dir}lr-V1-only-3mm+orig -prefix mask.V1.nii -master $rest_dir/tAATs${subj}_t2svm_ss.nii
    3dresample -rmode NN -input ${roi_dir}lr-gm-3mm+orig -prefix mask.GM.nii -master $rest_dir/tAATs${subj}_t2svm_ss.nii
    3dresample -rmode NN -input ${roi_dir}lr-vmpfc-3mm+orig -prefix mask.vmPFC.nii -master $rest_dir/tAATs${subj}_t2svm_ss.nii
    3dresample -rmode NN -input ${roi_dir}lr-precentral-3mm+orig -prefix mask.MC.nii -master $rest_dir/tAATs${subj}_t2svm_ss.nii
    3dresample -rmode NN -input ${roi_dir}lr-transtemp-3mm+orig -prefix mask.AC.nii -master $rest_dir/tAATs${subj}_t2svm_ss.nii
    3dfractionize -overwrite -clip .1 -template $rest_dir/tAATs${subj}_t2svm_ss.nii \
        -input /home/fMRI/projects/tempAttnAudT/$subj_name/afni/*/LCx_ROI_overlap_inMPRAGE_${subj_name}+orig.BRIK -prefix mask.LC.nii
    3dfractionize -overwrite -clip .1 -template $rest_dir/tAATs${subj}_t2svm_ss.nii \
        -input /home/fMRI/projects/tempAttnAudT/$subj_name/afni/*/PT_ROI_overlap_inMPRAGE_${subj_name}.nii -prefix mask.PT.nii
    3dfractionize -overwrite -clip .1 -template tAATs${subj}_t2svm_ss.mni.nii \
        -input /home/fMRI/projects/tempAttnAudT/analysis/LC_maps/LC_1SD_BINARY_TEMPLATE.nii -prefix mask.K1.nii
    3dfractionize -overwrite -clip .1 -template tAATs${subj}_t2svm_ss.mni.nii \
        -input /home/fMRI/projects/tempAttnAudT/analysis/LC_maps/LC_1SD_BINARY_TEMPLATE.nii -prefix mask.K2.nii

    for roi in WM LC V1 GM vmPFC MC AC PT; do
        3dmaskave -quiet -mask mask.$roi.nii $rest_dir/tAATs${subj}_t2svm_ss.nii > t2stat.$roi.tAATs${subj}.1D
    done

    for roi in K1 K2; do
        3dmaskave -quiet -mask mask.$roi.nii tAATs${subj}_t2svm_ss.mni.nii > t2stat.$roi.tAATs${subj}.1D
    done

    rm mask.*.nii
done


# Compile t2stats
out_file=compiled_t2stats.txt
header="Subj,Roi,t2s"
echo $header > $out_file

for subj in 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27; do
for roi in WM LC V1 GM vmPFC MC AC PT K1 K2; do

    awk '{OFS=","} {print "'$subj'","'$roi'",$0}' t2stat.$roi.tAATs${subj}.1D >> $out_file

done; done

cp $out_file $analysis_dir
rm t2stat.*.1D $out_file
cd ../../final_scripts

end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end
