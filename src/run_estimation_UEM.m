% run_estimation_UEM.m
% -------------------------------------------------------------
%  Lance l'estimation bayesienne de two_countries_UEM via
%  estimation_UEM.mod, en routant tous les artefacts Dynare
%  (chains MH, _results.mat, +estimation_UEM/, etc.) vers build/,
%  et :
%    - le log brut complet vers logs/estimation_raw.log
%    - toutes les figures generees (EPS, PDF) vers data/figures/
%
%  A lancer depuis src/ :
%      >> run_estimation_UEM
%
%  Duree typique : 10-30 min (mode_compute=9 + 5000 MH x 2).
% -------------------------------------------------------------

close all; clear;

here     = fileparts(mfilename('fullpath'));
root     = fullfile(here, '..');
log_dir  = fullfile(root, 'logs');
bld_dir  = fullfile(root, 'build');
fig_dir  = fullfile(root, 'data', 'figures');
data_src = fullfile(root, 'data', 'myobs_FR_DE.mat');
mod_src  = fullfile(here, 'estimation_UEM.mod');
if ~exist(log_dir, 'dir'); mkdir(log_dir); end
if ~exist(bld_dir, 'dir'); mkdir(bld_dir); end
if ~exist(fig_dir, 'dir'); mkdir(fig_dir); end

% On copie le .mod dans build/ pour que Dynare genere ses
% artefacts (chains MH, +estimation_UEM/, _results.mat, ...)
% dans build/ plutot que de polluer src/.
mod_bld = fullfile(bld_dir, 'estimation_UEM.mod');
copyfile(mod_src, mod_bld);

% Le datafile est reference en relatif '../data/myobs_FR_DE.mat'
% dans le .mod : depuis build/, ce chemin pointe bien vers data/.
assert(exist(data_src,'file')==2, ...
       'Datafile manquant : %s', data_src);

cd(bld_dir);

% ---------------- Capture du log Dynare -----------------------
% diary() ne capture pas fiablement la sortie de Dynare 6.5
% (Dynare reset internement le diary). On utilise evalc qui
% redirige stdout dans une string, puis on ecrit + on affiche.
diary_file = fullfile(log_dir, 'estimation_raw.log');
fid = fopen(diary_file, 'w');
if fid == -1
    error('Impossible d''ouvrir %s en ecriture.', diary_file);
end

t0 = tic;
launch_msg = sprintf('Lancement estimation_UEM.mod ...\n');
fprintf('%s', launch_msg);
fprintf(fid, '%s', launch_msg);

try
    raw_out = evalc('dynare estimation_UEM.mod noclearall');
    estim_ok = true;
catch ME
    raw_out = sprintf('ECHEC : %s\n\n%s\n', ME.message, getReport(ME));
    estim_ok = false;
end

% On affiche ET on persiste la sortie complete.
fprintf('%s', raw_out);
fprintf(fid, '%s', raw_out);
fclose(fid);

elapsed = toc(t0);

% ---------------- Copie des figures vers data/figures/ --------
src_fig_dir = fullfile(bld_dir, 'estimation_UEM', 'graphs');
n_copied = 0;
if exist(src_fig_dir, 'dir')
    fig_files = [dir(fullfile(src_fig_dir, '*.eps')); ...
                 dir(fullfile(src_fig_dir, '*.pdf')); ...
                 dir(fullfile(src_fig_dir, '*.png')); ...
                 dir(fullfile(src_fig_dir, '*.fig'))];
    for k = 1:numel(fig_files)
        src = fullfile(fig_files(k).folder, fig_files(k).name);
        dst = fullfile(fig_dir, fig_files(k).name);
        copyfile(src, dst);
        n_copied = n_copied + 1;
    end
end

% ---------------- Recap final ----------------------------------
fprintf('\n====================================================\n');
fprintf('  Estimation terminee en %.1f min.\n', elapsed/60);
fprintf('  Statut         : %s\n', tern(estim_ok,'OK','ECHEC'));
fprintf('  Log brut Dynare: %s\n', diary_file);
fprintf('  Figures copiees: %d -> %s\n', n_copied, fig_dir);
if estim_ok
    fprintf('  Resultats      : %s\n', fullfile(bld_dir, 'estimation_UEM_results.mat'));
    fprintf('  Chaines MH     : %s\n', fullfile(bld_dir, 'estimation_UEM', 'metropolis'));
end
fprintf('====================================================\n');

function s = tern(c, a, b)
    if c; s = a; else; s = b; end
end
