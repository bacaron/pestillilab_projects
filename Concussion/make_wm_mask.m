function s_fe_make_wm_mask_concussion
%
% This script makes the white-matter mask used to track the connectomes in
% Caiafa and Pestilli Manuscript.
%
% Copyright Franco Pestilli (c) Indiana University, 2016; adapted by Brad Caron 

% Get the base directory for the data
anatomypath = '/N/dc2/projects/lifebid/Concussion/concussion_test';
subjects = {'1_002', '1_003'};

for isbj = 1:length(subjects)
    wmMaskFile = fullfile(anatomypath,subjects{isbj},'diffusion_data', '1000', 'Anatomy', 'wm_mask.nii.gz');
    
    fs_wm = fullfile(anatomypath,subjects{isbj},'diffusion_directory', 'Anatomy', 'aparc+aseg.nii.gz');
    fprintf('\n loading %s \n',fs_wm);
    wm = niftiRead(fs_wm);
    wm.fname = wmMaskFile;
    invals  = [2 41 16 17 28 60 51 53 12 52 13 18 54 50 11 251 252 253 254 255 10 49 46 7];
    origvals = unique(wm.data(:));
    fprintf('\n[%s] Converting voxels... ',mfilename);
    wmCounter=0;noWMCounter=0;
    for ii = 1:length(origvals);
        if any(origvals(ii) == invals)
            wm.data( wm.data == origvals(ii) ) = 1;
            wmCounter=wmCounter+1;
        else            
            wm.data( wm.data == origvals(ii) ) = 0;
            noWMCounter = noWMCounter + 1;
        end
    end
    fprintf('converted %i regions to White-matter (%i regions left outside of WM)\n\n',wmCounter,noWMCounter);
    niftiWrite(wm);
end

end % Main function
