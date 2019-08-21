#!/usr/bin/bash -f

# Compile DVARS data
# July 20 2019 - HBT

work_dir=/home/fMRI/projects/tempAttnAudT/analysis/univariate/rest_results/
cd ${work_dir}analysis

wm=1
gsr=0


out_file=compiled_dvars_tproj.wmr${wm}_gsr${gsr}.txt
header="Subj,Prep,Blur,ROI,Beta"
echo $header > $out_file


for subj in `seq 7 27`; do
for prep in ME SE; do
for roi in whole K1 K2 LC PT; do
for blur in 0 5; do

    base_dir=${work_dir}analysis/dvars/

    awk '{OFS=","} {print "'$subj'","'$prep'","'$blur'","'$roi'",$0}' dvars_tproj.tAATs${subj}.${prep}.b${blur}.${roi}.wm${wm}.gsr${gsr}.1D >> $out_file

done
done
done
done


wm=1
gsr=0


out_file=compiled_srms_tproj.wmr${wm}_gsr${gsr}.txt
header="Subj,Prep,Blur,ROI,Beta"
echo $header > $out_file


for subj in `seq 7 27`; do
for prep in ME SE; do
for roi in whole K1 K2 LC PT; do
for blur in 0 5; do

base_dir=${work_dir}analysis/dvars/

awk '{OFS=","} {print "'$subj'","'$prep'","'$blur'","'$roi'",$0}' srms_tproj.tAATs${subj}.${prep}.b${blur}.${roi}.wm${wm}.gsr${gsr}.1D >> $out_file

done
done
done
done

