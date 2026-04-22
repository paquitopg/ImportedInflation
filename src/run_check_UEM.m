% run_check_UEM.m
% -------------------------------------------------------------
%  Diagnostic de two_countries_UEM.mod :
%    1) residus au steady-state (consistance de la calibration)
%    2) condition de Blanchard-Kahn (determinacy)
%    3) signe des IRF pour un choc energie DE (eta_p_F)
%
%  Produit :
%    logs/model_check.log      - resume structure lisible
%    logs/model_check_raw.log  - sortie brute de Dynare
%
%  A lancer depuis src/ :
%      >> run_check_UEM
% -------------------------------------------------------------

close all; clear;

here    = fileparts(mfilename('fullpath'));
root    = fullfile(here, '..');
log_dir = fullfile(root, 'logs');
bld_dir = fullfile(root, 'build');
mod_src = fullfile(here, 'two_countries_UEM.mod');
if ~exist(log_dir, 'dir'); mkdir(log_dir); end
if ~exist(bld_dir, 'dir'); mkdir(bld_dir); end

logfile    = fullfile(log_dir, 'model_check.log');
diary_file = fullfile(log_dir, 'model_check_raw.log');
if exist(diary_file,'file'); delete(diary_file); end

% On copie le .mod dans build/ pour que Dynare genere tous ses artefacts
% (two_countries_UEM/, +two_countries_UEM/, .log, .m) dans build/ et non
% dans src/. src/ reste reserve au code source versionne.
mod_bld = fullfile(bld_dir, 'two_countries_UEM.mod');
copyfile(mod_src, mod_bld);
cd(bld_dir);

% --- 1) Run Dynare (sortie brute capturee via diary) ---
err_msg   = '';
dynare_ok = false;
diary(diary_file);
try
    dynare two_countries_UEM.mod noclearall
    dynare_ok = true;
catch ME
    err_msg = ME.message;
end
diary off;

% --- 2) Residus au steady-state ---
max_resid = NaN; ok_resid = false;
if dynare_ok
    try
        % appel du fichier static genere par Dynare
        static_fn = str2func([M_.fname '.static']);
        res = static_fn(oo_.steady_state, oo_.exo_steady_state, M_.params);
        max_resid = max(abs(res));
        ok_resid = (max_resid < 1e-8);
    catch
        % API plus recente
        try
            res = feval([M_.fname '.sparse.static_resid'], ...
                        oo_.steady_state, oo_.exo_steady_state, M_.params);
            max_resid = max(abs(res));
            ok_resid = (max_resid < 1e-8);
        catch ME2
            err_msg = [err_msg ' | resid: ' ME2.message];
        end
    end
end

% --- 3) Condition de Blanchard-Kahn ---
n_eig_gt1 = NaN; n_fwd = NaN; ok_bk = false;
if dynare_ok && isfield(oo_,'dr') && isfield(oo_.dr,'eigval')
    eigs_abs  = abs(oo_.dr.eigval);
    n_eig_gt1 = sum(eigs_abs > 1 + 1e-6);
    if isfield(M_, 'nfwrd')
        n_fwd = M_.nfwrd + M_.nboth;
    else
        n_fwd = NaN;  % Dynare ancienne version
    end
    % si stoch_simul a tourne jusqu'au bout, BK est OK par construction
    ok_bk = isfield(oo_, 'irfs') && ~isempty(fieldnames(oo_.irfs));
end

% --- 4) IRF : choc eta_p_F (+1 sigma) ---
vars_irf = {'pic_F','pic_H','pi_UEM','y_F','y_H','rer','r','ex_H','ex_F','NFA_H'};
H_report = [1 4 8 12];
shock    = 'eta_p_F';
irf_mat  = nan(length(vars_irf), length(H_report));
if dynare_ok && isfield(oo_,'irfs')
    for iv = 1:length(vars_irf)
        fname = [vars_irf{iv} '_' shock];
        if isfield(oo_.irfs, fname)
            s = oo_.irfs.(fname);
            for ih = 1:length(H_report)
                h = H_report(ih);
                if h <= length(s); irf_mat(iv,ih) = s(h); end
            end
        end
    end
end

% --- 5) Tests de signe (theorie : choc cost-push en DE) ---
% On attend :
%   pic_F > 0      (inflation DE monte a l'impact)
%   pic_H > 0 rapidement (transmission imports FR depuis DE)
%   pi_UEM > 0     (inflation zone euro)
%   y_F < 0        (recession allemande)
%   y_H < 0        (recession francaise, retardee et attenuee)
%   rer > 0        (rer FR se deprecie vs DE = DE plus cher intra-UEM)
%   r > 0          (BCE reagit a l'inflation)
gi = @(v,h) get_irf_val(oo_, v, shock, h);

sign_tests = {
    'pic_F > 0 a t=1',   gi('pic_F',1) > 0
    'pic_H > 0 a t=4',   gi('pic_H',4) > 0
    'pi_UEM > 0 a t=1',  gi('pi_UEM',1) > 0
    'y_F < 0 a t=1',     gi('y_F',1)  < 0
    'y_H < 0 a t=4',     gi('y_H',4)  < 0
    'rer > 0 a t=1',     gi('rer',1)  > 0
    'r > 0 a t=4',       gi('r',4)    > 0
};
n_ok_signs = sum([sign_tests{:,2}]);
n_tot      = size(sign_tests,1);
ok_signs   = (n_ok_signs == n_tot);

% --- 6) Ecriture du log structure ---
fid = fopen(logfile, 'w');
fprintf(fid,'==============================================================\n');
fprintf(fid,'  MODEL CHECK  -  two_countries_UEM.mod\n');
fprintf(fid,'==============================================================\n');
fprintf(fid,'Run date     : %s\n', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
fprintf(fid,'Model file   : %s\n', fullfile(here,'two_countries_UEM.mod'));
fprintf(fid,'Dynare run   : %s\n', tern(dynare_ok,'OK','ECHEC'));
fprintf(fid,'--------------------------------------------------------------\n\n');

fprintf(fid,'1) RESIDUS AU STEADY-STATE\n');
fprintf(fid,'   max|residu|   = %.3e\n', max_resid);
fprintf(fid,'   Tolerance     = 1.000e-08\n');
fprintf(fid,'   Conclusion    : %s\n\n', ...
        tern(ok_resid,'OK (steady-state consistant)','ECHEC (recalibrer SS)'));

fprintf(fid,'2) CONDITION DE BLANCHARD-KAHN\n');
fprintf(fid,'   # valeurs propres > 1  : %d\n', n_eig_gt1);
fprintf(fid,'   # variables forward    : %d  (M_.nfwrd + M_.nboth)\n', n_fwd);
fprintf(fid,'   stoch_simul execute    : %s\n', tern(ok_bk,'oui','non'));
fprintf(fid,'   Conclusion    : %s\n\n', ...
        tern(ok_bk,'OK (equilibre determine)','ECHEC (indetermination)'));

fprintf(fid,'3) IRF : choc energie Allemagne (eta_p_F = +1 sigma = +0.015)\n\n');
fprintf(fid,'   Variable | %8s | %8s | %8s | %8s\n', 't=1','t=4','t=8','t=12');
fprintf(fid,'   ---------+----------+----------+----------+----------\n');
for iv = 1:length(vars_irf)
    fprintf(fid,'   %-8s |', vars_irf{iv});
    for ih = 1:length(H_report)
        v = irf_mat(iv,ih);
        if isnan(v)
            fprintf(fid,'   %6s |','NA');
        else
            fprintf(fid,'  %+7.4f |', v);
        end
    end
    fprintf(fid,'\n');
end
fprintf(fid,'\n');

fprintf(fid,'   Tests de signe attendus (cost-push DE) :\n');
for i = 1:size(sign_tests,1)
    fprintf(fid,'     [%s] %s\n', tern(sign_tests{i,2},'OK','NON'), sign_tests{i,1});
end
fprintf(fid,'   %d / %d tests passes.\n', n_ok_signs, n_tot);
fprintf(fid,'   Conclusion    : %s\n\n', ...
        tern(ok_signs, ...
             'Signes IRF conformes a la theorie', ...
             'Signes IRF a verifier (cf. raw log)'));

fprintf(fid,'--------------------------------------------------------------\n');
if ~isempty(err_msg)
    fprintf(fid,'ERREUR : %s\n', err_msg);
end
fprintf(fid,'VERDICT : %s\n', ...
        tern(ok_resid && ok_bk && ok_signs,'MODEL OK','MODEL A REVOIR'));
fprintf(fid,'==============================================================\n');
fprintf(fid,'Sortie brute Dynare : logs/model_check_raw.log\n');
fclose(fid);

fprintf('\n====================================================\n');
fprintf('  Diagnostic two_countries_UEM.mod termine.\n');
fprintf('  Log lisible     : %s\n', logfile);
fprintf('  Log brut Dynare : %s\n', diary_file);
fprintf('====================================================\n');

% =============================================================
%   FONCTIONS AUXILIAIRES
% =============================================================
function s = tern(c, a, b)
    if c; s = a; else; s = b; end
end

function v = get_irf_val(oo_, varname, shockname, h)
    v = NaN;
    fname = [varname '_' shockname];
    if isfield(oo_,'irfs') && isfield(oo_.irfs, fname)
        s = oo_.irfs.(fname);
        if h <= length(s); v = s(h); end
    end
end
