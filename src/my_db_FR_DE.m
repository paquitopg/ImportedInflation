% =========================================================================
%  my_db_FR_DE.m
%  Collecte DBnomics des séries France / Allemagne
%
%  Observables cibles :
%      gy_H_obs : croissance PIB réel France (Home)
%      gy_F_obs : croissance PIB réel Allemagne (Foreign)
%      pi_H_obs : inflation trimestrielle France (déviation vs ss)
%      pi_F_obs : inflation trimestrielle Allemagne (déviation vs ss)
%
%  Séries descriptives / scénarios :
%      conso FR/DE, exports FR/DE, HICP énergie FR/DE, Euribor 3M.
%
%  Sortie : ../data/myobs_FR_DE.mat
% =========================================================================

close all; clc;

% --- Localisation des dossiers du projet ---------------------------------
this_dir = fileparts(mfilename('fullpath'));           % .../src
proj_dir = fileparts(this_dir);                        % racine projet
data_dir = fullfile(proj_dir, 'data');                 % dossier de sortie
if ~exist(data_dir, 'dir'), mkdir(data_dir); end

% =========================================================================
% 1) REQUÊTES DBNOMICS
% =========================================================================
CLV_BASE = 'CLV20_MEUR';   % alternatives : 'CLV15_MEUR', 'CLV10_MEUR'

fprintf('--- Téléchargement des séries quarterly (National Accounts) ---\n');
fprintf('    Base volume utilisée : %s\n', CLV_BASE);

% --- Données trimestrielles : PIB, consommation, exports, volumes SA ----
% Eurostat QNA — chain-linked volumes, SCA = SA + Calendar Adjusted
[~, T_gdp] = call_dbnomics( ...
    ['Eurostat/namq_10_gdp/Q.' CLV_BASE '.SCA.B1GQ.FR+DE']);      % PIB

[~, T_con] = call_dbnomics( ...
    ['Eurostat/namq_10_gdp/Q.' CLV_BASE '.SCA.P31_S14_S15.FR+DE']); % Conso

[~, T_exp] = call_dbnomics( ...
    ['Eurostat/namq_10_gdp/Q.' CLV_BASE '.SCA.P6.FR+DE']);         % Exports

fprintf('--- Téléchargement des séries mensuelles (HICP + taux) ---\n');

% --- HICP mensuel, index 2015=100, CP00 = all-items, NRG = énergie ------
[~, T_hicp_all] = call_dbnomics( ...
    'Eurostat/prc_hicp_midx/M.I15.CP00.FR+DE');                   % HICP total

[~, T_hicp_nrg] = call_dbnomics( ...
    'Eurostat/prc_hicp_midx/M.I15.NRG.FR+DE');                    % HICP énergie

% --- Taux Euribor 3 mois (zone euro), en % annualisé --------------------
[~, T_rate] = call_dbnomics( ...
    'Eurostat/irt_st_m/M.IRT_M3.EA');                             % Euribor 3M

% =========================================================================
% 2) NETTOYAGE ET AGRÉGATION TRIMESTRIELLE
% =========================================================================

% --- Variables quarterly déjà en fréquence cible -------------------------
% On convertit les row names 'yyyy-qq' en yyyy.q (0, .25, .5, .75)
fprintf('--- Construction d''un échantillon quarterly commun ---\n');

t_q_gdp = qdate(T_gdp.Properties.RowNames);
t_q_con = qdate(T_con.Properties.RowNames);
t_q_exp = qdate(T_exp.Properties.RowNames);

% --- HICP mensuel → trimestriel (moyenne des 3 mois) --------------------
[t_q_hicp, hicp_FR_q]   = m2q_mean(T_hicp_all.Properties.RowNames, T_hicp_all.FR);
[~,        hicp_DE_q]   = m2q_mean(T_hicp_all.Properties.RowNames, T_hicp_all.DE);
[~,        hicp_NRG_FR] = m2q_mean(T_hicp_nrg.Properties.RowNames, T_hicp_nrg.FR);
[~,        hicp_NRG_DE] = m2q_mean(T_hicp_nrg.Properties.RowNames, T_hicp_nrg.DE);

% --- Taux Euribor mensuel → trimestriel (moyenne) -----------------------
[t_q_rate, rate_q]      = m2q_mean(T_rate.Properties.RowNames, T_rate{:,1});

% =========================================================================
% 3) ALIGNEMENT SUR UNE FENÊTRE COMMUNE 1999Q1 → dernier dispo
% =========================================================================

t_start = 1999.00;                           % début Euro
t_end   = min([max(t_q_gdp) max(t_q_con) max(t_q_exp) ...
               max(t_q_hicp) max(t_q_rate)]);

T       = (t_start:0.25:t_end)';

gdp_FR  = align(t_q_gdp, T_gdp.FR, T);
gdp_DE  = align(t_q_gdp, T_gdp.DE, T);
con_FR  = align(t_q_con, T_con.FR, T);
con_DE  = align(t_q_con, T_con.DE, T);
exp_FR  = align(t_q_exp, T_exp.FR, T);
exp_DE  = align(t_q_exp, T_exp.DE, T);
hicp_FR = align(t_q_hicp, hicp_FR_q, T);
hicp_DE = align(t_q_hicp, hicp_DE_q, T);
nrg_FR  = align(t_q_hicp, hicp_NRG_FR, T);
nrg_DE  = align(t_q_hicp, hicp_NRG_DE, T);
rate_EA = align(t_q_rate, rate_q, T);

% drop les trimestres avec NaN dans les observables principaux
ok = ~isnan(gdp_FR) & ~isnan(gdp_DE) & ~isnan(hicp_FR) & ~isnan(hicp_DE);
T = T(ok);
gdp_FR = gdp_FR(ok);   gdp_DE = gdp_DE(ok);
con_FR = con_FR(ok);   con_DE = con_DE(ok);
exp_FR = exp_FR(ok);   exp_DE = exp_DE(ok);
hicp_FR = hicp_FR(ok); hicp_DE = hicp_DE(ok);
nrg_FR = nrg_FR(ok);   nrg_DE = nrg_DE(ok);
rate_EA = rate_EA(ok);

% =========================================================================
% 4) TRANSFORMATIONS — COHÉRENCE AVEC LES ÉQUATIONS DE MESURE
% =========================================================================
%  Le modèle (soe_standard.mod) exige :
%     gy_X_obs = log(y_X/y_X(-1))                 (croissance trimestrielle)
%     pi_X_obs = pi_X - ss(pi_X)                  (déviation vs ss trimestriel)
%     r_X_obs  = r_X - ss(r_X)
% =========================================================================

% Croissances
gy_H_obs = diff(log(gdp_FR));       % France = Home
gy_F_obs = diff(log(gdp_DE));       % Allemagne = Foreign
gc_H_obs = diff(log(con_FR));
gc_F_obs = diff(log(con_DE));
gex_H_obs = diff(log(exp_FR));
gex_F_obs = diff(log(exp_DE));

% Inflations trimestrielles (log-diff du niveau HICP)
pi_H_q = diff(log(hicp_FR));
pi_F_q = diff(log(hicp_DE));
pi_NRG_H_q = diff(log(nrg_FR));
pi_NRG_F_q = diff(log(nrg_DE));

% Steady-state supposée cohérente avec piss = 1.005 dans le .mod
% → 0.5 % par trimestre = 2 % annualisé, cible BCE.
piss = log(1.005);
pi_H_obs = pi_H_q - piss;
pi_F_obs = pi_F_q - piss;

% Taux nominal en taux net trimestriel (Euribor en % annuel → /400)
r_EA_q = rate_EA(2:end)/400;
rss = piss + log(1/0.995);          % r̄ ≈ piss/beta (ici beta = 0.995)
r_EA_obs = r_EA_q - rss;

% Même taux utilisé comme observable dans les deux pays (union monétaire)
r_H_obs = r_EA_obs;
r_F_obs = r_EA_obs;

% Vecteur temps aligné sur les différences (retire le 1er point)
T = T(2:end);

% =========================================================================
% 5) ENREGISTREMENT
% =========================================================================
outfile = fullfile(data_dir, 'myobs_FR_DE.mat');
save(outfile, ...
     'T', ...
     'gy_H_obs','gy_F_obs','gc_H_obs','gc_F_obs', ...
     'pi_H_obs','pi_F_obs','r_H_obs','r_F_obs', ...
     'gex_H_obs','gex_F_obs','pi_NRG_H_q','pi_NRG_F_q');
fprintf('--- Sauvegarde : %s ---\n', outfile);

% =========================================================================
% 6) VISUALISATIONS
% =========================================================================

% Figure 1 — observables d'estimation
figure('Name','Observables estimation','NumberTitle','off');
subplot(2,2,1); plot(T, gy_H_obs, 'b', T, gy_F_obs, 'r', 'LineWidth', 1.2);
  title('Croissance PIB réel trimestrielle'); grid on;
  legend('France (H)','Allemagne (F)','Location','best');
  ylabel('log-diff');
subplot(2,2,2); plot(T, pi_H_obs, 'b', T, pi_F_obs, 'r', 'LineWidth', 1.2);
  title('Inflation HICP trimestrielle (déviation vs 2%/an)'); grid on;
  legend('France','Allemagne','Location','best');
subplot(2,2,3); plot(T, gc_H_obs, 'b', T, gc_F_obs, 'r', 'LineWidth', 1.2);
  title('Croissance consommation privée'); grid on;
  legend('France','Allemagne','Location','best');
subplot(2,2,4); plot(T, r_EA_obs, 'k', 'LineWidth', 1.2);
  title('Taux Euribor 3M (déviation vs ss)'); grid on;

% Figure 2 — choc énergétique sur HICP-énergie FR/DE (scénario)
figure('Name','Choc énergétique descriptif','NumberTitle','off');
subplot(1,2,1);
  plot(T, pi_NRG_H_q*400, 'b', T, pi_NRG_F_q*400, 'r', 'LineWidth', 1.2);
  title('Inflation énergie trimestrielle annualisée (%)'); grid on;
  legend('France','Allemagne','Location','best');
subplot(1,2,2);
  plot(T, gex_H_obs, 'b', T, gex_F_obs, 'r', 'LineWidth', 1.2);
  title('Croissance exports totaux (proxy commerce)'); grid on;
  legend('France','Allemagne','Location','best');

fprintf('\n>> Observables sauvegardés. N = %d périodes (de %.2f à %.2f).\n', ...
        length(T), T(1), T(end));


% =========================================================================
%   FONCTIONS UTILITAIRES
% =========================================================================

function t = qdate(rownames)
% Convertit 'yyyy-qq' ou 'yyyy-Qx' en vecteur temporel numérique yyyy + (q-1)/4.
    n = numel(rownames);
    t = zeros(n,1);
    for i = 1:n
        s = rownames{i};
        yyyy = str2double(s(1:4));
        q = str2double(s(end));
        t(i) = yyyy + (q-1)/4;
    end
end

function [t_q, x_q] = m2q_mean(rownames, x)
% Agrège une série mensuelle à partir des row names 'yyyy-mm' en trimestriel
% par moyenne des trois mois de chaque trimestre.
    n = numel(rownames);
    tm = zeros(n,1);
    for i = 1:n
        s = rownames{i};
        yyyy = str2double(s(1:4));
        mm   = str2double(s(6:7));
        tm(i) = yyyy + (mm-1)/12;
    end
    % quarter index
    yyyy = floor(tm);
    mm   = round((tm - yyyy)*12) + 1;
    qq   = ceil(mm/3);
    tq   = yyyy + (qq-1)/4;

    % agrégation
    [t_q,~,idx] = unique(tq);
    x_q = accumarray(idx, x, [], @(v) mean(v,'omitnan'));
    t_q = t_q(:);
    x_q = x_q(:);
end

function xa = align(tx, x, T)
% Alignement d'une série (tx,x) sur le grille T (remplit NaN si manquant)
    xa = nan(size(T));
    for i = 1:length(T)
        idx = find(abs(tx - T(i)) < 1e-6, 1, 'first');
        if ~isempty(idx), xa(i) = x(idx); end
    end
end
