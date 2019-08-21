#!/usr/bin/bash -f

# Take the overlaps for each subject and awk it all into a common textfile
# By HBT, Feb 26 2019

work_dir=/home/fMRI/projects/tempAttnAudT/analysis/univariate/rest_results/
cd ${work_dir}analysis/overlap

out_file1=compiled_M.K1_LC.b5s0.txt
out_file2=compiled_M.K1_LC.b5s5.txt
out_file3=compiled_S.K1_LC.b5s0.txt
out_file4=compiled_S.K1_LC.b5s5.txt
out_file5=compiled_X.K1.b5s0.txt
out_file6=compiled_X.K1.b5s5.txt
out_file7=compiled_X.LC.b5s0.txt
out_file8=compiled_X.LC.b5s5.txt
out_file9=compiled_B.LC.b5s50.txt



header="Subj,Dice"
echo $header > $out_file1
echo $header > $out_file2
echo $header > $out_file3
echo $header > $out_file4
echo $header > $out_file5
echo $header > $out_file6
echo $header > $out_file7
echo $header > $out_file8
echo $header > $out_file9


for subj in `seq 7 27`; do
    base_dir=${work_dir}tAATs${subj}/Overlap
    awk '{OFS=","} {print $0}' $base_dir/M.K1_LC.b5s0.txt >> $out_file1
    awk '{OFS=","} {print $0}' $base_dir/M.K1_LC.b5s5.txt >> $out_file2
    awk '{OFS=","} {print $0}' $base_dir/S.K1_LC.b5s0.txt >> $out_file3
    awk '{OFS=","} {print $0}' $base_dir/S.K1_LC.b5s5.txt >> $out_file4
    awk '{OFS=","} {print $0}' $base_dir/X.K1.b5s0.txt >> $out_file5
    awk '{OFS=","} {print $0}' $base_dir/X.K1.b5s5.txt >> $out_file6
    awk '{OFS=","} {print $0}' $base_dir/X.LC.b5s0.txt >> $out_file7
    awk '{OFS=","} {print $0}' $base_dir/X.LC.b5s5.txt >> $out_file8
    awk '{OFS=","} {print $0}' $base_dir/B.LC.b5s50.txt >> $out_file9
done

