# March 2019 by HBT
# =========================== Setup ============================

######################################################################## With LC included in MPRAGE space
mkdir ../analysis/twosamp_wm1_gsr0/
cd ../analysis/twosamp_wm1_gsr0/
data_dir=/home/fMRI/projects/tempAttnAudT/analysis/univariate/rest_results/
afni_dir=/usr/lib/afni/bin/

wm=1
gsr=0
cenmode=NTRP



# ME LC vs SE LC
label=ML50_SL50
mask=${data_dir}tAATs7/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs7_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii
3dttest++ -prefix $label -mask $mask -dupe_ok -ClustSim -prefix_clustsim $label \
-setA 'ML50' \
s1  ${data_dir}tAATs7/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs7_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s2  ${data_dir}tAATs9/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs9_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s3  ${data_dir}tAATs10/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs10_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s4  ${data_dir}tAATs11/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs11_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s5  ${data_dir}tAATs12/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs12_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s6  ${data_dir}tAATs13/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs13_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s7  ${data_dir}tAATs14/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs14_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s8  ${data_dir}tAATs15/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs15_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s9  ${data_dir}tAATs16/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs16_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s10  ${data_dir}tAATs17/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs17_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s11  ${data_dir}tAATs18/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs18_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s12  ${data_dir}tAATs19/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs19_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s13  ${data_dir}tAATs20/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs20_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s14  ${data_dir}tAATs21/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs21_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s15  ${data_dir}tAATs22/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs22_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s16  ${data_dir}tAATs23/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs23_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s17  ${data_dir}tAATs24/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs24_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s18  ${data_dir}tAATs25/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs25_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s19  ${data_dir}tAATs26/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs26_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s20  ${data_dir}tAATs27/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs27_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
-setB 'SL50' \
s1  ${data_dir}tAATs7/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs7_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s2  ${data_dir}tAATs9/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs9_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s3  ${data_dir}tAATs10/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs10_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s4  ${data_dir}tAATs11/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs11_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s5  ${data_dir}tAATs12/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs12_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s6  ${data_dir}tAATs13/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs13_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s7  ${data_dir}tAATs14/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs14_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s8  ${data_dir}tAATs15/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs15_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s9  ${data_dir}tAATs16/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs16_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s10  ${data_dir}tAATs17/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs17_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s11  ${data_dir}tAATs18/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs18_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s12  ${data_dir}tAATs19/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs19_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s13  ${data_dir}tAATs20/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs20_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s14  ${data_dir}tAATs21/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs21_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s15  ${data_dir}tAATs22/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs22_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s16  ${data_dir}tAATs23/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs23_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s17  ${data_dir}tAATs24/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs24_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s18  ${data_dir}tAATs25/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs25_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s19  ${data_dir}tAATs26/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs26_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s20  ${data_dir}tAATs27/SE/fcon/ZTcorr1D_LCoverlap.rest.tAATs27_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii



# ME LC vs ME LC b5
label=ML50_ML55
mask=${data_dir}tAATs7/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs7_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii
3dttest++ -prefix $label -mask $mask -dupe_ok -ClustSim -prefix_clustsim $label \
-setA 'ML50' \
s1  ${data_dir}tAATs7/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs7_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s2  ${data_dir}tAATs9/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs9_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s3  ${data_dir}tAATs10/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs10_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s4  ${data_dir}tAATs11/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs11_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s5  ${data_dir}tAATs12/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs12_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s6  ${data_dir}tAATs13/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs13_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s7  ${data_dir}tAATs14/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs14_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s8  ${data_dir}tAATs15/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs15_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s9  ${data_dir}tAATs16/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs16_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s10  ${data_dir}tAATs17/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs17_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s11  ${data_dir}tAATs18/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs18_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s12  ${data_dir}tAATs19/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs19_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s13  ${data_dir}tAATs20/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs20_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s14  ${data_dir}tAATs21/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs21_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s15  ${data_dir}tAATs22/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs22_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s16  ${data_dir}tAATs23/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs23_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s17  ${data_dir}tAATs24/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs24_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s18  ${data_dir}tAATs25/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs25_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s19  ${data_dir}tAATs26/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs26_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s20  ${data_dir}tAATs27/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs27_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
-setB 'ML55' \
s1  ${data_dir}tAATs7/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs7_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s2  ${data_dir}tAATs9/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs9_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s3  ${data_dir}tAATs10/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs10_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s4  ${data_dir}tAATs11/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs11_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s5  ${data_dir}tAATs12/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs12_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s6  ${data_dir}tAATs13/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs13_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s7  ${data_dir}tAATs14/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs14_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s8  ${data_dir}tAATs15/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs15_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s9  ${data_dir}tAATs16/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs16_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s10  ${data_dir}tAATs17/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs17_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s11  ${data_dir}tAATs18/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs18_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s12  ${data_dir}tAATs19/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs19_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s13  ${data_dir}tAATs20/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs20_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s14  ${data_dir}tAATs21/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs21_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s15  ${data_dir}tAATs22/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs22_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s16  ${data_dir}tAATs23/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs23_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s17  ${data_dir}tAATs24/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs24_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s18  ${data_dir}tAATs25/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs25_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s19  ${data_dir}tAATs26/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs26_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s20  ${data_dir}tAATs27/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs27_nat_b5.s5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii

# ME LC vs ME K1
label=ML50_MK50
mask=${data_dir}tAATs7/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs7_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii
3dttest++ -prefix $label -mask $mask -dupe_ok -ClustSim -prefix_clustsim $label \
-setA 'ML50' \
s1  ${data_dir}tAATs7/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs7_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s2  ${data_dir}tAATs9/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs9_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s3  ${data_dir}tAATs10/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs10_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s4  ${data_dir}tAATs11/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs11_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s5  ${data_dir}tAATs12/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs12_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s6  ${data_dir}tAATs13/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs13_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s7  ${data_dir}tAATs14/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs14_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s8  ${data_dir}tAATs15/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs15_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s9  ${data_dir}tAATs16/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs16_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s10  ${data_dir}tAATs17/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs17_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s11  ${data_dir}tAATs18/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs18_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s12  ${data_dir}tAATs19/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs19_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s13  ${data_dir}tAATs20/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs20_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s14  ${data_dir}tAATs21/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs21_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s15  ${data_dir}tAATs22/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs22_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s16  ${data_dir}tAATs23/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs23_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s17  ${data_dir}tAATs24/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs24_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s18  ${data_dir}tAATs25/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs25_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s19  ${data_dir}tAATs26/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs26_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s20  ${data_dir}tAATs27/ME/fcon/ZTcorr1D_LCoverlap.rest.tAATs27_nat_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
-setB 'MK50' \
s1  ${data_dir}tAATs7/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs7_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s2  ${data_dir}tAATs9/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs9_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s3  ${data_dir}tAATs10/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs10_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s4  ${data_dir}tAATs11/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs11_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s5  ${data_dir}tAATs12/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs12_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s6  ${data_dir}tAATs13/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs13_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s7  ${data_dir}tAATs14/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs14_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s8  ${data_dir}tAATs15/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs15_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s9  ${data_dir}tAATs16/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs16_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s10  ${data_dir}tAATs17/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs17_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s11  ${data_dir}tAATs18/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs18_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s12  ${data_dir}tAATs19/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs19_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s13  ${data_dir}tAATs20/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs20_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s14  ${data_dir}tAATs21/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs21_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s15  ${data_dir}tAATs22/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs22_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s16  ${data_dir}tAATs23/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs23_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s17  ${data_dir}tAATs24/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs24_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s18  ${data_dir}tAATs25/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs25_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s19  ${data_dir}tAATs26/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs26_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii \
s20  ${data_dir}tAATs27/ME/fcon/ZTcorr1D_Keren1SD.rest.tAATs27_mni_b5.s0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.nii

#######################################


