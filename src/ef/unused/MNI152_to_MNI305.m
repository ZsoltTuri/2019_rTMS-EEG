%% Transfromation from MNI152 to MNI305 (fsaverage) space
M152_305=[1.0022 0.0071 -0.0177  0.0528
         -0.0146 0.9990  0.0027 -1.5519
          0.0129 0.0094  1.0027 -1.2012
          0      0       0       1.0000];
mni152=[-36.99 -105.06 33.35 1]'; % MNI152 coordiante of PO3 electrode
mni305=M152_305*mni152; % corrected PO3 coordinate in the MNI305 space

%% https://surfer.nmr.mgh.harvard.edu/fswiki/CoordinateSystems 
% just for checking
M305_152=[0.9975 -0.0073  0.0176 -0.0429
          0.0146  1.0009 -0.0024  1.5496
         -0.0130 -0.0093  0.9971  1.1840
          0       0       0       1.0000];
mni305=[10 -20 35 1]';
mni152=M305_152*mni305
inv(M305_152)