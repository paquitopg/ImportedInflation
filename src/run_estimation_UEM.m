% run_estimation_UEM.m
% -------------------------------------------------------------
%  Lance l'estimation bayesienne de two_countries_UEM
%  via estimation_UEM.mod, en routant tous les artefacts
%  Dynare (chains MH, _results.mat, +estimation_UEM/, etc.)
%  vers build/, et le log brut vers logs/.
%
%  A lancer depuis src/ :
%      >> run_estimation_UEM
%
%  Duree typique : 10-30 min (mode_compute=4 + 5000 MH x 2).
% -------------------------------------------------------------

close all; clear;

here    = fileparts(mfilename('fullpath'));
root    = fullfile(here, '..');
log_dir = fullfile(root, 'logs');
bld_dir = fullfile(root, 'build');
data_src = fullfile(root, 'data', 'myobs_FR_DE.mat');
mod_src = fullfile(here, 'estimation_UEM.mod');
if ~exist(log_dir, 'dir'); mkdir(log_dir); end
if ~exist(bld_dir, 'dir'); mkdir(bld_dir); end

% On copie le .mod dans build/ pour que Dynare genere ses
% artefacts (chains MH, +estimation_UEM/, _results.mat, ...)
% dans build/ plutot que de polluer src/.
mod_bld = fullfile(bld_dir, 'estimation_UEM.mod');
copyfile(mod_src, mod_bld);

% Le datafile est reference en relatif '../data/myobs_FR_DE.mat'
% dans le .mod : depuis build/, ce chemin pointe bien vers data/.
% On verifie quand meme.
assert(exist(data_src,'file')==2, ...
       'Datafile manquant : %s', data_src);

cd(bld_dir);

diary_file = fullfile(log_dir, 'estimation_raw.log');
if exist(diary_file,'file'); delete(diary_file); end
diary(diary_file);

t0 = tic;
fprintf('Lancement estimation_UEM.mod ...\n');
try
    dynare estimation_UEM.mod noclearall
    estim_ok = true;
catch ME
    estim_ok = false;
    fprintf('ECHEC : %s\n', ME.message);
end
diary off;
elapsed = toc(t0);

fprintf('\n====================================================\n');
fprintf('  Estimation terminee en %.1f min.\n', elapsed/60);
fprintf('  Statut         : %s\n', tern(estim_ok,'OK','ECHEC'));
fprintf('  Log brut Dynare: %s\n', diary_file);
if estim_ok
    fprintf('  Resultats      : %s\n', fullfile(bld_dir, 'estimation_UEM_results.mat'));
    fprintf('  Chaines MH     : %s\n', fullfile(bld_dir, 'estimation_UEM', 'metropolis'));
end
fprintf('====================================================\n');

function s = tern(c, a, b)
    if c; s = a; else; s = b; end
end
