#!/usr/bin/bash -f

# Take the overlaps for each subject and awk it all into a common textfile
# By HBT, Feb 26 2019


work_dir=/home/fMRI/projects/tempAttnAudT/analysis/univariate/rest_results/
cd ${work_dir}analysis/overlaps

out_file1=compiled_PT.M.K1_LC.b5s0.txt
out_file2=compiled_PT.M.K1_LC.b5s5.txt
out_file3=compiled_PT.S.K1_LC.b5s0.txt
out_file4=compiled_PT.S.K1_LC.b5s5.txt
out_file5=compiled_PT.X.K1.b5s0.txt
out_file6=compiled_PT.X.K1.b5s5.txt
out_file7=compiled_PT.X.LC.b5s0.txt
out_file8=compiled_PT.X.LC.b5s5.txt

header="Subj,Dice,Iter"
echo $header > $out_file1
echo $header > $out_file2
echo $header > $out_file3
echo $header > $out_file4
echo $header > $out_file5
echo $header > $out_file6
echo $header > $out_file7
echo $header > $out_file8


for subj in `seq 7 27`; do
for iter in `seq 1 10`; do
base_dir=${work_dir}tAATs${subj}/Overlap/PT_dice_controls/
awk '{FS=",";OFS=","} {print $0,'${iter}'}' $base_dir/M.K1_LC.b5s0.iter${iter}.txt >> $out_file1
awk '{FS=",";OFS=","} {print $0,'${iter}'}' $base_dir/M.K1_LC.b5s5.iter${iter}.txt >> $out_file2
awk '{FS=",";OFS=","} {print $0,'${iter}'}' $base_dir/S.K1_LC.b5s0.iter${iter}.txt >> $out_file3
awk '{FS=",";OFS=","} {print $0,'${iter}'}' $base_dir/S.K1_LC.b5s5.iter${iter}.txt >> $out_file4
awk '{FS=",";OFS=","} {print $0,'${iter}'}' $base_dir/X.K1.b5s0.iter${iter}.txt >> $out_file5
awk '{FS=",";OFS=","} {print $0,'${iter}'}' $base_dir/X.K1.b5s5.iter${iter}.txt >> $out_file6
awk '{FS=",";OFS=","} {print $0,'${iter}'}' $base_dir/X.LC.b5s0.iter${iter}.txt >> $out_file7
awk '{FS=",";OFS=","} {print $0,'${iter}'}' $base_dir/X.LC.b5s5.iter${iter}.txt >> $out_file8
done
done
