#!/usr/bin/bash -f

# Compile tSNR data
# July 11 2019 - HBT

work_dir=/home/fMRI/projects/tempAttnAudT/analysis/univariate/rest_results/
cd ${work_dir}analysis

wm=1
gsr=0
blur=0

out_file=compiled_tsnr_wmr${wm}_gsr${gsr}_blur${blur}.txt
header="Subj,Prep,Type,ROI,Beta"
echo $header > $out_file


for subj in `seq 7 27`; do

    for roi in GM HPC precentral transtemp V1 vmPFC LC WM; do
        base_dir=${work_dir}tAATs${subj}/SE/tsnr/
        awk '{OFS=","} {print "'$subj'","echo2","both","'$roi'",$0}' ${base_dir}tsnr_tstat.nat.Deriv_1.WM_$wm.GSR_$gsr.blur$blur.${roi}.1D >> $out_file
    done

    for roi in GM HPC precentral transtemp V1 vmPFC LC WM; do
        base_dir=${work_dir}tAATs${subj}/SE/alt/
        awk '{OFS=","} {print "'$subj'","echo2","4v","'$roi'",$0}' ${base_dir}tsnr_tstat.4v.nat.Deriv_1.WM_$wm.GSR_$gsr.blur$blur.${roi}.1D >> $out_file
    done

    for roi in GM HPC precentral transtemp V1 vmPFC LC WM; do
        base_dir=${work_dir}tAATs${subj}/SE/alt/
        awk '{OFS=","} {print "'$subj'","echo2","none","'$roi'",$0}' ${base_dir}tsnr_tstat.none.nat.Deriv_1.WM_$wm.GSR_$gsr.blur$blur.${roi}.1D >> $out_file
    done

    for roi in GM HPC precentral transtemp V1 vmPFC LC WM; do
        base_dir=${work_dir}tAATs${subj}/SE/alt/
        awk '{OFS=","} {print "'$subj'","echo2","ricor","'$roi'",$0}' ${base_dir}tsnr_tstat.RICOR.nat.Deriv_1.WM_$wm.GSR_$gsr.blur$blur.${roi}.1D >> $out_file
    done


    for roi in GM HPC precentral transtemp V1 vmPFC LC WM; do
        base_dir=${work_dir}tAATs${subj}/ME/tsnr/
    awk '{OFS=","} {print "'$subj'","medn","medn","'$roi'",$0}' ${base_dir}tsnr_tstat.nat.Deriv_0.WM_$wm.GSR_$gsr.blur$blur.${roi}.1D >> $out_file
    done

done

