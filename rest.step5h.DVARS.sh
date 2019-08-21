# Resting state analysis - preprocessing
# execute via:
# ./rest.step9.DVARS.sh
# July 17 2019 - HBT
#
# Calculate the DVARS for all subjects - ME vs SE
# =========================== setup ============================
start=`date '+%m %d %Y at %H %M %S'`

for subj in `seq 7 1 27`; do
for blur in 0 5; do
for wmr in 0 1; do
for gsr in 0 1; do
    3dTto1D -input tAATs${subj}_e2_nat_blur${blur}.WM_${wmr}.GSR_${gsr}.tproj.NTRP.nii -method dvars -automask -prefix dvars_tproj.tAATs${subj}.SE.b${blur}.whole.wm${wmr}.gsr${gsr}.1D
    3dTto1D -input tAATs${subj}_medn_nat_blur${blur}.WM_${wmr}.GSR_${gsr}.tproj.NTRP.nii -method dvars -automask -prefix dvars_tproj.tAATs${subj}.ME.b${blur}.whole.wm${wmr}.gsr${gsr}.1D

    3dTto1D -mask mask_LCoverlap.tAATs${subj}_rest_nat.frac.nii -input tAATs${subj}_e2_nat_blur${blur}.WM_${wmr}.GSR_${gsr}.tproj.NTRP.nii -method dvars -prefix dvars_tproj.tAATs${subj}.SE.b${blur}.LC.wm${wmr}.gsr${gsr}.1D
    3dTto1D -mask mask_PT.tAATs${subj}_rest_nat.frac.nii -input tAATs${subj}_e2_nat_blur${blur}.WM_${wmr}.GSR_${gsr}.tproj.NTRP.nii -method dvars -prefix dvars_tproj.tAATs${subj}.SE.b${blur}.PT.wm${wmr}.gsr${gsr}.1D
    3dTto1D -mask mask_Keren1SD.tAATs${subj}_rest_mni.frac.nii -input tAATs${subj}_e2_mni_blur${blur}.WM_${wmr}.GSR_${gsr}.tproj.NTRP.nii -method dvars -prefix dvars_tproj.tAATs${subj}.SE.b${blur}.K1.wm${wmr}.gsr${gsr}.1D
    3dTto1D -mask mask_Keren2SD.tAATs${subj}_rest_mni.frac.nii -input tAATs${subj}_e2_mni_blur${blur}.WM_${wmr}.GSR_${gsr}.tproj.NTRP.nii -method dvars -prefix dvars_tproj.tAATs${subj}.SE.b${blur}.K2.wm${wmr}.gsr${gsr}.1D

    3dTto1D -mask mask_LCoverlap.tAATs${subj}_rest_nat.frac.nii -input tAATs${subj}_medn_nat_blur${blur}.WM_${wmr}.GSR_${gsr}.tproj.NTRP.nii -method dvars -prefix dvars_tproj.tAATs${subj}.ME.b${blur}.LC.wm${wmr}.gsr${gsr}.1D
    3dTto1D -mask mask_PT.tAATs${subj}_rest_nat.frac.nii -input tAATs${subj}_medn_nat_blur${blur}.WM_${wmr}.GSR_${gsr}.tproj.NTRP.nii -method dvars -prefix dvars_tproj.tAATs${subj}.ME.b${blur}.PT.wm${wmr}.gsr${gsr}.1D
    3dTto1D -mask mask_Keren1SD.tAATs${subj}_rest_mni.frac.nii -input tAATs${subj}_medn_mni_blur${blur}.WM_${wmr}.GSR_${gsr}.tproj.NTRP.nii -method dvars -prefix dvars_tproj.tAATs${subj}.ME.b${blur}.K1.wm${wmr}.gsr${gsr}.1D
    3dTto1D -mask mask_Keren2SD.tAATs${subj}_rest_mni.frac.nii -input tAATs${subj}_medn_mni_blur${blur}.WM_${wmr}.GSR_${gsr}.tproj.NTRP.nii -method dvars -prefix dvars_tproj.tAATs${subj}.ME.b${blur}.K2.wm${wmr}.gsr${gsr}.1D
done
done
done
done

for subj in `seq 7 1 27`; do
for blur in 0 5; do
    3dTto1D -input tAATs${subj}_e2_nat_blur${blur}.nii -method dvars -automask -prefix dvars_preproj.tAATs${subj}.SE.b${blur}.whole.1D
    3dTto1D -input tAATs${subj}_medn_nat_blur${blur}.nii -method dvars -automask -prefix dvars_preproj.tAATs${subj}.ME.b${blur}.whole.1D

    3dTto1D -mask mask_LCoverlap.tAATs${subj}_rest_nat.frac.nii -input tAATs${subj}_e2_nat_blur${blur}.nii -method dvars -prefix dvars_preproj.tAATs${subj}.SE.b${blur}.LC.1D
    3dTto1D -mask mask_PT.tAATs${subj}_rest_nat.frac.nii -input tAATs${subj}_e2_nat_blur${blur}.nii -method dvars -prefix dvars_preproj.tAATs${subj}.SE.b${blur}.PT.1D
    3dTto1D -mask mask_Keren1SD.tAATs${subj}_rest_mni.frac.nii -input tAATs${subj}_e2_mni_blur${blur}.nii -method dvars -prefix dvars_preproj.tAATs${subj}.SE.b${blur}.K1.1D
    3dTto1D -mask mask_Keren2SD.tAATs${subj}_rest_mni.frac.nii -input tAATs${subj}_e2_mni_blur${blur}.nii -method dvars -prefix dvars_preproj.tAATs${subj}.SE.b${blur}.K2.1D

    3dTto1D -mask mask_LCoverlap.tAATs${subj}_rest_nat.frac.nii -input tAATs${subj}_medn_nat_blur${blur}.nii -method dvars -prefix dvars_preproj.tAATs${subj}.ME.b${blur}.LC.1D
    3dTto1D -mask mask_PT.tAATs${subj}_rest_nat.frac.nii -input tAATs${subj}_medn_nat_blur${blur}.nii -method dvars -prefix dvars_preproj.tAATs${subj}.ME.b${blur}.PT.1D
    3dTto1D -mask mask_Keren1SD.tAATs${subj}_rest_mni.frac.nii -input tAATs${subj}_medn_mni_blur${blur}.nii -method dvars -prefix dvars_preproj.tAATs${subj}.ME.b${blur}.K1.1D
    3dTto1D -mask mask_Keren2SD.tAATs${subj}_rest_mni.frac.nii -input tAATs${subj}_medn_mni_blur${blur}.nii -method dvars -prefix dvars_preproj.tAATs${subj}.ME.b${blur}.K2.1D
done
done


end=`date '+%m %d %Y at %H %M %S'`
echo "Started: " $start
echo "End: " $end


