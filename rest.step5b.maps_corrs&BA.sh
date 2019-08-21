# Resting state analysis - generate info to create overlap/percentile figures
# execute via:
# ./rest.step5b.maps_corrs&BA.sh
# 9 July 2019 - HBT
# Mask out both K1 and LC, run one sample ttest, and write out the iFC maps as vectors so that we can look at correlation, information, and Bland-Altman plots of all maps.
# =========================== setup ============================
start=`date '+%m %d %Y at %H %M %S'`

data_dir=/home/fMRI/projects/tempAttnAudT/analysis/univariate/rest_results/
afni_dir=/usr/lib/afni/bin/
cenmode=NTRP
LC_space=nat

# Remove the LC ROIs
for subj in `seq 7 27`;
do
for blur in 5;
do
for wm in 1;
do
for gsr in 0;
do
for seed in 0 5;
do
    # Create union mask
    3dresample -overwrite -dxyz 3 3 3 -rmode NN -input ${data_dir}tAATs${subj}/ME/rois/mask_LCoverlap.tAATs${subj}_rest_mni.nii -prefix ${data_dir}tAATs${subj}/ME/rois/mask_LCoverlap.tAATs${subj}_rest_mni.3mm.nii \
    -master ${data_dir}tAATs${subj}/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs${subj}_mni_b5.s0.WM_0.GSR_0.tproj.${cenmode}.frac.nii

    3dresample -overwrite -dxyz 3 3 3 -rmode NN -input ${data_dir}tAATs${subj}/ME/rois/mask_Keren1SD.tAATs${subj}_rest_mni.frac.nii -prefix ${data_dir}tAATs${subj}/ME/rois/mask_Keren1SD.tAATs${subj}_rest_mni.3mm.nii \
    -master ${data_dir}tAATs${subj}/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs${subj}_mni_b5.s0.WM_0.GSR_0.tproj.${cenmode}.frac.nii

    3dmask_tool -overwrite -union -prefix ${data_dir}tAATs${subj}/ME/rois/mask_both.tAATs${subj}.nii -inputs ${data_dir}tAATs${subj}/ME/rois/mask_LCoverlap.tAATs${subj}_rest_mni.3mm.nii ${data_dir}tAATs${subj}/ME/rois/mask_Keren1SD.tAATs${subj}_rest_mni.3mm.nii


    # Remove from ME volumes
    3dcalc -overwrite -a ${data_dir}tAATs${subj}/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs${subj}_mni_b${blur}.s${seed}.WM_$wm.GSR_$gsr.tproj.${cenmode}.frac.nii -b ${data_dir}tAATs${subj}/ME/rois/mask_both.tAATs${subj}.nii \
    -expr '(a)*iszero(b)' -prefix ${data_dir}tAATs${subj}/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs${subj}_mni_b${blur}.s${seed}.WM_$wm.GSR_$gsr.noLC.nii
    3dcalc -overwrite -a ${data_dir}tAATs${subj}/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs${subj}_${LC_space}_b${blur}.s${seed}.WM_$wm.GSR_$gsr.tproj.${cenmode}.frac.nii -b ${data_dir}tAATs${subj}/ME/rois/mask_both.tAATs${subj}.nii \
    -expr '(a)*iszero(b)' -prefix ${data_dir}tAATs${subj}/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs${subj}_${LC_space}_b${blur}.s${seed}.WM_$wm.GSR_$gsr.noLC.nii

    # Remove from SE volumes
    3dcalc -overwrite -a ${data_dir}tAATs${subj}/SE/fcon/ZTcorr1D_Keren1SD.rest.tAATs${subj}_mni_b${blur}.s${seed}.WM_$wm.GSR_$gsr.tproj.${cenmode}.frac.nii -b ${data_dir}tAATs${subj}/ME/rois/mask_both.tAATs${subj}.nii \
    -expr '(a)*iszero(b)' -prefix ${data_dir}tAATs${subj}/SE/fcon/ZTcorr1D_Keren1SD.rest.tAATs${subj}_mni_b${blur}.s${seed}.WM_$wm.GSR_$gsr.noLC.nii
    3dcalc -overwrite -a ${data_dir}tAATs${subj}/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs${subj}_${LC_space}_b${blur}.s${seed}.WM_$wm.GSR_$gsr.tproj.${cenmode}.frac.nii -b ${data_dir}tAATs${subj}/ME/rois/mask_both.tAATs${subj}.nii \
    -expr '(a)*iszero(b)' -prefix ${data_dir}tAATs${subj}/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs${subj}_${LC_space}_b${blur}.s${seed}.WM_$wm.GSR_$gsr.noLC.nii
done
done
done
done
done


######################################################################## With LC EXCLUDED


cd $data_dir/analysis
mkdir onesamp_${LC_space}_wmr1_gsr0_noLC
cd onesamp_${LC_space}_wmr1_gsr0_noLC

wm=1
gsr=0
cenmode=NTRP

# Multi echo Keren
for keren in 1;
do
for blur in 5; # Blur of the base dataset
do
for seed in 0 5; # Blur of the seed
do
ROI_a=Keren${keren}SD
label=Multi.K${keren}.b$blur.s$seed
mask=${data_dir}tAATs7/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs7_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii
3dttest++ -prefix $label -mask $mask -dupe_ok -ClustSim -prefix_clustsim $label \
-setA 'Keren' \
s1  ${data_dir}tAATs7/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs7_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s2  ${data_dir}tAATs9/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs9_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s3  ${data_dir}tAATs10/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs10_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s4  ${data_dir}tAATs11/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs11_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s5  ${data_dir}tAATs12/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs12_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s6  ${data_dir}tAATs13/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs13_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s7  ${data_dir}tAATs14/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs14_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s8  ${data_dir}tAATs15/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs15_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s9  ${data_dir}tAATs16/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs16_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s10  ${data_dir}tAATs17/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs17_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s11  ${data_dir}tAATs18/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs18_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s12  ${data_dir}tAATs19/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs19_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s13  ${data_dir}tAATs20/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs20_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s14  ${data_dir}tAATs21/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs21_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s15  ${data_dir}tAATs22/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs22_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s16  ${data_dir}tAATs23/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs23_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s17  ${data_dir}tAATs24/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs24_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s18  ${data_dir}tAATs25/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs25_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s19  ${data_dir}tAATs26/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs26_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s20  ${data_dir}tAATs27/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs27_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii
done
done
done

# Multi echo traced LC
for blur in 5; # Blur of the base dataset
do
for seed in 0 5; # Blur of the seed
do
ROI_a=LCoverlap
label=Multi.LC.b$blur.s$seed
mask=${data_dir}tAATs7/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs7_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii
3dttest++ -prefix $label -mask $mask -dupe_ok -ClustSim -prefix_clustsim $label \
-setA 'LC' \
s1  ${data_dir}tAATs7/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs7_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s2  ${data_dir}tAATs9/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs9_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s3  ${data_dir}tAATs10/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs10_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s4  ${data_dir}tAATs11/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs11_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s5  ${data_dir}tAATs12/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs12_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s6  ${data_dir}tAATs13/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs13_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s7  ${data_dir}tAATs14/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs14_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s8  ${data_dir}tAATs15/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs15_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s9  ${data_dir}tAATs16/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs16_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s10  ${data_dir}tAATs17/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs17_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s11  ${data_dir}tAATs18/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs18_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s12  ${data_dir}tAATs19/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs19_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s13  ${data_dir}tAATs20/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs20_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s14  ${data_dir}tAATs21/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs21_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s15  ${data_dir}tAATs22/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs22_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s16  ${data_dir}tAATs23/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs23_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s17  ${data_dir}tAATs24/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs24_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s18  ${data_dir}tAATs25/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs25_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s19  ${data_dir}tAATs26/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs26_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s20  ${data_dir}tAATs27/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs27_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii
done
done

# Single echo Keren
for keren in 1;
do
for blur in 5; # Blur of the base dataset
do
for seed in 0 5; # Blur of the seed
do
ROI_a=Keren${keren}SD
label=Single.K${keren}.b$blur.s$seed
mask=${data_dir}tAATs7/SE/fcon/ZTcorr1D_Keren1SD.rest.tAATs7_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii
3dttest++ -prefix $label -mask $mask -dupe_ok -ClustSim -prefix_clustsim $label \
-setA 'Keren' \
s1  ${data_dir}tAATs7/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs7_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s2  ${data_dir}tAATs9/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs9_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s3  ${data_dir}tAATs10/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs10_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s4  ${data_dir}tAATs11/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs11_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s5  ${data_dir}tAATs12/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs12_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s6  ${data_dir}tAATs13/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs13_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s7  ${data_dir}tAATs14/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs14_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s8  ${data_dir}tAATs15/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs15_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s9  ${data_dir}tAATs16/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs16_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s10  ${data_dir}tAATs17/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs17_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s11  ${data_dir}tAATs18/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs18_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s12  ${data_dir}tAATs19/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs19_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s13  ${data_dir}tAATs20/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs20_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s14  ${data_dir}tAATs21/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs21_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s15  ${data_dir}tAATs22/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs22_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s16  ${data_dir}tAATs23/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs23_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s17  ${data_dir}tAATs24/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs24_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s18  ${data_dir}tAATs25/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs25_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s19  ${data_dir}tAATs26/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs26_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s20  ${data_dir}tAATs27/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs27_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii
done
done
done

# Single echo traced LC
for blur in 5; # Blur of the base dataset
do
for seed in 0 5; # Blur of the seed
do
ROI_a=LCoverlap
label=Single.LC.b$blur.s$seed
mask=${data_dir}tAATs7/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs7_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii
3dttest++ -prefix $label -mask $mask -dupe_ok -ClustSim -prefix_clustsim $label \
-setA 'LC' \
s1  ${data_dir}tAATs7/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs7_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s2  ${data_dir}tAATs9/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs9_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s3  ${data_dir}tAATs10/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs10_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s4  ${data_dir}tAATs11/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs11_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s5  ${data_dir}tAATs12/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs12_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s6  ${data_dir}tAATs13/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs13_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s7  ${data_dir}tAATs14/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs14_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s8  ${data_dir}tAATs15/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs15_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s9  ${data_dir}tAATs16/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs16_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s10  ${data_dir}tAATs17/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs17_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s11  ${data_dir}tAATs18/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs18_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s12  ${data_dir}tAATs19/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs19_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s13  ${data_dir}tAATs20/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs20_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s14  ${data_dir}tAATs21/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs21_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s15  ${data_dir}tAATs22/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs22_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s16  ${data_dir}tAATs23/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs23_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s17  ${data_dir}tAATs24/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs24_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s18  ${data_dir}tAATs25/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs25_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s19  ${data_dir}tAATs26/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs26_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii \
s20  ${data_dir}tAATs27/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs27_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.noLC.nii
done
done

####################################### # Write out all voxs
for scan in Multi Single;
do
for roi in K1 LC;
do
for blur in 5;
do
for seed in 0 5;
do
    3dmaskdump -overwrite -noijk -o dump_full.${scan}.${roi}.b${blur}.s${seed}.txt -mask ${scan}.${roi}.b${blur}.s${seed}+tlrc ${scan}.${roi}.b${blur}.s${seed}+tlrc'[0]'
done
done
done
done

######################################## Write out ~top 15% of voxels (using union mask of two top 15% masks)

# Create thresholded masks
# M K b5s0
3dBrickStat -mask Multi.K1.b5.s0+tlrc -non-zero -percentile 0 1 100 Multi.K1.b5.s0+tlrc'[0]' > percentiles_M.K1.b5s0.1D
hold=`cat percentiles_M.K1.b5s0.1D`; perc=($hold); 3dcalc -overwrite -a Multi.K1.b5.s0+tlrc'[0]' -expr 'step(ispositive(a-'${perc[171]}'))' -prefix mask_p85_M.K1.b5s0.nii

# M K b5s5
3dBrickStat -mask Multi.K1.b5.s5+tlrc -non-zero -percentile 0 1 100 Multi.K1.b5.s5+tlrc'[0]' > percentiles_M.K1.b5s5.1D
hold=`cat percentiles_M.K1.b5s5.1D`; perc=($hold); 3dcalc -overwrite -a Multi.K1.b5.s5+tlrc'[0]' -expr 'step(ispositive(a-'${perc[171]}'))' -prefix mask_p85_M.K1.b5s5.nii

# M L b5s0
3dBrickStat -mask Multi.LC.b5.s0+tlrc -non-zero -percentile 0 1 100 Multi.LC.b5.s0+tlrc'[0]' > percentiles_M.LC.b5s0.1D
hold=`cat percentiles_M.LC.b5s0.1D`; perc=($hold); 3dcalc -overwrite -a Multi.LC.b5.s0+tlrc'[0]' -expr 'step(ispositive(a-'${perc[171]}'))' -prefix mask_p85_M.LC.b5s0.nii

# M L b5s5
3dBrickStat -mask Multi.LC.b5.s5+tlrc -non-zero -percentile 0 1 100 Multi.LC.b5.s5+tlrc'[0]' > percentiles_M.LC.b5s5.1D
hold=`cat percentiles_M.LC.b5s5.1D`; perc=($hold); 3dcalc -overwrite -a Multi.LC.b5.s5+tlrc'[0]' -expr 'step(ispositive(a-'${perc[171]}'))' -prefix mask_p85_M.LC.b5s5.nii

# S K b5s0
3dBrickStat -mask Single.K1.b5.s0+tlrc -non-zero -percentile 0 1 100 Single.K1.b5.s0+tlrc'[0]' > percentiles_S.K1.b5s0.1D
hold=`cat percentiles_S.K1.b5s0.1D`; perc=($hold); 3dcalc -overwrite -a Single.K1.b5.s0+tlrc'[0]' -expr 'step(ispositive(a-'${perc[171]}'))' -prefix mask_p85_S.K1.b5s0.nii

# S K b5s5
3dBrickStat -mask Single.K1.b5.s5+tlrc -non-zero -percentile 0 1 100 Single.K1.b5.s5+tlrc'[0]' > percentiles_S.K1.b5s5.1D
hold=`cat percentiles_S.K1.b5s5.1D`; perc=($hold); 3dcalc -overwrite -a Single.K1.b5.s5+tlrc'[0]' -expr 'step(ispositive(a-'${perc[171]}'))' -prefix mask_p85_S.K1.b5s5.nii

# S L b5s0
3dBrickStat -mask Single.LC.b5.s0+tlrc -non-zero -percentile 0 1 100 Single.LC.b5.s0+tlrc'[0]' > percentiles_S.LC.b5s0.1D
hold=`cat percentiles_S.LC.b5s0.1D`; perc=($hold); 3dcalc -overwrite -a Single.LC.b5.s0+tlrc'[0]' -expr 'step(ispositive(a-'${perc[171]}'))' -prefix mask_p85_S.LC.b5s0.nii

# S L b5s5
3dBrickStat -mask Single.LC.b5.s5+tlrc -non-zero -percentile 0 1 100 Single.LC.b5.s5+tlrc'[0]' > percentiles_S.LC.b5s5.1D
hold=`cat percentiles_S.LC.b5s5.1D`; perc=($hold); 3dcalc -overwrite -a Single.LC.b5.s5+tlrc'[0]' -expr 'step(ispositive(a-'${perc[171]}'))' -prefix mask_p85_S.LC.b5s5.nii


# Create union masks for all comparisons and write out maps
### Single vs Multi echo
# SK50, MK50
3dmask_tool -overwrite -union -prefix mask.SK50_MK50.nii -inputs mask_p85_S.K1.b5s0.nii mask_p85_M.K1.b5s0.nii
3dmaskdump -overwrite -noijk -o dump_p85.SK50_MK50.SK50.txt -mask mask.SK50_MK50.nii Single.K1.b5.s0+tlrc'[0]'
3dmaskdump -overwrite -noijk -o dump_p85.SK50_MK50.MK50.txt -mask mask.SK50_MK50.nii Multi.K1.b5.s0+tlrc'[0]'

# SK55, MK55
3dmask_tool -overwrite -union -prefix mask.SK55_MK55.nii -inputs mask_p85_S.K1.b5s5.nii mask_p85_M.K1.b5s5.nii
3dmaskdump -overwrite -noijk -o dump_p85.SK55_MK55.SK55.txt -mask mask.SK55_MK55.nii Single.K1.b5.s5+tlrc'[0]'
3dmaskdump -overwrite -noijk -o dump_p85.SK55_MK55.MK55.txt -mask mask.SK55_MK55.nii Multi.K1.b5.s5+tlrc'[0]'

# SL50, ML50
3dmask_tool -overwrite -union -prefix mask.SL50_ML50.nii -inputs mask_p85_S.LC.b5s0.nii mask_p85_M.LC.b5s0.nii
3dmaskdump -overwrite -noijk -o dump_p85.SL50_ML50.SL50.txt -mask mask.SL50_ML50.nii Single.LC.b5.s0+tlrc'[0]'
3dmaskdump -overwrite -noijk -o dump_p85.SL50_ML50.ML50.txt -mask mask.SL50_ML50.nii Multi.LC.b5.s0+tlrc'[0]'

# SL55, ML55
3dmask_tool -overwrite -union -prefix mask.SL55_ML55.nii -inputs mask_p85_S.LC.b5s5.nii mask_p85_M.LC.b5s5.nii
3dmaskdump -overwrite -noijk -o dump_p85.SL55_ML55.SL55.txt -mask mask.SL55_ML55.nii Single.LC.b5.s5+tlrc'[0]'
3dmaskdump -overwrite -noijk -o dump_p85.SL55_ML55.ML55.txt -mask mask.SL55_ML55.nii Multi.LC.b5.s5+tlrc'[0]'

### Unblurred vs Blurred
# MK50, MK55
3dmask_tool -overwrite -union -prefix mask.MK50_MK55.nii -inputs mask_p85_M.K1.b5s0.nii mask_p85_M.K1.b5s5.nii
3dmaskdump -overwrite -noijk -o dump_p85.MK50_MK55.MK50.txt -mask mask.MK50_MK55.nii Multi.K1.b5.s0+tlrc'[0]'
3dmaskdump -overwrite -noijk -o dump_p85.MK50_MK55.MK55.txt -mask mask.MK50_MK55.nii Multi.K1.b5.s5+tlrc'[0]'

# SK50, SK55
3dmask_tool -overwrite -union -prefix mask.SK50_SK55.nii -inputs mask_p85_S.K1.b5s0.nii mask_p85_S.K1.b5s5.nii
3dmaskdump -overwrite -noijk -o dump_p85.SK50_SK55.SK50.txt -mask mask.SK50_SK55.nii Single.K1.b5.s0+tlrc'[0]'
3dmaskdump -overwrite -noijk -o dump_p85.SK50_SK55.SK55.txt -mask mask.SK50_SK55.nii Single.K1.b5.s5+tlrc'[0]'

# ML50, ML55
3dmask_tool -overwrite -union -prefix mask.ML50_ML55.nii -inputs mask_p85_M.LC.b5s0.nii mask_p85_M.LC.b5s5.nii
3dmaskdump -overwrite -noijk -o dump_p85.ML50_ML55.ML50.txt -mask mask.ML50_ML55.nii Multi.LC.b5.s0+tlrc'[0]'
3dmaskdump -overwrite -noijk -o dump_p85.ML50_ML55.ML55.txt -mask mask.ML50_ML55.nii Multi.LC.b5.s5+tlrc'[0]'

# SL50, SL55
3dmask_tool -overwrite -union -prefix mask.SL50_SL55.nii -inputs mask_p85_S.LC.b5s0.nii mask_p85_S.LC.b5s5.nii
3dmaskdump -overwrite -noijk -o dump_p85.SL50_SL55.SL50.txt -mask mask.SL50_SL55.nii Single.LC.b5.s0+tlrc'[0]'
3dmaskdump -overwrite -noijk -o dump_p85.SL50_SL55.SL55.txt -mask mask.SL50_SL55.nii Single.LC.b5.s5+tlrc'[0]'

### K1 vs traced LC
# ML50, MK50
3dmask_tool -overwrite -union -prefix mask.ML50_MK50.nii -inputs mask_p85_M.LC.b5s0.nii mask_p85_M.K1.b5s0.nii
3dmaskdump -overwrite -noijk -o dump_p85.ML50_MK50.ML50.txt -mask mask.ML50_MK50.nii Multi.LC.b5.s0+tlrc'[0]'
3dmaskdump -overwrite -noijk -o dump_p85.ML50_MK50.MK50.txt -mask mask.ML50_MK50.nii Multi.K1.b5.s0+tlrc'[0]'

# ML55, MK55
3dmask_tool -overwrite -union -prefix mask.ML55_MK55.nii -inputs mask_p85_M.LC.b5s5.nii mask_p85_M.K1.b5s5.nii
3dmaskdump -overwrite -noijk -o dump_p85.ML55_MK55.ML55.txt -mask mask.ML55_MK55.nii Multi.LC.b5.s5+tlrc'[0]'
3dmaskdump -overwrite -noijk -o dump_p85.ML55_MK55.MK55.txt -mask mask.ML55_MK55.nii Multi.K1.b5.s5+tlrc'[0]'

# SL50, SK50
3dmask_tool -overwrite -union -prefix mask.SL50_SK50.nii -inputs mask_p85_S.LC.b5s0.nii mask_p85_S.K1.b5s0.nii
3dmaskdump -overwrite -noijk -o dump_p85.SL50_SK50.SL50.txt -mask mask.SL50_SK50.nii Single.LC.b5.s0+tlrc'[0]'
3dmaskdump -overwrite -noijk -o dump_p85.SL50_SK50.SK50.txt -mask mask.SL50_SK50.nii Single.K1.b5.s0+tlrc'[0]'

# SL55, SK55
3dmask_tool -overwrite -union -prefix mask.SL55_SK55.nii -inputs mask_p85_S.LC.b5s5.nii mask_p85_S.K1.b5s5.nii
3dmaskdump -overwrite -noijk -o dump_p85.SL55_SK55.SL55.txt -mask mask.SL55_SK55.nii Single.LC.b5.s5+tlrc'[0]'
3dmaskdump -overwrite -noijk -o dump_p85.SL55_SK55.SK55.txt -mask mask.SL55_SK55.nii Single.K1.b5.s5+tlrc'[0]'

echo   "++++++++++++++++++++++++"
echo   "Housekeeping"
cd ../../final_scripts

end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end





