# Resting state analysis - preprocessing for multi-echo data
# execute via:
# ./rest.step2b.SE.sh s??
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

if [ -d $rest_dir/SE ]
then
    rm -r $rest_dir/SE
    rm -r $rest_dir/tempSE
fi

mkdir $rest_dir/SE
mkdir $rest_dir/tempSE
cd $rest_dir/tempSE

# =========================== process resting state ============================
echo   "++++++++++++++++++++++++"
echo   "Starting meica pre-processing pipeline"
echo   "++++++++++++++++++++++++"

echo   "Deoblique, unifize, skullstrip, and/or autobox anatomical, in afni directory so this only has to be done once (may take a little while)"
if [ ! -e ${afni_dir}mprage-BET$bet-noskull_do.nii.gz ]
then
    if [ ! -e ${afni_dir}mprage-skull.nii ]
    then
        echo "Converting ${afni_dir}$mpragename to nifti"
        3dAFNItoNIFTI -prefix ${afni_dir}mprage-skull ${afni_dir}$mpragename+orig
    fi
    if [ ! -e ${afni_dir}mprage-BET$bet-noskull.nii ]
    then
        echo   "Skull stripping..."
        $bet_loc ${afni_dir}mprage-skull.nii ${afni_dir}mprage-BET$bet-noskull -R -f $bet -g 0
        gunzip ${afni_dir}mprage-BET$bet-noskull.nii

        # Convert NIFTI back to regular AFNI file
        3dcalc -a ${afni_dir}mprage-BET$bet-noskull.nii -prefix ${afni_dir}mprage-BET$bet-noskull -expr 'a'
    fi
    3dWarp -overwrite -prefix ${afni_dir}mprage-BET$bet-noskull_do.nii.gz -deoblique ${afni_dir}mprage-BET$bet-noskull.nii
fi

echo   "++++++++++++++++++++++++"
echo   "Starting single echo pre-processing pipeline"
echo   "Copy in second echo, reset NIFTI tags as needed"
3dcalc -a ${data_dir}$run.e02.nii -expr 'a' -prefix ./$run.e02.nii
nifti_tool -mod_hdr -mod_field sform_code 1 -mod_field qform_code 1 -infiles ./$run.e02.nii -overwrite

echo   "Calculate and save motion and obliquity parameters, despiking first if not disabled, and separately save and mask the base volume"
3dWarp -verb -card2oblique ./$run.e02.nii'[0]' -overwrite  -newgrid 1.000000 -prefix $rest_dir/SE/mprage-BET$bet-noskull_ob.nii ${data_dir}mprage-BET$bet-noskull_do.nii.gz | \grep  -A 4 '# mat44 Obliquity Transformation ::'  > $rest_dir/SE/transform_deoblique2oblique.mat.1D
3dDespike -overwrite -prefix ./$run.e02_vrA.nii ./$run.e02.nii
3daxialize -overwrite -prefix ./$run.e02_vrA.nii ./$run.e02_vrA.nii
3dcalc -a ./$run.e02_vrA.nii'[2]' -expr 'a' -prefix e0_base.nii
3dvolreg -overwrite -tshift -quintic -prefix ./$run.e02_vrA.nii -base e0_base.nii -dfile ./$run.e02_vrA.1D -1Dmatrix_save $rest_dir/SE/transform_volreg.aff12.1D ./$run.e02_vrA.nii
1dcat ./$run.e02_vrA.1D'[1..6]{2..$}' > $rest_dir/SE/motion.1D
rm $run.e02_vrA.nii

echo   "++++++++++++++++++++++++"
echo   "RICOR"
if [ -f $afni_dir$run.slibase.1D ]
then
    1dcat $afni_dir$run.slibase.1D'{2..$}' > ricor.1D
else
    1dcat $afni_dir${run//0}.slibase.1D'{2..$}' > ricor.1D
fi
3dDetrend -polort 6 -prefix rm.ricor.1D ricor.1D\'
1dtranspose rm.ricor.1D ricor_det.1D
1dcat ricor_det.1D"[0..12]" > ricor_det_s0.1D
3dDeconvolve -polort 6 -input $run.e02.nii"[2..$]" -x1D_stop -x1D e2.ricor.xmat.1D

3dREMLfit -input $run.e02.nii'[2..$]' \
-matrix e2.ricor.xmat.1D \
-Obeta e2.ricor.betas \
-Oerrts e2.ricor.errts \
-slibase_sm ricor_det.1D

3dSynthesize -matrix e2.ricor.xmat.1D                  \
-cbucket e2.ricor.betas+orig"[0..6]"                \
-select polort -prefix e2.ricor.polort

3dcalc -a e2.ricor.errts+orig  \
-b e2.ricor.polort+orig \
-datum short -nscale \
-expr 'a+b' -prefix $run.e2.ricor.nii

echo   "++++++++++++++++++++++++"
echo   "Preliminary preprocessing of functional datasets: despike, tshift, deoblique, and/or axialize"
echo "--------Preliminary preprocessing dataset $run.e01.nii of TE=13ms to produce e1_ts+orig"
3dDespike -overwrite -prefix ./$run.e2_pt.nii.gz $run.e2.ricor.nii
3dTshift -heptic -prefix ./e2_ts+orig ./$run.e2_pt.nii.gz
3daxialize -overwrite -prefix ./e2_ts+orig ./e2_ts+orig
3drefit -deoblique -TR 3 e2_ts+orig

3dUnifize -prefix ./$subj_name.e2_ts_unifize+orig e2_ts+orig
3dSkullStrip -no_avoid_eyes -prefix $rest_dir/SE/$subj_name.e2_ts_ss.nii.gz -overwrite -input $subj_name.e2_ts_unifize+orig

echo   "++++++++++++++++++++++++"
echo   "Copy anatomical"
cp ${afni_dir}mprage-BET$bet-noskull_do.nii.gz ${rest_dir}/SE
gunzip ${rest_dir}/SE/mprage-BET$bet-noskull_do.nii.gz

echo "--------Using AFNI align_epi_anat.py to drive anatomical-functional coregistration "
align_epi_anat.py -anat2epi -volreg off -tshift off -deoblique off -anat_has_skull no -save_script aea_anat_to_e2.tcsh -anat $rest_dir/SE/mprage-BET$bet-noskull_ob.nii -epi $rest_dir/SE/$subj_name.e2_ts_ss.nii.gz -epi_base 0 -epi_strip 3dAutomask -edge
mv mprage-BET$bet-noskull_ob_al_e2a_only_mat.aff12.1D $rest_dir/SE/transform_anat_obl2epi.mat.aff12.1D
cat_matvec -ONELINE $rest_dir/SE/transform_deoblique2oblique.mat.1D $rest_dir/SE/transform_anat_obl2epi.mat.aff12.1D -I > $rest_dir/SE/transform_epi2anat_deob.aff12.1D
cat_matvec -ONELINE $rest_dir/SE/transform_deoblique2oblique.mat.1D $rest_dir/SE/transform_anat_obl2epi.mat.aff12.1D -I $rest_dir/SE/transform_volreg.aff12.1D > $rest_dir/SE/transform_epi2anat_deob_volreg.aff12.1D


echo   "++++++++++++++++++++++++"
echo   "Extended preprocessing of functional datasets"
# get median of e1 timeseries
3dBrickStat -mask e0_base.nii -percentile 50 1 50 e2_ts+orig[2] > $rest_dir/SE/gms.1D
gms=`cat $rest_dir/SE/gms.1D`; gmsa=($gms); p50=${gmsa[1]}
# shrinking voxel sizes for some reason
3dcopy e0_base.nii e0_base+orig
voxsize=`ccalc .85*$(3dinfo -voxvol e0_base+orig)**.33`
voxdims="`3dinfo -adi e0_base.nii` `3dinfo -adj e0_base.nii` `3dinfo -adk e0_base.nii`"
echo $voxdims > voxdims.1D
echo $voxsize > voxsize.1D

echo "--------Preparing functional masking for this ME-EPI run"
3dZeropad -I 12 -S 12 -A 12 -P 12 -L 12 -R 12 -prefix padded_e2_ss.nii $rest_dir/SE/$subj_name.e2_ts_ss.nii.gz'[0]'

# align mask to deobliqued anatomical, and resample to smaller voxels
3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_epi2anat_deob.aff12.1D -base $rest_dir/SE/mprage-BET$bet-noskull_do.nii -input padded_e2_ss.nii -prefix ./padded_e2_ss.nii -master $rest_dir/SE/mprage-BET$bet-noskull_do.nii.gz -mast_dxyz ${voxsize}

echo "--------Trim empty space off of mask dataset and/or resample"
3dAutobox -overwrite -prefix padded_e2_ss.nii padded_e2_ss.nii
3dresample -overwrite -master padded_e2_ss.nii -dxyz ${voxsize} ${voxsize} ${voxsize} -input padded_e2_ss.nii -prefix padded_e2_ss.nii
3dcalc -float -a padded_e2_ss.nii -expr 'notzero(a)' -overwrite -prefix mask_e2_ss.nii
3dresample -rmode Li -overwrite -master $rest_dir/SE/mprage-BET$bet-noskull_do.nii -dxyz $voxdims -input mask_e2_ss.nii -prefix $rest_dir/SE/nat_e2_mask.nii

echo "--------Apply combined co-registration/motion correction parameter set to e2_ts+orig"
3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_epi2anat_deob_volreg.aff12.1D -base $rest_dir/SE/nat_e2_mask.nii -input e2_ts+orig -prefix ./e2_vr.nii.gz
# In the ME-ICA pipeline, we drop the first two volumes in the next line. Here, we've already dropped those during the earlier RICOR step
3dcalc -float -overwrite -a $rest_dir/SE/nat_e2_mask.nii -b ./e2_vr.nii.gz -expr 'step(a)*b' -prefix ./e2_sm.nii.gz
3dcalc -float -overwrite -a ./e2_sm.nii.gz -expr "a*10000/${p50}" -prefix ./e2_sm.nii.gz
3dTstat -overwrite -prefix ./e2_mean.nii.gz ./e2_sm.nii.gz
mv e2_sm.nii.gz e2_in.nii.gz
3dcalc -float -overwrite -a ./e2_in.nii.gz -b ./e2_mean.nii.gz -expr 'a+b' -prefix ./e2_in.nii.gz
3dTstat -overwrite -stdev -prefix ./e2_std.nii.gz ./e2_in.nii.gz
#rm -f e2_pt.nii.gz e2_vr.nii.gz e2_sm.nii.gz
mv ./e2_in.nii.gz $rest_dir/SE/${subj_name}_nat_e2.nii.gz
gunzip $rest_dir/SE/${subj_name}_nat_e2.nii.gz

# =========================== Transformation information ============================
cd ..

cat_matvec -ONELINE mprage-BET$bet-noskull_do_at.nii::WARP_DATA -I > SE/transform_deob_epi2mni.1D
cat_matvec -ONELINE mprage-BET$bet-noskull_do_at.nii::WARP_DATA > SE/transform_mni2deob_epi.1D

# =========================== Set up folder structure ============================
mkdir SE/tsnr
mkdir SE/fcon
mkdir SE/1d
mkdir SE/rois

# =========================== Blurring of e02 data ============================
cp $rest_dir/SE/${subj_name}_nat_e2.nii $rest_dir/SE/fcon/${subj_name}_e2_nat_blur0.nii
3dBlurToFWHM -overwrite -automask -FWHM $blur -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur0.nii -prefix $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blur}.nii

# =========================== Generate masks and nuisance regressors ============================
# WM masks and regressors
3dmask_tool -overwrite -dilate_input -2 -input ${roi_dir}lr-wm-3mm+orig -prefix $rest_dir/SE/rois/mask_WM_min2.${subj_name}_nat.nii

3dmaskave -overwrite -quiet -mask $rest_dir/SE/rois/mask_WM_min2.${subj_name}_nat.nii $rest_dir/SE/fcon/${subj_name}_e2_nat_blur0.nii > $rest_dir/SE/1d/WM_rest_ts.blur0.1D
# detrend regressor (make orthogonal to poly baseline)
3dDetrend -overwrite -polort 6 -prefix $rest_dir/SE/1d/WM_rest_regressor.blur0.1D $rest_dir/SE/1d/WM_rest_ts.blur0.1D\'
1dtranspose -overwrite $rest_dir/SE/1d/WM_rest_regressor.blur0.1D $rest_dir/SE/1d/WM_rest_regressor_e2.blur0.1D
rm $rest_dir/SE/1d/WM_rest_regressor.blur0.1D
rm $rest_dir/SE/1d/WM_rest_ts.blur0.1D

# 4th Ventricle regressor
# extract 4th ventricle time series
3dmaskave -quiet -mask ${roi_dir}lr-4v-3mm+orig $rest_dir/SE/fcon/${subj_name}_e2_nat_blur0.nii > tempSE/4v_rest_ts.blur0.1D
# detrend regressor (make orthogonal to poly baseline)
3dDetrend -polort 6 -prefix SE/1d/4v_rest_regressor.blur0.1D tempSE/4v_rest_ts.blur0.1D\'
1dtranspose -overwrite SE/1d/4v_rest_regressor.blur0.1D SE/1d/4v_rest_regressor_e2.blur0.1D
rm $rest_dir/SE/1d/4v_rest_regressor.blur0.1D

# Global Signal Regressor
3dmaskave -mask $rest_dir/SE/fcon/${subj_name}_e2_nat_blur0.nii $rest_dir/SE/fcon/${subj_name}_e2_nat_blur0.nii | awk '{FS = " "}; {print $1}' | 1d_tool.py -infile - -demean -write $rest_dir/SE/1d/GSR_rest_regressor_e2.blur0.1D

# Bandpass Regressor
1dBport -nodata $nTR $TE -band 0.01 0.1 -invert -nozero > $rest_dir/SE/1d/bandpass_regressor.1D

echo   "++++++++++++++++++++++++"
echo   "Bandpass and regress motion - SETUP"
# Demeaned motion parameters and derivatives, censor with this info (We only need the info for echo 2, as the other echoes are aligned to echo 2[0])
cp $rest_dir/SE/motion.1D $rest_dir/SE/1d/motion.1D
1d_tool.py -infile $rest_dir/SE/motion.1D -set_nruns 1 -demean -write $rest_dir/SE/1d/motion_demean.1D
1d_tool.py -infile $rest_dir/SE/motion.1D -set_nruns 1 -derivative -demean -write $rest_dir/SE/1d/motion_deriv.1D
1d_tool.py -infile $rest_dir/SE/motion.1D -set_nruns 1 -show_censor_count -censor_prev_TR -censor_motion 0.2 $rest_dir/SE/1d/motion_rest
ktrs=`1d_tool.py -infile $rest_dir/SE/1d/motion_rest_censor.1D -show_trs_uncensored encoded`


echo   "++++++++++++++++++++++++"
echo   "Bandpass and regress motion"
# 3dDeconvolve to generate xmats, then stop

# Native space: derivs +, WM +, GSR -, blur -, 4th V +
3dDeconvolve -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur0.nii                        \
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
    -stim_file 14 $rest_dir/SE/1d/4v_rest_regressor_e2.blur0.1D -stim_base 14 -stim_label 14 4v \
    -x1D $rest_dir/SE/1d/X.xmat.nat.polortA.Deriv_1.WM_1.GSR_0.blur0.1D                    \
    -x1D_uncensored $rest_dir/SE/1d/X.nocensor.xmat.nat.polortA.Deriv_1.WM_1.GSR_0.blur0.1D \
    -x1D_stop

# Native space: derivs +, WM +, GSR +, blur -
3dDeconvolve -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur0.nii                        \
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
    -stim_file 13 $rest_dir/SE/1d/WM_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 WM   \
    -stim_file 14 $rest_dir/SE/1d/GSR_rest_regressor_e2.blur0.1D -stim_base 14 -stim_label 14 GSR \
    -stim_file 15 $rest_dir/SE/1d/4v_rest_regressor_e2.blur0.1D -stim_base 15 -stim_label 15 4v \
    -x1D $rest_dir/SE/1d/X.xmat.nat.polortA.Deriv_1.WM_1.GSR_1.blur0.1D                    \
    -x1D_uncensored $rest_dir/SE/1d/X.nocensor.xmat.nat.polortA.Deriv_1.WM_1.GSR_1.blur0.1D \
    -x1D_stop


# Native space: derivs +, WM -, GSR -, blur -
3dDeconvolve -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur0.nii                        \
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
    -stim_file 13 $rest_dir/SE/1d/4v_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 4v \
    -x1D $rest_dir/SE/1d/X.xmat.nat.polortA.Deriv_1.WM_0.GSR_0.blur0.1D                    \
    -x1D_uncensored $rest_dir/SE/1d/X.nocensor.xmat.nat.polortA.Deriv_1.WM_0.GSR_0.blur0.1D \
    -x1D_stop

# Native space: derivs +, WM -, GSR +, blur -
3dDeconvolve -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur0.nii                        \
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
    -stim_file 13 $rest_dir/SE/1d/GSR_rest_regressor_e2.blur0.1D -stim_base 13 -stim_label 13 GSR \
    -stim_file 14 $rest_dir/SE/1d/4v_rest_regressor_e2.blur0.1D -stim_base 14 -stim_label 14 4v \
    -x1D $rest_dir/SE/1d/X.xmat.nat.polortA.Deriv_1.WM_0.GSR_1.blur0.1D                    \
    -x1D_uncensored $rest_dir/SE/1d/X.nocensor.xmat.nat.polortA.Deriv_1.WM_0.GSR_1.blur0.1D \
    -x1D_stop


# Display any large pairwise correlations from the X-matrix
#1d_tool.py -show_cormat_warnings -infile $rest_dir/SE/1d/X.xmat.nat.polortA.Deriv_1.WM_1.GSR_0.blur0.1D  |& tee $rest_dir/SE/fcon/out.cormat_warn.nat.polortA.Deriv_1.WM_1.GSR_0.blur0.txt
#1d_tool.py -show_cormat_warnings -infile $rest_dir/SE/1d/X.xmat.nat.polortA.Deriv_1.WM_1.GSR_1.blur0.1D  |& tee $rest_dir/SE/fcon/out.cormat_warn.nat.polortA.Deriv_1.WM_1.GSR_1.blur0.txt
#1d_tool.py -show_cormat_warnings -infile $rest_dir/SE/1d/X.xmat.nat.polortA.Deriv_1.WM_1.GSR_0.blur${blur}.1D  |& tee $rest_dir/SE/fcon/out.cormat_warn.nat.polortA.Deriv_1.WM_1.GSR_0.blur${blur}.txt
#1d_tool.py -show_cormat_warnings -infile $rest_dir/SE/1d/X.xmat.nat.polortA.Deriv_1.WM_1.GSR_1.blur${blur}.1D  |& tee $rest_dir/SE/fcon/out.cormat_warn.nat.polortA.Deriv_1.WM_1.GSR_1.blur${blur}.txt

# Project out regression matrix - Native space
for blurval in 0 $blur
do
    3dTproject -polort 0 -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode ${cenmode} -ort $rest_dir/SE/1d/X.nocensor.xmat.nat.polortA.Deriv_1.WM_1.GSR_0.blur0.1D -prefix $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii
    3dTproject -polort 0 -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode ${cenmode} -ort $rest_dir/SE/1d/X.nocensor.xmat.nat.polortA.Deriv_1.WM_1.GSR_1.blur0.1D -prefix $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii
    3dTproject -polort 0 -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode ${cenmode} -ort $rest_dir/SE/1d/X.nocensor.xmat.nat.polortA.Deriv_1.WM_0.GSR_0.blur0.1D -prefix $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii
    3dTproject -polort 0 -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.nii -censor $rest_dir/SE/1d/motion_rest_censor.1D -cenmode ${cenmode} -ort $rest_dir/SE/1d/X.nocensor.xmat.nat.polortA.Deriv_1.WM_0.GSR_1.blur0.1D -prefix $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii
done

# =========================== Warp the e2 in MPRAGE space to TSE and MNI spaces ============================
cp $rest_dir/ME/transform_anat2tse.${subj_name}.1D $rest_dir/SE/
cp $rest_dir/SE/transform* $rest_dir/SE/1d/

# Warp the e2s
for blurval in 0 $blur
do
    # Warp echo 2 to TSE
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_anat2tse.${subj_name}.1D -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/SE/fcon/${subj_name}_e2_tse_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii -master ${subj_E_dir}ANATinTSE.${subj_name}+orig -mast_dxyz $dims $dims $dims
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_anat2tse.${subj_name}.1D -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii -prefix $rest_dir/SE/fcon/${subj_name}_e2_tse_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii -master ${subj_E_dir}ANATinTSE.${subj_name}+orig -mast_dxyz $dims $dims $dims
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_anat2tse.${subj_name}.1D -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/SE/fcon/${subj_name}_e2_tse_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii -master ${subj_E_dir}ANATinTSE.${subj_name}+orig -mast_dxyz $dims $dims $dims
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_anat2tse.${subj_name}.1D -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii -prefix $rest_dir/SE/fcon/${subj_name}_e2_tse_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii -master ${subj_E_dir}ANATinTSE.${subj_name}+orig -mast_dxyz $dims $dims $dims

    # Warp echo 2 to MNI
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_deob_epi2mni.1D  -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii -master abtemplate.nii.gz -mast_dxyz $dims $dims $dims
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_deob_epi2mni.1D  -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii -prefix $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii -master abtemplate.nii.gz -mast_dxyz $dims $dims $dims
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_deob_epi2mni.1D  -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii -master abtemplate.nii.gz -mast_dxyz $dims $dims $dims
    3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/SE/transform_deob_epi2mni.1D  -input $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii -prefix $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii -master abtemplate.nii.gz -mast_dxyz $dims $dims $dims
done

# =========================== Calculate tSNR ============================
for blurval in 0 $blur
do
    # tSNR in native MPRAGE
    3dTstat -cvarinvNOD -prefix $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii

    # tSNR in MNI
    3dTstat -cvarinvNOD -prefix $rest_dir/SE/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/SE/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/SE/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/SE/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii

    # tSNR in TSE
    3dTstat -cvarinvNOD -prefix $rest_dir/SE/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_1.GSR_0.tstat_tsnr.nii $rest_dir/SE/fcon/${subj_name}_e2_tse_blur${blurval}.WM_1.GSR_0.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/SE/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_1.GSR_1.tstat_tsnr.nii $rest_dir/SE/fcon/${subj_name}_e2_tse_blur${blurval}.WM_1.GSR_1.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/SE/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_0.GSR_0.tstat_tsnr.nii $rest_dir/SE/fcon/${subj_name}_e2_tse_blur${blurval}.WM_0.GSR_0.tproj.${cenmode}.nii
    3dTstat -cvarinvNOD -prefix $rest_dir/SE/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_0.GSR_1.tstat_tsnr.nii $rest_dir/SE/fcon/${subj_name}_e2_tse_blur${blurval}.WM_0.GSR_1.tproj.${cenmode}.nii
done

# =========================== Generate ROIs for tSNR ============================
# Keren masks
3dfractionize -overwrite -clip $Kclip -template $rest_dir/SE/tsnr/${subj_name}_e2_mni_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/SE/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_1SD_BINARY_TEMPLATE.nii
3dfractionize -overwrite -clip $Kclip -template $rest_dir/SE/tsnr/${subj_name}_e2_mni_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/SE/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_2SD_BINARY_TEMPLATE.nii

# LC mask
3dfractionize -overwrite -clip $Lclip -template $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/SE/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_inMPRAGE_${subj_name}+orig.BRIK
3dfractionize -overwrite -clip $Lclip -template $rest_dir/SE/tsnr/${subj_name}_e2_tse_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/SE/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_${subj_name}.nii

# PT mask
3dfractionize -overwrite -clip $Lclip -template $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/SE/rois/mask_PT.${subj_name}_rest_nat.frac.nii -input ${base_dir}/${subj_name}/afni/*/PT_ROI_overlap_inMPRAGE_${subj_name}.nii
3dfractionize -overwrite -clip $Lclip -template $rest_dir/SE/tsnr/${subj_name}_e2_tse_blur0.WM_0.GSR_0.tstat_tsnr.nii -prefix $rest_dir/SE/rois/mask_PT.${subj_name}_rest_tse.frac.nii -input ${base_dir}/${subj_name}/afni/*/PT_ROI_overlap_${subj_name}.nii

echo "+++++++++++++++++++++++++++++++++++++++ TSNR per ROI +++++++++++++++++++++++++++++++++++++++"
for blurval in 0 $blurA #$blurB
do
for wm in 0 1
do
for gsr in 0 1
do
    # Whole brain
    3dmaskave -quiet -mask SELF $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.Whole.1D

    # WM heavy erode
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_WM_min2.${subj_name}_nat.nii $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.WM.1D

    # Traced LC
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii $rest_dir/SE/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.tse.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.LC.1D
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.LC.1D

    # V1
    3dmaskave -quiet -mask ${roi_dir}lr-V1-only-3mm+orig $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.V1.1D

    # HPC
    3dmaskave -quiet -mask ${roi_dir}lr-hpc-3mm+orig $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.HPC.1D

    # GM
    3dmaskave -quiet -mask ${roi_dir}lr-gm-3mm+orig $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.GM.1D

    # vmPFC
    3dmaskave -quiet -mask ${roi_dir}lr-vmpfc-3mm+orig $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.vmPFC.1D

    # Precentral
    3dmaskave -quiet -mask ${roi_dir}lr-precentral-3mm+orig $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.precentral.1D

    # Transtemporal
    3dmaskave -quiet -mask ${roi_dir}lr-transtemp-3mm+orig $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.transtemp.1D

    # Pontine Tegmentum
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_PT.${subj_name}_rest_nat.frac.nii $rest_dir/SE/tsnr/${subj_name}_e2_nat_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.nat.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.PT.1D
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_PT.${subj_name}_rest_tse.frac.nii $rest_dir/SE/tsnr/${subj_name}_e2_tse_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.tse.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.PT.1D

    # Keren atlas
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii $rest_dir/SE/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.mni.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.K1.1D
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii $rest_dir/SE/tsnr/${subj_name}_e2_mni_blur${blurval}.WM_${wm}.GSR_${gsr}.tstat_tsnr.nii > $rest_dir/SE/tsnr/tsnr_tstat.mni.Deriv_1.WM_${wm}.GSR_${gsr}.blur${blurval}.K2.1D

done
done
done

rm $rest_dir/SE/tsnr/${subj_name}_e2_nat*.nii
rm $rest_dir/SE/tsnr/${subj_name}_e2_tse*.nii


# =========================== Generate ROIs for iFC ============================
# Keren masks
3dfractionize -overwrite -clip $Kclip -template $rest_dir/SE/fcon/${subj_name}_e2_mni_blur0.WM_0.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/SE/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_1SD_BINARY_TEMPLATE.nii
3dfractionize -overwrite -clip $Kclip -template $rest_dir/SE/fcon/${subj_name}_e2_mni_blur0.WM_0.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/SE/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii -input ${base_dir}analysis/LC_maps/LC_2SD_BINARY_TEMPLATE.nii

# LC mask
3dfractionize -overwrite -clip $Lclip -template $rest_dir/SE/fcon/${subj_name}_e2_nat_blur0.WM_0.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/SE/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_inMPRAGE_${subj_name}+orig.BRIK
3dfractionize -overwrite -clip $Lclip -template $rest_dir/SE/fcon/${subj_name}_e2_tse_blur0.WM_0.GSR_0.tproj.${cenmode}.nii -prefix $rest_dir/SE/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii -input ${base_dir}/${subj_name}/afni/*/LCx_ROI_overlap_${subj_name}.nii

echo "+++++++++++++++++++++++++++++++++++++++ Keren iFC +++++++++++++++++++++++++++++++++++++++"
for base_blur in $blur
do
for seed_blur in 0 $blur
do
for gsr_val in 0 1;
do
for wm_val in 0 1;
do
    # Seed
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > $rest_dir/SE/fcon/seed_Keren1SD.${subj_name}_e2_mni_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > $rest_dir/SE/fcon/seed_Keren2SD.${subj_name}_e2_mni_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D

    # Corr maps
    3dTcorr1D -prefix $rest_dir/SE/fcon/Tcorr1D_Keren1SD.rest.${subj_name}_mni_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${base_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii $rest_dir/SE/fcon/seed_Keren1SD.${subj_name}_e2_mni_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D
    3dTcorr1D -prefix $rest_dir/SE/fcon/Tcorr1D_Keren2SD.rest.${subj_name}_mni_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${base_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii $rest_dir/SE/fcon/seed_Keren2SD.${subj_name}_e2_mni_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D

    3dcalc -a $rest_dir/SE/fcon/Tcorr1D_Keren1SD.rest.${subj_name}_mni_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac+tlrc -expr 'atanh(a)' -prefix $rest_dir/SE/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.nii
    3dcalc -a $rest_dir/SE/fcon/Tcorr1D_Keren2SD.rest.${subj_name}_mni_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac+tlrc -expr 'atanh(a)' -prefix $rest_dir/SE/fcon/ZTcorr1D_Keren2SD.rest.${subj_name}_mni_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.nii
done
done
done
done
rm $rest_dir/SE/fcon/Tcorr1D*

echo "+++++++++++++++++++++++++++++++++++++++ Traced LC iFC +++++++++++++++++++++++++++++++++++++++"
for base_blur in $blur
do
for seed_blur in 0 $blur
do
for gsr_val in 0 1;
do
for wm_val in 0 1;
do
    # Seed
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_LCoverlap.${subj_name}_rest_tse.frac.nii $rest_dir/SE/fcon/${subj_name}_e2_tse_blur${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > $rest_dir/SE/fcon/seed_traceLC.${subj_name}_e2_tse_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > $rest_dir/SE/fcon/seed_traceLC.${subj_name}_e2_nat_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D

    # Corr maps
    3dTcorr1D -prefix $rest_dir/SE/fcon/Tcorr1D_LCoverlap.rest.${subj_name}_tse_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${base_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii $rest_dir/SE/fcon/seed_traceLC.${subj_name}_e2_tse_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D
    3dTcorr1D -prefix $rest_dir/SE/fcon/Tcorr1D_LCoverlap.rest.${subj_name}_nat_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${base_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii $rest_dir/SE/fcon/seed_traceLC.${subj_name}_e2_nat_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D

    3dcalc -a $rest_dir/SE/fcon/Tcorr1D_LCoverlap.rest.${subj_name}_tse_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac+tlrc -expr 'atanh(a)' -prefix $rest_dir/SE/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_tse_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.nii
    3dcalc -a $rest_dir/SE/fcon/Tcorr1D_LCoverlap.rest.${subj_name}_nat_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac+tlrc -expr 'atanh(a)' -prefix $rest_dir/SE/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.nii
done
done
done
done
rm $rest_dir/SE/fcon/Tcorr1D*

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
#rm $rest_dir/SE/fcon/*tproj.${cenmode}.nii
#rm $rest_dir/SE/fcon/*nat_blur*.nii


cd $rest_dir/
rm -r tempSE


cd ../final_scripts


end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end










