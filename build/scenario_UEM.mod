% ============================================================
%  scenario_UEM.mod
%  Scenario contrefactuel : choc d'energie 2021-2023 sous deux
%  regimes de politique monetaire BCE.
%
%  Modele : two_countries_UEM (post-estimation).
%  Parametres : moyenne posterieure (cf. data/tables/posterior_summary.csv).
%
%  La regle BCE phi_pi est *parametree au runtime* via set_param_value
%  depuis run_scenario_UEM.m :
%     - regime "baseline" : phi_pi = 2.468 (estime)
%     - regime "hawkish"  : phi_pi = 3.702 = 1.5 * 2.468
%
%  Le scenario d'interet (cf. run_scenario_UEM.m) :
%     eta_p_F = +3*sigma persistant 4 trimestres (replique
%     l'episode de choc gazier 2021Q4-2022Q3).
% ============================================================

close all;

%----------------------------------------------------------------
% 1. Declaration des variables
%----------------------------------------------------------------
var
    c_H pic_H pi_H mc_H w_H h_H y_H p_H NFA_H lb_H ex_H
    c_F pic_F pi_F mc_F w_F h_F y_F p_F NFA_F lb_F ex_F
    r rer pi_UEM y_UEM
    e_z_H e_p_H e_x_H e_g_H
    e_z_F e_p_F e_x_F e_g_F
    e_r
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
% 2. Calibration POSTERIEURE (mode + std posterieur, iter 9)
%----------------------------------------------------------------

% --- Preferences (sigma calibres, hc estimes) ---
sigmaC_H    = 1.5;
sigmaC_F    = 1.5;
sigmaH_H    = 2.0;
sigmaH_F    = 2.0;
beta        = 0.995;
hc_H        = 0.808;    % POSTERIEUR (prior 0.7)
hc_F        = 0.956;    % POSTERIEUR (prior 0.7)

% --- Technologie ---
alpha       = 0.65;
Hss         = 1/3;

% --- Rigidites nominales (estimees) ---
xi_H        = 99.665;   % POSTERIEUR (prior 80)
xi_F        = 100.890;  % POSTERIEUR (prior 100)
epsilon_H   = 10;
epsilon_F   = 10;

% --- Commerce bilateral (calibres) ---
mu          = 1.5;
alphaC_H    = 0.220;
alphaC_F    = 0.117;

% --- Tailles relatives ---
n           = 0.40;
y0          = 2.85;

% --- Cout portefeuille (stationnarite numerique) ---
chi_B       = 1e-3;

% --- Politique monetaire BCE (rho et phi_pi estimes) ---
rho         = 0.753;    % POSTERIEUR (prior 0.85)
phi_pi      = 2.468;    % POSTERIEUR (prior 1.5)
                        % Override par set_param_value en mode hawkish
                        % depuis run_scenario_UEM.m
phi_y       = 0.125;
piss        = 1.005;

% --- Depenses publiques ---
gy_H        = 0.24;
gy_F        = 0.20;

% --- Persistance des chocs (z_*, r estimes ; reste calibres) ---
rho_z_H     = 0.719;    % POSTERIEUR (prior 0.85)
rho_z_F     = 0.948;    % POSTERIEUR (prior 0.85)
rho_p_H     = 0.90;
rho_p_F     = 0.95;
rho_x_H     = 0.85;
rho_x_F     = 0.85;
rho_g_H     = 0.85;
rho_g_F     = 0.85;
rho_r       = 0.760;    % POSTERIEUR (prior 0.50)

%----------------------------------------------------------------
% 3. Steady-state (identique two_countries_UEM)
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

    c_F = ( y_F - g_F_ss - ((1-phi_H)*n/(1-n))*(y_H - g_H_ss)/phi_H ) / ( phi_F - (1-phi_H)*(1-phi_F)/phi_H );
    c_H = ( y_H - g_H_ss - (1-phi_F)*c_F*(1-n)/n ) / phi_H;

    lb_H = (c_H - hc_H*c_H)^(-sigmaC_H);
    lb_F = (c_F - hc_F*c_F)^(-sigmaC_F);

    r       = piss/beta;
    pic_H   = piss; pic_F = piss;
    pi_H    = piss; pi_F  = piss;
    pi_UEM  = piss;
    y_UEM   = n*y_H + (1-n)*y_F;

    TB_H_ss = (1-phi_F)*(1-n)/n*c_F - (1-phi_H)*c_H;
    NFA_H   = TB_H_ss * beta / (beta - 1);
    NFA_F   = -n/(1-n) * NFA_H;
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
% 4. Modele (identique two_countries_UEM)
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

    % ===== EQUATIONS DE MESURE =====
    [name='mesure : croissance PIB FR']
    gy_H_obs = log(y_H/y_H(-1));
    [name='mesure : croissance PIB DE']
    gy_F_obs = log(y_F/y_F(-1));
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
% 5. Verifications
%----------------------------------------------------------------
steady;
resid;
check;

%----------------------------------------------------------------
% 6. Chocs (POSTERIEURS pour z_*, p_* ; calibres pour x_*, g_*, r)
%----------------------------------------------------------------
shocks;
    var eta_z_H;  stderr 0.0049;   % POSTERIEUR
    var eta_z_F;  stderr 0.0047;   % POSTERIEUR
    var eta_p_H;  stderr 0.0095;   % POSTERIEUR
    var eta_p_F;  stderr 0.0068;   % POSTERIEUR
    var eta_x_H;  stderr 0.005;    % calibre
    var eta_x_F;  stderr 0.005;    % calibre
    var eta_g_H;  stderr 0.005;    % calibre
    var eta_g_F;  stderr 0.005;    % calibre
    var eta_r;    stderr 0.003;    % calibre
    corr eta_p_H, eta_p_F = 0.7;
end;

%----------------------------------------------------------------
% 7. IRFs avec graphes (cle pour points 5 et 6 du rapport)
%----------------------------------------------------------------
% On garde les graphes : Dynare produit des EPS dans
% scenario_UEM/graphs/ que run_scenario_UEM.m copie ensuite vers
% data/figures/.
% NB Dynare 6.5 : graph_format accepte EPS, PDF, FIG, NONE (pas PNG).
% On choisit EPS+PDF ; run_scenario_UEM.m convertit ensuite si besoin.
stoch_simul(order=1, irf=20, graph_format=(eps,pdf))
    y_H y_F c_H c_F pi_H pi_F pic_H pic_F pi_UEM r rer ex_H ex_F NFA_H
    gy_H_obs gy_F_obs pi_H_obs pi_F_obs ;
