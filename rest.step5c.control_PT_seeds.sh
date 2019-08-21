# Resting state analysis - generate info to create overlap/percentile figures
# execute via:
# ./rest.fcon.analysis.overlap.sh s??
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
bet=.25
blur=5
cenmode=NTRP

# environment variables
export OMP_NUM_THREADS=$jobs
export MKL_NUM_THREADS=$jobs
export DYLD_FALLBACK_LIBRARY_PATH=/Users/khena/abin

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
    overwrite=${args[1]}
    rest_dir=${base_dir}analysis/univariate/rest_results/$subj_name/
    v4_dir=${base_dir}analysis/univariate/e2_both_results/$subj_name/
    roi_dir=${base_dir}analysis/rois/$subj_name/
    echo "Running $subj_name"
else
    echo "Arguments missing, terminating"
exit
fi

# =========================== make directories ============================
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

if [ -d $rest_dir/Overlap/PT ]
then
    rm -r $rest_dir/Overlap/PT
fi

mkdir $rest_dir/Overlap/PT
cd $rest_dir/Overlap/PT

wm_val=1
gsr_val=0

# =========================== get time series and iFC for PT ============================

for base_blur in $blur
do
for seed_blur in 0 $blur
do
    # Seed
    3dmaskave -quiet -mask $rest_dir/ME/rois/mask_PT.${subj_name}_rest_nat.frac.nii $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > $rest_dir/Overlap/PT/seed_PT.ME.${subj_name}_medn_nat_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D
    3dmaskave -quiet -mask $rest_dir/SE/rois/mask_PT.${subj_name}_rest_nat.frac.nii $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > $rest_dir/Overlap/PT/seed_PT.SE.${subj_name}_e2_nat_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D

    # Corr maps
    3dTcorr1D -prefix $rest_dir/Overlap/PT/Tcorr1D_PT.ME.rest.${subj_name}_nat_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${base_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii $rest_dir/Overlap/PT/seed_PT.ME.${subj_name}_medn_nat_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D
    3dTcorr1D -prefix $rest_dir/Overlap/PT/Tcorr1D_PT.SE.rest.${subj_name}_nat_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${base_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii $rest_dir/Overlap/PT/seed_PT.SE.${subj_name}_e2_nat_seed${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.1D

    3dcalc -a $rest_dir/Overlap/PT/Tcorr1D_PT.ME.rest.${subj_name}_nat_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac+tlrc -expr 'atanh(a)' -prefix $rest_dir/Overlap/PT/ZTcorr1D_PT.ME.rest.${subj_name}_nat_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.nii
    3dcalc -a $rest_dir/Overlap/PT/Tcorr1D_PT.SE.rest.${subj_name}_nat_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac+tlrc -expr 'atanh(a)' -prefix $rest_dir/Overlap/PT/ZTcorr1D_PT.SE.rest.${subj_name}_nat_b${base_blur}.s${seed_blur}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.frac.nii
done
done
rm $rest_dir/Overlap/PT/Tcorr1D*


echo "+++++++++++++++++++++++++++++++++++++++ Keren seed in ME +++++++++++++++++++++++++++++++++++++++"
for blur_val in 0 5;
do
    3dROIstats -mask $rest_dir/ME/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${blur_val}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > seed_Keren1SD.ME.${subj_name}.blur${blur_val}.1D
    3dROIstats -mask $rest_dir/ME/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii $rest_dir/ME/fcon/${subj_name}_medn_mni_blur${blur_val}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > seed_Keren2SD.ME.${subj_name}.blur${blur_val}.1D

    awk '{$1=$2=""} NR>1 {print $0}' < seed_Keren1SD.ME.${subj_name}.blur${blur_val}.1D > seed_Keren1SD.ME.${subj_name}.blur${blur_val}.txt
    awk '{$1=$2=""} NR>1 {print $0}' < seed_Keren2SD.ME.${subj_name}.blur${blur_val}.1D > seed_Keren2SD.ME.${subj_name}.blur${blur_val}.txt
done

echo "+++++++++++++++++++++++++++++++++++++++ Keren seed in SE +++++++++++++++++++++++++++++++++++++++"
for blur_val in 0 5;
do
    3dROIstats -mask $rest_dir/SE/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${blur_val}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > seed_Keren1SD.SE.${subj_name}.blur${blur_val}.1D
    3dROIstats -mask $rest_dir/SE/rois/mask_Keren2SD.${subj_name}_rest_mni.frac.nii $rest_dir/SE/fcon/${subj_name}_e2_mni_blur${blur_val}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > seed_Keren2SD.SE.${subj_name}.blur${blur_val}.1D

    awk '{$1=$2=""} NR>1 {print $0}' < seed_Keren1SD.SE.${subj_name}.blur${blur_val}.1D > seed_Keren1SD.SE.${subj_name}.blur${blur_val}.txt
    awk '{$1=$2=""} NR>1 {print $0}' < seed_Keren2SD.SE.${subj_name}.blur${blur_val}.1D > seed_Keren2SD.SE.${subj_name}.blur${blur_val}.txt
done

echo "+++++++++++++++++++++++++++++++++++ Traced LC seed in ME and SE +++++++++++++++++++++++++++++++++++"
for blur_val in 0 5;
do
    3dROIstats -mask $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii $rest_dir/ME/fcon/${subj_name}_medn_nat_blur${blur_val}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > seed_LC.ME.${subj_name}.blur${blur_val}.1D
    3dROIstats -mask $rest_dir/SE/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii $rest_dir/SE/fcon/${subj_name}_e2_nat_blur${blur_val}.WM_${wm_val}.GSR_${gsr_val}.tproj.${cenmode}.nii > seed_LC.SE.${subj_name}.blur${blur_val}.1D

    awk '{$1=$2=""} NR>1 {print $0}' < seed_LC.ME.${subj_name}.blur${blur_val}.1D > seed_LC.ME.${subj_name}.blur${blur_val}.txt
    awk '{$1=$2=""} NR>1 {print $0}' < seed_LC.SE.${subj_name}.blur${blur_val}.1D > seed_LC.SE.${subj_name}.blur${blur_val}.txt
done




echo   "++++++++++++++++++++++++"
echo   "Housekeeping"
rm seed_Keren*.1D
rm seed_LC*.1D
cd ../../

end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end





