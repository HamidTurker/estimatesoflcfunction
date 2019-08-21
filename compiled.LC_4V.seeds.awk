#!/usr/bin/bash -f

# Take the time series for each ROI, for each preprocessing method, for each subject and awk it all into a textfile
# By HBT, Oct 16 2018

work_dir=/home/fMRI/projects/tempAttnAudT/analysis/univariate/rest_results/
cd ${work_dir}analysis

out_file=compiled.LC_4V.seeds.txt
header="Subj,ROI,Space,Blur,WMR,GSR,Beta"
echo $header > $out_file

for subj in `seq 7 27`; do
    base_dir=${work_dir}tAATs${subj}/SE/fcon/

    awk '{OFS=","} {print "'$subj'","4v","nat","blur0","wmr0","gsr0",$0}' ${base_dir}seed_4V.tAATs${subj}.blur0.WM_0.GSR_0.tproj.NTRP.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","nat","blur5","wmr0","gsr0",$0}' ${base_dir}seed_4V.tAATs${subj}.blur5.WM_0.GSR_0.tproj.NTRP.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","nat","blur0","wmr1","gsr0",$0}' ${base_dir}seed_4V.tAATs${subj}.blur0.WM_1.GSR_0.tproj.NTRP.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","nat","blur5","wmr1","gsr0",$0}' ${base_dir}seed_4V.tAATs${subj}.blur5.WM_1.GSR_0.tproj.NTRP.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","nat","blur0","wmr0","gsr1",$0}' ${base_dir}seed_4V.tAATs${subj}.blur0.WM_0.GSR_1.tproj.NTRP.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","nat","blur5","wmr0","gsr1",$0}' ${base_dir}seed_4V.tAATs${subj}.blur5.WM_0.GSR_1.tproj.NTRP.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","nat","blur0","wmr1","gsr1",$0}' ${base_dir}seed_4V.tAATs${subj}.blur0.WM_1.GSR_1.tproj.NTRP.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","nat","blur5","wmr1","gsr1",$0}' ${base_dir}seed_4V.tAATs${subj}.blur5.WM_1.GSR_1.tproj.NTRP.nat.1D >> $out_file

    awk '{OFS=","} {print "'$subj'","4v","tse","blur0","wmr0","gsr0",$0}' ${base_dir}seed_4V.tAATs${subj}.blur0.WM_0.GSR_0.tproj.NTRP.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","tse","blur5","wmr0","gsr0",$0}' ${base_dir}seed_4V.tAATs${subj}.blur5.WM_0.GSR_0.tproj.NTRP.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","tse","blur0","wmr1","gsr0",$0}' ${base_dir}seed_4V.tAATs${subj}.blur0.WM_1.GSR_0.tproj.NTRP.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","tse","blur5","wmr1","gsr0",$0}' ${base_dir}seed_4V.tAATs${subj}.blur5.WM_1.GSR_0.tproj.NTRP.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","tse","blur0","wmr0","gsr1",$0}' ${base_dir}seed_4V.tAATs${subj}.blur0.WM_0.GSR_1.tproj.NTRP.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","tse","blur5","wmr0","gsr1",$0}' ${base_dir}seed_4V.tAATs${subj}.blur5.WM_0.GSR_1.tproj.NTRP.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","tse","blur0","wmr1","gsr1",$0}' ${base_dir}seed_4V.tAATs${subj}.blur0.WM_1.GSR_1.tproj.NTRP.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","4v","tse","blur5","wmr1","gsr1",$0}' ${base_dir}seed_4V.tAATs${subj}.blur5.WM_1.GSR_1.tproj.NTRP.tse.1D >> $out_file

    awk '{OFS=","} {print "'$subj'","LC","nat","blur0","wmr0","gsr0",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur0.WM_0.GSR_0.tproj.NTRP.frac.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","nat","blur5","wmr0","gsr0",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur5.WM_0.GSR_0.tproj.NTRP.frac.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","nat","blur0","wmr1","gsr0",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur0.WM_1.GSR_0.tproj.NTRP.frac.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","nat","blur5","wmr1","gsr0",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur5.WM_1.GSR_0.tproj.NTRP.frac.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","nat","blur0","wmr0","gsr1",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur0.WM_0.GSR_1.tproj.NTRP.frac.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","nat","blur5","wmr0","gsr1",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur5.WM_0.GSR_1.tproj.NTRP.frac.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","nat","blur0","wmr1","gsr1",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur0.WM_1.GSR_1.tproj.NTRP.frac.nat.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","nat","blur5","wmr1","gsr1",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur5.WM_1.GSR_1.tproj.NTRP.frac.nat.1D >> $out_file

    awk '{OFS=","} {print "'$subj'","LC","tse","blur0","wmr0","gsr0",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur0.WM_0.GSR_0.tproj.NTRP.frac.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","tse","blur5","wmr0","gsr0",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur5.WM_0.GSR_0.tproj.NTRP.frac.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","tse","blur0","wmr1","gsr0",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur0.WM_1.GSR_0.tproj.NTRP.frac.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","tse","blur5","wmr1","gsr0",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur5.WM_1.GSR_0.tproj.NTRP.frac.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","tse","blur0","wmr0","gsr1",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur0.WM_0.GSR_1.tproj.NTRP.frac.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","tse","blur5","wmr0","gsr1",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur5.WM_0.GSR_1.tproj.NTRP.frac.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","tse","blur0","wmr1","gsr1",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur0.WM_1.GSR_1.tproj.NTRP.frac.tse.1D >> $out_file
    awk '{OFS=","} {print "'$subj'","LC","tse","blur5","wmr1","gsr1",$0}' ${base_dir}seed_traceLC.tAATs${subj}.blur5.WM_1.GSR_1.tproj.NTRP.frac.tse.1D >> $out_file

done