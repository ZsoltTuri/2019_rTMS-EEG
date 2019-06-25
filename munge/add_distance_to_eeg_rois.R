eeg_roi_abs$distance<-distance$distance
eeg_roi_normal$distance<-distance$distance
# save dataset
saveRDS(eeg_roi_abs, file = "absEF_eeg.rds")
saveRDS(eeg_roi_normal, file = "normalEF_eeg.rds")