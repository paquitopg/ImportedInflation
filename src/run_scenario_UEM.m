% run_scenario_UEM.m
% -------------------------------------------------------------
%  Scenario contrefactuel "choc d'energie 2021-2023" sous deux
%  regimes de politique monetaire BCE.
%
%  Etapes :
%    1. Lance scenario_UEM.mod sous phi_pi = 2.468 (baseline).
%    2. Re-resoud le modele sous phi_pi = 3.702 (hawkish, x1.5).
%    3. Construit la trajectoire sous un choc eta_p_F de +3*sigma
%       persistant pendant 4 trimestres (replique 2021Q4-2022Q3).
%    4. Trace les comparaisons des deux regimes pour 9 variables :
%         pi_H, pi_F, pi_UEM, gy_H, gy_F, ex_H, ex_F, NFA_H, r
%    5. Sauve toutes les figures dans data/figures/scenario_*.png.
% -------------------------------------------------------------

close all; clear;

here   = fileparts(mfilename('fullpath'));
root   = fullfile(here, '..');
bld    = fullfile(root, 'build');
fig    = fullfile(root, 'data', 'figures');
mod_src = fullfile(here, 'scenario_UEM.mod');

if ~exist(bld, 'dir'); mkdir(bld); end
if ~exist(fig, 'dir'); mkdir(fig); end

% ---------- Parametres du scenario ----------------------------
H        = 20;          % horizon de simulation (trimestres)
phi_base = 2.468;       % phi_pi posterieur estime
phi_hawk = 1.5 * phi_base;  % regime "hawkish" contrefactuel
shock_horizon = 4;      % nb de trimestres avec choc actif
shock_size_in_sigma = 3;   % +3*sigma_eta_p_F sur 4 trimestres

% ---------- Etape 1 : baseline (phi_pi estime) ----------------
mod_bld = fullfile(bld, 'scenario_UEM.mod');
copyfile(mod_src, mod_bld);
cd(bld);

fprintf('[1/2] Resolution scenario_UEM.mod sous regime BASELINE (phi_pi=%.3f)...\n', phi_base);
dynare scenario_UEM noclearall;

oo_base = oo_;
M_base  = M_;

% ---------- Etape 2 : re-resolution hawkish -------------------
fprintf('\n[2/2] Re-resolution sous regime HAWKISH (phi_pi=%.3f)...\n', phi_hawk);
set_param_value('phi_pi', phi_hawk);

% On re-resoud le modele avec le nouveau phi_pi.
% stoch_simul re-execute resol() puis recompute oo_.dr
options_.noprint = 1;
options_.nograph = 1;
% NB Dynare 6.5 : var_list doit etre une cellstr (pas un char array),
% sinon disp_th_moments echoue sur var_list{i}.
var_list = {'y_H','y_F','c_H','c_F','pi_H','pi_F','pic_H','pic_F','pi_UEM',...
            'r','rer','ex_H','ex_F','NFA_H',...
            'gy_H_obs','gy_F_obs','pi_H_obs','pi_F_obs'};
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list);

oo_hawk = oo_;
M_hawk  = M_;

% ---------- Etape 3 : trajectoire contrefactuelle -------------
% Sigma posterieur du choc d'inflation importee allemande.
sigma_eta_p_F = 0.0068;

% Indice de eta_p_F dans le vecteur des chocs.
i_shock = find(strcmp(M_base.exo_names, 'eta_p_F'));
nshocks = M_base.exo_nbr;

% Sequence de chocs : +shock_size_in_sigma * sigma pendant
% shock_horizon trimestres, puis 0.
ex_  = zeros(H, nshocks);
ex_(1:shock_horizon, i_shock) = shock_size_in_sigma * sigma_eta_p_F;

% Etat initial = steady-state.
y0_base = oo_base.dr.ys;
y0_hawk = oo_hawk.dr.ys;

% simult_ : simulation linearisee a partir de l'etat initial.
y_path_base = simult_(M_base, options_, y0_base, oo_base.dr, ex_, 1);
y_path_hawk = simult_(M_hawk, options_, y0_hawk, oo_hawk.dr, ex_, 1);

% ---------- Etape 4 : graphes comparatifs ---------------------
% Variables a tracer (en deviation pourcentage par rapport au SS,
% sauf inflation qui est en pp annualises).
plot_vars = {'pi_H','pi_F','pi_UEM','gy_H_obs','gy_F_obs','ex_H','ex_F','NFA_H','r'};
plot_labels = {'\pi_H (FR, an pp)','\pi_F (DE, an pp)','\pi^{UEM} (an pp)',...
               'gy_H (FR, %Q)','gy_F (DE, %Q)','ex_H (FR\rightarrowDE, %)',...
               'ex_F (DE\rightarrowFR, %)','NFA_H (FR, niveau)','r (an pp)'};
% transforms : 1 = annualise inflation pp, 2 = pp trimestriel,
%              3 = ecart % vs SS, 4 = niveau brut
plot_kind = [1 1 1 2 2 3 3 4 1];

n_idx = zeros(1, numel(plot_vars));
for k = 1:numel(plot_vars)
    n_idx(k) = find(strcmp(M_base.endo_names, plot_vars{k}));
end

ss_base = oo_base.dr.ys;
ss_hawk = oo_hawk.dr.ys;

f = figure('Position',[100 100 1200 900], 'Color','w');
T = 0:H-1;
for k = 1:9
    subplot(3,3,k);
    yb = y_path_base(n_idx(k), 1:H);
    yh = y_path_hawk(n_idx(k), 1:H);
    sb = ss_base(n_idx(k));
    sh = ss_hawk(n_idx(k));
    switch plot_kind(k)
        case 1   % inflation : (pi - 1) * 400 pour pp annualise
            xb = (yb - 1) * 400;
            xh = (yh - 1) * 400;
        case 2   % gy : deja en log-diff, en %Q
            xb = yb * 100;
            xh = yh * 100;
        case 3   % ex : ecart % vs SS
            xb = (yb - sb) / sb * 100;
            xh = (yh - sh) / sh * 100;
        case 4   % NFA niveau brut
            xb = yb - sb;
            xh = yh - sh;
    end
    plot(T, xb, 'b-', 'LineWidth', 1.8); hold on;
    plot(T, xh, 'r--', 'LineWidth', 1.8);
    yline(0, 'k:', 'LineWidth', 0.8);
    title(plot_labels{k}, 'FontSize', 11);
    xlabel('Trimestres'); grid on;
    if k == 1
        legend('Baseline (\phi_\pi=2.47)', 'Hawkish (\phi_\pi=3.70)', ...
               'Location','best');
    end
end
sgtitle(sprintf(['Scenario : choc \\eta^p_F de +%d\\sigma persistant %d trim. ' ...
                 '\\rightarrow comparaison reponse BCE'], ...
                shock_size_in_sigma, shock_horizon), 'FontSize', 13);

f_path = fullfile(fig, 'scenario_energy_2regimes.png');
exportgraphics(f, f_path, 'Resolution', 200);
fprintf('\nFigure principale : %s\n', f_path);

% ---------- Etape 5 : tableau impact cumule -------------------
% Impact a 4 et 8 trimestres pour pi_H, pi_F, gy_H, gy_F, NFA_H.
key_vars   = {'pi_H','pi_F','pi_UEM','gy_H_obs','gy_F_obs','NFA_H'};
key_horizons = [4, 8];

fprintf('\n=== Impact (deviation par rapport au SS) ===\n');
fprintf('Variable        |  Baseline  |  Hawkish   |  Difference\n');
fprintf('--------------- | ---------- | ---------- | -----------\n');

impact_table = zeros(numel(key_vars)*numel(key_horizons), 4);
row = 1;
for h = key_horizons
    fprintf('--- A horizon %d trimestres ---\n', h);
    for v = 1:numel(key_vars)
        idx = find(strcmp(M_base.endo_names, key_vars{v}));
        yb_h = y_path_base(idx, h);
        yh_h = y_path_hawk(idx, h);
        sb   = ss_base(idx);
        sh   = ss_hawk(idx);
        if startsWith(key_vars{v},'pi')
            xb = (yb_h - 1) * 400;
            xh = (yh_h - 1) * 400;
            unit = 'pp ann';
        elseif startsWith(key_vars{v},'gy')
            xb = yb_h * 100;
            xh = yh_h * 100;
            unit = '%Q';
        else
            xb = (yb_h - sb) / sb * 100;
            xh = (yh_h - sh) / sh * 100;
            unit = '% SS';
        end
        fprintf('%-15s |  %+7.3f   |  %+7.3f   |  %+7.3f  (%s)\n', ...
                key_vars{v}, xb, xh, xh-xb, unit);
        impact_table(row, :) = [h, xb, xh, xh-xb];
        row = row + 1;
    end
end

% Sauve le tableau d'impact
table_path = fullfile(root, 'data', 'tables', 'scenario_impact.csv');
T_out = array2table(impact_table, ...
    'VariableNames', {'horizon_Q','baseline','hawkish','difference'});
T_var = repmat(key_vars(:), numel(key_horizons), 1);
T_out.variable = T_var;
T_out = T_out(:, {'variable','horizon_Q','baseline','hawkish','difference'});
writetable(T_out, table_path);
fprintf('\nTableau d''impact : %s\n', table_path);

% ---------- Etape 6 : copie des figures Dynare ----------------
src_fig_dir = fullfile(bld, 'scenario_UEM', 'graphs');
n_copied = 0;
if exist(src_fig_dir, 'dir')
    files = [dir(fullfile(src_fig_dir, '*.eps')); ...
             dir(fullfile(src_fig_dir, '*.pdf')); ...
             dir(fullfile(src_fig_dir, '*.fig'))];
    for k = 1:numel(files)
        src = fullfile(files(k).folder, files(k).name);
        dst = fullfile(fig, ['scenario_baseline_' files(k).name]);
        copyfile(src, dst);
        n_copied = n_copied + 1;
    end
end
fprintf('\n%d IRF baseline copiees vers %s\n', n_copied, fig);

fprintf('\n====================================================\n');
fprintf('Scenario contrefactuel termine.\n');
fprintf('Choc considere : eta_p_F = +%.4f sur %d trimestres\n', ...
        shock_size_in_sigma * sigma_eta_p_F, shock_horizon);
fprintf('====================================================\n');
