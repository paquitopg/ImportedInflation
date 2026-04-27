% ============================================================
%  two_countries_UEM.mod
%  DSGE a deux pays adapte a l'Union Economique et Monetaire.
%  Home = France, Foreign = Allemagne.
%  Projet ENSAE 2026  ImportedInflation.
% ============================================================

close all;

%----------------------------------------------------------------
% 1. Declaration des variables
%----------------------------------------------------------------
var
    % Home (France)
    c_H pic_H pi_H mc_H w_H h_H y_H p_H NFA_H lb_H ex_H
    % Foreign (Allemagne)
    c_F pic_F pi_F mc_F w_F h_F y_F p_F NFA_F lb_F ex_F
    % Union monetaire (un seul taux, real exchange rate intra-UEM)
    r rer pi_UEM y_UEM
    % Chocs structurels (processus AR(1))
    e_z_H e_p_H e_x_H e_g_H
    e_z_F e_p_F e_x_F e_g_F
    e_r
    % Observables (equations de mesure)
    gy_H_obs gy_F_obs pi_H_obs pi_F_obs ;

varexo
    eta_z_H eta_p_H eta_x_H eta_g_H
    eta_z_F eta_p_F eta_x_F eta_g_F
    eta_r ;

parameters
    sigmaC_H sigmaC_F sigmaH_H sigmaH_F beta alpha hc_H hc_F
    chi_B chi_H chi_F
    xi_H xi_F epsilon_H epsilon_F mu
    alphaC_H alphaC_F phi_H phi_F n
    rho phi_pi phi_y piss
    gy_H gy_F y0 A Hss
    rho_z_H rho_p_H rho_x_H rho_g_H
    rho_z_F rho_p_F rho_x_F rho_g_F
    rho_r ;

%----------------------------------------------------------------
% 2. Calibration FR-DE
%----------------------------------------------------------------

% --- Preferences (symetriques, standards UEM) ---
sigmaC_H    = 1.5;      % aversion au risque FR
sigmaC_F    = 1.5;      % aversion au risque DE
sigmaH_H    = 2.0;      % Frisch inverse FR
sigmaH_F    = 2.0;      % Frisch inverse DE
beta        = 0.995;    % taux reel ~2%/an
hc_H        = 0.7;      % habits de consommation FR
hc_F        = 0.7;      % habits de consommation DE

% --- Technologie ---
alpha       = 0.65;     % part du travail, CD UEM
Hss         = 1/3;      % heures travaillees SS

% --- Rigidites nominales (xi_H, xi_F seront estimes) ---
xi_H        = 80;       % cout Rotemberg FR (mediane freq ajust. 4-5Q)
xi_F        = 100;      % cout Rotemberg DE (mediane freq ajust. 6-7Q)
epsilon_H   = 10;       % substitution DS FR (markup 11%)
epsilon_F   = 10;       % substitution DS DE

% --- Commerce bilateral (asymetrie clef de la transmission) ---
% alphaC_i est le parametre d'ouverture tel que la part des biens
% etrangers dans le panier de conso s'ecrit (1-phi_i) = n_k * alphaC_i.
% Cibles empiriques : imports bilateraux / PIB propre = 13% (FR) / 3.5% (DE).
% Valeurs resolues pour atteindre ces cibles au steady-state.
mu          = 1.5;      % Armington intra-UE
alphaC_H    = 0.259;    % openness FR -> 1-phi_H = 0.155 (13% PIB FR)
alphaC_F    = 0.117;    % openness DE -> 1-phi_F = 0.047 (3.5% PIB DE)

% --- Tailles relatives ---
n           = 0.40;     % FR/(FR+DE) en volume 2025
y0          = 2.85;     % PIB FR trimestriel en T d'euros (approx.)

% --- Cout portefeuille (stationnarite numerique uniquement) ---
chi_B       = 1e-3;

% --- Politique monetaire BCE ---
rho         = 0.85;     % lissage
phi_pi      = 1.5;      % reaction inflation
phi_y       = 0.125;    % reaction activite
piss        = 1.005;    % cible 2%/an

% --- Depenses publiques ---
gy_H        = 0.24;     % France, historiquement plus interventionniste
gy_F        = 0.20;     % Allemagne

% --- Processus AR(1) des chocs ---
% Technologie (standard)
rho_z_H     = 0.95;
rho_z_F     = 0.95;
% Cost-push (= proxy choc energie) : asymetrique,
% calibre sur les series pi_NRG_H et pi_NRG_F
rho_p_H     = 0.90;
rho_p_F     = 0.95;
% Import (preference)
rho_x_H     = 0.85;
rho_x_F     = 0.85;
% Depenses publiques
rho_g_H     = 0.85;
rho_g_F     = 0.85;
% Politique monetaire (choc unique BCE)
rho_r       = 0.50;

%----------------------------------------------------------------
% 3. Steady-state
%----------------------------------------------------------------
steady_state_model;
    h_H     = Hss;
    h_F     = Hss;
    phi_H   = 1 - (1-n)*alphaC_H;
    phi_F   = 1 - n*alphaC_F;
    y_H     = y0/n;
    A       = y_H / h_H^alpha;
    y_F     = A * h_F^alpha;
    g_H_ss  = gy_H * y_H;
    g_F_ss  = gy_F * y_F;

    % Allocation SS depuis les contraintes de ressources (sans abatement)
    c_F = ( y_F - g_F_ss - ((1-phi_H)*n/(1-n))*(y_H - g_H_ss)/phi_H ) / ( phi_F - (1-phi_H)*(1-phi_F)/phi_H );
    c_H = ( y_H - g_H_ss - (1-phi_F)*c_F*(1-n)/n ) / phi_H;

    lb_H = (c_H - hc_H*c_H)^(-sigmaC_H);
    lb_F = (c_F - hc_F*c_F)^(-sigmaC_F);

    r       = piss/beta;
    pic_H   = piss; pic_F = piss;
    pi_H    = piss; pi_F  = piss;
    pi_UEM  = piss;
    y_UEM   = n*y_H + (1-n)*y_F;

    % --- NFA-SS : finance la balance commerciale bilaterale.
    % Avec FR plus ouverte que DE (alphaC_H >> alphaC_F) et productivites
    % symetriques, FR a un deficit commercial structurel TB_H_ss < 0.
    % L'equation NFA impose au SS : NFA_H_ss * (1 - 1/beta) = TB_H_ss,
    % donc NFA_H_ss > 0 (FR creanciere nette) finance le deficit
    % commercial via les revenus d'interets.
    TB_H_ss = (1-phi_F)*(1-n)/n*c_F - (1-phi_H)*c_H;
    NFA_H   = TB_H_ss * beta / (beta - 1);
    NFA_F   = -n/(1-n) * NFA_H;     % bouclage international
    rer     = 1;

    mc_H  = (epsilon_H - 1)/epsilon_H;
    mc_F  = (epsilon_F - 1)/epsilon_F;
    w_H   = mc_H * alpha * y_H / h_H;
    w_F   = mc_F * alpha * y_F / h_F;
    p_H   = 1; p_F = 1;
    ex_H  = (1-phi_F) * c_F * (1-n);
    ex_F  = (1-phi_H) * c_H * n;

    chi_H = lb_H * w_H / h_H^sigmaH_H;
    chi_F = lb_F * w_F / h_F^sigmaH_F;

    e_z_H = 1; e_p_H = 1; e_x_H = 1; e_g_H = 1;
    e_z_F = 1; e_p_F = 1; e_x_F = 1; e_g_F = 1;
    e_r   = 1;

    gy_H_obs = 0; gy_F_obs = 0; pi_H_obs = 0; pi_F_obs = 0;
end;

%----------------------------------------------------------------
% 4. Modele (equations structurelles)
%----------------------------------------------------------------
model;
    % ===== MENAGES =====
    [name='FOC consommation']
    lb_H = (c_H - hc_H*c_H(-1))^(-sigmaC_H);
    lb_F = (c_F - hc_F*c_F(-1))^(-sigmaC_F);
    [name='Equation d Euler (taux unique r en UEM)']
    lb_H = beta * lb_H(+1) * r / pic_H(+1);
    lb_F = beta * lb_F(+1) * r / pic_F(+1);
    [name='Offre de travail']
    chi_H * h_H^sigmaH_H = lb_H * w_H;
    chi_F * h_F^sigmaH_F = lb_F * w_F;

    % ===== FIRMES =====
    [name='NKPC Rotemberg Home']
    (1-epsilon_H) + epsilon_H*e_p_H*mc_H
        - xi_H*pi_H*(pi_H - piss)
        + xi_H*beta * ((c_H(+1)-hc_H*c_H)/(c_H-hc_H*c_H(-1)))^(-sigmaC_H)
                    * pi_H(+1)*(pi_H(+1)-piss) * y_H(+1)/y_H ;
    [name='NKPC Rotemberg Foreign']
    (1-epsilon_F) + epsilon_F*e_p_F*mc_F
        - xi_F*pi_F*(pi_F - piss)
        + xi_F*beta * ((c_F(+1)-hc_F*c_F)/(c_F-hc_F*c_F(-1)))^(-sigmaC_F)
                    * pi_F(+1)*(pi_F(+1)-piss) * y_F(+1)/y_F ;
    [name='FOC travail entreprise']
    mc_H = h_H/(alpha*y_H) * w_H;
    mc_F = h_F/(alpha*y_F) * w_F;
    [name='Production']
    y_H = A * e_z_H * h_H^alpha;
    y_F = A * e_z_F * h_F^alpha;
    [name='Indice de prix CES']
    1 = phi_H * p_H^(1-mu) + (1-phi_H) * rer^(1-mu);
    1 = phi_F * p_F^(1-mu) + (1-phi_F) * (1/rer)^(1-mu);
    [name='Prix relatif']
    p_H/p_H(-1) = pi_H / pic_H;
    p_F/p_F(-1) = pi_F / pic_F;

    % ===== CONTRAINTES DE RESSOURCES =====
    % (sans abatement ni taxe carbone)
    [name='Marche biens Home']
    y_H = phi_H*p_H^(-mu)*c_H
        + e_x_F*(1-phi_F)*(p_H/rer)^(-mu)*c_F*(1-n)/n
        + gy_H*STEADY_STATE(y_H)*e_g_H
        + 0.5*xi_H*(pi_H - piss)^2 * y_H
        + 0.5*chi_B*(NFA_H - STEADY_STATE(NFA_H))^2 ;
    [name='Marche biens Foreign']
    y_F = phi_F*p_F^(-mu)*c_F
        + e_x_H*(1-phi_H)*(p_F*rer)^(-mu)*c_H*n/(1-n)
        + gy_F*STEADY_STATE(y_F)*e_g_F
        + 0.5*xi_F*(pi_F - piss)^2 * y_F
        - 0.5*chi_B*(NFA_F - STEADY_STATE(NFA_F))^2 ;

    % ===== UNION MONETAIRE =====
    [name='Aggregat inflation UEM HICP (GDP weighted)']
    pi_UEM = n*pic_H + (1-n)*pic_F;
    [name='Aggregat activite UEM']
    y_UEM = n*y_H + (1-n)*y_F;
    [name='Regle BCE unique (lissee)']
    r = r(-1)^rho
        * ( STEADY_STATE(r) * (pi_UEM/piss)^phi_pi
                            * (y_UEM/STEADY_STATE(y_UEM))^phi_y )^(1-rho)
        * e_r ;

    % ===== COMPTE COURANT BILATERAL =====
    % (pas de *de* car Delta e_t = 1 en UEM ; r_H = r_F = r)
    [name='Accumulation NFA (Home)']
    NFA_H = r(-1)/pic_H * NFA_H(-1)
          + p_H * ( phi_H*p_H^(-mu)*c_H
                  + e_x_F*(1-phi_F)*(1-n)/n*(p_H/rer)^(-mu)*c_F )
          - c_H ;
    [name='Bouclage international']
    n*NFA_H + (1-n)*NFA_F = 0;
    [name='Taux de change reel (intra-UEM = differentiel d inflation)']
    rer/rer(-1) = pi_F/pi_H;

    % ===== EXPORTS BILATERAUX =====
    [name='Exports FR vers DE']
    ex_H = e_x_H*(1-phi_F)*(p_H/rer)^(-mu)*c_F*(1-n);
    [name='Exports DE vers FR']
    ex_F = e_x_F*(1-phi_H)*(p_F*rer)^(-mu)*c_H*n;

    % ===== EQUATIONS DE MESURE (4 observables) =====
    [name='mesure : croissance PIB FR']
    gy_H_obs = log(y_H/y_H(-1));
    [name='mesure : croissance PIB DE']
    gy_F_obs = log(y_F/y_F(-1));
    % Note : les donnees empiriques sont du HICP (inflation conso), donc
    % on mesure sur pic_H / pic_F (non sur pi_H / pi_F qui est l'inflation
    % des producteurs domestiques).
    [name='mesure : inflation HICP FR (deviation cible)']
    pi_H_obs = pic_H - piss;
    [name='mesure : inflation HICP DE (deviation cible)']
    pi_F_obs = pic_F - piss;

    % ===== PROCESSUS STOCHASTIQUES =====
    log(e_z_H) = rho_z_H*log(e_z_H(-1)) + eta_z_H;
    log(e_p_H) = rho_p_H*log(e_p_H(-1)) + eta_p_H;
    log(e_x_H) = rho_x_H*log(e_x_H(-1)) + eta_x_H;
    log(e_g_H) = rho_g_H*log(e_g_H(-1)) + eta_g_H;
    log(e_z_F) = rho_z_F*log(e_z_F(-1)) + eta_z_F;
    log(e_p_F) = rho_p_F*log(e_p_F(-1)) + eta_p_F;
    log(e_x_F) = rho_x_F*log(e_x_F(-1)) + eta_x_F;
    log(e_g_F) = rho_g_F*log(e_g_F(-1)) + eta_g_F;
    log(e_r)   = rho_r  *log(e_r(-1))   + eta_r;
end;

%----------------------------------------------------------------
% 5. Verifications Dynare
%----------------------------------------------------------------
steady;
resid;
check;

%----------------------------------------------------------------
% 6. Chocs (ecarts-types calibres + correlation energie)
%----------------------------------------------------------------
% Les std des chocs non-energie seront estimes; ceux de l'energie
% (eta_p_H, eta_p_F) sont calibres sur pi_NRG_H et pi_NRG_F.
shocks;
    var eta_z_H;  stderr 0.007;
    var eta_z_F;  stderr 0.007;
    var eta_p_H;  stderr 0.005;   % calibre (FR, bouclier tarifaire)
    var eta_p_F;  stderr 0.015;   % calibre (DE, exposition gaz)
    var eta_x_H;  stderr 0.01;
    var eta_x_F;  stderr 0.01;
    var eta_g_H;  stderr 0.01;
    var eta_g_F;  stderr 0.01;
    var eta_r;    stderr 0.002;
    % Choc energie = choc commun FR/DE, amplitude differente
    corr eta_p_H, eta_p_F = 0.7;
end;

%----------------------------------------------------------------
% 7. IRF : choc energie cote Allemagne (eta_p_F de 1 ecart-type)
%----------------------------------------------------------------
stoch_simul(order=1, irf=20, nograph) y_H y_F c_H c_F pi_H pi_F
    pic_H pic_F pi_UEM r rer ex_H ex_F NFA_H ;
