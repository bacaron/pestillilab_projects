function generate_signal_post_concussion_model(subj,bvals)

dataOutputPath = ['/N/dc2/projects/lifebid/Concussion/concussion_test/' subj '/diffusion_data/' bvals '/Concussion_model/results/'];

%% Set the proper path for VISTASOFT 
vista_soft_path = '/N/dc2/projects/lifebid/code/vistasoft/';
addpath(genpath(vista_soft_path));

%% Set the proper path for the ENCODE with Concussion model
ENCODE_path = '/N/dc2/projects/lifebid/code/bacaron/encode/encode_concussion/';
addpath(genpath(ENCODE_path));

%% Concussion dataset 
dataRootPath = '/N/dc2/projects/lifebid/Concussion/concussion_test';
stem = 'data_b1000_aligned_trilin_noMEC';

% Generate fe_strucure
%% Build the file names for the diffusion data, the anatomical MRI.
dwiFile = ['/N/dc2/projects/lifebid/Concussion/concussion_test/' subj '/diffusion_data/' bvals '/data_b1000_aligned_trilin_noMEC.nii.gz'];
t1File = ['/N/dc2/projects/lifebid/Concussion/concussion_test/' subj '/diffusion_data/' bvals '/t1_acpc_bet.nii.gz'];
fgFileName = ['/N/dc2/projects/lifebid/Concussion/concussion_test/' subj '/diffusion_data/' bvals '/major_tracts/data_b1000_aligned_trilin_noMEC_ensemble.mat'];
feFileName    = strcat(subj,'_',stem,'_','ensemble','_','FE');

load(['/N/dc2/projects/lifebid/Concussion/concussion_test/' subj '/diffusion_data/' bvals '/Concussion_model/results/fe_post_concussion.mat']);

%% Generate  Iso signal prediction
prediso = feGet(fe_prob,'prediso');

%% Generate Fibers signal prediction
predfibersfull = feGet(fe_prob,'predfibersfull');

%% Generate Microstructure signal prediction
predmicro = feGet(fe_prob,'predmicro');

%% Total signal prediction
predfull = prediso + predfibersfull + predmicro;

%% Compute error of fit
meas_full = feGet(fe_prob,'dsigmeasured');
norm_full = norm(meas_full,'fro');
error_full =  norm(meas_full - predfull,'fro')/norm_full;

%% Generation of NIFTI files
% Copy original NIFTI file to a local folder
ni = niftiRead(dwiFile);
fName = fullfile(dataOutputPath,strcat(subj,'_PROB_original.nii.gz'));
niftiWrite(ni,fName);

%% Iso signal
name = fullfile(dataOutputPath,strcat(subj,'_PROB_iso.nii.gz'));
Generate_nifti(ni,name,fe_prob,prediso);

%% Fibers signal
name = fullfile(dataOutputPath,strcat(subj,'_PROB_fibers.nii.gz'));
Generate_nifti(ni,name,fe_prob,predfibersfull);

%% Micro
name = fullfile(dataOutputPath,strcat(subj,'_PROB_micro.nii.gz'));
Generate_nifti(ni,name,fe_prob,predmicro);

%% Error signal
name = fullfile(dataOutputPath,strcat(subj,'_PROB_error.nii.gz'));
Generate_nifti(ni,name,fe_prob,meas_full - predfull);

%% Predfull diffusion signal
name = fullfile(dataOutputPath,strcat(subj,'_PROB_predfull.nii.gz'));
Generate_nifti(ni,name,fe_prob,predfull);
