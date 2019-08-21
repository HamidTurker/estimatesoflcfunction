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

mkdir $rest_dir/Overlap
cd $rest_dir/Overlap

# =========================== get overlap information ============================

3dAllineate -overwrite -final NN -NN -float -1Dmatrix_apply $rest_dir/ME/transform_deob_epi2mni.1D -input $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_nat.frac.nii -master $rest_dir/abtemplate.nii.gz -mast_dxyz 3 -prefix $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_mni.frac.nii
cp ${base_dir}analysis/tse/heatmap/LC_ROI_overlap_inMNI_${subj_name}.nii $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_mni.nii


########################## Multi Keren
# M K b0s0
#3dcalc -a $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b0.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/ME/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_M.K1.b0s0.nii
#3dBrickStat -mask mask_M.K1.b0s0.nii -non-zero -percentile 0 1 100 $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b0.s0.no_derivs.no_GSR.frac.nii > percentiles_M.K1.b0s0.1D
#hold=`cat percentiles_M.K1.b0s0.1D`; perc=($hold);
#M_Kb0s0_p0=${perc[1]}; M_Kb0s0_p1=${perc[3]}; M_Kb0s0_p2=${perc[5]}; M_Kb0s0_p3=${perc[7]}; M_Kb0s0_p4=${perc[9]}; M_Kb0s0_p5=${perc[11]}; M_Kb0s0_p6=${perc[13]}; M_Kb0s0_p7=${perc[15]}; M_Kb0s0_p8=${perc[17]}; M_Kb0s0_p9=${perc[19]}; M_Kb0s0_p10=${perc[21]};
#M_Kb0s0_p11=${perc[23]}; M_Kb0s0_p12=${perc[25]}; M_Kb0s0_p13=${perc[27]}; M_Kb0s0_p14=${perc[29]}; M_Kb0s0_p15=${perc[31]}; M_Kb0s0_p16=${perc[33]}; M_Kb0s0_p17=${perc[35]}; M_Kb0s0_p18=${perc[37]}; M_Kb0s0_p19=${perc[39]}; M_Kb0s0_p20=${perc[41]};
#M_Kb0s0_p21=${perc[43]}; M_Kb0s0_p22=${perc[45]}; M_Kb0s0_p23=${perc[47]}; M_Kb0s0_p24=${perc[49]}; M_Kb0s0_p25=${perc[51]}; M_Kb0s0_p26=${perc[53]}; M_Kb0s0_p27=${perc[55]}; M_Kb0s0_p28=${perc[57]}; M_Kb0s0_p29=${perc[59]}; M_Kb0s0_p30=${perc[61]};
#M_Kb0s0_p31=${perc[63]}; M_Kb0s0_p32=${perc[65]}; M_Kb0s0_p33=${perc[67]}; M_Kb0s0_p34=${perc[69]}; M_Kb0s0_p35=${perc[71]}; M_Kb0s0_p36=${perc[73]}; M_Kb0s0_p37=${perc[75]}; M_Kb0s0_p38=${perc[77]}; M_Kb0s0_p39=${perc[79]}; M_Kb0s0_p40=${perc[81]};
#M_Kb0s0_p41=${perc[83]}; M_Kb0s0_p42=${perc[85]}; M_Kb0s0_p43=${perc[87]}; M_Kb0s0_p44=${perc[89]}; M_Kb0s0_p45=${perc[91]}; M_Kb0s0_p46=${perc[93]}; M_Kb0s0_p47=${perc[95]}; M_Kb0s0_p48=${perc[97]}; M_Kb0s0_p49=${perc[99]}; M_Kb0s0_p50=${perc[101]};
#M_Kb0s0_p51=${perc[103]}; M_Kb0s0_p52=${perc[105]}; M_Kb0s0_p53=${perc[107]}; M_Kb0s0_p54=${perc[109]}; M_Kb0s0_p55=${perc[111]}; M_Kb0s0_p56=${perc[113]}; M_Kb0s0_p57=${perc[115]}; M_Kb0s0_p58=${perc[117]}; M_Kb0s0_p59=${perc[119]}; M_Kb0s0_p60=${perc[121]};
#M_Kb0s0_p61=${perc[123]}; M_Kb0s0_p62=${perc[125]}; M_Kb0s0_p63=${perc[127]}; M_Kb0s0_p64=${perc[129]}; M_Kb0s0_p65=${perc[131]}; M_Kb0s0_p66=${perc[133]}; M_Kb0s0_p67=${perc[135]}; M_Kb0s0_p68=${perc[137]}; M_Kb0s0_p69=${perc[139]}; M_Kb0s0_p70=${perc[141]};
#M_Kb0s0_p71=${perc[143]}; M_Kb0s0_p72=${perc[145]}; M_Kb0s0_p73=${perc[147]}; M_Kb0s0_p74=${perc[149]}; M_Kb0s0_p75=${perc[151]}; M_Kb0s0_p76=${perc[153]}; M_Kb0s0_p77=${perc[155]}; M_Kb0s0_p78=${perc[157]}; M_Kb0s0_p79=${perc[159]}; M_Kb0s0_p80=${perc[161]};
#M_Kb0s0_p81=${perc[163]}; M_Kb0s0_p82=${perc[165]}; M_Kb0s0_p83=${perc[167]}; M_Kb0s0_p84=${perc[169]}; M_Kb0s0_p85=${perc[171]}; M_Kb0s0_p86=${perc[173]}; M_Kb0s0_p87=${perc[175]}; M_Kb0s0_p88=${perc[177]}; M_Kb0s0_p89=${perc[179]}; M_Kb0s0_p90=${perc[181]};
#M_Kb0s0_p91=${perc[183]}; M_Kb0s0_p92=${perc[185]}; M_Kb0s0_p93=${perc[187]}; M_Kb0s0_p94=${perc[189]}; M_Kb0s0_p95=${perc[191]}; M_Kb0s0_p96=${perc[193]}; M_Kb0s0_p97=${perc[195]}; M_Kb0s0_p98=${perc[197]}; M_Kb0s0_p99=${perc[199]}; M_Kb0s0_p100=${perc[201]};

# M K b0s5
#3dcalc -a $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b0.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/ME/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_M.K1.b0s5.nii
#3dBrickStat -mask mask_M.K1.b0s5.nii -non-zero -percentile 0 1 100 $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b0.s5.no_derivs.no_GSR.frac.nii > percentiles_M.K1.b0s5.1D
#hold=`cat percentiles_M.K1.b0s5.1D`; perc=($hold);
#M_Kb0s5_p0=${perc[1]}; M_Kb0s5_p1=${perc[3]}; M_Kb0s5_p2=${perc[5]}; M_Kb0s5_p3=${perc[7]}; M_Kb0s5_p4=${perc[9]}; M_Kb0s5_p5=${perc[11]}; M_Kb0s5_p6=${perc[13]}; M_Kb0s5_p7=${perc[15]}; M_Kb0s5_p8=${perc[17]}; M_Kb0s5_p9=${perc[19]}; M_Kb0s5_p10=${perc[21]};
#M_Kb0s5_p11=${perc[23]}; M_Kb0s5_p12=${perc[25]}; M_Kb0s5_p13=${perc[27]}; M_Kb0s5_p14=${perc[29]}; M_Kb0s5_p15=${perc[31]}; M_Kb0s5_p16=${perc[33]}; M_Kb0s5_p17=${perc[35]}; M_Kb0s5_p18=${perc[37]}; M_Kb0s5_p19=${perc[39]}; M_Kb0s5_p20=${perc[41]};
#M_Kb0s5_p21=${perc[43]}; M_Kb0s5_p22=${perc[45]}; M_Kb0s5_p23=${perc[47]}; M_Kb0s5_p24=${perc[49]}; M_Kb0s5_p25=${perc[51]}; M_Kb0s5_p26=${perc[53]}; M_Kb0s5_p27=${perc[55]}; M_Kb0s5_p28=${perc[57]}; M_Kb0s5_p29=${perc[59]}; M_Kb0s5_p30=${perc[61]};
#M_Kb0s5_p31=${perc[63]}; M_Kb0s5_p32=${perc[65]}; M_Kb0s5_p33=${perc[67]}; M_Kb0s5_p34=${perc[69]}; M_Kb0s5_p35=${perc[71]}; M_Kb0s5_p36=${perc[73]}; M_Kb0s5_p37=${perc[75]}; M_Kb0s5_p38=${perc[77]}; M_Kb0s5_p39=${perc[79]}; M_Kb0s5_p40=${perc[81]};
#M_Kb0s5_p41=${perc[83]}; M_Kb0s5_p42=${perc[85]}; M_Kb0s5_p43=${perc[87]}; M_Kb0s5_p44=${perc[89]}; M_Kb0s5_p45=${perc[91]}; M_Kb0s5_p46=${perc[93]}; M_Kb0s5_p47=${perc[95]}; M_Kb0s5_p48=${perc[97]}; M_Kb0s5_p49=${perc[99]}; M_Kb0s5_p50=${perc[101]};
#M_Kb0s5_p51=${perc[103]}; M_Kb0s5_p52=${perc[105]}; M_Kb0s5_p53=${perc[107]}; M_Kb0s5_p54=${perc[109]}; M_Kb0s5_p55=${perc[111]}; M_Kb0s5_p56=${perc[113]}; M_Kb0s5_p57=${perc[115]}; M_Kb0s5_p58=${perc[117]}; M_Kb0s5_p59=${perc[119]}; M_Kb0s5_p60=${perc[121]};
#M_Kb0s5_p61=${perc[123]}; M_Kb0s5_p62=${perc[125]}; M_Kb0s5_p63=${perc[127]}; M_Kb0s5_p64=${perc[129]}; M_Kb0s5_p65=${perc[131]}; M_Kb0s5_p66=${perc[133]}; M_Kb0s5_p67=${perc[135]}; M_Kb0s5_p68=${perc[137]}; M_Kb0s5_p69=${perc[139]}; M_Kb0s5_p70=${perc[141]};
#M_Kb0s5_p71=${perc[143]}; M_Kb0s5_p72=${perc[145]}; M_Kb0s5_p73=${perc[147]}; M_Kb0s5_p74=${perc[149]}; M_Kb0s5_p75=${perc[151]}; M_Kb0s5_p76=${perc[153]}; M_Kb0s5_p77=${perc[155]}; M_Kb0s5_p78=${perc[157]}; M_Kb0s5_p79=${perc[159]}; M_Kb0s5_p80=${perc[161]};
#M_Kb0s5_p81=${perc[163]}; M_Kb0s5_p82=${perc[165]}; M_Kb0s5_p83=${perc[167]}; M_Kb0s5_p84=${perc[169]}; M_Kb0s5_p85=${perc[171]}; M_Kb0s5_p86=${perc[173]}; M_Kb0s5_p87=${perc[175]}; M_Kb0s5_p88=${perc[177]}; M_Kb0s5_p89=${perc[179]}; M_Kb0s5_p90=${perc[181]};
#M_Kb0s5_p91=${perc[183]}; M_Kb0s5_p92=${perc[185]}; M_Kb0s5_p93=${perc[187]}; M_Kb0s5_p94=${perc[189]}; M_Kb0s5_p95=${perc[191]}; M_Kb0s5_p96=${perc[193]}; M_Kb0s5_p97=${perc[195]}; M_Kb0s5_p98=${perc[197]}; M_Kb0s5_p99=${perc[199]}; M_Kb0s5_p100=${perc[201]};

# M K b5s0
3dcalc -a $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/ME/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_M.K1.b5s0.nii
3dBrickStat -mask mask_M.K1.b5s0.nii -non-zero -percentile 0 1 100 $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_M.K1.b5s0.1D
hold=`cat percentiles_M.K1.b5s0.1D`; perc=($hold);
M_Kb5s0_p0=${perc[1]}; M_Kb5s0_p1=${perc[3]}; M_Kb5s0_p2=${perc[5]}; M_Kb5s0_p3=${perc[7]}; M_Kb5s0_p4=${perc[9]}; M_Kb5s0_p5=${perc[11]}; M_Kb5s0_p6=${perc[13]}; M_Kb5s0_p7=${perc[15]}; M_Kb5s0_p8=${perc[17]}; M_Kb5s0_p9=${perc[19]}; M_Kb5s0_p10=${perc[21]};
M_Kb5s0_p11=${perc[23]}; M_Kb5s0_p12=${perc[25]}; M_Kb5s0_p13=${perc[27]}; M_Kb5s0_p14=${perc[29]}; M_Kb5s0_p15=${perc[31]}; M_Kb5s0_p16=${perc[33]}; M_Kb5s0_p17=${perc[35]}; M_Kb5s0_p18=${perc[37]}; M_Kb5s0_p19=${perc[39]}; M_Kb5s0_p20=${perc[41]};
M_Kb5s0_p21=${perc[43]}; M_Kb5s0_p22=${perc[45]}; M_Kb5s0_p23=${perc[47]}; M_Kb5s0_p24=${perc[49]}; M_Kb5s0_p25=${perc[51]}; M_Kb5s0_p26=${perc[53]}; M_Kb5s0_p27=${perc[55]}; M_Kb5s0_p28=${perc[57]}; M_Kb5s0_p29=${perc[59]}; M_Kb5s0_p30=${perc[61]};
M_Kb5s0_p31=${perc[63]}; M_Kb5s0_p32=${perc[65]}; M_Kb5s0_p33=${perc[67]}; M_Kb5s0_p34=${perc[69]}; M_Kb5s0_p35=${perc[71]}; M_Kb5s0_p36=${perc[73]}; M_Kb5s0_p37=${perc[75]}; M_Kb5s0_p38=${perc[77]}; M_Kb5s0_p39=${perc[79]}; M_Kb5s0_p40=${perc[81]};
M_Kb5s0_p41=${perc[83]}; M_Kb5s0_p42=${perc[85]}; M_Kb5s0_p43=${perc[87]}; M_Kb5s0_p44=${perc[89]}; M_Kb5s0_p45=${perc[91]}; M_Kb5s0_p46=${perc[93]}; M_Kb5s0_p47=${perc[95]}; M_Kb5s0_p48=${perc[97]}; M_Kb5s0_p49=${perc[99]}; M_Kb5s0_p50=${perc[101]};
M_Kb5s0_p51=${perc[103]}; M_Kb5s0_p52=${perc[105]}; M_Kb5s0_p53=${perc[107]}; M_Kb5s0_p54=${perc[109]}; M_Kb5s0_p55=${perc[111]}; M_Kb5s0_p56=${perc[113]}; M_Kb5s0_p57=${perc[115]}; M_Kb5s0_p58=${perc[117]}; M_Kb5s0_p59=${perc[119]}; M_Kb5s0_p60=${perc[121]};
M_Kb5s0_p61=${perc[123]}; M_Kb5s0_p62=${perc[125]}; M_Kb5s0_p63=${perc[127]}; M_Kb5s0_p64=${perc[129]}; M_Kb5s0_p65=${perc[131]}; M_Kb5s0_p66=${perc[133]}; M_Kb5s0_p67=${perc[135]}; M_Kb5s0_p68=${perc[137]}; M_Kb5s0_p69=${perc[139]}; M_Kb5s0_p70=${perc[141]};
M_Kb5s0_p71=${perc[143]}; M_Kb5s0_p72=${perc[145]}; M_Kb5s0_p73=${perc[147]}; M_Kb5s0_p74=${perc[149]}; M_Kb5s0_p75=${perc[151]}; M_Kb5s0_p76=${perc[153]}; M_Kb5s0_p77=${perc[155]}; M_Kb5s0_p78=${perc[157]}; M_Kb5s0_p79=${perc[159]}; M_Kb5s0_p80=${perc[161]};
M_Kb5s0_p81=${perc[163]}; M_Kb5s0_p82=${perc[165]}; M_Kb5s0_p83=${perc[167]}; M_Kb5s0_p84=${perc[169]}; M_Kb5s0_p85=${perc[171]}; M_Kb5s0_p86=${perc[173]}; M_Kb5s0_p87=${perc[175]}; M_Kb5s0_p88=${perc[177]}; M_Kb5s0_p89=${perc[179]}; M_Kb5s0_p90=${perc[181]};
M_Kb5s0_p91=${perc[183]}; M_Kb5s0_p92=${perc[185]}; M_Kb5s0_p93=${perc[187]}; M_Kb5s0_p94=${perc[189]}; M_Kb5s0_p95=${perc[191]}; M_Kb5s0_p96=${perc[193]}; M_Kb5s0_p97=${perc[195]}; M_Kb5s0_p98=${perc[197]}; M_Kb5s0_p99=${perc[199]}; M_Kb5s0_p100=${perc[201]};

# M K b5s5
3dcalc -a $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/ME/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_M.K1.b5s5.nii
3dBrickStat -mask mask_M.K1.b5s5.nii -non-zero -percentile 0 1 100 $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_M.K1.b5s5.1D
hold=`cat percentiles_M.K1.b5s5.1D`; perc=($hold);
M_Kb5s5_p0=${perc[1]}; M_Kb5s5_p1=${perc[3]}; M_Kb5s5_p2=${perc[5]}; M_Kb5s5_p3=${perc[7]}; M_Kb5s5_p4=${perc[9]}; M_Kb5s5_p5=${perc[11]}; M_Kb5s5_p6=${perc[13]}; M_Kb5s5_p7=${perc[15]}; M_Kb5s5_p8=${perc[17]}; M_Kb5s5_p9=${perc[19]}; M_Kb5s5_p10=${perc[21]};
M_Kb5s5_p11=${perc[23]}; M_Kb5s5_p12=${perc[25]}; M_Kb5s5_p13=${perc[27]}; M_Kb5s5_p14=${perc[29]}; M_Kb5s5_p15=${perc[31]}; M_Kb5s5_p16=${perc[33]}; M_Kb5s5_p17=${perc[35]}; M_Kb5s5_p18=${perc[37]}; M_Kb5s5_p19=${perc[39]}; M_Kb5s5_p20=${perc[41]};
M_Kb5s5_p21=${perc[43]}; M_Kb5s5_p22=${perc[45]}; M_Kb5s5_p23=${perc[47]}; M_Kb5s5_p24=${perc[49]}; M_Kb5s5_p25=${perc[51]}; M_Kb5s5_p26=${perc[53]}; M_Kb5s5_p27=${perc[55]}; M_Kb5s5_p28=${perc[57]}; M_Kb5s5_p29=${perc[59]}; M_Kb5s5_p30=${perc[61]};
M_Kb5s5_p31=${perc[63]}; M_Kb5s5_p32=${perc[65]}; M_Kb5s5_p33=${perc[67]}; M_Kb5s5_p34=${perc[69]}; M_Kb5s5_p35=${perc[71]}; M_Kb5s5_p36=${perc[73]}; M_Kb5s5_p37=${perc[75]}; M_Kb5s5_p38=${perc[77]}; M_Kb5s5_p39=${perc[79]}; M_Kb5s5_p40=${perc[81]};
M_Kb5s5_p41=${perc[83]}; M_Kb5s5_p42=${perc[85]}; M_Kb5s5_p43=${perc[87]}; M_Kb5s5_p44=${perc[89]}; M_Kb5s5_p45=${perc[91]}; M_Kb5s5_p46=${perc[93]}; M_Kb5s5_p47=${perc[95]}; M_Kb5s5_p48=${perc[97]}; M_Kb5s5_p49=${perc[99]}; M_Kb5s5_p50=${perc[101]};
M_Kb5s5_p51=${perc[103]}; M_Kb5s5_p52=${perc[105]}; M_Kb5s5_p53=${perc[107]}; M_Kb5s5_p54=${perc[109]}; M_Kb5s5_p55=${perc[111]}; M_Kb5s5_p56=${perc[113]}; M_Kb5s5_p57=${perc[115]}; M_Kb5s5_p58=${perc[117]}; M_Kb5s5_p59=${perc[119]}; M_Kb5s5_p60=${perc[121]};
M_Kb5s5_p61=${perc[123]}; M_Kb5s5_p62=${perc[125]}; M_Kb5s5_p63=${perc[127]}; M_Kb5s5_p64=${perc[129]}; M_Kb5s5_p65=${perc[131]}; M_Kb5s5_p66=${perc[133]}; M_Kb5s5_p67=${perc[135]}; M_Kb5s5_p68=${perc[137]}; M_Kb5s5_p69=${perc[139]}; M_Kb5s5_p70=${perc[141]};
M_Kb5s5_p71=${perc[143]}; M_Kb5s5_p72=${perc[145]}; M_Kb5s5_p73=${perc[147]}; M_Kb5s5_p74=${perc[149]}; M_Kb5s5_p75=${perc[151]}; M_Kb5s5_p76=${perc[153]}; M_Kb5s5_p77=${perc[155]}; M_Kb5s5_p78=${perc[157]}; M_Kb5s5_p79=${perc[159]}; M_Kb5s5_p80=${perc[161]};
M_Kb5s5_p81=${perc[163]}; M_Kb5s5_p82=${perc[165]}; M_Kb5s5_p83=${perc[167]}; M_Kb5s5_p84=${perc[169]}; M_Kb5s5_p85=${perc[171]}; M_Kb5s5_p86=${perc[173]}; M_Kb5s5_p87=${perc[175]}; M_Kb5s5_p88=${perc[177]}; M_Kb5s5_p89=${perc[179]}; M_Kb5s5_p90=${perc[181]};
M_Kb5s5_p91=${perc[183]}; M_Kb5s5_p92=${perc[185]}; M_Kb5s5_p93=${perc[187]}; M_Kb5s5_p94=${perc[189]}; M_Kb5s5_p95=${perc[191]}; M_Kb5s5_p96=${perc[193]}; M_Kb5s5_p97=${perc[195]}; M_Kb5s5_p98=${perc[197]}; M_Kb5s5_p99=${perc[199]}; M_Kb5s5_p100=${perc[201]};

########################## Single Keren
# S K b0s0
#3dcalc -a $rest_dir/SE/fcon/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_e2_mni_b0.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/SE/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_S.K1.b0s0.nii
#3dBrickStat -mask mask_S.K1.b0s0.nii -non-zero -percentile 0 1 100 $rest_dir/SE/fcon/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_e2_mni_b0.s0.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_S.K1.b0s0.1D
#hold=`cat percentiles_S.K1.b0s0.1D`; perc=($hold);
#S_Kb0s0_p0=${perc[1]}; S_Kb0s0_p1=${perc[3]}; S_Kb0s0_p2=${perc[5]}; S_Kb0s0_p3=${perc[7]}; S_Kb0s0_p4=${perc[9]}; S_Kb0s0_p5=${perc[11]}; S_Kb0s0_p6=${perc[13]}; S_Kb0s0_p7=${perc[15]}; S_Kb0s0_p8=${perc[17]}; S_Kb0s0_p9=${perc[19]}; S_Kb0s0_p10=${perc[21]};
#S_Kb0s0_p11=${perc[23]}; S_Kb0s0_p12=${perc[25]}; S_Kb0s0_p13=${perc[27]}; S_Kb0s0_p14=${perc[29]}; S_Kb0s0_p15=${perc[31]}; S_Kb0s0_p16=${perc[33]}; S_Kb0s0_p17=${perc[35]}; S_Kb0s0_p18=${perc[37]}; S_Kb0s0_p19=${perc[39]}; S_Kb0s0_p20=${perc[41]};
#S_Kb0s0_p21=${perc[43]}; S_Kb0s0_p22=${perc[45]}; S_Kb0s0_p23=${perc[47]}; S_Kb0s0_p24=${perc[49]}; S_Kb0s0_p25=${perc[51]}; S_Kb0s0_p26=${perc[53]}; S_Kb0s0_p27=${perc[55]}; S_Kb0s0_p28=${perc[57]}; S_Kb0s0_p29=${perc[59]}; S_Kb0s0_p30=${perc[61]};
#S_Kb0s0_p31=${perc[63]}; S_Kb0s0_p32=${perc[65]}; S_Kb0s0_p33=${perc[67]}; S_Kb0s0_p34=${perc[69]}; S_Kb0s0_p35=${perc[71]}; S_Kb0s0_p36=${perc[73]}; S_Kb0s0_p37=${perc[75]}; S_Kb0s0_p38=${perc[77]}; S_Kb0s0_p39=${perc[79]}; S_Kb0s0_p40=${perc[81]};
#S_Kb0s0_p41=${perc[83]}; S_Kb0s0_p42=${perc[85]}; S_Kb0s0_p43=${perc[87]}; S_Kb0s0_p44=${perc[89]}; S_Kb0s0_p45=${perc[91]}; S_Kb0s0_p46=${perc[93]}; S_Kb0s0_p47=${perc[95]}; S_Kb0s0_p48=${perc[97]}; S_Kb0s0_p49=${perc[99]}; S_Kb0s0_p50=${perc[101]};
#S_Kb0s0_p51=${perc[103]}; S_Kb0s0_p52=${perc[105]}; S_Kb0s0_p53=${perc[107]}; S_Kb0s0_p54=${perc[109]}; S_Kb0s0_p55=${perc[111]}; S_Kb0s0_p56=${perc[113]}; S_Kb0s0_p57=${perc[115]}; S_Kb0s0_p58=${perc[117]}; S_Kb0s0_p59=${perc[119]}; S_Kb0s0_p60=${perc[121]};
#S_Kb0s0_p61=${perc[123]}; S_Kb0s0_p62=${perc[125]}; S_Kb0s0_p63=${perc[127]}; S_Kb0s0_p64=${perc[129]}; S_Kb0s0_p65=${perc[131]}; S_Kb0s0_p66=${perc[133]}; S_Kb0s0_p67=${perc[135]}; S_Kb0s0_p68=${perc[137]}; S_Kb0s0_p69=${perc[139]}; S_Kb0s0_p70=${perc[141]};
#S_Kb0s0_p71=${perc[143]}; S_Kb0s0_p72=${perc[145]}; S_Kb0s0_p73=${perc[147]}; S_Kb0s0_p74=${perc[149]}; S_Kb0s0_p75=${perc[151]}; S_Kb0s0_p76=${perc[153]}; S_Kb0s0_p77=${perc[155]}; S_Kb0s0_p78=${perc[157]}; S_Kb0s0_p79=${perc[159]}; S_Kb0s0_p80=${perc[161]};
#S_Kb0s0_p81=${perc[163]}; S_Kb0s0_p82=${perc[165]}; S_Kb0s0_p83=${perc[167]}; S_Kb0s0_p84=${perc[169]}; S_Kb0s0_p85=${perc[171]}; S_Kb0s0_p86=${perc[173]}; S_Kb0s0_p87=${perc[175]}; S_Kb0s0_p88=${perc[177]}; S_Kb0s0_p89=${perc[179]}; S_Kb0s0_p90=${perc[181]};
#S_Kb0s0_p91=${perc[183]}; S_Kb0s0_p92=${perc[185]}; S_Kb0s0_p93=${perc[187]}; S_Kb0s0_p94=${perc[189]}; S_Kb0s0_p95=${perc[191]}; S_Kb0s0_p96=${perc[193]}; S_Kb0s0_p97=${perc[195]}; S_Kb0s0_p98=${perc[197]}; S_Kb0s0_p99=${perc[199]}; S_Kb0s0_p100=${perc[201]};

# S K b0s5
#3dcalc -a $rest_dir/SE/fcon/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_e2_mni_b0.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/SE/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_S.K1.b0s5.nii
#3dBrickStat -mask mask_S.K1.b0s5.nii -non-zero -percentile 0 1 100 $rest_dir/SE/fcon/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_e2_mni_b0.s5.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_S.K1.b0s5.1D
#hold=`cat percentiles_S.K1.b0s5.1D`; perc=($hold);
#S_Kb0s5_p0=${perc[1]}; S_Kb0s5_p1=${perc[3]}; S_Kb0s5_p2=${perc[5]}; S_Kb0s5_p3=${perc[7]}; S_Kb0s5_p4=${perc[9]}; S_Kb0s5_p5=${perc[11]}; S_Kb0s5_p6=${perc[13]}; S_Kb0s5_p7=${perc[15]}; S_Kb0s5_p8=${perc[17]}; S_Kb0s5_p9=${perc[19]}; S_Kb0s5_p10=${perc[21]};
#S_Kb0s5_p11=${perc[23]}; S_Kb0s5_p12=${perc[25]}; S_Kb0s5_p13=${perc[27]}; S_Kb0s5_p14=${perc[29]}; S_Kb0s5_p15=${perc[31]}; S_Kb0s5_p16=${perc[33]}; S_Kb0s5_p17=${perc[35]}; S_Kb0s5_p18=${perc[37]}; S_Kb0s5_p19=${perc[39]}; S_Kb0s5_p20=${perc[41]};
#S_Kb0s5_p21=${perc[43]}; S_Kb0s5_p22=${perc[45]}; S_Kb0s5_p23=${perc[47]}; S_Kb0s5_p24=${perc[49]}; S_Kb0s5_p25=${perc[51]}; S_Kb0s5_p26=${perc[53]}; S_Kb0s5_p27=${perc[55]}; S_Kb0s5_p28=${perc[57]}; S_Kb0s5_p29=${perc[59]}; S_Kb0s5_p30=${perc[61]};
#S_Kb0s5_p31=${perc[63]}; S_Kb0s5_p32=${perc[65]}; S_Kb0s5_p33=${perc[67]}; S_Kb0s5_p34=${perc[69]}; S_Kb0s5_p35=${perc[71]}; S_Kb0s5_p36=${perc[73]}; S_Kb0s5_p37=${perc[75]}; S_Kb0s5_p38=${perc[77]}; S_Kb0s5_p39=${perc[79]}; S_Kb0s5_p40=${perc[81]};
#S_Kb0s5_p41=${perc[83]}; S_Kb0s5_p42=${perc[85]}; S_Kb0s5_p43=${perc[87]}; S_Kb0s5_p44=${perc[89]}; S_Kb0s5_p45=${perc[91]}; S_Kb0s5_p46=${perc[93]}; S_Kb0s5_p47=${perc[95]}; S_Kb0s5_p48=${perc[97]}; S_Kb0s5_p49=${perc[99]}; S_Kb0s5_p50=${perc[101]};
#S_Kb0s5_p51=${perc[103]}; S_Kb0s5_p52=${perc[105]}; S_Kb0s5_p53=${perc[107]}; S_Kb0s5_p54=${perc[109]}; S_Kb0s5_p55=${perc[111]}; S_Kb0s5_p56=${perc[113]}; S_Kb0s5_p57=${perc[115]}; S_Kb0s5_p58=${perc[117]}; S_Kb0s5_p59=${perc[119]}; S_Kb0s5_p60=${perc[121]};
#S_Kb0s5_p61=${perc[123]}; S_Kb0s5_p62=${perc[125]}; S_Kb0s5_p63=${perc[127]}; S_Kb0s5_p64=${perc[129]}; S_Kb0s5_p65=${perc[131]}; S_Kb0s5_p66=${perc[133]}; S_Kb0s5_p67=${perc[135]}; S_Kb0s5_p68=${perc[137]}; S_Kb0s5_p69=${perc[139]}; S_Kb0s5_p70=${perc[141]};
#S_Kb0s5_p71=${perc[143]}; S_Kb0s5_p72=${perc[145]}; S_Kb0s5_p73=${perc[147]}; S_Kb0s5_p74=${perc[149]}; S_Kb0s5_p75=${perc[151]}; S_Kb0s5_p76=${perc[153]}; S_Kb0s5_p77=${perc[155]}; S_Kb0s5_p78=${perc[157]}; S_Kb0s5_p79=${perc[159]}; S_Kb0s5_p80=${perc[161]};
#S_Kb0s5_p81=${perc[163]}; S_Kb0s5_p82=${perc[165]}; S_Kb0s5_p83=${perc[167]}; S_Kb0s5_p84=${perc[169]}; S_Kb0s5_p85=${perc[171]}; S_Kb0s5_p86=${perc[173]}; S_Kb0s5_p87=${perc[175]}; S_Kb0s5_p88=${perc[177]}; S_Kb0s5_p89=${perc[179]}; S_Kb0s5_p90=${perc[181]};
#S_Kb0s5_p91=${perc[183]}; S_Kb0s5_p92=${perc[185]}; S_Kb0s5_p93=${perc[187]}; S_Kb0s5_p94=${perc[189]}; S_Kb0s5_p95=${perc[191]}; S_Kb0s5_p96=${perc[193]}; S_Kb0s5_p97=${perc[195]}; S_Kb0s5_p98=${perc[197]}; S_Kb0s5_p99=${perc[199]}; S_Kb0s5_p100=${perc[201]};

# S K b5s0
3dcalc -a $rest_dir/SE/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/SE/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_S.K1.b5s0.nii
3dBrickStat -mask mask_S.K1.b5s0.nii -non-zero -percentile 0 1 100 $rest_dir/SE/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_S.K1.b5s0.1D
hold=`cat percentiles_S.K1.b5s0.1D`; perc=($hold);
S_Kb5s0_p0=${perc[1]}; S_Kb5s0_p1=${perc[3]}; S_Kb5s0_p2=${perc[5]}; S_Kb5s0_p3=${perc[7]}; S_Kb5s0_p4=${perc[9]}; S_Kb5s0_p5=${perc[11]}; S_Kb5s0_p6=${perc[13]}; S_Kb5s0_p7=${perc[15]}; S_Kb5s0_p8=${perc[17]}; S_Kb5s0_p9=${perc[19]}; S_Kb5s0_p10=${perc[21]};
S_Kb5s0_p11=${perc[23]}; S_Kb5s0_p12=${perc[25]}; S_Kb5s0_p13=${perc[27]}; S_Kb5s0_p14=${perc[29]}; S_Kb5s0_p15=${perc[31]}; S_Kb5s0_p16=${perc[33]}; S_Kb5s0_p17=${perc[35]}; S_Kb5s0_p18=${perc[37]}; S_Kb5s0_p19=${perc[39]}; S_Kb5s0_p20=${perc[41]};
S_Kb5s0_p21=${perc[43]}; S_Kb5s0_p22=${perc[45]}; S_Kb5s0_p23=${perc[47]}; S_Kb5s0_p24=${perc[49]}; S_Kb5s0_p25=${perc[51]}; S_Kb5s0_p26=${perc[53]}; S_Kb5s0_p27=${perc[55]}; S_Kb5s0_p28=${perc[57]}; S_Kb5s0_p29=${perc[59]}; S_Kb5s0_p30=${perc[61]};
S_Kb5s0_p31=${perc[63]}; S_Kb5s0_p32=${perc[65]}; S_Kb5s0_p33=${perc[67]}; S_Kb5s0_p34=${perc[69]}; S_Kb5s0_p35=${perc[71]}; S_Kb5s0_p36=${perc[73]}; S_Kb5s0_p37=${perc[75]}; S_Kb5s0_p38=${perc[77]}; S_Kb5s0_p39=${perc[79]}; S_Kb5s0_p40=${perc[81]};
S_Kb5s0_p41=${perc[83]}; S_Kb5s0_p42=${perc[85]}; S_Kb5s0_p43=${perc[87]}; S_Kb5s0_p44=${perc[89]}; S_Kb5s0_p45=${perc[91]}; S_Kb5s0_p46=${perc[93]}; S_Kb5s0_p47=${perc[95]}; S_Kb5s0_p48=${perc[97]}; S_Kb5s0_p49=${perc[99]}; S_Kb5s0_p50=${perc[101]};
S_Kb5s0_p51=${perc[103]}; S_Kb5s0_p52=${perc[105]}; S_Kb5s0_p53=${perc[107]}; S_Kb5s0_p54=${perc[109]}; S_Kb5s0_p55=${perc[111]}; S_Kb5s0_p56=${perc[113]}; S_Kb5s0_p57=${perc[115]}; S_Kb5s0_p58=${perc[117]}; S_Kb5s0_p59=${perc[119]}; S_Kb5s0_p60=${perc[121]};
S_Kb5s0_p61=${perc[123]}; S_Kb5s0_p62=${perc[125]}; S_Kb5s0_p63=${perc[127]}; S_Kb5s0_p64=${perc[129]}; S_Kb5s0_p65=${perc[131]}; S_Kb5s0_p66=${perc[133]}; S_Kb5s0_p67=${perc[135]}; S_Kb5s0_p68=${perc[137]}; S_Kb5s0_p69=${perc[139]}; S_Kb5s0_p70=${perc[141]};
S_Kb5s0_p71=${perc[143]}; S_Kb5s0_p72=${perc[145]}; S_Kb5s0_p73=${perc[147]}; S_Kb5s0_p74=${perc[149]}; S_Kb5s0_p75=${perc[151]}; S_Kb5s0_p76=${perc[153]}; S_Kb5s0_p77=${perc[155]}; S_Kb5s0_p78=${perc[157]}; S_Kb5s0_p79=${perc[159]}; S_Kb5s0_p80=${perc[161]};
S_Kb5s0_p81=${perc[163]}; S_Kb5s0_p82=${perc[165]}; S_Kb5s0_p83=${perc[167]}; S_Kb5s0_p84=${perc[169]}; S_Kb5s0_p85=${perc[171]}; S_Kb5s0_p86=${perc[173]}; S_Kb5s0_p87=${perc[175]}; S_Kb5s0_p88=${perc[177]}; S_Kb5s0_p89=${perc[179]}; S_Kb5s0_p90=${perc[181]};
S_Kb5s0_p91=${perc[183]}; S_Kb5s0_p92=${perc[185]}; S_Kb5s0_p93=${perc[187]}; S_Kb5s0_p94=${perc[189]}; S_Kb5s0_p95=${perc[191]}; S_Kb5s0_p96=${perc[193]}; S_Kb5s0_p97=${perc[195]}; S_Kb5s0_p98=${perc[197]}; S_Kb5s0_p99=${perc[199]}; S_Kb5s0_p100=${perc[201]};

# S K b5s5
3dcalc -a $rest_dir/SE/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/SE/rois/mask_Keren1SD.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_S.K1.b5s5.nii
3dBrickStat -mask mask_S.K1.b5s5.nii -non-zero -percentile 0 1 100 $rest_dir/SE/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_S.K1.b5s5.1D
hold=`cat percentiles_S.K1.b5s5.1D`; perc=($hold);
S_Kb5s5_p0=${perc[1]}; S_Kb5s5_p1=${perc[3]}; S_Kb5s5_p2=${perc[5]}; S_Kb5s5_p3=${perc[7]}; S_Kb5s5_p4=${perc[9]}; S_Kb5s5_p5=${perc[11]}; S_Kb5s5_p6=${perc[13]}; S_Kb5s5_p7=${perc[15]}; S_Kb5s5_p8=${perc[17]}; S_Kb5s5_p9=${perc[19]}; S_Kb5s5_p10=${perc[21]};
S_Kb5s5_p11=${perc[23]}; S_Kb5s5_p12=${perc[25]}; S_Kb5s5_p13=${perc[27]}; S_Kb5s5_p14=${perc[29]}; S_Kb5s5_p15=${perc[31]}; S_Kb5s5_p16=${perc[33]}; S_Kb5s5_p17=${perc[35]}; S_Kb5s5_p18=${perc[37]}; S_Kb5s5_p19=${perc[39]}; S_Kb5s5_p20=${perc[41]};
S_Kb5s5_p21=${perc[43]}; S_Kb5s5_p22=${perc[45]}; S_Kb5s5_p23=${perc[47]}; S_Kb5s5_p24=${perc[49]}; S_Kb5s5_p25=${perc[51]}; S_Kb5s5_p26=${perc[53]}; S_Kb5s5_p27=${perc[55]}; S_Kb5s5_p28=${perc[57]}; S_Kb5s5_p29=${perc[59]}; S_Kb5s5_p30=${perc[61]};
S_Kb5s5_p31=${perc[63]}; S_Kb5s5_p32=${perc[65]}; S_Kb5s5_p33=${perc[67]}; S_Kb5s5_p34=${perc[69]}; S_Kb5s5_p35=${perc[71]}; S_Kb5s5_p36=${perc[73]}; S_Kb5s5_p37=${perc[75]}; S_Kb5s5_p38=${perc[77]}; S_Kb5s5_p39=${perc[79]}; S_Kb5s5_p40=${perc[81]};
S_Kb5s5_p41=${perc[83]}; S_Kb5s5_p42=${perc[85]}; S_Kb5s5_p43=${perc[87]}; S_Kb5s5_p44=${perc[89]}; S_Kb5s5_p45=${perc[91]}; S_Kb5s5_p46=${perc[93]}; S_Kb5s5_p47=${perc[95]}; S_Kb5s5_p48=${perc[97]}; S_Kb5s5_p49=${perc[99]}; S_Kb5s5_p50=${perc[101]};
S_Kb5s5_p51=${perc[103]}; S_Kb5s5_p52=${perc[105]}; S_Kb5s5_p53=${perc[107]}; S_Kb5s5_p54=${perc[109]}; S_Kb5s5_p55=${perc[111]}; S_Kb5s5_p56=${perc[113]}; S_Kb5s5_p57=${perc[115]}; S_Kb5s5_p58=${perc[117]}; S_Kb5s5_p59=${perc[119]}; S_Kb5s5_p60=${perc[121]};
S_Kb5s5_p61=${perc[123]}; S_Kb5s5_p62=${perc[125]}; S_Kb5s5_p63=${perc[127]}; S_Kb5s5_p64=${perc[129]}; S_Kb5s5_p65=${perc[131]}; S_Kb5s5_p66=${perc[133]}; S_Kb5s5_p67=${perc[135]}; S_Kb5s5_p68=${perc[137]}; S_Kb5s5_p69=${perc[139]}; S_Kb5s5_p70=${perc[141]};
S_Kb5s5_p71=${perc[143]}; S_Kb5s5_p72=${perc[145]}; S_Kb5s5_p73=${perc[147]}; S_Kb5s5_p74=${perc[149]}; S_Kb5s5_p75=${perc[151]}; S_Kb5s5_p76=${perc[153]}; S_Kb5s5_p77=${perc[155]}; S_Kb5s5_p78=${perc[157]}; S_Kb5s5_p79=${perc[159]}; S_Kb5s5_p80=${perc[161]};
S_Kb5s5_p81=${perc[163]}; S_Kb5s5_p82=${perc[165]}; S_Kb5s5_p83=${perc[167]}; S_Kb5s5_p84=${perc[169]}; S_Kb5s5_p85=${perc[171]}; S_Kb5s5_p86=${perc[173]}; S_Kb5s5_p87=${perc[175]}; S_Kb5s5_p88=${perc[177]}; S_Kb5s5_p89=${perc[179]}; S_Kb5s5_p90=${perc[181]};
S_Kb5s5_p91=${perc[183]}; S_Kb5s5_p92=${perc[185]}; S_Kb5s5_p93=${perc[187]}; S_Kb5s5_p94=${perc[189]}; S_Kb5s5_p95=${perc[191]}; S_Kb5s5_p96=${perc[193]}; S_Kb5s5_p97=${perc[195]}; S_Kb5s5_p98=${perc[197]}; S_Kb5s5_p99=${perc[199]}; S_Kb5s5_p100=${perc[201]};

########################## Multi LC
# M L b0s0
#3dcalc -a $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_mni_b0.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_M.LC.b0s0.nii
#3dBrickStat -mask mask_M.LC.b0s0.nii -non-zero -percentile 0 1 100 $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_mni_b0.s0.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_M.LC.b0s0.1D
#hold=`cat percentiles_M.LC.b0s0.1D`; perc=($hold);
#M_Lb0s0_p0=${perc[1]}; M_Lb0s0_p1=${perc[3]}; M_Lb0s0_p2=${perc[5]}; M_Lb0s0_p3=${perc[7]}; M_Lb0s0_p4=${perc[9]}; M_Lb0s0_p5=${perc[11]}; M_Lb0s0_p6=${perc[13]}; M_Lb0s0_p7=${perc[15]}; M_Lb0s0_p8=${perc[17]}; M_Lb0s0_p9=${perc[19]}; M_Lb0s0_p10=${perc[21]};
#M_Lb0s0_p11=${perc[23]}; M_Lb0s0_p12=${perc[25]}; M_Lb0s0_p13=${perc[27]}; M_Lb0s0_p14=${perc[29]}; M_Lb0s0_p15=${perc[31]}; M_Lb0s0_p16=${perc[33]}; M_Lb0s0_p17=${perc[35]}; M_Lb0s0_p18=${perc[37]}; M_Lb0s0_p19=${perc[39]}; M_Lb0s0_p20=${perc[41]};
#M_Lb0s0_p21=${perc[43]}; M_Lb0s0_p22=${perc[45]}; M_Lb0s0_p23=${perc[47]}; M_Lb0s0_p24=${perc[49]}; M_Lb0s0_p25=${perc[51]}; M_Lb0s0_p26=${perc[53]}; M_Lb0s0_p27=${perc[55]}; M_Lb0s0_p28=${perc[57]}; M_Lb0s0_p29=${perc[59]}; M_Lb0s0_p30=${perc[61]};
#M_Lb0s0_p31=${perc[63]}; M_Lb0s0_p32=${perc[65]}; M_Lb0s0_p33=${perc[67]}; M_Lb0s0_p34=${perc[69]}; M_Lb0s0_p35=${perc[71]}; M_Lb0s0_p36=${perc[73]}; M_Lb0s0_p37=${perc[75]}; M_Lb0s0_p38=${perc[77]}; M_Lb0s0_p39=${perc[79]}; M_Lb0s0_p40=${perc[81]};
#M_Lb0s0_p41=${perc[83]}; M_Lb0s0_p42=${perc[85]}; M_Lb0s0_p43=${perc[87]}; M_Lb0s0_p44=${perc[89]}; M_Lb0s0_p45=${perc[91]}; M_Lb0s0_p46=${perc[93]}; M_Lb0s0_p47=${perc[95]}; M_Lb0s0_p48=${perc[97]}; M_Lb0s0_p49=${perc[99]}; M_Lb0s0_p50=${perc[101]};
#M_Lb0s0_p51=${perc[103]}; M_Lb0s0_p52=${perc[105]}; M_Lb0s0_p53=${perc[107]}; M_Lb0s0_p54=${perc[109]}; M_Lb0s0_p55=${perc[111]}; M_Lb0s0_p56=${perc[113]}; M_Lb0s0_p57=${perc[115]}; M_Lb0s0_p58=${perc[117]}; M_Lb0s0_p59=${perc[119]}; M_Lb0s0_p60=${perc[121]};
#M_Lb0s0_p61=${perc[123]}; M_Lb0s0_p62=${perc[125]}; M_Lb0s0_p63=${perc[127]}; M_Lb0s0_p64=${perc[129]}; M_Lb0s0_p65=${perc[131]}; M_Lb0s0_p66=${perc[133]}; M_Lb0s0_p67=${perc[135]}; M_Lb0s0_p68=${perc[137]}; M_Lb0s0_p69=${perc[139]}; M_Lb0s0_p70=${perc[141]};
#M_Lb0s0_p71=${perc[143]}; M_Lb0s0_p72=${perc[145]}; M_Lb0s0_p73=${perc[147]}; M_Lb0s0_p74=${perc[149]}; M_Lb0s0_p75=${perc[151]}; M_Lb0s0_p76=${perc[153]}; M_Lb0s0_p77=${perc[155]}; M_Lb0s0_p78=${perc[157]}; M_Lb0s0_p79=${perc[159]}; M_Lb0s0_p80=${perc[161]};
#M_Lb0s0_p81=${perc[163]}; M_Lb0s0_p82=${perc[165]}; M_Lb0s0_p83=${perc[167]}; M_Lb0s0_p84=${perc[169]}; M_Lb0s0_p85=${perc[171]}; M_Lb0s0_p86=${perc[173]}; M_Lb0s0_p87=${perc[175]}; M_Lb0s0_p88=${perc[177]}; M_Lb0s0_p89=${perc[179]}; M_Lb0s0_p90=${perc[181]};
#M_Lb0s0_p91=${perc[183]}; M_Lb0s0_p92=${perc[185]}; M_Lb0s0_p93=${perc[187]}; M_Lb0s0_p94=${perc[189]}; M_Lb0s0_p95=${perc[191]}; M_Lb0s0_p96=${perc[193]}; M_Lb0s0_p97=${perc[195]}; M_Lb0s0_p98=${perc[197]}; M_Lb0s0_p99=${perc[199]}; M_Lb0s0_p100=${perc[201]};

# M L b0s5
#3dcalc -a $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_mni_b0.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_M.LC.b0s5.nii
#3dBrickStat -mask mask_M.LC.b0s5.nii -non-zero -percentile 0 1 100 $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_mni_b0.s5.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_M.LC.b0s5.1D
#hold=`cat percentiles_M.LC.b0s5.1D`; perc=($hold);
#M_Lb0s5_p0=${perc[1]}; M_Lb0s5_p1=${perc[3]}; M_Lb0s5_p2=${perc[5]}; M_Lb0s5_p3=${perc[7]}; M_Lb0s5_p4=${perc[9]}; M_Lb0s5_p5=${perc[11]}; M_Lb0s5_p6=${perc[13]}; M_Lb0s5_p7=${perc[15]}; M_Lb0s5_p8=${perc[17]}; M_Lb0s5_p9=${perc[19]}; M_Lb0s5_p10=${perc[21]};
#M_Lb0s5_p11=${perc[23]}; M_Lb0s5_p12=${perc[25]}; M_Lb0s5_p13=${perc[27]}; M_Lb0s5_p14=${perc[29]}; M_Lb0s5_p15=${perc[31]}; M_Lb0s5_p16=${perc[33]}; M_Lb0s5_p17=${perc[35]}; M_Lb0s5_p18=${perc[37]}; M_Lb0s5_p19=${perc[39]}; M_Lb0s5_p20=${perc[41]};
#M_Lb0s5_p21=${perc[43]}; M_Lb0s5_p22=${perc[45]}; M_Lb0s5_p23=${perc[47]}; M_Lb0s5_p24=${perc[49]}; M_Lb0s5_p25=${perc[51]}; M_Lb0s5_p26=${perc[53]}; M_Lb0s5_p27=${perc[55]}; M_Lb0s5_p28=${perc[57]}; M_Lb0s5_p29=${perc[59]}; M_Lb0s5_p30=${perc[61]};
#M_Lb0s5_p31=${perc[63]}; M_Lb0s5_p32=${perc[65]}; M_Lb0s5_p33=${perc[67]}; M_Lb0s5_p34=${perc[69]}; M_Lb0s5_p35=${perc[71]}; M_Lb0s5_p36=${perc[73]}; M_Lb0s5_p37=${perc[75]}; M_Lb0s5_p38=${perc[77]}; M_Lb0s5_p39=${perc[79]}; M_Lb0s5_p40=${perc[81]};
#M_Lb0s5_p41=${perc[83]}; M_Lb0s5_p42=${perc[85]}; M_Lb0s5_p43=${perc[87]}; M_Lb0s5_p44=${perc[89]}; M_Lb0s5_p45=${perc[91]}; M_Lb0s5_p46=${perc[93]}; M_Lb0s5_p47=${perc[95]}; M_Lb0s5_p48=${perc[97]}; M_Lb0s5_p49=${perc[99]}; M_Lb0s5_p50=${perc[101]};
#M_Lb0s5_p51=${perc[103]}; M_Lb0s5_p52=${perc[105]}; M_Lb0s5_p53=${perc[107]}; M_Lb0s5_p54=${perc[109]}; M_Lb0s5_p55=${perc[111]}; M_Lb0s5_p56=${perc[113]}; M_Lb0s5_p57=${perc[115]}; M_Lb0s5_p58=${perc[117]}; M_Lb0s5_p59=${perc[119]}; M_Lb0s5_p60=${perc[121]};
#M_Lb0s5_p61=${perc[123]}; M_Lb0s5_p62=${perc[125]}; M_Lb0s5_p63=${perc[127]}; M_Lb0s5_p64=${perc[129]}; M_Lb0s5_p65=${perc[131]}; M_Lb0s5_p66=${perc[133]}; M_Lb0s5_p67=${perc[135]}; M_Lb0s5_p68=${perc[137]}; M_Lb0s5_p69=${perc[139]}; M_Lb0s5_p70=${perc[141]};
#M_Lb0s5_p71=${perc[143]}; M_Lb0s5_p72=${perc[145]}; M_Lb0s5_p73=${perc[147]}; M_Lb0s5_p74=${perc[149]}; M_Lb0s5_p75=${perc[151]}; M_Lb0s5_p76=${perc[153]}; M_Lb0s5_p77=${perc[155]}; M_Lb0s5_p78=${perc[157]}; M_Lb0s5_p79=${perc[159]}; M_Lb0s5_p80=${perc[161]};
#M_Lb0s5_p81=${perc[163]}; M_Lb0s5_p82=${perc[165]}; M_Lb0s5_p83=${perc[167]}; M_Lb0s5_p84=${perc[169]}; M_Lb0s5_p85=${perc[171]}; M_Lb0s5_p86=${perc[173]}; M_Lb0s5_p87=${perc[175]}; M_Lb0s5_p88=${perc[177]}; M_Lb0s5_p89=${perc[179]}; M_Lb0s5_p90=${perc[181]};
#M_Lb0s5_p91=${perc[183]}; M_Lb0s5_p92=${perc[185]}; M_Lb0s5_p93=${perc[187]}; M_Lb0s5_p94=${perc[189]}; M_Lb0s5_p95=${perc[191]}; M_Lb0s5_p96=${perc[193]}; M_Lb0s5_p97=${perc[195]}; M_Lb0s5_p98=${perc[197]}; M_Lb0s5_p99=${perc[199]}; M_Lb0s5_p100=${perc[201]};

# M L b5s0
3dcalc -a $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_M.LC.b5s0.nii
3dBrickStat -mask mask_M.LC.b5s0.nii -non-zero -percentile 0 1 100 $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_M.LC.b5s0.1D
hold=`cat percentiles_M.LC.b5s0.1D`; perc=($hold);
M_Lb5s0_p0=${perc[1]}; M_Lb5s0_p1=${perc[3]}; M_Lb5s0_p2=${perc[5]}; M_Lb5s0_p3=${perc[7]}; M_Lb5s0_p4=${perc[9]}; M_Lb5s0_p5=${perc[11]}; M_Lb5s0_p6=${perc[13]}; M_Lb5s0_p7=${perc[15]}; M_Lb5s0_p8=${perc[17]}; M_Lb5s0_p9=${perc[19]}; M_Lb5s0_p10=${perc[21]};
M_Lb5s0_p11=${perc[23]}; M_Lb5s0_p12=${perc[25]}; M_Lb5s0_p13=${perc[27]}; M_Lb5s0_p14=${perc[29]}; M_Lb5s0_p15=${perc[31]}; M_Lb5s0_p16=${perc[33]}; M_Lb5s0_p17=${perc[35]}; M_Lb5s0_p18=${perc[37]}; M_Lb5s0_p19=${perc[39]}; M_Lb5s0_p20=${perc[41]};
M_Lb5s0_p21=${perc[43]}; M_Lb5s0_p22=${perc[45]}; M_Lb5s0_p23=${perc[47]}; M_Lb5s0_p24=${perc[49]}; M_Lb5s0_p25=${perc[51]}; M_Lb5s0_p26=${perc[53]}; M_Lb5s0_p27=${perc[55]}; M_Lb5s0_p28=${perc[57]}; M_Lb5s0_p29=${perc[59]}; M_Lb5s0_p30=${perc[61]};
M_Lb5s0_p31=${perc[63]}; M_Lb5s0_p32=${perc[65]}; M_Lb5s0_p33=${perc[67]}; M_Lb5s0_p34=${perc[69]}; M_Lb5s0_p35=${perc[71]}; M_Lb5s0_p36=${perc[73]}; M_Lb5s0_p37=${perc[75]}; M_Lb5s0_p38=${perc[77]}; M_Lb5s0_p39=${perc[79]}; M_Lb5s0_p40=${perc[81]};
M_Lb5s0_p41=${perc[83]}; M_Lb5s0_p42=${perc[85]}; M_Lb5s0_p43=${perc[87]}; M_Lb5s0_p44=${perc[89]}; M_Lb5s0_p45=${perc[91]}; M_Lb5s0_p46=${perc[93]}; M_Lb5s0_p47=${perc[95]}; M_Lb5s0_p48=${perc[97]}; M_Lb5s0_p49=${perc[99]}; M_Lb5s0_p50=${perc[101]};
M_Lb5s0_p51=${perc[103]}; M_Lb5s0_p52=${perc[105]}; M_Lb5s0_p53=${perc[107]}; M_Lb5s0_p54=${perc[109]}; M_Lb5s0_p55=${perc[111]}; M_Lb5s0_p56=${perc[113]}; M_Lb5s0_p57=${perc[115]}; M_Lb5s0_p58=${perc[117]}; M_Lb5s0_p59=${perc[119]}; M_Lb5s0_p60=${perc[121]};
M_Lb5s0_p61=${perc[123]}; M_Lb5s0_p62=${perc[125]}; M_Lb5s0_p63=${perc[127]}; M_Lb5s0_p64=${perc[129]}; M_Lb5s0_p65=${perc[131]}; M_Lb5s0_p66=${perc[133]}; M_Lb5s0_p67=${perc[135]}; M_Lb5s0_p68=${perc[137]}; M_Lb5s0_p69=${perc[139]}; M_Lb5s0_p70=${perc[141]};
M_Lb5s0_p71=${perc[143]}; M_Lb5s0_p72=${perc[145]}; M_Lb5s0_p73=${perc[147]}; M_Lb5s0_p74=${perc[149]}; M_Lb5s0_p75=${perc[151]}; M_Lb5s0_p76=${perc[153]}; M_Lb5s0_p77=${perc[155]}; M_Lb5s0_p78=${perc[157]}; M_Lb5s0_p79=${perc[159]}; M_Lb5s0_p80=${perc[161]};
M_Lb5s0_p81=${perc[163]}; M_Lb5s0_p82=${perc[165]}; M_Lb5s0_p83=${perc[167]}; M_Lb5s0_p84=${perc[169]}; M_Lb5s0_p85=${perc[171]}; M_Lb5s0_p86=${perc[173]}; M_Lb5s0_p87=${perc[175]}; M_Lb5s0_p88=${perc[177]}; M_Lb5s0_p89=${perc[179]}; M_Lb5s0_p90=${perc[181]};
M_Lb5s0_p91=${perc[183]}; M_Lb5s0_p92=${perc[185]}; M_Lb5s0_p93=${perc[187]}; M_Lb5s0_p94=${perc[189]}; M_Lb5s0_p95=${perc[191]}; M_Lb5s0_p96=${perc[193]}; M_Lb5s0_p97=${perc[195]}; M_Lb5s0_p98=${perc[197]}; M_Lb5s0_p99=${perc[199]}; M_Lb5s0_p100=${perc[201]};

# M L b5s5
3dcalc -a $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_M.LC.b5s5.nii
3dBrickStat -mask mask_M.LC.b5s5.nii -non-zero -percentile 0 1 100 $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_M.LC.b5s5.1D
hold=`cat percentiles_M.LC.b5s5.1D`; perc=($hold);
M_Lb5s5_p0=${perc[1]}; M_Lb5s5_p1=${perc[3]}; M_Lb5s5_p2=${perc[5]}; M_Lb5s5_p3=${perc[7]}; M_Lb5s5_p4=${perc[9]}; M_Lb5s5_p5=${perc[11]}; M_Lb5s5_p6=${perc[13]}; M_Lb5s5_p7=${perc[15]}; M_Lb5s5_p8=${perc[17]}; M_Lb5s5_p9=${perc[19]}; M_Lb5s5_p10=${perc[21]};
M_Lb5s5_p11=${perc[23]}; M_Lb5s5_p12=${perc[25]}; M_Lb5s5_p13=${perc[27]}; M_Lb5s5_p14=${perc[29]}; M_Lb5s5_p15=${perc[31]}; M_Lb5s5_p16=${perc[33]}; M_Lb5s5_p17=${perc[35]}; M_Lb5s5_p18=${perc[37]}; M_Lb5s5_p19=${perc[39]}; M_Lb5s5_p20=${perc[41]};
M_Lb5s5_p21=${perc[43]}; M_Lb5s5_p22=${perc[45]}; M_Lb5s5_p23=${perc[47]}; M_Lb5s5_p24=${perc[49]}; M_Lb5s5_p25=${perc[51]}; M_Lb5s5_p26=${perc[53]}; M_Lb5s5_p27=${perc[55]}; M_Lb5s5_p28=${perc[57]}; M_Lb5s5_p29=${perc[59]}; M_Lb5s5_p30=${perc[61]};
M_Lb5s5_p31=${perc[63]}; M_Lb5s5_p32=${perc[65]}; M_Lb5s5_p33=${perc[67]}; M_Lb5s5_p34=${perc[69]}; M_Lb5s5_p35=${perc[71]}; M_Lb5s5_p36=${perc[73]}; M_Lb5s5_p37=${perc[75]}; M_Lb5s5_p38=${perc[77]}; M_Lb5s5_p39=${perc[79]}; M_Lb5s5_p40=${perc[81]};
M_Lb5s5_p41=${perc[83]}; M_Lb5s5_p42=${perc[85]}; M_Lb5s5_p43=${perc[87]}; M_Lb5s5_p44=${perc[89]}; M_Lb5s5_p45=${perc[91]}; M_Lb5s5_p46=${perc[93]}; M_Lb5s5_p47=${perc[95]}; M_Lb5s5_p48=${perc[97]}; M_Lb5s5_p49=${perc[99]}; M_Lb5s5_p50=${perc[101]};
M_Lb5s5_p51=${perc[103]}; M_Lb5s5_p52=${perc[105]}; M_Lb5s5_p53=${perc[107]}; M_Lb5s5_p54=${perc[109]}; M_Lb5s5_p55=${perc[111]}; M_Lb5s5_p56=${perc[113]}; M_Lb5s5_p57=${perc[115]}; M_Lb5s5_p58=${perc[117]}; M_Lb5s5_p59=${perc[119]}; M_Lb5s5_p60=${perc[121]};
M_Lb5s5_p61=${perc[123]}; M_Lb5s5_p62=${perc[125]}; M_Lb5s5_p63=${perc[127]}; M_Lb5s5_p64=${perc[129]}; M_Lb5s5_p65=${perc[131]}; M_Lb5s5_p66=${perc[133]}; M_Lb5s5_p67=${perc[135]}; M_Lb5s5_p68=${perc[137]}; M_Lb5s5_p69=${perc[139]}; M_Lb5s5_p70=${perc[141]};
M_Lb5s5_p71=${perc[143]}; M_Lb5s5_p72=${perc[145]}; M_Lb5s5_p73=${perc[147]}; M_Lb5s5_p74=${perc[149]}; M_Lb5s5_p75=${perc[151]}; M_Lb5s5_p76=${perc[153]}; M_Lb5s5_p77=${perc[155]}; M_Lb5s5_p78=${perc[157]}; M_Lb5s5_p79=${perc[159]}; M_Lb5s5_p80=${perc[161]};
M_Lb5s5_p81=${perc[163]}; M_Lb5s5_p82=${perc[165]}; M_Lb5s5_p83=${perc[167]}; M_Lb5s5_p84=${perc[169]}; M_Lb5s5_p85=${perc[171]}; M_Lb5s5_p86=${perc[173]}; M_Lb5s5_p87=${perc[175]}; M_Lb5s5_p88=${perc[177]}; M_Lb5s5_p89=${perc[179]}; M_Lb5s5_p90=${perc[181]};
M_Lb5s5_p91=${perc[183]}; M_Lb5s5_p92=${perc[185]}; M_Lb5s5_p93=${perc[187]}; M_Lb5s5_p94=${perc[189]}; M_Lb5s5_p95=${perc[191]}; M_Lb5s5_p96=${perc[193]}; M_Lb5s5_p97=${perc[195]}; M_Lb5s5_p98=${perc[197]}; M_Lb5s5_p99=${perc[199]}; M_Lb5s5_p100=${perc[201]};

########################## Single LC
# S L b0s0
#3dcalc -a $rest_dir/SE/fcon/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b0.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_S.LC.b0s0.nii
#3dBrickStat -mask mask_S.LC.b0s0.nii -non-zero -percentile 0 1 100 $rest_dir/SE/fcon/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b0.s0.derivs.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_S.LC.b0s0.1D
#hold=`cat percentiles_S.LC.b0s0.1D`; perc=($hold);
#S_Lb0s0_p0=${perc[1]}; S_Lb0s0_p1=${perc[3]}; S_Lb0s0_p2=${perc[5]}; S_Lb0s0_p3=${perc[7]}; S_Lb0s0_p4=${perc[9]}; S_Lb0s0_p5=${perc[11]}; S_Lb0s0_p6=${perc[13]}; S_Lb0s0_p7=${perc[15]}; S_Lb0s0_p8=${perc[17]}; S_Lb0s0_p9=${perc[19]}; S_Lb0s0_p10=${perc[21]};
#S_Lb0s0_p11=${perc[23]}; S_Lb0s0_p12=${perc[25]}; S_Lb0s0_p13=${perc[27]}; S_Lb0s0_p14=${perc[29]}; S_Lb0s0_p15=${perc[31]}; S_Lb0s0_p16=${perc[33]}; S_Lb0s0_p17=${perc[35]}; S_Lb0s0_p18=${perc[37]}; S_Lb0s0_p19=${perc[39]}; S_Lb0s0_p20=${perc[41]};
#S_Lb0s0_p21=${perc[43]}; S_Lb0s0_p22=${perc[45]}; S_Lb0s0_p23=${perc[47]}; S_Lb0s0_p24=${perc[49]}; S_Lb0s0_p25=${perc[51]}; S_Lb0s0_p26=${perc[53]}; S_Lb0s0_p27=${perc[55]}; S_Lb0s0_p28=${perc[57]}; S_Lb0s0_p29=${perc[59]}; S_Lb0s0_p30=${perc[61]};
#S_Lb0s0_p31=${perc[63]}; S_Lb0s0_p32=${perc[65]}; S_Lb0s0_p33=${perc[67]}; S_Lb0s0_p34=${perc[69]}; S_Lb0s0_p35=${perc[71]}; S_Lb0s0_p36=${perc[73]}; S_Lb0s0_p37=${perc[75]}; S_Lb0s0_p38=${perc[77]}; S_Lb0s0_p39=${perc[79]}; S_Lb0s0_p40=${perc[81]};
#S_Lb0s0_p41=${perc[83]}; S_Lb0s0_p42=${perc[85]}; S_Lb0s0_p43=${perc[87]}; S_Lb0s0_p44=${perc[89]}; S_Lb0s0_p45=${perc[91]}; S_Lb0s0_p46=${perc[93]}; S_Lb0s0_p47=${perc[95]}; S_Lb0s0_p48=${perc[97]}; S_Lb0s0_p49=${perc[99]}; S_Lb0s0_p50=${perc[101]};
#S_Lb0s0_p51=${perc[103]}; S_Lb0s0_p52=${perc[105]}; S_Lb0s0_p53=${perc[107]}; S_Lb0s0_p54=${perc[109]}; S_Lb0s0_p55=${perc[111]}; S_Lb0s0_p56=${perc[113]}; S_Lb0s0_p57=${perc[115]}; S_Lb0s0_p58=${perc[117]}; S_Lb0s0_p59=${perc[119]}; S_Lb0s0_p60=${perc[121]};
#S_Lb0s0_p61=${perc[123]}; S_Lb0s0_p62=${perc[125]}; S_Lb0s0_p63=${perc[127]}; S_Lb0s0_p64=${perc[129]}; S_Lb0s0_p65=${perc[131]}; S_Lb0s0_p66=${perc[133]}; S_Lb0s0_p67=${perc[135]}; S_Lb0s0_p68=${perc[137]}; S_Lb0s0_p69=${perc[139]}; S_Lb0s0_p70=${perc[141]};
#S_Lb0s0_p71=${perc[143]}; S_Lb0s0_p72=${perc[145]}; S_Lb0s0_p73=${perc[147]}; S_Lb0s0_p74=${perc[149]}; S_Lb0s0_p75=${perc[151]}; S_Lb0s0_p76=${perc[153]}; S_Lb0s0_p77=${perc[155]}; S_Lb0s0_p78=${perc[157]}; S_Lb0s0_p79=${perc[159]}; S_Lb0s0_p80=${perc[161]};
#S_Lb0s0_p81=${perc[163]}; S_Lb0s0_p82=${perc[165]}; S_Lb0s0_p83=${perc[167]}; S_Lb0s0_p84=${perc[169]}; S_Lb0s0_p85=${perc[171]}; S_Lb0s0_p86=${perc[173]}; S_Lb0s0_p87=${perc[175]}; S_Lb0s0_p88=${perc[177]}; S_Lb0s0_p89=${perc[179]}; S_Lb0s0_p90=${perc[181]};
#S_Lb0s0_p91=${perc[183]}; S_Lb0s0_p92=${perc[185]}; S_Lb0s0_p93=${perc[187]}; S_Lb0s0_p94=${perc[189]}; S_Lb0s0_p95=${perc[191]}; S_Lb0s0_p96=${perc[193]}; S_Lb0s0_p97=${perc[195]}; S_Lb0s0_p98=${perc[197]}; S_Lb0s0_p99=${perc[199]}; S_Lb0s0_p100=${perc[201]};

# S L b0s5
#3dcalc -a $rest_dir/SE/fcon/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b0.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_S.LC.b0s5.nii
#3dBrickStat -mask mask_S.LC.b0s5.nii -non-zero -percentile 0 1 100 $rest_dir/SE/fcon/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b0.s5.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_S.LC.b0s5.1D
#hold=`cat percentiles_S.LC.b0s5.1D`; perc=($hold);
#S_Lb0s5_p0=${perc[1]}; S_Lb0s5_p1=${perc[3]}; S_Lb0s5_p2=${perc[5]}; S_Lb0s5_p3=${perc[7]}; S_Lb0s5_p4=${perc[9]}; S_Lb0s5_p5=${perc[11]}; S_Lb0s5_p6=${perc[13]}; S_Lb0s5_p7=${perc[15]}; S_Lb0s5_p8=${perc[17]}; S_Lb0s5_p9=${perc[19]}; S_Lb0s5_p10=${perc[21]};
#S_Lb0s5_p11=${perc[23]}; S_Lb0s5_p12=${perc[25]}; S_Lb0s5_p13=${perc[27]}; S_Lb0s5_p14=${perc[29]}; S_Lb0s5_p15=${perc[31]}; S_Lb0s5_p16=${perc[33]}; S_Lb0s5_p17=${perc[35]}; S_Lb0s5_p18=${perc[37]}; S_Lb0s5_p19=${perc[39]}; S_Lb0s5_p20=${perc[41]};
#S_Lb0s5_p21=${perc[43]}; S_Lb0s5_p22=${perc[45]}; S_Lb0s5_p23=${perc[47]}; S_Lb0s5_p24=${perc[49]}; S_Lb0s5_p25=${perc[51]}; S_Lb0s5_p26=${perc[53]}; S_Lb0s5_p27=${perc[55]}; S_Lb0s5_p28=${perc[57]}; S_Lb0s5_p29=${perc[59]}; S_Lb0s5_p30=${perc[61]};
#S_Lb0s5_p31=${perc[63]}; S_Lb0s5_p32=${perc[65]}; S_Lb0s5_p33=${perc[67]}; S_Lb0s5_p34=${perc[69]}; S_Lb0s5_p35=${perc[71]}; S_Lb0s5_p36=${perc[73]}; S_Lb0s5_p37=${perc[75]}; S_Lb0s5_p38=${perc[77]}; S_Lb0s5_p39=${perc[79]}; S_Lb0s5_p40=${perc[81]};
#S_Lb0s5_p41=${perc[83]}; S_Lb0s5_p42=${perc[85]}; S_Lb0s5_p43=${perc[87]}; S_Lb0s5_p44=${perc[89]}; S_Lb0s5_p45=${perc[91]}; S_Lb0s5_p46=${perc[93]}; S_Lb0s5_p47=${perc[95]}; S_Lb0s5_p48=${perc[97]}; S_Lb0s5_p49=${perc[99]}; S_Lb0s5_p50=${perc[101]};
#S_Lb0s5_p51=${perc[103]}; S_Lb0s5_p52=${perc[105]}; S_Lb0s5_p53=${perc[107]}; S_Lb0s5_p54=${perc[109]}; S_Lb0s5_p55=${perc[111]}; S_Lb0s5_p56=${perc[113]}; S_Lb0s5_p57=${perc[115]}; S_Lb0s5_p58=${perc[117]}; S_Lb0s5_p59=${perc[119]}; S_Lb0s5_p60=${perc[121]};
#S_Lb0s5_p61=${perc[123]}; S_Lb0s5_p62=${perc[125]}; S_Lb0s5_p63=${perc[127]}; S_Lb0s5_p64=${perc[129]}; S_Lb0s5_p65=${perc[131]}; S_Lb0s5_p66=${perc[133]}; S_Lb0s5_p67=${perc[135]}; S_Lb0s5_p68=${perc[137]}; S_Lb0s5_p69=${perc[139]}; S_Lb0s5_p70=${perc[141]};
#S_Lb0s5_p71=${perc[143]}; S_Lb0s5_p72=${perc[145]}; S_Lb0s5_p73=${perc[147]}; S_Lb0s5_p74=${perc[149]}; S_Lb0s5_p75=${perc[151]}; S_Lb0s5_p76=${perc[153]}; S_Lb0s5_p77=${perc[155]}; S_Lb0s5_p78=${perc[157]}; S_Lb0s5_p79=${perc[159]}; S_Lb0s5_p80=${perc[161]};
#S_Lb0s5_p81=${perc[163]}; S_Lb0s5_p82=${perc[165]}; S_Lb0s5_p83=${perc[167]}; S_Lb0s5_p84=${perc[169]}; S_Lb0s5_p85=${perc[171]}; S_Lb0s5_p86=${perc[173]}; S_Lb0s5_p87=${perc[175]}; S_Lb0s5_p88=${perc[177]}; S_Lb0s5_p89=${perc[179]}; S_Lb0s5_p90=${perc[181]};
#S_Lb0s5_p91=${perc[183]}; S_Lb0s5_p92=${perc[185]}; S_Lb0s5_p93=${perc[187]}; S_Lb0s5_p94=${perc[189]}; S_Lb0s5_p95=${perc[191]}; S_Lb0s5_p96=${perc[193]}; S_Lb0s5_p97=${perc[195]}; S_Lb0s5_p98=${perc[197]}; S_Lb0s5_p99=${perc[199]}; S_Lb0s5_p100=${perc[201]};

# S L b5s0
3dcalc -a $rest_dir/SE/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_S.LC.b5s0.nii
3dBrickStat -mask mask_S.LC.b5s0.nii -non-zero -percentile 0 1 100 $rest_dir/SE/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_S.LC.b5s0.1D
hold=`cat percentiles_S.LC.b5s0.1D`; perc=($hold);
S_Lb5s0_p0=${perc[1]}; S_Lb5s0_p1=${perc[3]}; S_Lb5s0_p2=${perc[5]}; S_Lb5s0_p3=${perc[7]}; S_Lb5s0_p4=${perc[9]}; S_Lb5s0_p5=${perc[11]}; S_Lb5s0_p6=${perc[13]}; S_Lb5s0_p7=${perc[15]}; S_Lb5s0_p8=${perc[17]}; S_Lb5s0_p9=${perc[19]}; S_Lb5s0_p10=${perc[21]};
S_Lb5s0_p11=${perc[23]}; S_Lb5s0_p12=${perc[25]}; S_Lb5s0_p13=${perc[27]}; S_Lb5s0_p14=${perc[29]}; S_Lb5s0_p15=${perc[31]}; S_Lb5s0_p16=${perc[33]}; S_Lb5s0_p17=${perc[35]}; S_Lb5s0_p18=${perc[37]}; S_Lb5s0_p19=${perc[39]}; S_Lb5s0_p20=${perc[41]};
S_Lb5s0_p21=${perc[43]}; S_Lb5s0_p22=${perc[45]}; S_Lb5s0_p23=${perc[47]}; S_Lb5s0_p24=${perc[49]}; S_Lb5s0_p25=${perc[51]}; S_Lb5s0_p26=${perc[53]}; S_Lb5s0_p27=${perc[55]}; S_Lb5s0_p28=${perc[57]}; S_Lb5s0_p29=${perc[59]}; S_Lb5s0_p30=${perc[61]};
S_Lb5s0_p31=${perc[63]}; S_Lb5s0_p32=${perc[65]}; S_Lb5s0_p33=${perc[67]}; S_Lb5s0_p34=${perc[69]}; S_Lb5s0_p35=${perc[71]}; S_Lb5s0_p36=${perc[73]}; S_Lb5s0_p37=${perc[75]}; S_Lb5s0_p38=${perc[77]}; S_Lb5s0_p39=${perc[79]}; S_Lb5s0_p40=${perc[81]};
S_Lb5s0_p41=${perc[83]}; S_Lb5s0_p42=${perc[85]}; S_Lb5s0_p43=${perc[87]}; S_Lb5s0_p44=${perc[89]}; S_Lb5s0_p45=${perc[91]}; S_Lb5s0_p46=${perc[93]}; S_Lb5s0_p47=${perc[95]}; S_Lb5s0_p48=${perc[97]}; S_Lb5s0_p49=${perc[99]}; S_Lb5s0_p50=${perc[101]};
S_Lb5s0_p51=${perc[103]}; S_Lb5s0_p52=${perc[105]}; S_Lb5s0_p53=${perc[107]}; S_Lb5s0_p54=${perc[109]}; S_Lb5s0_p55=${perc[111]}; S_Lb5s0_p56=${perc[113]}; S_Lb5s0_p57=${perc[115]}; S_Lb5s0_p58=${perc[117]}; S_Lb5s0_p59=${perc[119]}; S_Lb5s0_p60=${perc[121]};
S_Lb5s0_p61=${perc[123]}; S_Lb5s0_p62=${perc[125]}; S_Lb5s0_p63=${perc[127]}; S_Lb5s0_p64=${perc[129]}; S_Lb5s0_p65=${perc[131]}; S_Lb5s0_p66=${perc[133]}; S_Lb5s0_p67=${perc[135]}; S_Lb5s0_p68=${perc[137]}; S_Lb5s0_p69=${perc[139]}; S_Lb5s0_p70=${perc[141]};
S_Lb5s0_p71=${perc[143]}; S_Lb5s0_p72=${perc[145]}; S_Lb5s0_p73=${perc[147]}; S_Lb5s0_p74=${perc[149]}; S_Lb5s0_p75=${perc[151]}; S_Lb5s0_p76=${perc[153]}; S_Lb5s0_p77=${perc[155]}; S_Lb5s0_p78=${perc[157]}; S_Lb5s0_p79=${perc[159]}; S_Lb5s0_p80=${perc[161]};
S_Lb5s0_p81=${perc[163]}; S_Lb5s0_p82=${perc[165]}; S_Lb5s0_p83=${perc[167]}; S_Lb5s0_p84=${perc[169]}; S_Lb5s0_p85=${perc[171]}; S_Lb5s0_p86=${perc[173]}; S_Lb5s0_p87=${perc[175]}; S_Lb5s0_p88=${perc[177]}; S_Lb5s0_p89=${perc[179]}; S_Lb5s0_p90=${perc[181]};
S_Lb5s0_p91=${perc[183]}; S_Lb5s0_p92=${perc[185]}; S_Lb5s0_p93=${perc[187]}; S_Lb5s0_p94=${perc[189]}; S_Lb5s0_p95=${perc[191]}; S_Lb5s0_p96=${perc[193]}; S_Lb5s0_p97=${perc[195]}; S_Lb5s0_p98=${perc[197]}; S_Lb5s0_p99=${perc[199]}; S_Lb5s0_p100=${perc[201]};

# S L b5s5
3dcalc -a $rest_dir/SE/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b $rest_dir/ME/rois/mask_LCoverlap.${subj_name}_rest_mni.frac.nii -expr 'notzero(a)*iszero(b)' -prefix mask_S.LC.b5s5.nii
3dBrickStat -mask mask_S.LC.b5s5.nii -non-zero -percentile 0 1 100 $rest_dir/SE/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii > percentiles_S.LC.b5s5.1D
hold=`cat percentiles_S.LC.b5s5.1D`; perc=($hold);
S_Lb5s5_p0=${perc[1]}; S_Lb5s5_p1=${perc[3]}; S_Lb5s5_p2=${perc[5]}; S_Lb5s5_p3=${perc[7]}; S_Lb5s5_p4=${perc[9]}; S_Lb5s5_p5=${perc[11]}; S_Lb5s5_p6=${perc[13]}; S_Lb5s5_p7=${perc[15]}; S_Lb5s5_p8=${perc[17]}; S_Lb5s5_p9=${perc[19]}; S_Lb5s5_p10=${perc[21]};
S_Lb5s5_p11=${perc[23]}; S_Lb5s5_p12=${perc[25]}; S_Lb5s5_p13=${perc[27]}; S_Lb5s5_p14=${perc[29]}; S_Lb5s5_p15=${perc[31]}; S_Lb5s5_p16=${perc[33]}; S_Lb5s5_p17=${perc[35]}; S_Lb5s5_p18=${perc[37]}; S_Lb5s5_p19=${perc[39]}; S_Lb5s5_p20=${perc[41]};
S_Lb5s5_p21=${perc[43]}; S_Lb5s5_p22=${perc[45]}; S_Lb5s5_p23=${perc[47]}; S_Lb5s5_p24=${perc[49]}; S_Lb5s5_p25=${perc[51]}; S_Lb5s5_p26=${perc[53]}; S_Lb5s5_p27=${perc[55]}; S_Lb5s5_p28=${perc[57]}; S_Lb5s5_p29=${perc[59]}; S_Lb5s5_p30=${perc[61]};
S_Lb5s5_p31=${perc[63]}; S_Lb5s5_p32=${perc[65]}; S_Lb5s5_p33=${perc[67]}; S_Lb5s5_p34=${perc[69]}; S_Lb5s5_p35=${perc[71]}; S_Lb5s5_p36=${perc[73]}; S_Lb5s5_p37=${perc[75]}; S_Lb5s5_p38=${perc[77]}; S_Lb5s5_p39=${perc[79]}; S_Lb5s5_p40=${perc[81]};
S_Lb5s5_p41=${perc[83]}; S_Lb5s5_p42=${perc[85]}; S_Lb5s5_p43=${perc[87]}; S_Lb5s5_p44=${perc[89]}; S_Lb5s5_p45=${perc[91]}; S_Lb5s5_p46=${perc[93]}; S_Lb5s5_p47=${perc[95]}; S_Lb5s5_p48=${perc[97]}; S_Lb5s5_p49=${perc[99]}; S_Lb5s5_p50=${perc[101]};
S_Lb5s5_p51=${perc[103]}; S_Lb5s5_p52=${perc[105]}; S_Lb5s5_p53=${perc[107]}; S_Lb5s5_p54=${perc[109]}; S_Lb5s5_p55=${perc[111]}; S_Lb5s5_p56=${perc[113]}; S_Lb5s5_p57=${perc[115]}; S_Lb5s5_p58=${perc[117]}; S_Lb5s5_p59=${perc[119]}; S_Lb5s5_p60=${perc[121]};
S_Lb5s5_p61=${perc[123]}; S_Lb5s5_p62=${perc[125]}; S_Lb5s5_p63=${perc[127]}; S_Lb5s5_p64=${perc[129]}; S_Lb5s5_p65=${perc[131]}; S_Lb5s5_p66=${perc[133]}; S_Lb5s5_p67=${perc[135]}; S_Lb5s5_p68=${perc[137]}; S_Lb5s5_p69=${perc[139]}; S_Lb5s5_p70=${perc[141]};
S_Lb5s5_p71=${perc[143]}; S_Lb5s5_p72=${perc[145]}; S_Lb5s5_p73=${perc[147]}; S_Lb5s5_p74=${perc[149]}; S_Lb5s5_p75=${perc[151]}; S_Lb5s5_p76=${perc[153]}; S_Lb5s5_p77=${perc[155]}; S_Lb5s5_p78=${perc[157]}; S_Lb5s5_p79=${perc[159]}; S_Lb5s5_p80=${perc[161]};
S_Lb5s5_p81=${perc[163]}; S_Lb5s5_p82=${perc[165]}; S_Lb5s5_p83=${perc[167]}; S_Lb5s5_p84=${perc[169]}; S_Lb5s5_p85=${perc[171]}; S_Lb5s5_p86=${perc[173]}; S_Lb5s5_p87=${perc[175]}; S_Lb5s5_p88=${perc[177]}; S_Lb5s5_p89=${perc[179]}; S_Lb5s5_p90=${perc[181]};
S_Lb5s5_p91=${perc[183]}; S_Lb5s5_p92=${perc[185]}; S_Lb5s5_p93=${perc[187]}; S_Lb5s5_p94=${perc[189]}; S_Lb5s5_p95=${perc[191]}; S_Lb5s5_p96=${perc[193]}; S_Lb5s5_p97=${perc[195]}; S_Lb5s5_p98=${perc[197]}; S_Lb5s5_p99=${perc[199]}; S_Lb5s5_p100=${perc[201]};


########################## Compute overlaps
# M K 50, S K 50
for percentile in `seq 0 1 99`;
do
    this_tile=M_Kb5s0_p${percentile}
    3dcalc -overwrite -a $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_M.K1.b5s0.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.M.K1.b5s0.p${percentile}.nii

    this_tile=S_Kb5s0_p${percentile}
    3dcalc -overwrite -a $rest_dir/SE/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_S.K1.b5s0.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.S.K1.b5s0.p${percentile}.nii

    3ddot -dodice rmx.M.K1.b5s0.p${percentile}.nii rmx.S.K1.b5s0.p${percentile}.nii >> hold.X.K1.b5s0.txt
done
rm rmx.*

# M K 55, S K 55
for percentile in `seq 0 1 99`;
do
    this_tile=M_Kb5s5_p${percentile}
    3dcalc -overwrite -a $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_M.K1.b5s5.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.M.K1.b5s5.p${percentile}.nii

    this_tile=S_Kb5s5_p${percentile}
    3dcalc -overwrite -a $rest_dir/SE/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_S.K1.b5s5.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.S.K1.b5s5.p${percentile}.nii

    3ddot -dodice rmx.M.K1.b5s5.p${percentile}.nii rmx.S.K1.b5s5.p${percentile}.nii >> hold.X.K1.b5s5.txt
done
rm rmx.*

# M K 50, M L 50
for percentile in `seq 0 1 99`;
do
    this_tile=M_Kb5s0_p${percentile}
    3dcalc -overwrite -a $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_M.K1.b5s0.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.M.K1.b5s0.p${percentile}.nii

    this_tile=M_Lb5s0_p${percentile}
    3dcalc -overwrite -a $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_M.LC.b5s0.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.M.LC.b5s0.p${percentile}.nii

    3ddot -dodice rmx.M.K1.b5s0.p${percentile}.nii rmx.M.LC.b5s0.p${percentile}.nii >> hold.M.K1_LC.b5s0.txt
done
rm rmx.*

# M K 55, M L 55
for percentile in `seq 0 1 99`;
do
    this_tile=M_Kb5s5_p${percentile}
    3dcalc -overwrite -a $rest_dir/ME/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_M.K1.b5s5.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.M.K1.b5s5.p${percentile}.nii

    this_tile=M_Lb5s5_p${percentile}
    3dcalc -overwrite -a $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_M.LC.b5s5.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.M.LC.b5s5.p${percentile}.nii

    3ddot -dodice rmx.M.K1.b5s5.p${percentile}.nii rmx.M.LC.b5s5.p${percentile}.nii >> hold.M.K1_LC.b5s5.txt
done
rm rmx.*

# S K 50, S L 50
for percentile in `seq 0 1 99`;
do
    this_tile=S_Kb5s0_p${percentile}
    3dcalc -overwrite -a $rest_dir/SE/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_S.K1.b5s0.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.S.K1.b5s0.p${percentile}.nii

    this_tile=S_Lb5s0_p${percentile}
    3dcalc -overwrite -a $rest_dir/SE/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_S.LC.b5s0.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.S.LC.b5s0.p${percentile}.nii

    3ddot -dodice rmx.S.K1.b5s0.p${percentile}.nii rmx.S.LC.b5s0.p${percentile}.nii >> hold.S.K1_LC.b5s0.txt
done
rm rmx.*

# S K 55, S L 55
for percentile in `seq 0 1 99`;
do
    this_tile=S_Kb5s5_p${percentile}
    3dcalc -overwrite -a $rest_dir/SE/fcon/ZTcorr1D_Keren1SD.rest.${subj_name}_mni_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_S.K1.b5s5.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.S.K1.b5s5.p${percentile}.nii

    this_tile=S_Lb5s5_p${percentile}
    3dcalc -overwrite -a $rest_dir/SE/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_S.LC.b5s5.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.S.LC.b5s5.p${percentile}.nii

    3ddot -dodice rmx.S.K1.b5s5.p${percentile}.nii rmx.S.LC.b5s5.p${percentile}.nii >> hold.S.K1_LC.b5s5.txt
done
rm rmx.*

# M L 50, S L 50
for percentile in `seq 0 1 99`;
do
    this_tile=M_Lb5s0_p${percentile}
    3dcalc -overwrite -a $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_M.LC.b5s0.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.M.LC.b5s0.p${percentile}.nii

    this_tile=S_Lb5s0_p${percentile}
    3dcalc -overwrite -a $rest_dir/SE/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_S.LC.b5s0.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.S.LC.b5s0.p${percentile}.nii

    3ddot -dodice rmx.M.LC.b5s0.p${percentile}.nii rmx.S.LC.b5s0.p${percentile}.nii >> hold.X.LC.b5s0.txt
done
rm rmx.*

# M L 55, S L 55
for percentile in `seq 0 1 99`;
do
    this_tile=M_Lb5s5_p${percentile}
    3dcalc -overwrite -a $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_M.LC.b5s5.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.M.LC.b5s5.p${percentile}.nii

    this_tile=S_Lb5s5_p${percentile}
    3dcalc -overwrite -a $rest_dir/SE/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_S.LC.b5s5.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.S.LC.b5s5.p${percentile}.nii

    3ddot -dodice rmx.M.LC.b5s5.p${percentile}.nii rmx.S.LC.b5s5.p${percentile}.nii >> hold.X.LC.b5s5.txt
done
rm rmx.*

# M L 55, M L 50
for percentile in `seq 0 1 99`;
do
    this_tile=M_Lb5s5_p${percentile}
    3dcalc -overwrite -a $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s5.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_M.LC.b5s5.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.M.LC.b5s5.p${percentile}.nii

    this_tile=M_Lb5s0_p${percentile}
    3dcalc -overwrite -a $rest_dir/ME/fcon/ZTcorr1D_LCoverlap.rest.${subj_name}_nat_b5.s0.WM_1.GSR_0.tproj.NTRP.frac.nii -b mask_M.LC.b5s0.nii -expr 'step(b)*ispositive(a-'${!this_tile}')' -prefix rmx.M.LC.b5s0.p${percentile}.nii

    3ddot -dodice rmx.M.LC.b5s5.p${percentile}.nii rmx.M.LC.b5s0.p${percentile}.nii >> hold.B.LC.b5s50.txt
done
rm rmx.*


########################## Format overlaps
awk '{OFS=","} {print "'$subj'",$0}' hold.M.K1_LC.b5s0.txt > M.K1_LC.b5s0.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.M.K1_LC.b5s5.txt > M.K1_LC.b5s5.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.S.K1_LC.b5s0.txt > S.K1_LC.b5s0.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.S.K1_LC.b5s5.txt > S.K1_LC.b5s5.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.X.K1.b5s0.txt > X.K1.b5s0.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.X.K1.b5s5.txt > X.K1.b5s5.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.X.LC.b5s0.txt > X.LC.b5s0.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.X.LC.b5s5.txt > X.LC.b5s5.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.B.LC.b5s50.txt > B.LC.b5s50.txt



echo   "++++++++++++++++++++++++"
echo   "Housekeeping"
rm hold*
cd ../../final_scripts

end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end





