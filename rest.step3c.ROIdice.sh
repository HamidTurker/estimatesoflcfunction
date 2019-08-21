# Resting state analysis - generate info to create overlap/percentile figures
# execute via:
# ./rest.fcon.analysis.overlap.sh s??
# 9 December 2018 - HBT
#
# =========================== setup ============================
start=`date '+%m %d %Y at %H %M %S'`

set -e
jobs=4

k1_dir=/home/fMRI/projects/tempAttnAudT/analysis/LC_maps
lc_dir=/home/fMRI/projects/tempAttnAudT/analysis/tse/heatmap

3dresample -rmode NN -input LC_1SD_BINARY_TEMPLATE.nii -master LCx_ROI_overlap_inMNI_thresh_tAATs7.nii -prefix K1.nii

for subj in `seq 7 1 27`; do

    3ddot -dodice $k1_dir/LC_1SD_BINARY_TEMPLATE.nii $lc_dir/LCx_ROI_overlap_inMNI_thresh_tAATs${subj}.nii

done

########################## Format overlaps
awk '{OFS=","} {print "'$subj'",$0}' hold.M.K1_LC.b5s0.txt > M.K1_LC.b5s0.iter${iter_val}.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.M.K1_LC.b5s5.txt > M.K1_LC.b5s5.iter${iter_val}.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.S.K1_LC.b5s0.txt > S.K1_LC.b5s0.iter${iter_val}.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.S.K1_LC.b5s5.txt > S.K1_LC.b5s5.iter${iter_val}.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.X.K1.b5s0.txt > X.K1.b5s0.iter${iter_val}.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.X.K1.b5s5.txt > X.K1.b5s5.iter${iter_val}.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.X.LC.b5s0.txt > X.LC.b5s0.iter${iter_val}.txt
awk '{OFS=","} {print "'$subj'",$0}' hold.X.LC.b5s5.txt > X.LC.b5s5.iter${iter_val}.txt



echo   "++++++++++++++++++++++++"
echo   "Housekeeping"
rm hold*
rm mask*
rm percentiles*
done

cd ../../

end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end





3dresample -rmode NN -input LC_1SD_BINARY_TEMPLATE.nii -master LCx_ROI_overlap_inMNI_thresh_tAATs7.nii -prefix K1.nii

out=dice.txt
echo "" > dice.txt

for subj in `seq 7 1 27`; do
    3ddot -dodice K1.nii LCx_ROI_overlap_inMNI_thresh_tAATs$subj.nii
done

3ddot -dodice K1.nii LCx_ROI_overlap_inMNI_thresh_tAATs7.nii
3ddot -dodice K1.nii LCx_ROI_overlap_inMNI_thresh_tAATs9.nii
3ddot -dodice K1.nii LCx_ROI_overlap_inMNI_thresh_tAATs10.nii
3ddot -dodice K1.nii LCx_ROI_overlap_inMNI_thresh_tAATs11.nii