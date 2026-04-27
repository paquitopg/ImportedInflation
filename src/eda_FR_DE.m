% =========================================================================
%  eda_FR_DE.m
%  Analyse exploratoire des observables France/Allemagne téléchargés par
%  my_db_FR_DE.m.
%
%  Sorties : figures PNG dans ../data/figures/
%            table statistiques en console
%
%  Exécution : depuis src/, taper `run eda_FR_DE`.
% =========================================================================

close all; clc;

% --- Localisation ---------------------------------------------------------
this_dir = fileparts(mfilename('fullpath'));
proj_dir = fileparts(this_dir);
data_dir = fullfile(proj_dir, 'data');
fig_dir  = fullfile(data_dir, 'figures');
log_dir  = fullfile(proj_dir, 'logs');
if ~exist(fig_dir,'dir'), mkdir(fig_dir); end
if ~exist(log_dir,'dir'), mkdir(log_dir); end

% --- Chargement -----------------------------------------------------------
infile = fullfile(data_dir, 'myobs_FR_DE.mat');
if ~isfile(infile)
    error('Fichier introuvable : %s. Lance d''abord my_db_FR_DE.m.', infile);
end
load(infile);
fprintf('Chargé : %s\n', infile);
fprintf('N périodes : %d  (de %.2f à %.2f)\n\n', length(T), T(1), T(end));

% =========================================================================
% 1) FENÊTRE EFFECTIVE
% =========================================================================
vars_obs = {'gy_H_obs','gy_F_obs','pi_H_obs','pi_F_obs', ...
            'gc_H_obs','gc_F_obs','r_H_obs', ...
            'gex_H_obs','gex_F_obs','pi_NRG_H_q','pi_NRG_F_q'};

fprintf('--- Couverture par série ---\n');
for k = 1:numel(vars_obs)
    v = eval(vars_obs{k});
    ok = ~isnan(v);
    if any(ok)
        i1 = find(ok,1,'first'); i2 = find(ok,1,'last');
        fprintf('  %-14s  %.2f -> %.2f   N = %d\n', ...
                vars_obs{k}, T(i1), T(i2), sum(ok));
    else
        fprintf('  %-14s  [aucune observation]\n', vars_obs{k});
    end
end
fprintf('\n');

% =========================================================================
% 2) FIGURES — OBSERVABLES PRINCIPAUX ET AUXILIAIRES
% =========================================================================
fprintf('--- Génération des figures ---\n');

% ---- FIG 1 : 4 observables d'estimation + taux d'intérêt --------------
f1 = figure('Name','Observables','Position',[100 100 1100 700]);
subplot(3,2,1);
plot(T, gy_H_obs*100, 'b', T, gy_F_obs*100, 'r', 'LineWidth', 1.2);
title('Croissance PIB réel trimestrielle (%)');
legend({'France','Allemagne'},'Location','best'); grid on; ylabel('%');
xlim([T(1) T(end)]);

subplot(3,2,2);
plot(T, pi_H_obs*400, 'b', T, pi_F_obs*400, 'r', 'LineWidth', 1.2);
title('Inflation HICP (annualisée, déviation vs 2%)');
legend({'France','Allemagne'},'Location','best'); grid on; ylabel('pp');
xlim([T(1) T(end)]);

subplot(3,2,3);
plot(T, gc_H_obs*100, 'b', T, gc_F_obs*100, 'r', 'LineWidth', 1.2);
title('Croissance consommation privée (%)');
legend({'France','Allemagne'},'Location','best'); grid on; ylabel('%');
xlim([T(1) T(end)]);

subplot(3,2,4);
plot(T, r_H_obs*400, 'k', 'LineWidth', 1.2);
title('Taux court Euribor 3M (annualisé, déviation vs ss)');
grid on; ylabel('pp'); xlim([T(1) T(end)]);

subplot(3,2,5);
plot(T, gex_H_obs*100, 'b', T, gex_F_obs*100, 'r', 'LineWidth', 1.2);
title('Croissance exports totaux (%)');
legend({'France','Allemagne'},'Location','best'); grid on; ylabel('%');
xlim([T(1) T(end)]);

subplot(3,2,6);
plot(T, pi_NRG_H_q*400, 'b', T, pi_NRG_F_q*400, 'r', 'LineWidth', 1.2);
title('Inflation HICP énergie (annualisée, %)');
legend({'France','Allemagne'},'Location','best'); grid on; ylabel('%');
xlim([T(1) T(end)]);

sgtitle({'France (H) vs Allemagne (F) — observables',...
         sprintf('Échantillon : %.2f - %.2f  (N=%d)',T(1),T(end),length(T))},...
        'FontWeight','bold');
saveas(f1, fullfile(fig_dir,'fig1_observables.png'));

% ---- FIG 2 : Zoom sur 2019-présent avec choc énergie surligné --------
tzoom = T >= 2019;
f2 = figure('Name','Zoom 2019+','Position',[150 150 1000 600]);

subplot(2,1,1);
plot(T(tzoom), pi_H_obs(tzoom)*400, 'b', ...
     T(tzoom), pi_F_obs(tzoom)*400, 'r', 'LineWidth', 1.5);
hold on;
% Bande grise pour la période de choc énergétique majeur
yl = ylim; patch([2021.5 2023 2023 2021.5],[yl(1) yl(1) yl(2) yl(2)], ...
                 [.9 .9 .9], 'EdgeColor','none','FaceAlpha',0.4);
plot(T(tzoom), pi_H_obs(tzoom)*400, 'b', ...
     T(tzoom), pi_F_obs(tzoom)*400, 'r', 'LineWidth', 1.5);
title('Inflation HICP FR vs DE — zoom choc énergétique (bande grise)');
legend({'France','Allemagne','choc énergie'},'Location','best');
ylabel('Inflation annualisée (pp dev. vs 2%)'); grid on;

subplot(2,1,2);
plot(T(tzoom), pi_NRG_H_q(tzoom)*400, 'b', ...
     T(tzoom), pi_NRG_F_q(tzoom)*400, 'r', 'LineWidth', 1.5);
hold on;
yl = ylim; patch([2021.5 2023 2023 2021.5],[yl(1) yl(1) yl(2) yl(2)], ...
                 [.9 .9 .9], 'EdgeColor','none','FaceAlpha',0.4);
plot(T(tzoom), pi_NRG_H_q(tzoom)*400, 'b', ...
     T(tzoom), pi_NRG_F_q(tzoom)*400, 'r', 'LineWidth', 1.5);
title('Composante énergie du HICP — inflation trimestrielle annualisée');
legend({'France','Allemagne','choc énergie'},'Location','best');
ylabel('Inflation annualisée (%)'); xlabel('Année'); grid on;

saveas(f2, fullfile(fig_dir,'fig2_choc_energie.png'));

% ---- FIG 3 : Différentiel inflation FR-DE (canal soft inflation) ------
f3 = figure('Name','Différentiel inflation','Position',[200 200 900 400]);
plot(T, (pi_F_obs - pi_H_obs)*400, 'k-', 'LineWidth', 1.3);
hold on; yline(0,'--','Color',[.5 .5 .5]);
yl = ylim; patch([2021.5 2023 2023 2021.5],[yl(1) yl(1) yl(2) yl(2)], ...
                 [.95 .85 .85], 'EdgeColor','none','FaceAlpha',0.4);
title('Différentiel d''inflation Allemagne − France (pp, annualisé)');
ylabel('\pi_F - \pi_H (pp)'); grid on; xlim([T(1) T(end)]);
saveas(f3, fullfile(fig_dir,'fig3_differentiel_inflation.png'));

% =========================================================================
% 3) STATISTIQUES DESCRIPTIVES
% =========================================================================
fprintf('\n--- Statistiques descriptives ---\n');
headers = {'Variable','Mean','Std','Min','Max','AR(1)','Nobs'};
stats = cell(numel(vars_obs), 7);
for k = 1:numel(vars_obs)
    v = eval(vars_obs{k});
    v = v(~isnan(v));
    if numel(v) < 5
        stats(k,:) = {vars_obs{k}, NaN, NaN, NaN, NaN, NaN, numel(v)};
        continue;
    end
    ar1 = corr(v(1:end-1), v(2:end));
    stats(k,:) = {vars_obs{k}, mean(v), std(v), min(v), max(v), ar1, numel(v)};
end
T_stats = cell2table(stats, 'VariableNames', headers);
disp(T_stats);

% Export CSV des stats pour le rapport
writetable(T_stats, fullfile(data_dir, 'stats_desc.csv'));
fprintf('Stats enregistrées : %s\n', fullfile(data_dir,'stats_desc.csv'));

% =========================================================================
% 4) TESTS DE STATIONNARITÉ
% =========================================================================
% Résultats écrits dans logs/stationarity_tests.log pour réutilisation dans
% la rédaction du rapport.
logfile = fullfile(log_dir, 'stationarity_tests.log');
fid = fopen(logfile, 'w');

has_adf = exist('adftest','file') == 2;

fprintf(fid, '==============================================================\n');
fprintf(fid, '  STATIONARITY TESTS  -  ImportedInflation project\n');
fprintf(fid, '==============================================================\n');
fprintf(fid, 'Run date    : %s\n', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
fprintf(fid, 'Data file   : %s\n', infile);
fprintf(fid, 'Sample      : %.2f - %.2f  (N = %d)\n', T(1), T(end), length(T));
if has_adf
    fprintf(fid, 'Test        : Augmented Dickey-Fuller (Model = ARD, drift)\n');
    fprintf(fid, 'H0          : racine unitaire\n');
    fprintf(fid, 'Decision    : rejet de H0 au seuil 5%% (p<0.05) => stationnaire\n');
else
    fprintf(fid, 'Test        : AR(1) coefficient (Econometrics Toolbox indisponible)\n');
    fprintf(fid, 'Decision    : |rho| < 0.98 => stationnaire (indicatif)\n');
end
fprintf(fid, '--------------------------------------------------------------\n\n');

fprintf('\n--- Tests de stationnarité ---\n');
if has_adf
    hdr = sprintf('%-14s  %6s  %+10s  %10s  %-13s\n', ...
                  'Variable','N','ADF-stat','p-value','Stationnaire?');
    fprintf(fid, '%s', hdr); fprintf('%s', hdr);
    for k = 1:numel(vars_obs)
        v = eval(vars_obs{k}); v = v(~isnan(v));
        if numel(v) < 30
            line = sprintf('%-14s  %6d  %10s  %10s  %s\n', ...
                   vars_obs{k}, numel(v), 'n/a', 'n/a', 'Nobs insuffisant');
        else
            [h, pv, stat] = adftest(v, 'Model', 'ARD');
            line = sprintf('%-14s  %6d  %+10.3f  %10.4f  %-13s\n', ...
                   vars_obs{k}, numel(v), stat, pv, ...
                   ternary(h==1, 'OUI', 'non'));
        end
        fprintf(fid, '%s', line); fprintf('%s', line);
    end
else
    hdr = sprintf('%-14s  %6s  %+8s  %-20s\n', ...
                  'Variable','N','AR(1)','Verdict');
    fprintf(fid, '%s', hdr); fprintf('%s', hdr);
    for k = 1:numel(vars_obs)
        v = eval(vars_obs{k}); v = v(~isnan(v));
        if numel(v) < 5
            line = sprintf('%-14s  %6d  %8s  %s\n', ...
                   vars_obs{k}, numel(v), 'n/a', 'Nobs insuffisant');
        else
            ar1 = corr(v(1:end-1), v(2:end));
            verdict = ternary(abs(ar1) < 0.98, ...
                              'stationnaire', 'suspect (racine unitaire?)');
            line = sprintf('%-14s  %6d  %+8.3f  %s\n', ...
                   vars_obs{k}, numel(v), ar1, verdict);
        end
        fprintf(fid, '%s', line); fprintf('%s', line);
    end
end

fprintf(fid, '\n--------------------------------------------------------------\n');
fprintf(fid, 'Lecture du tableau :\n');
fprintf(fid, '  Series en taux de croissance (gy_*, gc_*, gex_*, pi_*) :\n');
fprintf(fid, '    attendues stationnaires (log-diff).\n');
fprintf(fid, '  Series d''inflation energie (pi_NRG_*) :\n');
fprintf(fid, '    attendues stationnaires mais tres volatiles pendant 2021-2023.\n');
fprintf(fid, '  r_H_obs (Euribor - r_bar) : stationnaire en niveau apres centrage.\n');
fprintf(fid, '==============================================================\n');
fclose(fid);

fprintf('\n>> Log stationnarite sauvegarde : %s\n', logfile);

% =========================================================================
% 5) CORRÉLATIONS CROISÉES CLÉS
% =========================================================================
fprintf('\n--- Corrélations croisées ---\n');

% (a) Inflation FR vs DE
ok_pi = ~isnan(pi_H_obs) & ~isnan(pi_F_obs);
[r, lags] = xcov(pi_H_obs(ok_pi), pi_F_obs(ok_pi), 8, 'coeff');

% (b) Inflation énergie DE vs inflation totale FR (canal imported inflation)
v1 = pi_NRG_F_q; v2 = pi_H_obs;
ok = ~isnan(v1) & ~isnan(v2);
[r2, lags2] = xcov(v1(ok), v2(ok), 8, 'coeff');

f4 = figure('Name','Corrélations croisées','Position',[250 250 1000 400]);
subplot(1,2,1); stem(lags, r, 'filled'); grid on;
title('\pi_H vs \pi_F (xcorr normalisée)'); xlabel('lag (trimestres)');
ylabel('corrélation'); yline(0,'--');

subplot(1,2,2); stem(lags2, r2, 'filled','r'); grid on;
title('\pi^{NRG}_{F}(t) vs \pi_H(t+k)  —  transmission DE->FR');
xlabel('lag k'); ylabel('corrélation'); yline(0,'--');
saveas(f4, fullfile(fig_dir,'fig4_correlations_croisees.png'));

fprintf('\nFigures sauvegardées dans : %s\n', fig_dir);
fprintf('Fichiers : fig1_observables.png, fig2_choc_energie.png,\n');
fprintf('          fig3_differentiel_inflation.png, fig4_correlations_croisees.png\n');

% =========================================================================
%  UTILITAIRE
% =========================================================================
function out = ternary(cond, a, b)
    if cond, out = a; else, out = b; end
end
