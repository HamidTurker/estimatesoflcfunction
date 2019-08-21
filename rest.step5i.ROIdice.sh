# Resting state analysis - preprocessing
# execute via:
# ./rest.step9.DVARS.sh
# July 17 2019 - HBT
#
# Calculate the DVARS for all subjects - ME vs SE
# =========================== setup ============================
start=`date '+%m %d %Y at %H %M %S'`

for subj in `seq 7 1 27`; do
    base_dir=/home/fMRI/projects/tempAttnAudT/analysis/univariate/rest_results/tAATs$subj
    3ddot -dodice $base_dir/ME/rois/mask_Keren
done



end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end


