% analyze_shock_decomposition.m
% -------------------------------------------------------------
%  Lit oo_.shock_decomposition de l'estimation UEM et produit :
%    - data/tables/shock_decomp_pi_H.csv
%    - data/tables/shock_decomp_pi_F.csv
%    - une synthese imprimee a l'ecran sur 2021Q1-2023Q4.
%
%  Utile pour le point 5.4 du rapport : qui a pousse l'inflation
%  FR/DE pendant la periode du choc d'energie ?
%
%  Pre-requis : run_estimation_UEM.m a tourne avec succes.
% -------------------------------------------------------------

clear; close all;

here = fileparts(mfilename('fullpath'));
root = fullfile(here, '..');
% Dynare 6.5 stocke les resultats dans build/<mod>/Output/<mod>_results.mat
res  = fullfile(root, 'build', 'estimation_UEM', 'Output', 'estimation_UEM_results.mat');
out_dir = fullfile(root, 'data', 'tables');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end

assert(exist(res,'file')==2, 'Resultats manquants : %s', res);
S = load(res);
assert(isfield(S, 'oo_'), 'oo_ absent du fichier resultats.');
assert(isfield(S.oo_, 'shock_decomposition'), ...
    'shock_decomposition absent ; relancer estimation avec mh_replic > 0.');

oo_ = S.oo_;
M_  = S.M_;

% Variables d'interet
target_vars = {'pi_H_obs', 'pi_F_obs'};
% Dates : 1999Q2 + 1, ..., N (N = nb obs)
N = size(oo_.shock_decomposition, 3);
dates_q = (1999 + 1/4):0.25:(1999 + 1/4 + (N-1)/4);

shock_names = M_.exo_names;
nshocks = numel(shock_names);

for v = 1:numel(target_vars)
    var_name = target_vars{v};
    idx = find(strcmp(M_.endo_names, var_name));
    if isempty(idx)
        fprintf('Variable %s introuvable.\n', var_name);
        continue;
    end

    % oo_.shock_decomposition : [endo x (nshocks+2) x time]
    %   colonnes : nshocks chocs + initial_values + steady_state
    decomp = squeeze(oo_.shock_decomposition(idx, :, :));   % (ncols x N)
    ncols = size(decomp, 1);

    % Construit colonnes de noms
    col_names = cell(1, ncols);
    for k = 1:nshocks
        col_names{k} = char(shock_names(k));
    end
    if ncols >= nshocks+1; col_names{nshocks+1} = 'init_values'; end
    if ncols >= nshocks+2; col_names{nshocks+2} = 'steady_state'; end

    T_out = array2table(decomp', 'VariableNames', col_names);
    T_out.date = dates_q(:);
    T_out = movevars(T_out, 'date', 'Before', 1);

    csv_path = fullfile(out_dir, sprintf('shock_decomp_%s.csv', var_name));
    writetable(T_out, csv_path);
    fprintf('Ecrit : %s\n', csv_path);

    % --- Synthese 2021Q1-2023Q4 ---
    mask = (dates_q >= 2021.0) & (dates_q <= 2023.75);
    fprintf('\n%s --- moyenne contribution 2021Q1-2023Q4 (en pp annualises) ---\n', var_name);
    fprintf('Total observe (moyenne)       : %+7.3f\n', mean(sum(decomp(:, mask), 1)) * 400);
    for k = 1:nshocks
        contrib = mean(decomp(k, mask)) * 400;
        if abs(contrib) > 0.05
            fprintf('  %-12s : %+7.3f pp ann.\n', char(shock_names(k)), contrib);
        end
    end
    fprintf('\n');
end

fprintf('=== Analyse terminee. ===\n');
fprintf('Voir aussi data/figures/estimation_UEM_shock_decomposition_*.eps\n');
fprintf('  (figures Dynare natives, deja produites par run_estimation_UEM.m)\n');
