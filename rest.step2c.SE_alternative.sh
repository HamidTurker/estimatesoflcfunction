# Resting state analysis - preprocessing for multi-echo data
# execute via:
# ./rest.step2.SE.sh s??
# May 2019 - HBT

# The resting state analysis scripts are based on three things:
# 1. The standard rs-fMRI procedure as implemented by AFNI's uber_subject.py
# 2. "Effective Preprocessing Procedures Virtually Eliminate Distance-Dependent Motion Artifacts in Resting State FRMI" - Joon Jo ... Cox, Saad
# https://afni.nimh.nih.gov/pub/dist/HBM2013/Motion_LocalWMe_JAM_Jo2013.pdf
# 3. Khena Swallow's prepare-denoised-nomeica and run-meica scripts for the tempAttnAudT-ME task data

# Multi-Echo ICA, Version v2.5 beta1
# Kundu, P., Brenowitz, N.D., Voon, V., Worbe, Y., Vertes, P.E., Inati, S.J., Saad, Z.S.,
# Bandettini, P.A. & Bullmore, E.T. Integrated strategy for improving functional
# connectivity mapping using multiecho fMRI. PNAS (2013).
#
# Kundu, P., Inati, S.J., Evans, J.W., Luh, W.M. & Bandettini, P.A. Differentiating
#   BOLD and non-BOLD signals in fMRI time series using multi-echo EPI. NeuroImage (2011).
# http://dx.doi.org/10.1016/j.neuroimage.2011.12.028
#
# =========================== setup ============================
start=`date '+%m %d %Y at %H %M %S'`

set -e
jobs=4
nTR=202
TE=3.0
bet=.25
blur=5
dims=3
Kclip=.1
Lclip=.1

# environment variables
export OMP_NUM_THREADS=$jobs
export MKL_NUM_THREADS=$jobs
export DYLD_FALLBACK_LIBRARY_PATH=/Users/khena/abin
export AFNI_3dDespike_NEW=YES

# set up parameters
bet_loc=/usr/share/fsl/5.0/bin/bet
meica_loc=/usr/lib/afni/bin/
atlas_dir=/usr/lib/afni/bin/
base_dir=/home/fMRI/projects/tempAttnAudT/
spec_filename="spec.txt"

args=("$@")
if [ $# > 0 ]
then
    subj=${args[0]}
    subj_name="tAAT"$subj
    subj_dir=${base_dir}$subj_name/
    data_dir=$subj_dir"medata/"
    rest_dir=${base_dir}analysis/univariate/rest_results/$subj_name/
    v4_dir=${base_dir}analysis/univariate/e2_both_results/$subj_name/
    roi_dir=${base_dir}analysis/rois/$subj_name/
    echo "Running $subj_name"
else
echo "Arguments missing, terminating"
exit
fi

# =========================== make directories and copy files ============================
# assert directory contains a single E_subjID folder #
cd $base_dir"/"$subj_name"/afni/"
for i in `find ./ -maxdepth 1 -name 'E*'`
do
    enum=`echo $i | awk '{print substr($0,4)}'`
done
afni_dir=$subj_dir"afni/E"$enum/

# read in spec.txt file
spec_file=$(<$subj_dir"/"$spec_filename)
spec_list=()
for line in $spec_file;
do
   spec_list=("${spec_list[@]}" $line)
done
subj_E_dir=${spec_list[0]}
mpragename=${spec_list[1]}
run=${spec_list[3]}


################################################# RICOR ONLY ################################################# RICOR ONLY #################################################
################################################# RICOR ONLY ################################################# RICOR ONLY #################################################
################################################# RICOR ONLY ################################################# RICOR ONLY #################################################

# =========================== Directory structure ============================
mkdir $rest_dir/alt
mkdir $rest_dir/temp2
cd $rest_dir/temp2

mkdir $rest_dir/alt/tsnr
mkdir $rest_dir/alt/fcon
mkdir $rest_dir/alt/rois
mkdir $rest_dir/alt/1d

cp $rest_dir/SE/${subj_name}_nat_e2.nii $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii
3dBlurToFWHM -overwrite -automask -FWHM $blur -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blur}.nii

ktrs=`1d_tool.py -infile $rest_dir/SE/1d/motion_rest_censor.1D -show_trs_uncensored encoded`

echo   "++++++++++++++++++++++++"
echo   "Bandpass and regress motion"
# 3dDeconvolve to generate xmats, then stop

# Native space: derivs +, WM +, GSR -, blur -
3dDeconvolve -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii                        \
    -censor $rest_dir/SE/1d/motion_rest_censor.1D                                          \
    -ortvec $rest_dir/SE/1d/bandpass_regressor.1D bandpass                                 \
    -polort A                                                                                \
    -num_stimts 13                                                                            \
    -stim_file 1 $rest_dir/SE/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
    -stim_file 2 $rest_dir/SE/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
    -stim_file 3 $rest_dir/SE/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
    -stim_file 4 $rest_dir/SE/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
    -stim_file 5 $rest_dir/SE/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
    -stim_file 6 $rest_dir/SE/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
    -stim_file 7 $rest_dir/SE/1d/motion_deriv.1D'[0]' -stim_base 7 -stim_label 7 roll_02   \
    -stim_file 8 $rest_dir/SE/1d/motion_deriv.1D'[1]' -stim_base 8 -stim_label 8 pitch_02       \
    -stim_file 9 $rest_dir/SE/1d/motion_deriv.1D'[2]' -stim_base 9 -stim_label 9 yaw_02         \
    -stim_file 10 $rest_dir/SE/1d/motion_deriv.1D'[3]' -stim_base 10 -stim_label 10 dS_02       \
    -stim_file 11 $rest_dir/SE/1d/motion_deriv.1D'[4]' -stim_base 11 -stim_label 11 dL_02       \
    -stim_file 12 $rest_dir/SE/1d/motion_deriv.1D'[5]' -stim_base 12 -stim_label 12 dP_02       \
    -stim_file 13 $rest_dir/SE/1d/WM_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 WM   \
    -x1D $rest_dir/alt/1d/X.xmat.nat.polortA.ricor.WM_1.GSR_0.blur0.1D                    \
    -x1D_uncensored $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.ricor.WM_1.GSR_0.blur0.1D \
    -x1D_stop

# Native space: derivs +, WM +, GSR +, blur -
3dDeconvolve -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii                        \
    -censor $rest_dir/SE/1d/motion_rest_censor.1D                                          \
    -ortvec $rest_dir/SE/1d/bandpass_regressor.1D bandpass                                 \
    -polort A                                                                                \
    -num_stimts 14                                                                            \
    -stim_file 1 $rest_dir/SE/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
    -stim_file 2 $rest_dir/SE/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
    -stim_file 3 $rest_dir/SE/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
    -stim_file 4 $rest_dir/SE/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
    -stim_file 5 $rest_dir/SE/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
    -stim_file 6 $rest_dir/SE/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
    -stim_file 7 $rest_dir/SE/1d/motion_deriv.1D'[0]' -stim_base 7 -stim_label 7 roll_02   \
    -stim_file 8 $rest_dir/SE/1d/motion_deriv.1D'[1]' -stim_base 8 -stim_label 8 pitch_02       \
    -stim_file 9 $rest_dir/SE/1d/motion_deriv.1D'[2]' -stim_base 9 -stim_label 9 yaw_02         \
    -stim_file 10 $rest_dir/SE/1d/motion_deriv.1D'[3]' -stim_base 10 -stim_label 10 dS_02       \
    -stim_file 11 $rest_dir/SE/1d/motion_deriv.1D'[4]' -stim_base 11 -stim_label 11 dL_02       \
    -stim_file 12 $rest_dir/SE/1d/motion_deriv.1D'[5]' -stim_base 12 -stim_label 12 dP_02       \
    -stim_file 13 $rest_dir/SE/1d/WM_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 WM   \
    -stim_file 14 $rest_dir/SE/1d/GSR_rest_regressor_e2.blur0.1D -stim_base 14 -stim_label 14 GSR \
    -x1D $rest_dir/alt/1d/X.xmat.nat.polortA.ricor.WM_1.GSR_1.blur0.1D                    \
    -x1D_uncensored $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.ricor.WM_1.GSR_1.blur0.1D \
    -x1D_stop


# Native space: derivs +, WM -, GSR -, blur -
3dDeconvolve -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii                        \
    -censor $rest_dir/SE/1d/motion_rest_censor.1D                                          \
    -ortvec $rest_dir/SE/1d/bandpass_regressor.1D bandpass                                 \
    -polort A                                                                                \
    -num_stimts 12                                                                            \
    -stim_file 1 $rest_dir/SE/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
    -stim_file 2 $rest_dir/SE/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
    -stim_file 3 $rest_dir/SE/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
    -stim_file 4 $rest_dir/SE/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
    -stim_file 5 $rest_dir/SE/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
    -stim_file 6 $rest_dir/SE/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
    -stim_file 7 $rest_dir/SE/1d/motion_deriv.1D'[0]' -stim_base 7 -stim_label 7 roll_02   \
    -stim_file 8 $rest_dir/SE/1d/motion_deriv.1D'[1]' -stim_base 8 -stim_label 8 pitch_02       \
    -stim_file 9 $rest_dir/SE/1d/motion_deriv.1D'[2]' -stim_base 9 -stim_label 9 yaw_02         \
    -stim_file 10 $rest_dir/SE/1d/motion_deriv.1D'[3]' -stim_base 10 -stim_label 10 dS_02       \
    -stim_file 11 $rest_dir/SE/1d/motion_deriv.1D'[4]' -stim_base 11 -stim_label 11 dL_02       \
    -stim_file 12 $rest_dir/SE/1d/motion_deriv.1D'[5]' -stim_base 12 -stim_label 12 dP_02       \
    -x1D $rest_dir/alt/1d/X.xmat.nat.polortA.ricor.WM_0.GSR_0.blur0.1D                    \
    -x1D_uncensored $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.ricor.WM_0.GSR_0.blur0.1D \
    -x1D_stop

# Native space: derivs +, WM -, GSR +, blur -
3dDeconvolve -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii                        \
    -censor $rest_dir/SE/1d/motion_rest_censor.1D                                          \
    -ortvec $rest_dir/SE/1d/bandpass_regressor.1D bandpass                                 \
    -polort A                                                                                \
    -num_stimts 13                                                                            \
    -stim_file 1 $rest_dir/SE/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
    -stim_file 2 $rest_dir/SE/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
    -stim_file 3 $rest_dir/SE/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
    -stim_file 4 $rest_dir/SE/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
    -stim_file 5 $rest_dir/SE/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
    -stim_file 6 $rest_dir/SE/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
    -stim_file 7 $rest_dir/SE/1d/motion_deriv.1D'[0]' -stim_base 7 -stim_label 7 roll_02   \
    -stim_file 8 $rest_dir/SE/1d/motion_deriv.1D'[1]' -stim_base 8 -stim_label 8 pitch_02       \
    -stim_file 9 $rest_dir/SE/1d/motion_deriv.1D'[2]' -stim_base 9 -stim_label 9 yaw_02         \
    -stim_file 10 $rest_dir/SE/1d/motion_deriv.1D'[3]' -stim_base 10 -stim_label 10 dS_02       \
    -stim_file 11 $rest_dir/SE/1d/motion_deriv.1D'[4]' -stim_base 11 -stim_label 11 dL_02       \
    -stim_file 12 $rest_dir/SE/1d/motion_deriv.1D'[5]' -stim_base 12 -stim_label 12 dP_02       \
    -stim_file 13 $rest_dir/SE/1d/GSR_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 GSR \
    -x1D $rest_dir/alt/1d/X.xmat.nat.polortA.ricor.WM_0.GSR_1.blur0.1D                    \
    -x1D_uncensored $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.ricor.WM_0.GSR_1.blur0.1D \
    -x1D_stop


# Project out regression matrix - Native space
for blurval in 0 $blur
do
    3dTproject -polort 0 -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode NTRP -ort $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.ricor.WM_1.GSR_0.blur0.1D -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_0.tproj.NTRP.nii
    3dTproject -polort 0 -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode NTRP -ort $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.ricor.WM_1.GSR_1.blur0.1D -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_1.tproj.NTRP.nii
    3dTproject -polort 0 -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode NTRP -ort $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.ricor.WM_0.GSR_0.blur0.1D -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_0.tproj.NTRP.nii
    3dTproject -polort 0 -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode NTRP -ort $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.ricor.WM_0.GSR_1.blur0.1D -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_1.tproj.NTRP.nii
done

# =========================== Warp e2s ============================
for blurval in 0 $blur
do
for wm in 0 1
do
for gsr in 0 1
do
    # e2 in native TSE
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_anat2tse.${subj_name}.1D -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii -prefix $rest_dir/alt/fcon/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii -master ${subj_E_dir}ANATinTSE.${subj_name}+orig -mast_dxyz $dims $dims $dims

    # e2 in MNI
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_deob_epi2mni.1D -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii -prefix $rest_dir/alt/fcon/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii -master $rest_dir/abtemplate.nii -mast_dxyz $dims $dims $dims
done
done
done

# =========================== Calculate tSNR ============================
for blurval in 0 $blur
do
for wm in 0 1
do
for gsr in 0 1
do
    # tSNR in native MPRAGE
    3dTstat -cvarinvNOD -prefix $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii

    # tSNR into MNI
    3dTstat -cvarinvNOD -prefix $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii $rest_dir/alt/fcon/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii

    # tSNR in Native TSE
    3dTstat -cvarinvNOD -prefix $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii $rest_dir/alt/fcon/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii
done
done
done


# =========================== Generate ROIs ============================
# Keren masks
3dfractionize -overwrite -clip $Kclip -template $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_1SD_BINARY_TEMPLATE.nii
3dfractionize -overwrite -clip $Kclip -template $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_2SD_BINARY_TEMPLATE.nii

# LC mask
3dfractionize -overwrite -clip $Lclip -template $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_inMPRAGE_${subj_name}+orig.BRIK
3dfractionize -overwrite -clip $Lclip -template $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_${subj_name}.nii

# PT mask
3dfractionize -overwrite -clip $Lclip -template $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_PT.${subj_name}_rest_nat.frac.nii -input ${base_dir}/${subj_name}/afni/*/PT_ROI_overlap_inMPRAGE_${subj_name}.nii
3dfractionize -overwrite -clip $Lclip -template $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_PT.${subj_name}_rest_tse.frac.nii -input ${base_dir}/${subj_name}/afni/*/PT_ROI_overlap_${subj_name}.nii


echo "+++++++++++++++++++++++++++++++++++++++ TSNR per ROI +++++++++++++++++++++++++++++++++++++++"
for blurval in 0 $blur
do
for wm in 0 1
do
for gsr in 0 1
do
    # Whole brain
    3dmaskave -quiet -mask SELF $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.Whole.1D

    # WM heavy erode
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_WM_min2.${subj_name}_nat.nii $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.WM.1D

    # Traced LC
    3dmaskave -quiet -mask $rest_dir/alt/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.LC.1D
    3dmaskave -quiet -mask $rest_dir/alt/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.tse.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.LC.1D

    # V1
    3dmaskave -quiet -mask ${roi_dir}lr-V1-only-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.V1.1D

    # HPC
    3dmaskave -quiet -mask ${roi_dir}lr-hpc-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.HPC.1D

    # GM
    3dmaskave -quiet -mask ${roi_dir}lr-gm-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.GM.1D

    # vmPFC
    3dmaskave -quiet -mask ${roi_dir}lr-vmpfc-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.vmPFC.1D

    # Precentral
    3dmaskave -quiet -mask ${roi_dir}lr-precentral-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.precentral.1D

    # Transtemporal
    3dmaskave -quiet -mask ${roi_dir}lr-transtemp-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.transtemp.1D

    # Pontine Tegmentum
    3dmaskave -quiet -mask $rest_dir/alt/rois/mask_PT.${subj_name}_rest_nat.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.PT.1D
    3dmaskave -quiet -mask $rest_dir/alt/rois/mask_PT.${subj_name}_rest_tse.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.tse.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.PT.1D

    # Keren atlas
    3dmaskave -quiet -mask $rest_dir/alt/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.mni.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.K1.1D
    3dmaskave -quiet -mask $rest_dir/alt/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.RICOR.mni.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.K2.1D
done
done
done

mkdir $rest_dir/SE/alt
cp $rest_dir/alt/tsnr/*.1D $rest_dir/SE/alt

rm -r $rest_dir/alt
rm -r $rest_dir/temp2

################################################# 4th V ONLY ################################################# 4th V ONLY #################################################
################################################# 4th V ONLY ################################################# 4th V ONLY #################################################
################################################# 4th V ONLY ################################################# 4th V ONLY #################################################

mkdir $rest_dir/alt
mkdir $rest_dir/temp2
cd $rest_dir/temp2

3dcalc -a ${data_dir}$run.e02.nii -expr 'a' -prefix ./$run.e02.nii
nifti_tool -mod_hdr -mod_field sform_code 1 -mod_field qform_code 1 -infiles ./$run.e02.nii -overwrite
3dDespike -overwrite -prefix ./$run.e02_vrA.nii ./$run.e02.nii
3daxialize -overwrite -prefix ./$run.e02_vrA.nii ./$run.e02_vrA.nii
3dcalc -a ./$run.e02_vrA.nii'[2]' -expr 'a' -prefix e0_base.nii
3dvolreg -overwrite -tshift -quintic -prefix ./$run.e02_vrA.nii -base e0_base.nii -dfile ./$run.e02_vrA.1D -1Dmatrix_save $rest_dir/SE/transform_volreg.aff12.1D ./$run.e02_vrA.nii
rm $run.e02_vrA.nii

3dDespike -overwrite -prefix ./$run.e2_pt.nii.gz $run.e02.nii'[2..$]'
3dTshift -heptic -prefix ./e2_ts+orig ./$run.e2_pt.nii.gz
3daxialize -overwrite -prefix ./e2_ts+orig ./e2_ts+orig
3drefit -deoblique -TR 3 e2_ts+orig

3dUnifize -prefix ./$subj_name.e2_ts_unifize+orig e2_ts+orig
3dSkullStrip -no_avoid_eyes -prefix $rest_dir/temp2/$subj_name.e2_ts_ss.nii.gz -overwrite -input $subj_name.e2_ts_unifize+orig

cp ${afni_dir}mprage-BET$bet-noskull_do.nii.gz ${rest_dir}/temp2
gunzip ${rest_dir}/temp2/mprage-BET$bet-noskull_do.nii.gz

3dBrickStat -mask e0_base.nii -percentile 50 1 50 e2_ts+orig[2] > gms.1D
gms=`cat gms.1D`; gmsa=($gms); p50=${gmsa[1]}
3dcopy e0_base.nii e0_base+orig
voxsize=`ccalc .85*$(3dinfo -voxvol e0_base+orig)**.33`
voxdims="`3dinfo -adi e0_base.nii` `3dinfo -adj e0_base.nii` `3dinfo -adk e0_base.nii`"
echo $voxdims > voxdims.1D
echo $voxsize > voxsize.1D

3dZeropad -I 12 -S 12 -A 12 -P 12 -L 12 -R 12 -prefix padded_e2_ss.nii $subj_name.e2_ts_ss.nii.gz'[0]'
3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_epi2anat_deob.aff12.1D -base mprage-BET$bet-noskull_do.nii -input padded_e2_ss.nii -prefix ./padded_e2_ss.nii -master $rest_dir/SE/mprage-BET$bet-noskull_do.nii.gz -mast_dxyz ${voxsize}

3dAutobox -overwrite -prefix padded_e2_ss.nii padded_e2_ss.nii
3dresample -overwrite -master padded_e2_ss.nii -dxyz ${voxsize} ${voxsize} ${voxsize} -input padded_e2_ss.nii -prefix padded_e2_ss.nii
3dcalc -float -a padded_e2_ss.nii -expr 'notzero(a)' -overwrite -prefix mask_e2_ss.nii
3dresample -rmode Li -overwrite -master mprage-BET$bet-noskull_do.nii -dxyz $voxdims -input mask_e2_ss.nii -prefix nat_e2_mask.nii

3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_epi2anat_deob_volreg.aff12.1D -base nat_e2_mask.nii -input e2_ts+orig -prefix ./e2_vr.nii.gz
3dcalc -float -overwrite -a nat_e2_mask.nii -b ./e2_vr.nii.gz -expr 'step(a)*b' -prefix ./e2_sm.nii.gz
3dcalc -float -overwrite -a ./e2_sm.nii.gz -expr "a*10000/${p50}" -prefix ./e2_sm.nii.gz
3dTstat -overwrite -prefix ./e2_mean.nii.gz ./e2_sm.nii.gz
mv e2_sm.nii.gz e2_in.nii.gz
3dcalc -float -overwrite -a ./e2_in.nii.gz -b ./e2_mean.nii.gz -expr 'a+b' -prefix ./e2_in.nii.gz
3dTstat -overwrite -stdev -prefix ./e2_std.nii.gz ./e2_in.nii.gz
mv ./e2_in.nii.gz ${subj_name}_nat_e2.nii.gz
gunzip ${subj_name}_nat_e2.nii.gz

mkdir $rest_dir/alt/tsnr
mkdir $rest_dir/alt/fcon
mkdir $rest_dir/alt/rois
mkdir $rest_dir/alt/1d

cp ${subj_name}_nat_e2.nii $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii
3dBlurToFWHM -overwrite -automask -FWHM $blur -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blur}.nii

# WM masks and regressors
3dmaskave -overwrite -quiet -mask $rest_dir/SE/rois/mask_WM_min2.${subj_name}_nat.nii $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii > $rest_dir/alt/1d/WM_rest_ts.blur0.1D
3dDetrend -overwrite -polort 6 -prefix $rest_dir/alt/1d/WM_rest_regressor.blur0.1D $rest_dir/alt/1d/WM_rest_ts.blur0.1D\'
1dtranspose -overwrite $rest_dir/alt/1d/WM_rest_regressor.blur0.1D $rest_dir/alt/1d/WM_rest_regressor_e2.blur0.1D
rm $rest_dir/alt/1d/WM_rest_regressor.blur0.1D
rm $rest_dir/alt/1d/WM_rest_ts.blur0.1D

# 4th Ventricle regressor
3dmaskave -quiet -mask ${roi_dir}lr-4v-3mm+orig $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii > $rest_dir/alt/1d/4v_rest_ts.blur0.1D
3dDetrend -polort 6 -prefix $rest_dir/alt/1d/4v_rest_regressor.blur0.1D $rest_dir/alt/1d/4v_rest_ts.blur0.1D\'
1dtranspose -overwrite $rest_dir/alt/1d/4v_rest_regressor.blur0.1D $rest_dir/alt/1d/4v_rest_regressor_e2.blur0.1D
rm $rest_dir/alt/1d/4v_rest_regressor.blur0.1D
rm $rest_dir/alt/1d/4v_rest_ts.blur0.1D

# Global Signal Regressor
3dmaskave -mask $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii | awk '{FS = " "}; {print $1}' | 1d_tool.py -infile - -demean -write $rest_dir/alt/1d/GSR_rest_regressor_e2.blur0.1D

# Native space: derivs +, WM +, GSR -, blur -
3dDeconvolve -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii                        \
-censor $rest_dir/SE/1d/motion_rest_censor.1D                                          \
-ortvec $rest_dir/SE/1d/bandpass_regressor.1D bandpass                                 \
-polort A                                                                                \
-num_stimts 14                                                                            \
-stim_file 1 $rest_dir/SE/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
-stim_file 2 $rest_dir/SE/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
-stim_file 3 $rest_dir/SE/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
-stim_file 4 $rest_dir/SE/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
-stim_file 5 $rest_dir/SE/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
-stim_file 6 $rest_dir/SE/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
-stim_file 7 $rest_dir/SE/1d/motion_deriv.1D'[0]' -stim_base 7 -stim_label 7 roll_02   \
-stim_file 8 $rest_dir/SE/1d/motion_deriv.1D'[1]' -stim_base 8 -stim_label 8 pitch_02       \
-stim_file 9 $rest_dir/SE/1d/motion_deriv.1D'[2]' -stim_base 9 -stim_label 9 yaw_02         \
-stim_file 10 $rest_dir/SE/1d/motion_deriv.1D'[3]' -stim_base 10 -stim_label 10 dS_02       \
-stim_file 11 $rest_dir/SE/1d/motion_deriv.1D'[4]' -stim_base 11 -stim_label 11 dL_02       \
-stim_file 12 $rest_dir/SE/1d/motion_deriv.1D'[5]' -stim_base 12 -stim_label 12 dP_02       \
-stim_file 13 $rest_dir/alt/1d/WM_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 WM   \
-stim_file 14 $rest_dir/alt/1d/4v_rest_regressor_e2.blur0.1D -stim_base 14 -stim_label 14 4v \
-x1D $rest_dir/alt/1d/X.xmat.nat.polortA.4v.WM_1.GSR_0.blur0.1D                    \
-x1D_uncensored $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.4v.WM_1.GSR_0.blur0.1D \
-x1D_stop

# Native space: derivs +, WM +, GSR +, blur -
3dDeconvolve -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii                        \
-censor $rest_dir/SE/1d/motion_rest_censor.1D                                          \
-ortvec $rest_dir/SE/1d/bandpass_regressor.1D bandpass                                 \
-polort A                                                                                \
-num_stimts 15                                                                            \
-stim_file 1 $rest_dir/SE/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
-stim_file 2 $rest_dir/SE/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
-stim_file 3 $rest_dir/SE/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
-stim_file 4 $rest_dir/SE/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
-stim_file 5 $rest_dir/SE/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
-stim_file 6 $rest_dir/SE/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
-stim_file 7 $rest_dir/SE/1d/motion_deriv.1D'[0]' -stim_base 7 -stim_label 7 roll_02   \
-stim_file 8 $rest_dir/SE/1d/motion_deriv.1D'[1]' -stim_base 8 -stim_label 8 pitch_02       \
-stim_file 9 $rest_dir/SE/1d/motion_deriv.1D'[2]' -stim_base 9 -stim_label 9 yaw_02         \
-stim_file 10 $rest_dir/SE/1d/motion_deriv.1D'[3]' -stim_base 10 -stim_label 10 dS_02       \
-stim_file 11 $rest_dir/SE/1d/motion_deriv.1D'[4]' -stim_base 11 -stim_label 11 dL_02       \
-stim_file 12 $rest_dir/SE/1d/motion_deriv.1D'[5]' -stim_base 12 -stim_label 12 dP_02       \
-stim_file 13 $rest_dir/alt/1d/WM_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 WM   \
-stim_file 14 $rest_dir/alt/1d/GSR_rest_regressor_e2.blur0.1D -stim_base 14 -stim_label 14 GSR \
-stim_file 15 $rest_dir/alt/1d/4v_rest_regressor_e2.blur0.1D -stim_base 15 -stim_label 15 4v \
-x1D $rest_dir/alt/1d/X.xmat.nat.polortA.4v.WM_1.GSR_1.blur0.1D                    \
-x1D_uncensored $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.4v.WM_1.GSR_1.blur0.1D \
-x1D_stop

# Native space: derivs +, WM -, GSR -, blur -
3dDeconvolve -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii                        \
-censor $rest_dir/SE/1d/motion_rest_censor.1D                                          \
-ortvec $rest_dir/SE/1d/bandpass_regressor.1D bandpass                                 \
-polort A                                                                                \
-num_stimts 13                                                                            \
-stim_file 1 $rest_dir/SE/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
-stim_file 2 $rest_dir/SE/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
-stim_file 3 $rest_dir/SE/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
-stim_file 4 $rest_dir/SE/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
-stim_file 5 $rest_dir/SE/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
-stim_file 6 $rest_dir/SE/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
-stim_file 7 $rest_dir/SE/1d/motion_deriv.1D'[0]' -stim_base 7 -stim_label 7 roll_02   \
-stim_file 8 $rest_dir/SE/1d/motion_deriv.1D'[1]' -stim_base 8 -stim_label 8 pitch_02       \
-stim_file 9 $rest_dir/SE/1d/motion_deriv.1D'[2]' -stim_base 9 -stim_label 9 yaw_02         \
-stim_file 10 $rest_dir/SE/1d/motion_deriv.1D'[3]' -stim_base 10 -stim_label 10 dS_02       \
-stim_file 11 $rest_dir/SE/1d/motion_deriv.1D'[4]' -stim_base 11 -stim_label 11 dL_02       \
-stim_file 12 $rest_dir/SE/1d/motion_deriv.1D'[5]' -stim_base 12 -stim_label 12 dP_02       \
-stim_file 13 $rest_dir/alt/1d/4v_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 4v \
-x1D $rest_dir/alt/1d/X.xmat.nat.polortA.4v.WM_0.GSR_0.blur0.1D                    \
-x1D_uncensored $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.4v.WM_0.GSR_0.blur0.1D \
-x1D_stop

# Native space: derivs +, WM -, GSR +, blur -
3dDeconvolve -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii                        \
-censor $rest_dir/SE/1d/motion_rest_censor.1D                                          \
-ortvec $rest_dir/SE/1d/bandpass_regressor.1D bandpass                                 \
-polort A                                                                                \
-num_stimts 14                                                                            \
-stim_file 1 $rest_dir/SE/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
-stim_file 2 $rest_dir/SE/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
-stim_file 3 $rest_dir/SE/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
-stim_file 4 $rest_dir/SE/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
-stim_file 5 $rest_dir/SE/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
-stim_file 6 $rest_dir/SE/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
-stim_file 7 $rest_dir/SE/1d/motion_deriv.1D'[0]' -stim_base 7 -stim_label 7 roll_02   \
-stim_file 8 $rest_dir/SE/1d/motion_deriv.1D'[1]' -stim_base 8 -stim_label 8 pitch_02       \
-stim_file 9 $rest_dir/SE/1d/motion_deriv.1D'[2]' -stim_base 9 -stim_label 9 yaw_02         \
-stim_file 10 $rest_dir/SE/1d/motion_deriv.1D'[3]' -stim_base 10 -stim_label 10 dS_02       \
-stim_file 11 $rest_dir/SE/1d/motion_deriv.1D'[4]' -stim_base 11 -stim_label 11 dL_02       \
-stim_file 12 $rest_dir/SE/1d/motion_deriv.1D'[5]' -stim_base 12 -stim_label 12 dP_02       \
-stim_file 13 $rest_dir/alt/1d/GSR_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 GSR \
-stim_file 14 $rest_dir/alt/1d/4v_rest_regressor_e2.blur0.1D -stim_base 14 -stim_label 14 4v \
-x1D $rest_dir/alt/1d/X.xmat.nat.polortA.4v.WM_0.GSR_1.blur0.1D                    \
-x1D_uncensored $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.4v.WM_0.GSR_1.blur0.1D \
-x1D_stop


# Project out regression matrix - Native space
for blurval in 0 $blur
do
3dTproject -polort 0 -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode NTRP -ort $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.4v.WM_1.GSR_0.blur0.1D -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_0.tproj.NTRP.nii
3dTproject -polort 0 -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode NTRP -ort $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.4v.WM_1.GSR_1.blur0.1D -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_1.tproj.NTRP.nii
3dTproject -polort 0 -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode NTRP -ort $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.4v.WM_0.GSR_0.blur0.1D -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_0.tproj.NTRP.nii
3dTproject -polort 0 -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode NTRP -ort $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.4v.WM_0.GSR_1.blur0.1D -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_1.tproj.NTRP.nii
done

# =========================== Warp e2s ============================
for blurval in 0 $blur
do
for wm in 0 1
do
for gsr in 0 1
do
# e2 in native TSE
3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_anat2tse.${subj_name}.1D -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii -prefix $rest_dir/alt/fcon/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii -master ${subj_E_dir}ANATinTSE.${subj_name}+orig -mast_dxyz $dims $dims $dims

# e2 in MNI
3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_deob_epi2mni.1D -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii -prefix $rest_dir/alt/fcon/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii -master $rest_dir/abtemplate.nii -mast_dxyz $dims $dims $dims
done
done
done

# =========================== Calculate tSNR ============================
for blurval in 0 $blur
do
for wm in 0 1
do
for gsr in 0 1
do
# tSNR in native MPRAGE
3dTstat -cvarinvNOD -prefix $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii

# tSNR into MNI
3dTstat -cvarinvNOD -prefix $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii $rest_dir/alt/fcon/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii

# tSNR in Native TSE
3dTstat -cvarinvNOD -prefix $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii $rest_dir/alt/fcon/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii
done
done
done


# =========================== Generate ROIs ============================
# Keren masks
3dfractionize -overwrite -clip $Kclip -template $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_1SD_BINARY_TEMPLATE.nii
3dfractionize -overwrite -clip $Kclip -template $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_2SD_BINARY_TEMPLATE.nii

# LC mask
3dfractionize -overwrite -clip $Lclip -template $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_inMPRAGE_${subj_name}+orig.BRIK
3dfractionize -overwrite -clip $Lclip -template $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_${subj_name}.nii

# PT mask
3dfractionize -overwrite -clip $Lclip -template $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_PT.${subj_name}_rest_nat.frac.nii -input ${base_dir}/${subj_name}/afni/*/PT_ROI_overlap_inMPRAGE_${subj_name}.nii
3dfractionize -overwrite -clip $Lclip -template $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_PT.${subj_name}_rest_tse.frac.nii -input ${base_dir}/${subj_name}/afni/*/PT_ROI_overlap_${subj_name}.nii


echo "+++++++++++++++++++++++++++++++++++++++ TSNR per ROI +++++++++++++++++++++++++++++++++++++++"
for blurval in 0 $blur
do
for wm in 0 1
do
for gsr in 0 1
do
# Whole brain
3dmaskave -quiet -mask SELF $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.Whole.1D

# WM heavy erode
3dmaskave -quiet -mask $rest_dir/SE/rois/mask_WM_min2.${subj_name}_nat.nii $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.WM.1D

# Traced LC
3dmaskave -quiet -mask $rest_dir/alt/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.LC.1D
3dmaskave -quiet -mask $rest_dir/alt/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.tse.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.LC.1D

# V1
3dmaskave -quiet -mask ${roi_dir}lr-V1-only-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.V1.1D

# HPC
3dmaskave -quiet -mask ${roi_dir}lr-hpc-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.HPC.1D

# GM
3dmaskave -quiet -mask ${roi_dir}lr-gm-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.GM.1D

# vmPFC
3dmaskave -quiet -mask ${roi_dir}lr-vmpfc-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.vmPFC.1D

# Precentral
3dmaskave -quiet -mask ${roi_dir}lr-precentral-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.precentral.1D

# Transtemporal
3dmaskave -quiet -mask ${roi_dir}lr-transtemp-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.transtemp.1D

# Pontine Tegmentum
3dmaskave -quiet -mask $rest_dir/alt/rois/mask_PT.${subj_name}_rest_nat.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.PT.1D
3dmaskave -quiet -mask $rest_dir/alt/rois/mask_PT.${subj_name}_rest_tse.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.tse.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.PT.1D

# Keren atlas
3dmaskave -quiet -mask $rest_dir/alt/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.mni.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.K1.1D
3dmaskave -quiet -mask $rest_dir/alt/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.4v.mni.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.K2.1D
done
done
done

cp $rest_dir/alt/tsnr/*.1D $rest_dir/SE/alt

rm -r $rest_dir/alt
rm -r $rest_dir/temp2


################################################# NONE ################################################# NONE #################################################
################################################# NONE ################################################# NONE #################################################
################################################# NONE ################################################# NONE #################################################

mkdir $rest_dir/alt
mkdir $rest_dir/temp2
cd $rest_dir/temp2

3dcalc -a ${data_dir}$run.e02.nii -expr 'a' -prefix ./$run.e02.nii
nifti_tool -mod_hdr -mod_field sform_code 1 -mod_field qform_code 1 -infiles ./$run.e02.nii -overwrite
3dDespike -overwrite -prefix ./$run.e02_vrA.nii ./$run.e02.nii
3daxialize -overwrite -prefix ./$run.e02_vrA.nii ./$run.e02_vrA.nii
3dcalc -a ./$run.e02_vrA.nii'[2]' -expr 'a' -prefix e0_base.nii
3dvolreg -overwrite -tshift -quintic -prefix ./$run.e02_vrA.nii -base e0_base.nii -dfile ./$run.e02_vrA.1D -1Dmatrix_save $rest_dir/SE/transform_volreg.aff12.1D ./$run.e02_vrA.nii
rm $run.e02_vrA.nii

3dDespike -overwrite -prefix ./$run.e2_pt.nii.gz $run.e02.nii'[2..$]'
3dTshift -heptic -prefix ./e2_ts+orig ./$run.e2_pt.nii.gz
3daxialize -overwrite -prefix ./e2_ts+orig ./e2_ts+orig
3drefit -deoblique -TR 3 e2_ts+orig

3dUnifize -prefix ./$subj_name.e2_ts_unifize+orig e2_ts+orig
3dSkullStrip -no_avoid_eyes -prefix $rest_dir/temp2/$subj_name.e2_ts_ss.nii.gz -overwrite -input $subj_name.e2_ts_unifize+orig

cp ${afni_dir}mprage-BET$bet-noskull_do.nii.gz ${rest_dir}/temp2
gunzip ${rest_dir}/temp2/mprage-BET$bet-noskull_do.nii.gz

3dBrickStat -mask e0_base.nii -percentile 50 1 50 e2_ts+orig[2] > gms.1D
gms=`cat gms.1D`; gmsa=($gms); p50=${gmsa[1]}
3dcopy e0_base.nii e0_base+orig
voxsize=`ccalc .85*$(3dinfo -voxvol e0_base+orig)**.33`
voxdims="`3dinfo -adi e0_base.nii` `3dinfo -adj e0_base.nii` `3dinfo -adk e0_base.nii`"
echo $voxdims > voxdims.1D
echo $voxsize > voxsize.1D

3dZeropad -I 12 -S 12 -A 12 -P 12 -L 12 -R 12 -prefix padded_e2_ss.nii $subj_name.e2_ts_ss.nii.gz'[0]'
3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_epi2anat_deob.aff12.1D -base mprage-BET$bet-noskull_do.nii -input padded_e2_ss.nii -prefix ./padded_e2_ss.nii -master $rest_dir/SE/mprage-BET$bet-noskull_do.nii.gz -mast_dxyz ${voxsize}

3dAutobox -overwrite -prefix padded_e2_ss.nii padded_e2_ss.nii
3dresample -overwrite -master padded_e2_ss.nii -dxyz ${voxsize} ${voxsize} ${voxsize} -input padded_e2_ss.nii -prefix padded_e2_ss.nii
3dcalc -float -a padded_e2_ss.nii -expr 'notzero(a)' -overwrite -prefix mask_e2_ss.nii
3dresample -rmode Li -overwrite -master mprage-BET$bet-noskull_do.nii -dxyz $voxdims -input mask_e2_ss.nii -prefix nat_e2_mask.nii

3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_epi2anat_deob_volreg.aff12.1D -base nat_e2_mask.nii -input e2_ts+orig -prefix ./e2_vr.nii.gz
3dcalc -float -overwrite -a nat_e2_mask.nii -b ./e2_vr.nii.gz -expr 'step(a)*b' -prefix ./e2_sm.nii.gz
3dcalc -float -overwrite -a ./e2_sm.nii.gz -expr "a*10000/${p50}" -prefix ./e2_sm.nii.gz
3dTstat -overwrite -prefix ./e2_mean.nii.gz ./e2_sm.nii.gz
mv e2_sm.nii.gz e2_in.nii.gz
3dcalc -float -overwrite -a ./e2_in.nii.gz -b ./e2_mean.nii.gz -expr 'a+b' -prefix ./e2_in.nii.gz
3dTstat -overwrite -stdev -prefix ./e2_std.nii.gz ./e2_in.nii.gz
mv ./e2_in.nii.gz ${subj_name}_nat_e2.nii.gz
gunzip ${subj_name}_nat_e2.nii.gz

mkdir $rest_dir/alt/tsnr
mkdir $rest_dir/alt/fcon
mkdir $rest_dir/alt/rois
mkdir $rest_dir/alt/1d

cp ${subj_name}_nat_e2.nii $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii
3dBlurToFWHM -overwrite -automask -FWHM $blur -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blur}.nii

# WM masks and regressors
3dmaskave -overwrite -quiet -mask $rest_dir/SE/rois/mask_WM_min2.${subj_name}_nat.nii $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii > $rest_dir/alt/1d/WM_rest_ts.blur0.1D
3dDetrend -overwrite -polort 6 -prefix $rest_dir/alt/1d/WM_rest_regressor.blur0.1D $rest_dir/alt/1d/WM_rest_ts.blur0.1D\'
1dtranspose -overwrite $rest_dir/alt/1d/WM_rest_regressor.blur0.1D $rest_dir/alt/1d/WM_rest_regressor_e2.blur0.1D
rm $rest_dir/alt/1d/WM_rest_regressor.blur0.1D
rm $rest_dir/alt/1d/WM_rest_ts.blur0.1D

# Global Signal Regressor
3dmaskave -mask $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii | awk '{FS = " "}; {print $1}' | 1d_tool.py -infile - -demean -write $rest_dir/alt/1d/GSR_rest_regressor_e2.blur0.1D

# Native space: derivs +, WM +, GSR -, blur -
3dDeconvolve -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii                        \
-censor $rest_dir/SE/1d/motion_rest_censor.1D                                          \
-ortvec $rest_dir/SE/1d/bandpass_regressor.1D bandpass                                 \
-polort A                                                                                \
-num_stimts 13                                                                            \
-stim_file 1 $rest_dir/SE/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
-stim_file 2 $rest_dir/SE/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
-stim_file 3 $rest_dir/SE/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
-stim_file 4 $rest_dir/SE/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
-stim_file 5 $rest_dir/SE/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
-stim_file 6 $rest_dir/SE/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
-stim_file 7 $rest_dir/SE/1d/motion_deriv.1D'[0]' -stim_base 7 -stim_label 7 roll_02   \
-stim_file 8 $rest_dir/SE/1d/motion_deriv.1D'[1]' -stim_base 8 -stim_label 8 pitch_02       \
-stim_file 9 $rest_dir/SE/1d/motion_deriv.1D'[2]' -stim_base 9 -stim_label 9 yaw_02         \
-stim_file 10 $rest_dir/SE/1d/motion_deriv.1D'[3]' -stim_base 10 -stim_label 10 dS_02       \
-stim_file 11 $rest_dir/SE/1d/motion_deriv.1D'[4]' -stim_base 11 -stim_label 11 dL_02       \
-stim_file 12 $rest_dir/SE/1d/motion_deriv.1D'[5]' -stim_base 12 -stim_label 12 dP_02       \
-stim_file 13 $rest_dir/SE/1d/WM_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 WM   \
-x1D $rest_dir/alt/1d/X.xmat.nat.polortA.none.WM_1.GSR_0.blur0.1D                    \
-x1D_uncensored $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.none.WM_1.GSR_0.blur0.1D \
-x1D_stop

# Native space: derivs +, WM +, GSR +, blur -
3dDeconvolve -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii                        \
-censor $rest_dir/SE/1d/motion_rest_censor.1D                                          \
-ortvec $rest_dir/SE/1d/bandpass_regressor.1D bandpass                                 \
-polort A                                                                                \
-num_stimts 14                                                                            \
-stim_file 1 $rest_dir/SE/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
-stim_file 2 $rest_dir/SE/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
-stim_file 3 $rest_dir/SE/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
-stim_file 4 $rest_dir/SE/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
-stim_file 5 $rest_dir/SE/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
-stim_file 6 $rest_dir/SE/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
-stim_file 7 $rest_dir/SE/1d/motion_deriv.1D'[0]' -stim_base 7 -stim_label 7 roll_02   \
-stim_file 8 $rest_dir/SE/1d/motion_deriv.1D'[1]' -stim_base 8 -stim_label 8 pitch_02       \
-stim_file 9 $rest_dir/SE/1d/motion_deriv.1D'[2]' -stim_base 9 -stim_label 9 yaw_02         \
-stim_file 10 $rest_dir/SE/1d/motion_deriv.1D'[3]' -stim_base 10 -stim_label 10 dS_02       \
-stim_file 11 $rest_dir/SE/1d/motion_deriv.1D'[4]' -stim_base 11 -stim_label 11 dL_02       \
-stim_file 12 $rest_dir/SE/1d/motion_deriv.1D'[5]' -stim_base 12 -stim_label 12 dP_02       \
-stim_file 13 $rest_dir/SE/1d/WM_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 WM   \
-stim_file 14 $rest_dir/SE/1d/GSR_rest_regressor_e2.blur0.1D -stim_base 14 -stim_label 14 GSR \
-x1D $rest_dir/alt/1d/X.xmat.nat.polortA.none.WM_1.GSR_1.blur0.1D                    \
-x1D_uncensored $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.none.WM_1.GSR_1.blur0.1D \
-x1D_stop

# Native space: derivs +, WM -, GSR -, blur -
3dDeconvolve -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii                        \
-censor $rest_dir/SE/1d/motion_rest_censor.1D                                          \
-ortvec $rest_dir/SE/1d/bandpass_regressor.1D bandpass                                 \
-polort A                                                                                \
-num_stimts 12                                                                            \
-stim_file 1 $rest_dir/SE/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
-stim_file 2 $rest_dir/SE/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
-stim_file 3 $rest_dir/SE/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
-stim_file 4 $rest_dir/SE/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
-stim_file 5 $rest_dir/SE/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
-stim_file 6 $rest_dir/SE/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
-stim_file 7 $rest_dir/SE/1d/motion_deriv.1D'[0]' -stim_base 7 -stim_label 7 roll_02   \
-stim_file 8 $rest_dir/SE/1d/motion_deriv.1D'[1]' -stim_base 8 -stim_label 8 pitch_02       \
-stim_file 9 $rest_dir/SE/1d/motion_deriv.1D'[2]' -stim_base 9 -stim_label 9 yaw_02         \
-stim_file 10 $rest_dir/SE/1d/motion_deriv.1D'[3]' -stim_base 10 -stim_label 10 dS_02       \
-stim_file 11 $rest_dir/SE/1d/motion_deriv.1D'[4]' -stim_base 11 -stim_label 11 dL_02       \
-stim_file 12 $rest_dir/SE/1d/motion_deriv.1D'[5]' -stim_base 12 -stim_label 12 dP_02       \
-x1D $rest_dir/alt/1d/X.xmat.nat.polortA.none.WM_0.GSR_0.blur0.1D                    \
-x1D_uncensored $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.none.WM_0.GSR_0.blur0.1D \
-x1D_stop

# Native space: derivs +, WM -, GSR +, blur -
3dDeconvolve -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur0.nii                        \
-censor $rest_dir/SE/1d/motion_rest_censor.1D                                          \
-ortvec $rest_dir/SE/1d/bandpass_regressor.1D bandpass                                 \
-polort A                                                                                \
-num_stimts 13                                                                            \
-stim_file 1 $rest_dir/SE/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
-stim_file 2 $rest_dir/SE/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
-stim_file 3 $rest_dir/SE/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
-stim_file 4 $rest_dir/SE/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
-stim_file 5 $rest_dir/SE/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
-stim_file 6 $rest_dir/SE/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
-stim_file 7 $rest_dir/SE/1d/motion_deriv.1D'[0]' -stim_base 7 -stim_label 7 roll_02   \
-stim_file 8 $rest_dir/SE/1d/motion_deriv.1D'[1]' -stim_base 8 -stim_label 8 pitch_02       \
-stim_file 9 $rest_dir/SE/1d/motion_deriv.1D'[2]' -stim_base 9 -stim_label 9 yaw_02         \
-stim_file 10 $rest_dir/SE/1d/motion_deriv.1D'[3]' -stim_base 10 -stim_label 10 dS_02       \
-stim_file 11 $rest_dir/SE/1d/motion_deriv.1D'[4]' -stim_base 11 -stim_label 11 dL_02       \
-stim_file 12 $rest_dir/SE/1d/motion_deriv.1D'[5]' -stim_base 12 -stim_label 12 dP_02       \
-stim_file 13 $rest_dir/SE/1d/GSR_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 GSR \
-x1D $rest_dir/alt/1d/X.xmat.nat.polortA.none.WM_0.GSR_1.blur0.1D                    \
-x1D_uncensored $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.none.WM_0.GSR_1.blur0.1D \
-x1D_stop


# Project out regression matrix - Native space
for blurval in 0 $blur
do
3dTproject -polort 0 -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode NTRP -ort $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.none.WM_1.GSR_0.blur0.1D -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_0.tproj.NTRP.nii
3dTproject -polort 0 -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode NTRP -ort $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.none.WM_1.GSR_1.blur0.1D -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_1.tproj.NTRP.nii
3dTproject -polort 0 -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode NTRP -ort $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.none.WM_0.GSR_0.blur0.1D -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_0.tproj.NTRP.nii
3dTproject -polort 0 -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode NTRP -ort $rest_dir/alt/1d/X.nocensor.xmat.nat.polortA.none.WM_0.GSR_1.blur0.1D -prefix $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_1.tproj.NTRP.nii
done

# =========================== Warp e2s ============================
for blurval in 0 $blur
do
for wm in 0 1
do
for gsr in 0 1
do
# e2 in native TSE
3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_anat2tse.${subj_name}.1D -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii -prefix $rest_dir/alt/fcon/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii -master ${subj_E_dir}ANATinTSE.${subj_name}+orig -mast_dxyz $dims $dims $dims

# e2 in MNI
3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_deob_epi2mni.1D -input $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii -prefix $rest_dir/alt/fcon/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii -master $rest_dir/abtemplate.nii -mast_dxyz $dims $dims $dims
done
done
done

# =========================== Calculate tSNR ============================
for blurval in 0 $blur
do
for wm in 0 1
do
for gsr in 0 1
do
# tSNR in native MPRAGE
3dTstat -cvarinvNOD -prefix $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii $rest_dir/alt/fcon/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii

# tSNR into MNI
3dTstat -cvarinvNOD -prefix $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii $rest_dir/alt/fcon/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii

# tSNR in Native TSE
3dTstat -cvarinvNOD -prefix $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii $rest_dir/alt/fcon/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tproj.NTRP.nii
done
done
done


# =========================== Generate ROIs ============================
# Keren masks
3dfractionize -overwrite -clip $Kclip -template $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_1SD_BINARY_TEMPLATE.nii
3dfractionize -overwrite -clip $Kclip -template $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_2SD_BINARY_TEMPLATE.nii

# LC mask
3dfractionize -overwrite -clip $Lclip -template $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_inMPRAGE_${subj_name}+orig.BRIK
3dfractionize -overwrite -clip $Lclip -template $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_${subj_name}.nii

# PT mask
3dfractionize -overwrite -clip $Lclip -template $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_PT.${subj_name}_rest_nat.frac.nii -input ${base_dir}/${subj_name}/afni/*/PT_ROI_overlap_inMPRAGE_${subj_name}.nii
3dfractionize -overwrite -clip $Lclip -template $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/alt/rois/mask_PT.${subj_name}_rest_tse.frac.nii -input ${base_dir}/${subj_name}/afni/*/PT_ROI_overlap_${subj_name}.nii


echo "+++++++++++++++++++++++++++++++++++++++ TSNR per ROI +++++++++++++++++++++++++++++++++++++++"
for blurval in 0 $blur
do
for wm in 0 1
do
for gsr in 0 1
do
# Whole brain
3dmaskave -quiet -mask SELF $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.Whole.1D

# WM heavy erode
3dmaskave -quiet -mask $rest_dir/SE/rois/mask_WM_min2.${subj_name}_nat.nii $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.WM.1D

# Traced LC
3dmaskave -quiet -mask $rest_dir/alt/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.LC.1D
3dmaskave -quiet -mask $rest_dir/alt/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.tse.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.LC.1D

# V1
3dmaskave -quiet -mask ${roi_dir}lr-V1-only-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.V1.1D

# HPC
3dmaskave -quiet -mask ${roi_dir}lr-hpc-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.HPC.1D

# GM
3dmaskave -quiet -mask ${roi_dir}lr-gm-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.GM.1D

# vmPFC
3dmaskave -quiet -mask ${roi_dir}lr-vmpfc-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.vmPFC.1D

# Precentral
3dmaskave -quiet -mask ${roi_dir}lr-precentral-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.precentral.1D

# Transtemporal
3dmaskave -quiet -mask ${roi_dir}lr-transtemp-3mm+orig $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.transtemp.1D

# Pontine Tegmentum
3dmaskave -quiet -mask $rest_dir/alt/rois/mask_PT.${subj_name}_rest_nat.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.PT.1D
3dmaskave -quiet -mask $rest_dir/alt/rois/mask_PT.${subj_name}_rest_tse.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.tse.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.PT.1D

# Keren atlas
3dmaskave -quiet -mask $rest_dir/alt/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.mni.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.K1.1D
3dmaskave -quiet -mask $rest_dir/alt/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii $rest_dir/alt/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/alt/tsnr/tsnr_tstat.none.mni.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.K2.1D
done
done
done

cp $rest_dir/alt/tsnr/*.1D $rest_dir/SE/alt


echo   "++++++++++++++++++++++++"
echo   "Housekeeping"
rm -r $rest_dir/alt
rm -r $rest_dir/temp2

cd ../../final_scripts


end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end










