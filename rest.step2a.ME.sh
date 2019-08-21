# Resting state analysis - preprocessing for multi-echo data
# execute via:
# ./rest.multiecho.sh s??
# 9 December 2018 - HBT

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
Kclip=.1
Lclip=.1
cenmode=NTRP

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
    roi_dir=${base_dir}analysis/rois/$subj_name/
    echo "Running $subj_name"
else
    echo "Arguments missing, terminating"
exit
fi
transform_s27_dir=${base_dir}analysis/univariate/rest_results/old_scripts/

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

# =========================== Roll back to rest.step1.meica.sh ============================
# If step2a was run previously, this will remove those files and folders
shopt -s extglob
cd $rest_dir/
if [ -e "abtemplate.nii.gz" ]
then
    rm -- !(ME|temp)
fi
cd ME
if [ -d "1d" ]
then
    rm -r 1d fcon rois tsnr
fi
if [ -e "${subj_name}_ocv_ss.nii.gz" ]
then
    mv ${subj_name}_ocv_ss.nii.gz ocv_ss.nii.gz
    mv ${subj_name}_s0v_ss.nii.gz s0v_ss.nii.gz
    mv ${subj_name}_t2svm_ss.nii.gz t2svm_ss.nii.gz
fi

cd $rest_dir/temp
dims=3
voxsize=`ccalc .85*$(3dinfo -voxvol e0_base+orig)**.33`
voxdims="`3dinfo -adi e0_base.nii` `3dinfo -adj e0_base.nii` `3dinfo -adk e0_base.nii`"
cd ..

# =========================== Tedana in normalized space ============================
# Create transformation matrices that will allow us to warp our participant data to the common template (MNIa_caez_N27 in our case).
cp ME/mprage-BET$bet-noskull_do.nii ./
@auto_tlrc -no_ss -init_xform AUTO_CENTER -base ${atlas_dir}/MNIa_caez_N27+tlrc -input mprage-BET$bet-noskull_do.nii
3dAutobox -overwrite -prefix abtemplate.nii.gz ${atlas_dir}/MNIa_caez_N27+tlrc

cat_matvec -ONELINE mprage-BET$bet-noskull_do_at.nii::WARP_DATA -I > ME/transform_deob_epi2mni.1D
cat_matvec -ONELINE mprage-BET$bet-noskull_do_at.nii::WARP_DATA > ME/transform_mni2deob_epi.1D

3dAllineate -overwrite -final wsinc5 -cubic -float -1Dmatrix_apply $rest_dir/ME/transform_deob_epi2mni.1D -input $rest_dir/ME/nat_export_mask.nii -prefix $rest_dir/ME/mni_export_mask.nii -master abtemplate.nii.gz -mast_dxyz ${voxsize}
nifti_tool -mod_hdr -mod_field sform_code 2 -mod_field qform_code 2 -infiles $rest_dir/ME/mni_export_mask.nii -overwrite
3dresample -rmode Li -overwrite -master abtemplate.nii.gz -dxyz ${voxdims} -input ME/mni_export_mask.nii -prefix $rest_dir/ME/mni_export_mask_3mm.nii

# =========================== Set up folder structure ============================
mkdir ME/tsnr
mkdir ME/fcon
mkdir ME/1d
mkdir ME/rois

# =========================== Blurring of medn data ============================
blurA=5
blurB=8
cp $rest_dir/ME/${subj_name}_medn_nat.nii $rest_dir/ME/fcon/${subj_name}_medn_nat_blur0.nii
3dBlurToFWHM -overwrite -automask -FWHM ${blurA} -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur0.nii -prefix $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurA}.nii
3dBlurToFWHM -overwrite -automask -FWHM ${blurB} -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur0.nii -prefix $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurB}.nii

# =========================== Generate masks and nuisance regressors ============================
# WM masks and regressors
3dmask_tool -overwrite -dilate_input -2 -input ${roi_dir}lr-wm-3mm+orig -prefix $rest_dir/ME/rois/mask_WM_min2.${subj_name}_nat.nii
3dmaskave -overwrite -quiet -mask $rest_dir/ME/rois/mask_WM_min2.${subj_name}_nat.nii $rest_dir/ME/fcon/${subj_name}_medn_nat_blur0.nii > $rest_dir/ME/1d/WM_rest_ts.blur0.1D
# detrend regressor (make orthogonal to poly baseline)
3dDetrend -overwrite -polort 6 -prefix $rest_dir/ME/1d/WM_rest_regressor.blur0.1D $rest_dir/ME/1d/WM_rest_ts.blur0.1D\'
1dtranspose -overwrite $rest_dir/ME/1d/WM_rest_regressor.blur0.1D $rest_dir/ME/1d/WM_rest_regressor_medn.blur0.1D
rm $rest_dir/ME/1d/WM_rest_regressor.blur0.1D
rm $rest_dir/ME/1d/WM_rest_ts.blur0.1D

# 4th Ventricle regressor
3dmaskave -quiet -mask ${roi_dir}lr-4v-3mm+orig $rest_dir/ME/fcon/${subj_name}_medn_nat_blur0.nii > temp/4v_rest_ts.blur0.1D
# detrend regressor (make orthogonal to poly baseline)
3dDetrend -polort 6 -prefix ME/1d/4v_rest_regressor.blur0.1D temp/4v_rest_ts.blur0.1D\'
1dtranspose -overwrite ME/1d/4v_rest_regressor.blur0.1D ME/1d/4v_rest_regressor_medn.blur0.1D
rm $rest_dir/ME/1d/4v_rest_regressor.blur0.1D

# Global Signal Regressor
3dmaskave -overwrite -mask $rest_dir/ME/fcon/${subj_name}_medn_nat_blur0.nii $rest_dir/ME/fcon/${subj_name}_medn_nat_blur0.nii | awk '{FS = " "}; {print $1}' | 1d_tool.py -infile - -demean -write $rest_dir/ME/1d/GSR_rest_regressor_medn.blur0.1D

# Bandpass Regressor
1dBport -nodata $nTR $TE -band 0.01 0.1 -invert -nozero > $rest_dir/ME/1d/bandpass_regressor.1D

echo   "++++++++++++++++++++++++"
echo   "Bandpass and regress motion - SETUP"
# Demeaned motion parameters and derivatives, censor with this info (We only need the info for echo 2, as the other echoes are aligned to echo 2[0])
cp $rest_dir/ME/motion.1D $rest_dir/ME/1d/motion.1D
1d_tool.py -infile $rest_dir/ME/motion.1D -set_nruns 1 -demean -write $rest_dir/ME/1d/motion_demean.1D
1d_tool.py -infile $rest_dir/ME/motion.1D -set_nruns 1 -derivative -demean -write $rest_dir/ME/1d/motion_deriv.1D
1d_tool.py -infile $rest_dir/ME/motion.1D -set_nruns 1 -show_censor_count -censor_prev_TR -censor_motion 0.2 $rest_dir/ME/1d/motion_rest
ktrs=`1d_tool.py -infile $rest_dir/ME/1d/motion_rest_censor.1D -show_trs_uncensored encoded`

echo   "++++++++++++++++++++++++"
echo   "Bandpass and regress motion"
# 3dDeconvolve to generate xmats, then stop

# Native space: derivs -, 4th V+, WM +, GSR -
3dDeconvolve -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur0.nii                        \
    -censor $rest_dir/ME/1d/motion_rest_censor.1D                                          \
    -ortvec $rest_dir/ME/1d/bandpass_regressor.1D bandpass                                 \
    -polort A                                                                                \
    -num_stimts 8                                                                            \
    -stim_file 1 $rest_dir/ME/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
    -stim_file 2 $rest_dir/ME/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
    -stim_file 3 $rest_dir/ME/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
    -stim_file 4 $rest_dir/ME/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
    -stim_file 5 $rest_dir/ME/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
    -stim_file 6 $rest_dir/ME/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
    -stim_file 7 $rest_dir/ME/1d/WM_rest_regressor_medn.blur0.1D -stim_base 7 -stim_label 7 WM   \
    -stim_file 8 $rest_dir/ME/1d/4v_rest_regressor_medn.blur0.1D -stim_base 8 -stim_label 8 4v \
    -x1D $rest_dir/ME/1d/X.xmat.nat.polortA.Deriv_0.WM_1.GSR_0.blur0.1D                    \
    -x1D_uncensored $rest_dir/ME/1d/X.nocensor.xmat.nat.polortA.Deriv_0.WM_1.GSR_0.blur0.1D \
    -x1D_stop


# Native space: derivs -, 4th V+, WM +, GSR +
3dDeconvolve -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur0.nii                        \
    -censor $rest_dir/ME/1d/motion_rest_censor.1D                                          \
    -ortvec $rest_dir/ME/1d/bandpass_regressor.1D bandpass                                 \
    -polort A                                                                                \
    -num_stimts 9                                                                            \
    -stim_file 1 $rest_dir/ME/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
    -stim_file 2 $rest_dir/ME/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
    -stim_file 3 $rest_dir/ME/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
    -stim_file 4 $rest_dir/ME/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
    -stim_file 5 $rest_dir/ME/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
    -stim_file 6 $rest_dir/ME/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
    -stim_file 7 $rest_dir/ME/1d/WM_rest_regressor_medn.blur0.1D -stim_base 7 -stim_label 7 WM   \
    -stim_file 8 $rest_dir/ME/1d/GSR_rest_regressor_medn.blur0.1D -stim_base 8 -stim_label 8 GSR \
    -stim_file 9 $rest_dir/ME/1d/4v_rest_regressor_medn.blur0.1D -stim_base 9 -stim_label 9 4v \
    -x1D $rest_dir/ME/1d/X.xmat.nat.polortA.Deriv_0.WM_1.GSR_1.blur0.1D                    \
    -x1D_uncensored $rest_dir/ME/1d/X.nocensor.xmat.nat.polortA.Deriv_0.WM_1.GSR_1.blur0.1D \
    -x1D_stop

# Native space: derivs -, 4th V+, WM -, GSR -
3dDeconvolve -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur0.nii                        \
    -censor $rest_dir/ME/1d/motion_rest_censor.1D                                          \
    -ortvec $rest_dir/ME/1d/bandpass_regressor.1D bandpass                                 \
    -polort A                                                                                \
    -num_stimts 7                                                                            \
    -stim_file 1 $rest_dir/ME/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
    -stim_file 2 $rest_dir/ME/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
    -stim_file 3 $rest_dir/ME/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
    -stim_file 4 $rest_dir/ME/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
    -stim_file 5 $rest_dir/ME/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
    -stim_file 6 $rest_dir/ME/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
    -stim_file 7 $rest_dir/ME/1d/4v_rest_regressor_medn.blur0.1D -stim_base 7 -stim_label 7 4v \
    -x1D $rest_dir/ME/1d/X.xmat.nat.polortA.Deriv_0.WM_0.GSR_0.blur0.1D                    \
    -x1D_uncensored $rest_dir/ME/1d/X.nocensor.xmat.nat.polortA.Deriv_0.WM_0.GSR_0.blur0.1D \
    -x1D_stop

# Native space: derivs -, 4th V+, WM -, GSR +
3dDeconvolve -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur0.nii                        \
    -censor $rest_dir/ME/1d/motion_rest_censor.1D                                          \
    -ortvec $rest_dir/ME/1d/bandpass_regressor.1D bandpass                                 \
    -polort A                                                                                \
    -num_stimts 8                                                                            \
    -stim_file 1 $rest_dir/ME/1d/motion_demean.1D'[0]' -stim_base 1 -stim_label 1 roll_01  \
    -stim_file 2 $rest_dir/ME/1d/motion_demean.1D'[1]' -stim_base 2 -stim_label 2 pitch_01 \
    -stim_file 3 $rest_dir/ME/1d/motion_demean.1D'[2]' -stim_base 3 -stim_label 3 yaw_01   \
    -stim_file 4 $rest_dir/ME/1d/motion_demean.1D'[3]' -stim_base 4 -stim_label 4 dS_01    \
    -stim_file 5 $rest_dir/ME/1d/motion_demean.1D'[4]' -stim_base 5 -stim_label 5 dL_01    \
    -stim_file 6 $rest_dir/ME/1d/motion_demean.1D'[5]' -stim_base 6 -stim_label 6 dP_01    \
    -stim_file 7 $rest_dir/ME/1d/GSR_rest_regressor_medn.blur0.1D -stim_base 7 -stim_label 7 GSR \
    -stim_file 8 $rest_dir/ME/1d/4v_rest_regressor_medn.blur0.1D -stim_base 8 -stim_label 8 4v \
    -x1D $rest_dir/ME/1d/X.xmat.nat.polortA.Deriv_0.WM_0.GSR_1.blur0.1D                    \
    -x1D_uncensored $rest_dir/ME/1d/X.nocensor.xmat.nat.polortA.Deriv_0.WM_0.GSR_1.blur0.1D \
    -x1D_stop


# Display any large pairwise correlations from the X-matrix
#1d_tool.py -show_cormat_warnings -infile $rest_dir/ME/1d/X.xmat.nat.polortA.Deriv_0.WM_1.GSR_0.blur0.1D  |& tee $rest_dir/ME/fcon/out.cormat_warn.nat.polortA.Deriv_0.WM_1.GSR_0.blur0.txt
#1d_tool.py -show_cormat_warnings -infile $rest_dir/ME/1d/X.xmat.nat.polortA.Deriv_0.WM_1.GSR_1.blur0.1D  |& tee $rest_dir/ME/fcon/out.cormat_warn.nat.polortA.Deriv_0.WM_1.GSR_1.blur0.txt
#1d_tool.py -show_cormat_warnings -infile $rest_dir/ME/1d/X.xmat.nat.polortA.Deriv_0.WM_1.GSR_0.blur${blur}.1D  |& tee $rest_dir/ME/fcon/out.cormat_warn.nat.polortA.Deriv_0.WM_1.GSR_0.blur${blur}.txt
#1d_tool.py -show_cormat_warnings -infile $rest_dir/ME/1d/X.xmat.nat.polortA.Deriv_0.WM_1.GSR_1.blur${blur}.1D  |& tee $rest_dir/ME/fcon/out.cormat_warn.nat.polortA.Deriv_0.WM_1.GSR_1.blur${blur}.txt


# Project out regression matrix - Native space
for blurval in 0 $blurA $blurB
do
    3dTproject -polort 0 -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.nii -censor $rest_dir/ME/1d/motion_rest_censor.1D -cenmode ${cenmode} -ort $rest_dir/ME/1d/X.nocensor.xmat.nat.polortA.Deriv_0.WM_1.GSR_0.blur0.1D -prefix $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii
    3dTproject -polort 0 -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.nii -censor $rest_dir/ME/1d/motion_rest_censor.1D -cenmode ${cenmode} -ort $rest_dir/ME/1d/X.nocensor.xmat.nat.polortA.Deriv_0.WM_1.GSR_1.blur0.1D -prefix $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii
    3dTproject -polort 0 -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.nii -censor $rest_dir/ME/1d/motion_rest_censor.1D -cenmode ${cenmode} -ort $rest_dir/ME/1d/X.nocensor.xmat.nat.polortA.Deriv_0.WM_0.GSR_0.blur0.1D -prefix $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii
    3dTproject -polort 0 -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.nii -censor $rest_dir/ME/1d/motion_rest_censor.1D -cenmode ${cenmode} -ort $rest_dir/ME/1d/X.nocensor.xmat.nat.polortA.Deriv_0.WM_0.GSR_1.blur0.1D -prefix $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii
done

# =========================== Warp the medn in MPRAGE space to TSE and MNI spaces ============================
if ([ $subj == 's27' ]) then
    cp ${transform_s27_dir}transform_anat2tse.${subj_name}.1D $rest_dir/ME/transform_anat2tse.${subj_name}.1D
else
    cp ${subj_E_dir}TSEtoMPRAGE.${subj_name}.aff12.1D ${subj_E_dir}TSEtoMPRAGE.${subj_name}.1D
    cat_matvec ${subj_E_dir}TSEtoMPRAGE.${subj_name}.1D -I > $rest_dir/ME/transform_anat2tse.${subj_name}.1D
fi

# Copy the 1Ds to the 1d folder for future use
cp $rest_dir/ME/transform* $rest_dir/ME/1d/

# Warp the medns
for blurval in 0 $blurA $blurB
do
    # Warp medn to TSE space
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_anat2tse.${subj_name}.1D -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/ME/fcon/${subj_name}_medn_tse_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii -master ${subj_E_dir}ANATinTSE.${subj_name}+orig -mast_dxyz $dims $dims $dims
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_anat2tse.${subj_name}.1D -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii -prefix $rest_dir/ME/fcon/${subj_name}_medn_tse_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii -master ${subj_E_dir}ANATinTSE.${subj_name}+orig -mast_dxyz $dims $dims $dims
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_anat2tse.${subj_name}.1D -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/ME/fcon/${subj_name}_medn_tse_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii -master ${subj_E_dir}ANATinTSE.${subj_name}+orig -mast_dxyz $dims $dims $dims
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_anat2tse.${subj_name}.1D -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii -prefix $rest_dir/ME/fcon/${subj_name}_medn_tse_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii -master ${subj_E_dir}ANATinTSE.${subj_name}+orig -mast_dxyz $dims $dims $dims

    # Warp medn to MNI space
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_deob_epi2mni.1D -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii -master abtemplate.nii.gz -mast_dxyz $dims $dims $dims
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_deob_epi2mni.1D -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii -prefix $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii -master abtemplate.nii.gz -mast_dxyz $dims $dims $dims
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_deob_epi2mni.1D -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii -master abtemplate.nii.gz -mast_dxyz $dims $dims $dims
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_deob_epi2mni.1D -input $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii -prefix $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii -master abtemplate.nii.gz -mast_dxyz $dims $dims $dims
done

# =========================== Calculate tSNR ============================
for blurval in 0 $blurA $blurB
do
    # tSNR in native MPRAGE
    3dTstat -cvarinvNOD -prefix $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii

    # tSNR in MNI
    3dTstat -cvarinvNOD -prefix $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii

    # tSNR in TSE
    3dTstat -cvarinvNOD -prefix $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii $rest_dir/ME/fcon/${subj_name}_medn_tse_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii $rest_dir/ME/fcon/${subj_name}_medn_tse_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii $rest_dir/ME/fcon/${subj_name}_medn_tse_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii $rest_dir/ME/fcon/${subj_name}_medn_tse_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii
done

# =========================== Generate ROIs for tSNR ============================
# Keren masks
3dfractionize -overwrite -clip $Kclip -template $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/ME/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_1SD_BINARY_TEMPLATE.nii
3dfractionize -overwrite -clip $Kclip -template $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/ME/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_2SD_BINARY_TEMPLATE.nii

# LC mask
3dfractionize -overwrite -clip $Lclip -template $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_inMPRAGE_${subj_name}+orig.BRIK
3dfractionize -overwrite -clip $Lclip -template $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_${subj_name}.nii

# PT mask
3dfractionize -overwrite -clip $Lclip -template $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/ME/rois/mask_PT.${subj_name}_rest_nat.frac.nii -input ${base_dir}/${subj_name}/afni/*/PT_ROI_overlap_inMPRAGE_${subj_name}.nii
3dfractionize -overwrite -clip $Lclip -template $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/ME/rois/mask_PT.${subj_name}_rest_tse.frac.nii -input ${base_dir}/${subj_name}/afni/*/PT_ROI_overlap_${subj_name}.nii


echo "+++++++++++++++++++++++++++++++++++++++ TSNR per ROI +++++++++++++++++++++++++++++++++++++++"
for blurval in 0 $blurA $blurB
do
    # Whole brain
    3dmaskave -quiet -mask SELF $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_0.blur${blurval}.Whole.1D
    3dmaskave -quiet -mask SELF $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_1.blur${blurval}.Whole.1D
    3dmaskave -quiet -mask SELF $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_0.blur${blurval}.Whole.1D
    3dmaskave -quiet -mask SELF $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_1.blur${blurval}.Whole.1D

    # WM heavy erode
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_WM_min2.${subj_name}_nat.nii $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_0.blur${blurval}.WM.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_WM_min2.${subj_name}_nat.nii $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_1.blur${blurval}.WM.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_WM_min2.${subj_name}_nat.nii $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_0.blur${blurval}.WM.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_WM_min2.${subj_name}_nat.nii $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_1.blur${blurval}.WM.1D

    # Traced LC
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.tse.Deriv_0.WM_1.GSR_0.blur${blurval}.LC.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.tse.Deriv_0.WM_1.GSR_1.blur${blurval}.LC.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.tse.Deriv_0.WM_0.GSR_0.blur${blurval}.LC.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.tse.Deriv_0.WM_0.GSR_1.blur${blurval}.LC.1D

    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_0.blur${blurval}.LC.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_1.blur${blurval}.LC.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_0.blur${blurval}.LC.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_1.blur${blurval}.LC.1D

    # V1
    3dmaskave -quiet -mask ${roi_dir}lr-V1-only-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_0.blur${blurval}.V1.1D
    3dmaskave -quiet -mask ${roi_dir}lr-V1-only-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_1.blur${blurval}.V1.1D
    3dmaskave -quiet -mask ${roi_dir}lr-V1-only-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_0.blur${blurval}.V1.1D
    3dmaskave -quiet -mask ${roi_dir}lr-V1-only-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_1.blur${blurval}.V1.1D

    # HPC
    3dmaskave -quiet -mask ${roi_dir}lr-hpc-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_0.blur${blurval}.HPC.1D
    3dmaskave -quiet -mask ${roi_dir}lr-hpc-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_1.blur${blurval}.HPC.1D
    3dmaskave -quiet -mask ${roi_dir}lr-hpc-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_0.blur${blurval}.HPC.1D
    3dmaskave -quiet -mask ${roi_dir}lr-hpc-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_1.blur${blurval}.HPC.1D

    # GM
    3dmaskave -quiet -mask ${roi_dir}lr-gm-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_0.blur${blurval}.GM.1D
    3dmaskave -quiet -mask ${roi_dir}lr-gm-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_1.blur${blurval}.GM.1D
    3dmaskave -quiet -mask ${roi_dir}lr-gm-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_0.blur${blurval}.GM.1D
    3dmaskave -quiet -mask ${roi_dir}lr-gm-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_1.blur${blurval}.GM.1D

    # vmPFC
    3dmaskave -quiet -mask ${roi_dir}lr-vmpfc-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_0.blur${blurval}.vmPFC.1D
    3dmaskave -quiet -mask ${roi_dir}lr-vmpfc-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_1.blur${blurval}.vmPFC.1D
    3dmaskave -quiet -mask ${roi_dir}lr-vmpfc-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_0.blur${blurval}.vmPFC.1D
    3dmaskave -quiet -mask ${roi_dir}lr-vmpfc-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_1.blur${blurval}.vmPFC.1D

    # Precentral
    3dmaskave -quiet -mask ${roi_dir}lr-precentral-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_0.blur${blurval}.precentral.1D
    3dmaskave -quiet -mask ${roi_dir}lr-precentral-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_1.blur${blurval}.precentral.1D
    3dmaskave -quiet -mask ${roi_dir}lr-precentral-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_0.blur${blurval}.precentral.1D
    3dmaskave -quiet -mask ${roi_dir}lr-precentral-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_1.blur${blurval}.precentral.1D

    # Transtemporal
    3dmaskave -quiet -mask ${roi_dir}lr-transtemp-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_0.blur${blurval}.transtemp.1D
    3dmaskave -quiet -mask ${roi_dir}lr-transtemp-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_1.blur${blurval}.transtemp.1D
    3dmaskave -quiet -mask ${roi_dir}lr-transtemp-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_0.blur${blurval}.transtemp.1D
    3dmaskave -quiet -mask ${roi_dir}lr-transtemp-3mm+orig $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_1.blur${blurval}.transtemp.1D

    # Pontine Tegmentum
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_PT.${subj_name}_rest_nat.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_0.blur${blurval}.PT.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_PT.${subj_name}_rest_nat.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_1.GSR_1.blur${blurval}.PT.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_PT.${subj_name}_rest_nat.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_0.blur${blurval}.PT.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_PT.${subj_name}_rest_nat.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_nat_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.nat.Deriv_0.WM_0.GSR_1.blur${blurval}.PT.1D

    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_PT.${subj_name}_rest_tse.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.tse.Deriv_0.WM_1.GSR_0.blur${blurval}.PT.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_PT.${subj_name}_rest_tse.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.tse.Deriv_0.WM_1.GSR_1.blur${blurval}.PT.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_PT.${subj_name}_rest_tse.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.tse.Deriv_0.WM_0.GSR_0.blur${blurval}.PT.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_PT.${subj_name}_rest_tse.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_tse_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.tse.Deriv_0.WM_0.GSR_1.blur${blurval}.PT.1D

    # Keren atlas
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.mni.Deriv_0.WM_1.GSR_0.blur${blurval}.K1.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.mni.Deriv_0.WM_1.GSR_1.blur${blurval}.K1.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.mni.Deriv_0.WM_0.GSR_0.blur${blurval}.K1.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.mni.Deriv_0.WM_0.GSR_1.blur${blurval}.K1.1D

    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.mni.Deriv_0.WM_1.GSR_0.blur${blurval}.K2.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.mni.Deriv_0.WM_1.GSR_1.blur${blurval}.K2.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.mni.Deriv_0.WM_0.GSR_0.blur${blurval}.K2.1D
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii $rest_dir/ME/tsnr/${subj_name}_medn_mni_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii > $rest_dir/ME/tsnr/tsnr_tstat.mni.Deriv_0.WM_0.GSR_1.blur${blurval}.K2.1D
done

rm $rest_dir/ME/tsnr/${subj_name}_medn_nat*.nii
rm $rest_dir/ME/tsnr/${subj_name}_medn_tse*.nii

# =========================== Generate ROIs for iFC ============================
# Keren masks
3dfractionize -overwrite -clip $Kclip -template $rest_dir/ME/fcon/${subj_name}_medn_mni_blur0.WM_0.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/ME/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_1SD_BINARY_TEMPLATE.nii
3dfractionize -overwrite -clip $Kclip -template $rest_dir/ME/fcon/${subj_name}_medn_mni_blur0.WM_0.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/ME/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_2SD_BINARY_TEMPLATE.nii

# LC mask
3dfractionize -overwrite -clip $Lclip -template $rest_dir/ME/fcon/${subj_name}_medn_nat_blur0.WM_0.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_inMPRAGE_${subj_name}+orig.BRIK
3dfractionize -overwrite -clip $Lclip -template $rest_dir/ME/fcon/${subj_name}_medn_tse_blur0.WM_0.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_${subj_name}.nii

echo "+++++++++++++++++++++++++++++++++++++++ Keren iFC +++++++++++++++++++++++++++++++++++++++"
for base_blur in $blurA $blurB;
do
    for seed_blur in 0 $blurA $blurB;
    do
        for gsr_val in 0 1;
        do
            for wm_val in 0 1;
            do
                # Seed
                3dmaskave -quiet -mask $rest_dir/ME/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > $rest_dir/ME/fcon/seed_Keren1SD.${subj_name}_medn_mni_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D
                3dmaskave -quiet -mask $rest_dir/ME/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > $rest_dir/ME/fcon/seed_Keren2SD.${subj_name}_medn_mni_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D

                # Corr maps
                3dTcorr1D -prefix $rest_dir/ME/fcon/Tcorr1D_Keren1SD.rest.${subj_name}_mni_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${base_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii $rest_dir/ME/fcon/seed_Keren1SD.${subj_name}_medn_mni_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D
                3dTcorr1D -prefix $rest_dir/ME/fcon/Tcorr1D_Keren2SD.rest.${subj_name}_mni_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${base_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii $rest_dir/ME/fcon/seed_Keren2SD.${subj_name}_medn_mni_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D

                3dcalc -a $rest_dir/ME/fcon/Tcorr1D_Keren1SD.rest.${subj_name}_mni_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac+tlrc -expr 'atanh(a)' -prefix $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.nii
                3dcalc -a $rest_dir/ME/fcon/Tcorr1D_Keren2SD.rest.${subj_name}_mni_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac+tlrc -expr 'atanh(a)' -prefix $rest_dir/ME/fcon/ZTcorr1D_Keren2SD.rest.${subj_name}_mni_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.nii
            done
        done
    done
done
rm $rest_dir/ME/fcon/Tcorr1D*

echo "+++++++++++++++++++++++++++++++++++++++ Traced LC iFC +++++++++++++++++++++++++++++++++++++++"
for base_blur in $blurA $blurB;
do
    for seed_blur in 0 $blurA $blurB;
    do
        for gsr_val in 0 1;
        do
            for wm_val in 0 1;
            do
                # Seed
                3dmaskave -quiet -mask $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii $rest_dir/ME/fcon/${subj_name}_medn_tse_blur${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > $rest_dir/ME/fcon/seed_traceLC.${subj_name}_medn_tse_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D
                3dmaskave -quiet -mask $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > $rest_dir/ME/fcon/seed_traceLC.${subj_name}_medn_nat_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D

                # Corr maps
                3dTcorr1D -prefix $rest_dir/ME/fcon/Tcorr1D_LCoverlap.rest.${subj_name}_tse_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${base_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii $rest_dir/ME/fcon/seed_traceLC.${subj_name}_medn_tse_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D
                3dTcorr1D -prefix $rest_dir/ME/fcon/Tcorr1D_LCoverlap.rest.${subj_name}_nat_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${base_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii $rest_dir/ME/fcon/seed_traceLC.${subj_name}_medn_nat_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D

                3dcalc -a $rest_dir/ME/fcon/Tcorr1D_LCoverlap.rest.${subj_name}_tse_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac+tlrc -expr 'atanh(a)' -prefix $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_tse_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.nii
                3dcalc -a $rest_dir/ME/fcon/Tcorr1D_LCoverlap.rest.${subj_name}_nat_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac+tlrc -expr 'atanh(a)' -prefix $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.nii
            done
        done
    done
done
rm $rest_dir/ME/fcon/Tcorr1D*

# Create an all_runs dataset to match the fitts, errts, etc.
#3dTcat -prefix all_echoes.$subj_name $run.e0*.5.blur.mask.nii

# compute and store GCOR (global correlation average)
# (sum of squares of global mean of unit errts)
#3dTnorm -norm2 -prefix rm.errts.e01.unit errts.rest.tproject.e01+tlrc
#3dTnorm -norm2 -prefix rm.errts.e02.unit errts.rest.tproject.e02+tlrc
#3dTnorm -norm2 -prefix rm.errts.e03.unit errts.rest.tproject.e03+tlrc
#3dmaskave -quiet -mask full_mask.$subj+tlrc rm.errts.e01.unit+tlrc > gmean.errts.e01.unit.1D
#3dmaskave -quiet -mask full_mask.$subj+tlrc rm.errts.e02.unit+tlrc > gmean.errts.e02.unit.1D
#3dmaskave -quiet -mask full_mask.$subj+tlrc rm.errts.e03.unit+tlrc > gmean.errts.e03.unit.1D
#3dTstat -sos -prefix - gmean.errts.e01.unit.1D\' > out.gcor.e01.1D
#3dTstat -sos -prefix - gmean.errts.e02.unit.1D\' > out.gcor.e02.1D
#3dTstat -sos -prefix - gmean.errts.e03.unit.1D\' > out.gcor.e03.1D

echo   "++++++++++++++++++++++++"
echo   "Housekeeping"
#rm $rest_dir/ME/fcon/*tproj.${cenmode}.nii
#rm $rest_dir/ME/fcon/${subj_name}_medn*.nii

cp $rest_dir/mprage-BET${bet}-noskull_do_at.nii $rest_dir/ME/fcon/${subj_name}_mprage-BET${bet}-noskull_do_at.nii

cd ME

mv ocv_ss.nii.gz ${subj_name}_ocv_ss.nii.gz
mv s0v_ss.nii.gz ${subj_name}_s0v_ss.nii.gz
mv t2svm_ss.nii.gz ${subj_name}_t2svm_ss.nii.gz


cd ../../final_scripts

end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end



