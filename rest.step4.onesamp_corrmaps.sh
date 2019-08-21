# March 2019 by HBT
# =========================== Setup ============================

######################################################################## With LC included in MPRAGE space
mkdir ../analysis/onesamp_wm1_gsr0/
cd ../analysis/onesamp_wm1_gsr0/
data_dir=/home/fMRI/projects/tempAttnAudT/analysis/univariate/rest_results/
afni_dir=/usr/lib/afni/bin/

wm=0
gsr=0
cenmode=NTRP

# Multi echo Keren
for keren in 1;
do
for blur in 5; # Blur of the base dataset
do
for seed in 0; # Blur of the seed
do
ROI_a=Keren${keren}SD
label=Multi.K${keren}.b$blur.s$seed
mask=${data_dir}tAATs7/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs7_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii
3dttest++ -prefix $label -mask $mask -dupe_ok -ClustSim -prefix_clustsim $label \
-setA 'Keren' \
s1  ${data_dir}tAATs7/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs7_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s2  ${data_dir}tAATs9/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs9_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s3  ${data_dir}tAATs10/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs10_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s4  ${data_dir}tAATs11/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs11_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s5  ${data_dir}tAATs12/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs12_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s6  ${data_dir}tAATs13/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs13_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s7  ${data_dir}tAATs14/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs14_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s8  ${data_dir}tAATs15/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs15_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s9  ${data_dir}tAATs16/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs16_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s10  ${data_dir}tAATs17/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs17_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s11  ${data_dir}tAATs18/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs18_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s12  ${data_dir}tAATs19/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs19_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s13  ${data_dir}tAATs20/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs20_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s14  ${data_dir}tAATs21/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs21_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s15  ${data_dir}tAATs22/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs22_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s16  ${data_dir}tAATs23/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs23_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s17  ${data_dir}tAATs24/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs24_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s18  ${data_dir}tAATs25/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs25_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s19  ${data_dir}tAATs26/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs26_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s20  ${data_dir}tAATs27/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs27_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii
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
mask=${data_dir}tAATs7/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs7_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii
3dttest++ -prefix $label -mask $mask -dupe_ok -ClustSim -prefix_clustsim $label \
-setA 'LC' \
s1  ${data_dir}tAATs7/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs7_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s2  ${data_dir}tAATs9/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs9_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s3  ${data_dir}tAATs10/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs10_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s4  ${data_dir}tAATs11/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs11_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s5  ${data_dir}tAATs12/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs12_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s6  ${data_dir}tAATs13/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs13_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s7  ${data_dir}tAATs14/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs14_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s8  ${data_dir}tAATs15/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs15_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s9  ${data_dir}tAATs16/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs16_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s10  ${data_dir}tAATs17/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs17_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s11  ${data_dir}tAATs18/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs18_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s12  ${data_dir}tAATs19/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs19_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s13  ${data_dir}tAATs20/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs20_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s14  ${data_dir}tAATs21/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs21_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s15  ${data_dir}tAATs22/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs22_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s16  ${data_dir}tAATs23/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs23_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s17  ${data_dir}tAATs24/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs24_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s18  ${data_dir}tAATs25/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs25_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s19  ${data_dir}tAATs26/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs26_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s20  ${data_dir}tAATs27/ME/fcon/ZTcorr1D_${ROI_a}.rest.tAATs27_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii
done
done

# Single echo Keren
for keren in 1;
do
for blur in 5; # Blur of the base dataset
do
for seed in 0; # Blur of the seed
do
ROI_a=Keren${keren}SD
label=Single.K${keren}.b$blur.s$seed
mask=${data_dir}tAATs7/SE/fcon/ZTcorr1D_Keren1SD.rest.tAATs7_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii
3dttest++ -prefix $label -mask $mask -dupe_ok -ClustSim -prefix_clustsim $label \
-setA 'Keren' \
s1  ${data_dir}tAATs7/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs7_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s2  ${data_dir}tAATs9/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs9_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s3  ${data_dir}tAATs10/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs10_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s4  ${data_dir}tAATs11/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs11_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s5  ${data_dir}tAATs12/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs12_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s6  ${data_dir}tAATs13/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs13_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s7  ${data_dir}tAATs14/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs14_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s8  ${data_dir}tAATs15/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs15_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s9  ${data_dir}tAATs16/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs16_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s10  ${data_dir}tAATs17/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs17_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s11  ${data_dir}tAATs18/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs18_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s12  ${data_dir}tAATs19/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs19_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s13  ${data_dir}tAATs20/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs20_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s14  ${data_dir}tAATs21/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs21_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s15  ${data_dir}tAATs22/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs22_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s16  ${data_dir}tAATs23/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs23_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s17  ${data_dir}tAATs24/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs24_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s18  ${data_dir}tAATs25/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs25_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s19  ${data_dir}tAATs26/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs26_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s20  ${data_dir}tAATs27/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs27_mni_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii
done
done
done

# Single echo traced LC
for blur in 5; # Blur of the base dataset
do
for seed in 0; # Blur of the seed
do
ROI_a=LCoverlap
label=Single.LC.b$blur.s$seed
mask=${data_dir}tAATs7/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs7_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii
3dttest++ -prefix $label -mask $mask -dupe_ok -ClustSim -prefix_clustsim $label \
-setA 'LC' \
s1  ${data_dir}tAATs7/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs7_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s2  ${data_dir}tAATs9/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs9_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s3  ${data_dir}tAATs10/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs10_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s4  ${data_dir}tAATs11/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs11_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s5  ${data_dir}tAATs12/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs12_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s6  ${data_dir}tAATs13/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs13_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s7  ${data_dir}tAATs14/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs14_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s8  ${data_dir}tAATs15/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs15_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s9  ${data_dir}tAATs16/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs16_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s10  ${data_dir}tAATs17/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs17_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s11  ${data_dir}tAATs18/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs18_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s12  ${data_dir}tAATs19/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs19_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s13  ${data_dir}tAATs20/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs20_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s14  ${data_dir}tAATs21/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs21_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s15  ${data_dir}tAATs22/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs22_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s16  ${data_dir}tAATs23/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs23_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s17  ${data_dir}tAATs24/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs24_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s18  ${data_dir}tAATs25/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs25_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s19  ${data_dir}tAATs26/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs26_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s20  ${data_dir}tAATs27/SE/fcon/ZTcorr1D_${ROI_a}.rest.tAATs27_nat_b${blur}.s${seed}.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii
done
done

#######################################


