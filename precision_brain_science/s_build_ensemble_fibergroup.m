% THis is a tentative script to combine a series of candidate conenctomes for a
% single subject built usign different tractography methods.
%
% Franco Pestilli Indiana University 2015.11.09

basedir = '/N/dc2/projects/lifebid/2t1/predator/%s_96dirs_b2000_1p5iso/fibers_new';
subjects = {'FP'};
runType = 'run01';

for is = 1:length(subjects)
tic
cd(sprintf('/N/dc2/projects/lifebid/2t1/predator/%s_96dirs_b2000_1p5iso/fibers_new',subjects{is}))
alfiles = dir(sprintf('%s*-5000000*.tck',runType));

for ifg = 1:length(alfiles)
            fprintf('\n Loading %i of %i fibergroup',ifg,length(alfiles))
            fprintf('\n READING: %s ... ', alfiles(ifg).name)
  if ifg == 1
      fgal = dtiImportFibersMrtrix(alfiles(ifg).name);
      fgWrite(fgal,fgal.name,'mat');
  else
      fgtmp = dtiImportFibersMrtrix(alfiles(ifg).name);
      fgWrite(fgtmp,fgtmp.name,'mat');
      fgal = fgMerge(fgal, fgtmp);
  end
  fprintf('\n DONE Loading %i of %i fibergroups... ', ifg, length(alfiles))

end

disp('\n Saving ensemble fiber group to disk... ')
fgal.name = sprintf('%s_%s_96_b2000_ensemble_fibers_5MIL.mat', subjects{is},runType);
fgal.pathwayInfo = [];
fgWrite(fgal);
save(sprintf('%s_%s_96_b2000_ensemble_fibers_orig_names_5MIL.mat', subjects{is}, runType),'alfiles','-v7.3');

% Change permissions to allow others to read/write.
eval(sprintf('!chmod 777 %s', fgal.name))
eval(sprintf('!chmod 777 %s_%s_96_b2000_ensemble_fibers_orig_names.mat', subjects{is}, runType))

toc
end