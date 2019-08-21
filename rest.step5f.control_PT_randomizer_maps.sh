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
blur=5

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
cont_dir=${base_dir}/analysis/univariate/rest_results/analysis/overlaps/PT_randomized
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

if [ -d $rest_dir/PT ]
then
    rm -r $rest_dir/PT
fi

mkdir $rest_dir/PT
cd $rest_dir/PT

echo "+++++++++++++++++++++++++++++++++++++++ Overlap controls +++++++++++++++++++++++++++++++++++++++"
for iter_val in 1 2 3 4 5 6 7 8 9 10;
do
    for blur_val in 0 $blur;
    do
        3dTcorr1D -prefix Tcorr1D_PT.rest.ME_K1.${subj_name}.b5s${blur_val}.iter${iter_val}.nii $rest_dir/ME/fcon/${subj_name}_medn_mni_blur5.WM_1.GSR_0.tproj.NTRP.nii ${cont_dir}/control_${subj_name}.ME.PT.s${blur_val}_withK1_seed${iter_val}.txt
        3dTcorr1D -prefix Tcorr1D_PT.rest.ME_LC.${subj_name}.b5s${blur_val}.iter${iter_val}.nii $rest_dir/ME/fcon/${subj_name}_medn_mni_blur5.WM_1.GSR_0.tproj.NTRP.nii ${cont_dir}/control_${subj_name}.ME.PT.s${blur_val}_withLC_seed${iter_val}.txt

        3dTcorr1D -prefix Tcorr1D_PT.rest.SE_K1.${subj_name}.b5s${blur_val}.iter${iter_val}.nii $rest_dir/SE/fcon/${subj_name}_e2_mni_blur5.WM_1.GSR_0.tproj.NTRP.nii ${cont_dir}/control_${subj_name}.SE.PT.s${blur_val}_withK1_seed${iter_val}.txt
        3dTcorr1D -prefix Tcorr1D_PT.rest.SE_LC.${subj_name}.b5s${blur_val}.iter${iter_val}.nii $rest_dir/SE/fcon/${subj_name}_e2_mni_blur5.WM_1.GSR_0.tproj.NTRP.nii ${cont_dir}/control_${subj_name}.SE.PT.s${blur_val}_withLC_seed${iter_val}.txt


        3dcalc -a Tcorr1D_PT.rest.ME_K1.${subj_name}.b5s${blur_val}.iter${iter_val}.nii -expr 'atanh(a)' -prefix Zcorr1D_PT.rest.ME_K1.${subj_name}.b5s${blur_val}.iter${iter_val}.nii
        3dcalc -a Tcorr1D_PT.rest.ME_LC.${subj_name}.b5s${blur_val}.iter${iter_val}.nii -expr 'atanh(a)' -prefix Zcorr1D_PT.rest.ME_LC.${subj_name}.b5s${blur_val}.iter${iter_val}.nii

        3dcalc -a Tcorr1D_PT.rest.SE_K1.${subj_name}.b5s${blur_val}.iter${iter_val}.nii -expr 'atanh(a)' -prefix Zcorr1D_PT.rest.SE_K1.${subj_name}.b5s${blur_val}.iter${iter_val}.nii
        3dcalc -a Tcorr1D_PT.rest.SE_LC.${subj_name}.b5s${blur_val}.iter${iter_val}.nii -expr 'atanh(a)' -prefix Zcorr1D_PT.rest.SE_LC.${subj_name}.b5s${blur_val}.iter${iter_val}.nii
    done
done


echo   "++++++++++++++++++++++++"
echo   "Housekeeping"
rm $rest_dir/PT/Tcorr*

cd ../../

end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end










