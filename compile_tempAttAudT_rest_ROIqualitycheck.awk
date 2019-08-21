#!/usr/bin/bash -f

# Take the time series for each ROI, for each preprocessing method, for each subject and awk it all into a textfile
# July 13 2019, HBT

work_dir=/home/fMRI/projects/tempAttnAudT/analysis/univariate/rest_results/
cd ${work_dir}analysis

wm=1
gsr=0
cenmode=NTRP

out_file=compiled_ROIqualitycheck.WM_$wm.GSR_$gsr.txt
header="Subj,Prep,ROI,Blur,Beta"
echo $header > $out_file

for subj in `seq 7 27`; do
    base_dir=${work_dir}tAATs${subj}/

    awk '{OFS=","} {print "'$subj'","echo2","K1","Blur0",$0}' ${base_dir}/SE/fcon/seed_Keren1SD.tAATs${subj}_e2_mni_seed0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","echo2","K2","Blur0",$0}' ${base_dir}/SE/fcon/seed_Keren2SD.tAATs${subj}_e2_mni_seed0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","echo2","LC","Blur0",$0}' ${base_dir}/SE/fcon/seed_traceLC.tAATs${subj}_e2_nat_seed0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","echo2","PT","Blur0",$0}' ${base_dir}/Overlap/PT/seed_PT.SE.tAATs${subj}_e2_nat_seed0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file

    awk '{OFS=","} {print "'$subj'","echo2","K1","Blur5",$0}' ${base_dir}/SE/fcon/seed_Keren1SD.tAATs${subj}_e2_mni_seed5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","echo2","K2","Blur5",$0}' ${base_dir}/SE/fcon/seed_Keren2SD.tAATs${subj}_e2_mni_seed5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","echo2","LC","Blur5",$0}' ${base_dir}/SE/fcon/seed_traceLC.tAATs${subj}_e2_nat_seed5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","echo2","PT","Blur5",$0}' ${base_dir}/Overlap/PT/seed_PT.SE.tAATs${subj}_e2_nat_seed5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file


    awk '{OFS=","} {print "'$subj'","medn","K1","Blur0",$0}' ${base_dir}/ME/fcon/seed_Keren1SD.tAATs${subj}_medn_mni_seed0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","medn","K2","Blur0",$0}' ${base_dir}/ME/fcon/seed_Keren2SD.tAATs${subj}_medn_mni_seed0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","medn","LC","Blur0",$0}' ${base_dir}/ME/fcon/seed_traceLC.tAATs${subj}_medn_nat_seed0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","medn","PT","Blur0",$0}' ${base_dir}/Overlap/PT/seed_PT.ME.tAATs${subj}_medn_nat_seed0.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file

    awk '{OFS=","} {print "'$subj'","medn","K1","Blur5",$0}' ${base_dir}/ME/fcon/seed_Keren1SD.tAATs${subj}_medn_mni_seed5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","medn","K2","Blur5",$0}' ${base_dir}/ME/fcon/seed_Keren2SD.tAATs${subj}_medn_mni_seed5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","medn","LC","Blur5",$0}' ${base_dir}/ME/fcon/seed_traceLC.tAATs${subj}_medn_nat_seed5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","medn","PT","Blur5",$0}' ${base_dir}/Overlap/PT/seed_PT.ME.tAATs${subj}_medn_nat_seed5.WM_${wm}.GSR_${gsr}.tproj.${cenmode}.frac.1D >> $out_file
done

