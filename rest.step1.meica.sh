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
transform_dir=${base_dir}analysis/univariate/rest_results/old_scripts

#rm -r $rest_dir
mkdir $rest_dir

# =========================== make directories and copy files ============================
# assert directory contains a single E_subjID folder #
cd $base_dir"/"$subj_name"/afni/"
for i in `find ./ -maxdepth 1 -name 'E*'`
do
    enum=`echo $i | awk '{print substr($0,4)}'`
done
afni_dir=$subj_dir"afni/E"$enum/

# Verify that the results directory does not yet exist
if [ -d "$rest_dir/ME" ]
then
    if [ "$overwrite" = 0 ]
    then
        echo "Output dir " $rest_dir " already exists. If you want to rerun the analysis, overwrite to 1."
        exit
    elif [ "$overwrite" = 1 ]
    then
        echo -n "Output dir " $rest_dir " already exists. Are you sure you want to delete all directories for this subject? Enter y if so: "
        read answer
        if [ "$answer" = 'y' ]
        then
            echo "Deleting $rest_dir/ME"
            rm -R $rest_dir/ME
            mkdir $rest_dir/ME
        else
            echo "Exiting."
        exit
        fi
    elif [ "$overwrite" = 2 ]
    then
        echo "Deleting all directories for this participant."
        rm -R $rest_dir/ME
        mkdir $rest_dir/ME
    fi
else
	mkdir $rest_dir/ME
fi

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

mkdir $rest_dir/temp
cd $rest_dir/temp

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
echo   "Copy in resting state datasets, reset NIFTI tags as needed"
3dcalc -a ${data_dir}$run.e01.nii -expr 'a' -prefix ./$run.e01.nii
nifti_tool -mod_hdr -mod_field sform_code 1 -mod_field qform_code 1 -infiles ./$run.e01.nii -overwrite
3dcalc -a ${data_dir}$run.e02.nii -expr 'a' -prefix ./$run.e02.nii
nifti_tool -mod_hdr -mod_field sform_code 1 -mod_field qform_code 1 -infiles ./$run.e02.nii -overwrite
3dcalc -a ${data_dir}$run.e03.nii -expr 'a' -prefix ./$run.e03.nii
nifti_tool -mod_hdr -mod_field sform_code 1 -mod_field qform_code 1 -infiles ./$run.e03.nii -overwrite

echo   "Calculate and save motion and obliquity parameters, despiking first if not disabled, and separately save and mask the base volume"
3dWarp -verb -card2oblique ./$run.e01.nii'[0]' -overwrite  -newgrid 1.000000 -prefix $rest_dir/ME/mprage-BET$bet-noskull_ob.nii ${data_dir}mprage-BET$bet-noskull_do.nii.gz | \grep  -A 4 '# mat44 Obliquity Transformation ::'  > $rest_dir/ME/transform_deoblique2oblique.mat.1D
3dDespike -overwrite -prefix ./$run.e01_vrA.nii ./$run.e01.nii
3daxialize -overwrite -prefix ./$run.e01_vrA.nii ./$run.e01_vrA.nii
3dcalc -a ./$run.e01_vrA.nii'[2]' -expr 'a' -prefix e0_base.nii
3dvolreg -overwrite -tshift -quintic -prefix ./$run.e01_vrA.nii -base e0_base.nii -dfile ./$run.e01_vrA.1D -1Dmatrix_save $rest_dir/ME/transform_volreg.aff12.1D ./$run.e01_vrA.nii
1dcat ./$run.e01_vrA.1D'[1..6]{2..$}' > $rest_dir/ME/motion.1D
rm $run.e01_vrA.nii

echo   "++++++++++++++++++++++++"
echo   "Preliminary preprocessing of functional datasets: despike, tshift, deoblique, and/or axialize"
echo "--------Preliminary preprocessing dataset $run.e01.nii of TE=13ms to produce e1_ts+orig"
3dDespike -overwrite -prefix ./$run.e01_pt.nii.gz $run.e01.nii
3dTshift -heptic  -prefix ./e1_ts+orig ./$run.e01_pt.nii.gz
3daxialize  -overwrite -prefix ./e1_ts+orig ./e1_ts+orig
3drefit -deoblique -TR 3 e1_ts+orig
echo "--------Preliminary preprocessing dataset $run.e02.nii of TE=30ms to produce e2_ts+orig"
3dDespike -overwrite -prefix ./$run.e02_pt.nii.gz $run.e02.nii
3dTshift -heptic  -prefix ./e2_ts+orig ./$run.e02_pt.nii.gz
3daxialize  -overwrite -prefix ./e2_ts+orig ./e2_ts+orig
3drefit -deoblique -TR 3 e2_ts+orig
echo "--------Preliminary preprocessing dataset $run.e03.nii of TE=47ms to produce e3_ts+orig"
3dDespike -overwrite -prefix ./$run.e03_pt.nii.gz $run.e03.nii
3dTshift -heptic  -prefix ./e3_ts+orig ./$run.e03_pt.nii.gz
3daxialize  -overwrite -prefix ./e3_ts+orig ./e3_ts+orig
3drefit -deoblique -TR 3 e3_ts+orig
rm $run.e*_pt.nii.gz

echo   "++++++++++++++++++++++++"
echo   "Prepare T2* and S0 volumes for use in functional masking and (optionally) anatomical-functional coregistration (takes a little while)."
3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_volreg.aff12.1D'{2..22}' -base e0_base.nii -input e1_ts+orig'[2..22]' -prefix e1_vrmat.nii
3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_volreg.aff12.1D'{2..22}' -base e0_base.nii -input e2_ts+orig'[2..22]' -prefix e2_vrmat.nii
3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_volreg.aff12.1D'{2..22}' -base e0_base.nii -input e3_ts+orig'[2..22]' -prefix e3_vrmat.nii
3dZcat -prefix $rest_dir/ME/basestack.nii  e1_vrmat.nii e2_vrmat.nii e3_vrmat.nii
rm e*_vrmat.nii

/usr/bin/python2.7 ../../t2smap.py -d $rest_dir/ME/basestack.nii -e 13,30,47
#/usr/bin/python2.7 ${meica_loc}/meica.libs/t2smap.py -d $rest_dir/ME/basestack.nii -e 13,30,47

3dUnifize -prefix ./ocv_uni+orig ocv.nii
3dSkullStrip -no_avoid_eyes -prefix $rest_dir/ME/ocv_ss.nii.gz -overwrite -input ocv_uni+orig

3dcalc -overwrite -a t2svm.nii -b $rest_dir/ME/ocv_ss.nii.gz -expr 'a*ispositive(a)*step(b)' -prefix t2svm_ss.nii.gz
3dcalc -overwrite -a s0v.nii -b $rest_dir/ME/ocv_ss.nii.gz -expr 'a*ispositive(a)*step(b)' -prefix s0v_ss.nii.gz
3daxialize -overwrite -prefix $rest_dir/ME/t2svm_ss.nii.gz t2svm_ss.nii.gz
3daxialize -overwrite -prefix $rest_dir/ME/ocv_ss.nii.gz $rest_dir/ME/ocv_ss.nii.gz
3daxialize -overwrite -prefix $rest_dir/ME/s0v_ss.nii.gz s0v_ss.nii.gz
rm s0v_ss.nii.gz t2svm_ss.nii.gz

echo   "++++++++++++++++++++++++"
echo   "Copy anatomical into directories and process warps"
cp ${afni_dir}mprage-BET$bet-noskull_do.nii.gz ${rest_dir}/ME
gunzip ${rest_dir}/ME/mprage-BET$bet-noskull_do.nii.gz

echo "--------Using AFNI align_epi_anat.py to drive anatomical-functional coregistration "
align_epi_anat.py -anat2epi -volreg off -tshift off -deoblique off -anat_has_skull no -save_script aea_anat_to_ocv.tcsh -anat $rest_dir/ME/mprage-BET$bet-noskull_ob.nii -epi $rest_dir/ME/ocv_ss.nii.gz -epi_base 0 -epi_strip 3dAutomask -edge
mv mprage-BET$bet-noskull_ob_al_e2a_only_mat.aff12.1D $rest_dir/ME/transform_anat_obl2epi.mat.aff12.1D
cat_matvec -ONELINE $rest_dir/ME/transform_deoblique2oblique.mat.1D $rest_dir/ME/transform_anat_obl2epi.mat.aff12.1D -I > $rest_dir/ME/transform_epi2anat_deob.aff12.1D
cat_matvec -ONELINE $rest_dir/ME/transform_deoblique2oblique.mat.1D $rest_dir/ME/transform_anat_obl2epi.mat.aff12.1D -I $rest_dir/ME/transform_volreg.aff12.1D > $rest_dir/ME/transform_epi2anat_deob_volreg.aff12.1D

echo   "++++++++++++++++++++++++"
echo   "Extended preprocessing of functional datasets"
# get median of e1 timeseries
3dBrickStat -mask e0_base.nii -percentile 50 1 50 e1_ts+orig[2] > $rest_dir/ME/gms.1D
gms=`cat $rest_dir/ME/gms.1D`; gmsa=($gms); p50=${gmsa[1]}
# shrinking voxel sizes for some reason
3dcopy e0_base.nii e0_base+orig
voxsize=`ccalc .85*$(3dinfo -voxvol e0_base+orig)**.33`
voxdims="`3dinfo -adi e0_base.nii` `3dinfo -adj e0_base.nii` `3dinfo -adk e0_base.nii`"
echo $voxdims > voxdims.1D
echo $voxsize > voxsize.1D

echo "--------Preparing functional masking for this ME-EPI run"
3dZeropad -I 12 -S 12 -A 12 -P 12 -L 12 -R 12 -prefix padded_ocv_ss.nii $rest_dir/ME/ocv_ss.nii.gz'[0]'

# align mask to deobliqued anatomical, and resample to smaller voxels
3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_epi2anat_deob.aff12.1D -base ../ME/mprage-BET$bet-noskull_do.nii -input padded_ocv_ss.nii -prefix ./padded_ocv_ss.nii -master ../ME/mprage-BET$bet-noskull_do.nii.gz -mast_dxyz ${voxsize}

echo "--------Trim empty space off of mask dataset and/or resample"
3dAutobox -overwrite -prefix padded_ocv_ss.nii padded_ocv_ss.nii
3dresample -overwrite -master padded_ocv_ss.nii -dxyz ${voxsize} ${voxsize} ${voxsize} -input padded_ocv_ss.nii -prefix padded_ocv_ss.nii
3dcalc -float -a padded_ocv_ss.nii -expr 'notzero(a)' -overwrite -prefix mask_ocv_ss.nii

echo "--------Apply combined co-registration/motion correction parameter set to e1_ts+orig"
3dAllineate -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_epi2anat_deob_volreg.aff12.1D -base mask_ocv_ss.nii -input e1_ts+orig -prefix ./e1_vr.nii.gz
3dTstat -min -prefix ./e1_vr_min.nii.gz ./e1_vr.nii.gz
3dcalc -a mask_ocv_ss.nii -b e1_vr_min.nii.gz -expr 'step(a)*step(b)' -overwrite -prefix mask_ocv_ss.nii
3dcalc -float -overwrite -a mask_ocv_ss.nii -b ./e1_vr.nii.gz'[2..$]' -expr 'step(a)*b' -prefix ./e1_sm.nii.gz
cp ./e1_sm.nii.gz ./e1_noscale_noblur.nii.gz
# scaling so 10000 = median, 5000 = .5* median, 2500 = .25* median, 20000 = 2*median (why?)
3dcalc -float -overwrite -a ./e1_sm.nii.gz -expr "a*10000/${p50}" -prefix ./e1_sm.nii.gz
3dTstat -overwrite -prefix ./e1_mean.nii.gz ./e1_sm.nii.gz
mv e1_sm.nii.gz e1_in.nii.gz
# now adding mean back in (why?)
3dcalc -float -overwrite -a ./e1_in.nii.gz -b ./e1_mean.nii.gz -expr 'a+b' -prefix ./e1_in.nii.gz
3dTstat -overwrite -stdev -prefix ./e1_std.nii.gz ./e1_in.nii.gz
rm -f e1_pt.nii.gz e1_vr.nii.gz e1_sm.nii.gz

echo "--------Apply combined co-registration/motion correction parameter set to e2_ts+orig"
3dAllineate -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_epi2anat_deob_volreg.aff12.1D -base mask_ocv_ss.nii -input e2_ts+orig -prefix ./e2_vr.nii.gz
3dcalc -float -overwrite -a mask_ocv_ss.nii -b ./e2_vr.nii.gz'[2..$]' -expr 'step(a)*b' -prefix ./e2_sm.nii.gz
cp ./e2_sm.nii.gz ./e2_noscale_noblur.nii.gz
3dcalc -float -overwrite -a ./e2_sm.nii.gz -expr "a*10000/${p50}" -prefix ./e2_sm.nii.gz
3dTstat -prefix ./e2_mean.nii.gz ./e2_sm.nii.gz
mv e2_sm.nii.gz e2_in.nii.gz
3dcalc -float -overwrite -a ./e2_in.nii.gz -b ./e2_mean.nii.gz -expr 'a+b' -prefix ./e2_in.nii.gz
3dTstat -stdev -prefix ./e2_std.nii.gz ./e2_in.nii.gz
rm -f e2_pt.nii.gz e2_vr.nii.gz e2_sm.nii.gz

echo "--------Apply combined co-registration/motion correction parameter set to e3_ts+orig"
3dAllineate -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_epi2anat_deob_volreg.aff12.1D -base mask_ocv_ss.nii -input e3_ts+orig -prefix ./e3_vr.nii.gz
3dcalc -float -overwrite -a mask_ocv_ss.nii -b ./e3_vr.nii.gz'[2..$]' -expr 'step(a)*b' -prefix ./e3_sm.nii.gz
cp ./e3_sm.nii.gz ./e3_noscale_noblur.nii.gz
3dcalc -float -overwrite -a ./e3_sm.nii.gz -expr "a*10000/${p50}" -prefix ./e3_sm.nii.gz
3dTstat -prefix ./e3_mean.nii.gz ./e3_sm.nii.gz
mv e3_sm.nii.gz e3_in.nii.gz
3dcalc -float -overwrite -a ./e3_in.nii.gz -b ./e3_mean.nii.gz -expr 'a+b' -prefix ./e3_in.nii.gz
3dTstat -stdev -prefix ./e3_std.nii.gz ./e3_in.nii.gz
rm -f e3_pt.nii.gz e3_vr.nii.gz e3_sm.nii.gz

echo "--------Combined registered echos into zcat_ffd.nii.gz for tedana.py"
3dZcat -overwrite -prefix zcat_ffd.nii.gz ./e1_in.nii.gz ./e2_in.nii.gz ./e3_in.nii.gz
3dcalc -float -overwrite -a zcat_ffd.nii.gz'[0]' -expr 'notzero(a)' -prefix mask_zcat.nii.gz

# =========================== tedana in native space ============================
echo "++++++++++++++++++++++++"
echo +* "Perform TE-dependence analysis (takes a good while)"
/usr/bin/python2.7 ${meica_loc}/meica.libs/tedana.py -e 13,30,47 -d zcat_ffd.nii.gz --sourceTEs=-1 --kdaw=10 --rdaw=1 --initcost=tanh --finalcost=tanh --conv=2.5e-5

3dcalc -overwrite -float -a TED/ts_OC.nii'[0]' -overwrite -expr 'notzero(a)' -prefix TED/export_mask.nii.gz

echo "++++++++++++++++++++++++"
echo +* "Resampling results"
3dresample -rmode Li -overwrite -master ../ME/mprage-BET$bet-noskull_do.nii -dxyz ${voxdims} -input TED/export_mask.nii.gz -prefix $rest_dir/ME/nat_export_mask.nii

3dresample -rmode Li -overwrite -master ../ME/mprage-BET$bet-noskull_do.nii -dxyz ${voxdims} -input TED/ts_OC.nii -prefix $rest_dir/ME/${subj_name}_tsoc_nat.nii
3dNotes -h 'T2* weighted average of ME time series, produced by ME-ICA v2.5 beta6' $rest_dir/ME/${subj_name}_tsoc_nat.nii
3dcalc -overwrite -a $rest_dir/ME/nat_export_mask.nii -b $rest_dir/ME/${subj_name}_tsoc_nat.nii -expr 'ispositive(a-.5)*b' -prefix $rest_dir/ME/${subj_name}_tsoc_nat.nii

3dresample -rmode Li -overwrite -master ../ME/mprage-BET$bet-noskull_do.nii -dxyz ${voxdims} -input TED/dn_ts_OC.nii -prefix $rest_dir/ME/${subj_name}_medn_nat.nii
3dNotes -h 'Denoised timeseries (including thermal noise), produced by ME-ICA v2.5 beta6' $rest_dir/ME/${subj_name}_medn_nat.nii
3dcalc -overwrite -a $rest_dir/ME/nat_export_mask.nii -b $rest_dir/ME/${subj_name}_medn_nat.nii -expr 'ispositive(a-.5)*b' -prefix $rest_dir/ME/${subj_name}_medn_nat.nii

3dresample -rmode Li -overwrite -master ../ME/mprage-BET$bet-noskull_do.nii -dxyz ${voxdims} -input TED/dn_ts_OC.nii -prefix $rest_dir/ME/${subj_name}_T1c_medn_nat.nii
3dNotes -h 'Denoised timeseries with T1 equilibration correction (including thermal noise), produced by ME-ICA v2.5 beta6' $rest_dir/ME/${subj_name}_T1c_medn_nat.nii
3dcalc -overwrite -a $rest_dir/ME/nat_export_mask.nii -b $rest_dir/ME/${subj_name}_T1c_medn_nat.nii -expr 'ispositive(a-.5)*b' -prefix $rest_dir/ME/${subj_name}_T1c_medn_nat.nii

3dresample -rmode Li -overwrite -master ../ME/mprage-BET$bet-noskull_do.nii -dxyz ${voxdims} -input TED/hik_ts_OC.nii -prefix $rest_dir/ME/${subj_name}_hikts_nat.nii
3dNotes -h 'Denoised timeseries with T1 equilibration correction (no thermal noise), produced by ME-ICA v2.5 beta6' $rest_dir/ME/${subj_name}_hikts_nat.nii
3dcalc -overwrite -a $rest_dir/ME/nat_export_mask.nii -b $rest_dir/ME/${subj_name}_hikts_nat.nii -expr 'ispositive(a-.5)*b' -prefix $rest_dir/ME/${subj_name}_hikts_nat.nii

3dresample -rmode Li -overwrite -master ../ME/mprage-BET$bet-noskull_do.nii -dxyz ${voxdims} -input TED/betas_hik_OC.nii -prefix $rest_dir/ME/${subj_name}_mefc_nat.nii
3dNotes -h 'Denoised ICA coeff. set for ME-ICR seed-based FC analysis, produced by ME-ICA v2.5 beta6' $rest_dir/ME/${subj_name}_mefc_nat.nii
3dcalc -overwrite -a $rest_dir/ME/nat_export_mask.nii -b $rest_dir/ME/${subj_name}_mefc_nat.nii -expr 'ispositive(a-.5)*b' -prefix $rest_dir/ME/${subj_name}_mefc_nat.nii

3dresample -rmode Li -overwrite -master ../ME/mprage-BET$bet-noskull_do.nii -dxyz ${voxdims} -input TED/betas_OC.nii -prefix $rest_dir/ME/${subj_name}_mefl_nat.nii
3dNotes -h 'Full ICA coeff. set for component assessment, produced by ME-ICA v2.5 beta6' $rest_dir/ME/${subj_name}_mefl_nat.nii
3dcalc -overwrite -a $rest_dir/ME/nat_export_mask.nii -b $rest_dir/ME/${subj_name}_mefl_nat.nii -expr 'ispositive(a-.5)*b' -prefix TED/${subj_name}_mefl_nat.nii

3dresample -rmode Li -overwrite -master ../ME/mprage-BET$bet-noskull_do.nii -dxyz ${voxdims} -input TED/feats_OC2.nii -prefix $rest_dir/ME/${subj_name}_mefcz_nat.nii
3dNotes -h 'Z-normalized spatial component maps, produced by ME-ICA v2.5 beta6' $rest_dir/ME/${subj_name}_mefcz_nat.nii
3dcalc -overwrite -a $rest_dir/ME/nat_export_mask.nii -b $rest_dir/ME/${subj_name}_mefcz_nat.nii -expr 'ispositive(a-.5)*b' -prefix $rest_dir/ME/${subj_name}_mefcz_nat.nii

cp TED/comp_table.txt $rest_dir/ME/${subj_name}_ctab.txt
cp TED/meica_mix.1D $rest_dir/ME/${subj_name}_mmix.1D


cd ../../final_scripts

end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end



