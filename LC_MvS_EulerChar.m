% Convert the Z-map from group level AFNI results into NIFTI (e.g.,
% 3dAFNItoNIFTI Single.WMregK1.b5.s0+tlrc.BRIK'[1]') and run this script to
% get the Euler Characteristics.

% Thus, first run e.g. 3dcalc to get the [1]st subbrik (with Z-values) and
% then use 3dAFNItoNIFTI to turn that subbrik into a .nii file. Then you're
% ready to run it through this script.
% NB: you'll also need a .nii of a template (e.g. MNIa_caez_N27.nii)

% HBT Apr 10 2019


clear all;clc
Statistic_Map='Single.K1.b5.s0';
Mask='MNIa_caez_N27';

DF = 1;
V = spm_vol([Statistic_Map,'.nii']);
X = spm_read_vols(V);
Mask = spm_vol([Mask,'.nii']);
M = spm_read_vols(Mask);
template = 'tstat1.nii.gz';
X(X==0) = NaN;

X(X==100) = 0;
X(X==-100) = 0;
T = -2:0.01:7;

Z = zeros(size(T));
I = T<0;
Z(I)  =  spm_invNcdf(spm_Tcdf( T( I),DF));
Z(~I) = -spm_invNcdf(spm_Tcdf(-T(~I),DF));

EC = zeros(size(T));
cluster_count = zeros(size(T));
Binout = V(1);
Binout.fname = 'Bin.nii';


for i = 1:numel(EC)
    Bin = X>= T(i);
    Binout = spm_write_vol(Binout, Bin);
    % Write Bin to an image
    VBin = spm_vol('Bin.nii');
    tmp = spm_resels_vol(VBin, [0 0 0]);
    EC(i)= tmp(1);
    
    % Obtaining cluster count
    tmp = spm_read_vols(VBin);
    CC = bwconncomp(tmp, 6);
    cluster_count(i) = CC.NumObjects;
end

delete('Bin.nii');

A = zeros(length(T),2);
A(:,1) = T(1,:);
A(:,2) = EC(1,:);

B = zeros(length(T),2);
B(:,1) = T(1,:);
B(:,2) = cluster_count(1,:);

[Level2Dir, ~, ~] = fileparts(Statistic_Map);
csvwrite(fullfile(Level2Dir, ['euler_chars_',Statistic_Map,'.csv']), A);
csvwrite(fullfile(Level2Dir, ['cluster_count_',Statistic_Map,'.csv']), B);
