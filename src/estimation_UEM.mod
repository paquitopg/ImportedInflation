% ============================================================
%  estimation_UEM.mod
%  Estimation bayesienne du modele two_countries_UEM
%  sur l'echantillon FR-DE 1999Q2 - 2025Q3 (N=106).
%
%  Projet ENSAE 2026  ImportedInflation.
%
%  Observables (5) :
%     gy_H_obs, gy_F_obs, pi_H_obs, pi_F_obs, r_F_obs
%  NB : gex_*_obs ecartes (variance empirique 50x trop grande pour le DSGE).
%
%  Parametres estimes (16 - ITER 8) :
%     - rigidites nominales : xi_H, xi_F
%     - habits : hc_H, hc_F
%     - regle BCE : rho, phi_pi
%     - persistance : rho_z_H, rho_z_F, rho_r
%     - ecarts-type chocs structurels : eta_z_*, eta_p_*
%     - ecarts-type erreurs de mesure : ME_pi_*, ME_gy_*, ME_r
%       (5 ME estimees pour eviter le catch-all sur chocs structurels)
%
%  Parametres CALIBRES (cf. iter 1-6, sans observable de contrepartie) :
%     - beta, alpha, epsilon, mu, n, piss, phi_y, sigmaC_*, sigmaH_*
%     - commerce bilateral (alphaC_H, alphaC_F)
%     - persistance chocs energie (rho_p_H=0.90, rho_p_F=0.95)
%     - chocs sans observable : eta_x_*, eta_g_*, eta_r calibres tight
%       dans le bloc shocks ; rho_x_*, rho_g_* fixes a 0.85
%     - correlation eta_p_H/eta_p_F = 0.7 (choc energie commun)
%
%  Erreur de mesure (10% std empirique) sur les 5 observables :
%     necessaire car le modele ne peut pas matcher la variance d'inflation
%     observee (cf. iter 6 : sans erreur de mesure, eta_z_* explose en
%     catch-all). Permet une estimation propre et bornee.
% ============================================================

close all;

%----------------------------------------------------------------
% 1. Declaration (identique a two_countries_UEM.mod)
%----------------------------------------------------------------
var
    c_H pic_H pi_H mc_H w_H h_H y_H p_H NFA_H lb_H ex_H
    c_F pic_F pi_F mc_F w_F h_F y_F p_F NFA_F lb_F ex_F
    r rer pi_UEM y_UEM
    e_z_H e_p_H e_x_H e_g_H
    e_z_F e_p_F e_x_F e_g_F
    e_r
    gy_H_obs gy_F_obs pi_H_obs pi_F_obs r_F_obs ;
    % NB : gex_*_obs retires comme observables (volatilite empirique 3.8%/Q
    % vs modele ~0.07%/Q : DSGE sans inventaires/extensive margin ne peut
    % pas matcher cette variance ; provoque non-identification.)

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
% 2. Calibration initiale (cf. two_countries_UEM.mod)
%----------------------------------------------------------------
sigmaC_H = 1.5;     sigmaC_F = 1.5;
sigmaH_H = 2.0;     sigmaH_F = 2.0;
beta     = 0.995;
alpha    = 0.65;
hc_H     = 0.7;     hc_F     = 0.7;
chi_B    = 1e-3;
xi_H     = 80;      xi_F     = 100;
epsilon_H= 10;      epsilon_F= 10;
mu       = 1.5;
alphaC_H = 0.259;   alphaC_F = 0.117;
n        = 0.40;
y0       = 2.85;
rho      = 0.85;    phi_pi   = 1.5;     phi_y    = 0.125;
piss     = 1.005;
gy_H     = 0.24;    gy_F     = 0.20;
Hss      = 1/3;

rho_z_H = 0.95;    rho_z_F = 0.95;
rho_p_H = 0.90;    rho_p_F = 0.95;    % CALIBRES, pas estimes
rho_x_H = 0.85;    rho_x_F = 0.85;
rho_g_H = 0.85;    rho_g_F = 0.85;
rho_r   = 0.50;

%----------------------------------------------------------------
% 3. Steady-state
%----------------------------------------------------------------
steady_state_model;
    h_H = Hss;  h_F = Hss;
    phi_H = 1 - (1-n)*alphaC_H;
    phi_F = 1 - n*alphaC_F;
    y_H = y0/n;
    A   = y_H / h_H^alpha;
    y_F = A * h_F^alpha;
    g_H_ss = gy_H*y_H;  g_F_ss = gy_F*y_F;

    c_F = ( y_F - g_F_ss - ((1-phi_H)*n/(1-n))*(y_H - g_H_ss)/phi_H ) / ( phi_F - (1-phi_H)*(1-phi_F)/phi_H );
    c_H = ( y_H - g_H_ss - (1-phi_F)*c_F*(1-n)/n ) / phi_H;

    lb_H = (c_H - hc_H*c_H)^(-sigmaC_H);
    lb_F = (c_F - hc_F*c_F)^(-sigmaC_F);

    r = piss/beta;
    pic_H = piss; pic_F = piss;
    pi_H  = piss; pi_F  = piss;
    pi_UEM = piss;
    y_UEM  = n*y_H + (1-n)*y_F;

    % NFA_SS finance le deficit commercial bilateral (cf. two_countries_UEM.mod)
    TB_H_ss = (1-phi_F)*(1-n)/n*c_F - (1-phi_H)*c_H;
    NFA_H   = TB_H_ss * beta / (beta - 1);
    NFA_F   = -n/(1-n) * NFA_H;
    rer     = 1;
    mc_H = (epsilon_H-1)/epsilon_H;
    mc_F = (epsilon_F-1)/epsilon_F;
    w_H  = mc_H*alpha*y_H/h_H;
    w_F  = mc_F*alpha*y_F/h_F;
    p_H  = 1; p_F = 1;
    ex_H = (1-phi_F)*c_F*(1-n);
    ex_F = (1-phi_H)*c_H*n;
    chi_H = lb_H*w_H/h_H^sigmaH_H;
    chi_F = lb_F*w_F/h_F^sigmaH_F;
    e_z_H=1; e_p_H=1; e_x_H=1; e_g_H=1;
    e_z_F=1; e_p_F=1; e_x_F=1; e_g_F=1;
    e_r  =1;
    gy_H_obs=0; gy_F_obs=0; pi_H_obs=0; pi_F_obs=0;
    r_F_obs=0;
end;

%----------------------------------------------------------------
% 4. Modele (identique a two_countries_UEM.mod)
%----------------------------------------------------------------
model;
    % === Menages ===
    lb_H = (c_H - hc_H*c_H(-1))^(-sigmaC_H);
    lb_F = (c_F - hc_F*c_F(-1))^(-sigmaC_F);
    lb_H = beta*lb_H(+1)*r/pic_H(+1);
    lb_F = beta*lb_F(+1)*r/pic_F(+1);
    chi_H*h_H^sigmaH_H = lb_H*w_H;
    chi_F*h_F^sigmaH_F = lb_F*w_F;

    % === Firmes ===
    (1-epsilon_H) + epsilon_H*e_p_H*mc_H
        - xi_H*pi_H*(pi_H - piss)
        + xi_H*beta*((c_H(+1)-hc_H*c_H)/(c_H-hc_H*c_H(-1)))^(-sigmaC_H)
                   *pi_H(+1)*(pi_H(+1)-piss)*y_H(+1)/y_H ;
    (1-epsilon_F) + epsilon_F*e_p_F*mc_F
        - xi_F*pi_F*(pi_F - piss)
        + xi_F*beta*((c_F(+1)-hc_F*c_F)/(c_F-hc_F*c_F(-1)))^(-sigmaC_F)
                   *pi_F(+1)*(pi_F(+1)-piss)*y_F(+1)/y_F ;
    mc_H = h_H/(alpha*y_H)*w_H;
    mc_F = h_F/(alpha*y_F)*w_F;
    y_H = A*e_z_H*h_H^alpha;
    y_F = A*e_z_F*h_F^alpha;
    1 = phi_H*p_H^(1-mu) + (1-phi_H)*rer^(1-mu);
    1 = phi_F*p_F^(1-mu) + (1-phi_F)*(1/rer)^(1-mu);
    p_H/p_H(-1) = pi_H/pic_H;
    p_F/p_F(-1) = pi_F/pic_F;

    % === Contraintes de ressources ===
    y_H = phi_H*p_H^(-mu)*c_H
        + e_x_F*(1-phi_F)*(p_H/rer)^(-mu)*c_F*(1-n)/n
        + gy_H*STEADY_STATE(y_H)*e_g_H
        + 0.5*xi_H*(pi_H - piss)^2 * y_H
        + 0.5*chi_B*(NFA_H - STEADY_STATE(NFA_H))^2 ;
    y_F = phi_F*p_F^(-mu)*c_F
        + e_x_H*(1-phi_H)*(p_F*rer)^(-mu)*c_H*n/(1-n)
        + gy_F*STEADY_STATE(y_F)*e_g_F
        + 0.5*xi_F*(pi_F - piss)^2 * y_F
        - 0.5*chi_B*(NFA_F - STEADY_STATE(NFA_F))^2 ;

    % === Politique monetaire unique ===
    pi_UEM = n*pic_H + (1-n)*pic_F;
    y_UEM  = n*y_H + (1-n)*y_F;
    r = r(-1)^rho
        * ( STEADY_STATE(r)*(pi_UEM/piss)^phi_pi
                           *(y_UEM/STEADY_STATE(y_UEM))^phi_y )^(1-rho)
        * e_r ;

    % === Compte courant bilateral ===
    NFA_H = r(-1)/pic_H*NFA_H(-1)
          + p_H*( phi_H*p_H^(-mu)*c_H
                + e_x_F*(1-phi_F)*(1-n)/n*(p_H/rer)^(-mu)*c_F )
          - c_H ;
    n*NFA_H + (1-n)*NFA_F = 0;
    rer/rer(-1) = pi_F/pi_H;

    % === Exports bilateraux ===
    ex_H = e_x_H*(1-phi_F)*(p_H/rer)^(-mu)*c_F*(1-n);
    ex_F = e_x_F*(1-phi_H)*(p_F*rer)^(-mu)*c_H*n;

    % === Equations de mesure ===
    % HICP : pi_*_obs sur pic_*  (pas pi_* qui est le PPI domestique)
    gy_H_obs = log(y_H/y_H(-1));
    gy_F_obs = log(y_F/y_F(-1));
    pi_H_obs = pic_H - piss;
    pi_F_obs = pic_F - piss;
    % Taux UEM : un seul r ; on observe r_F_obs (identique a r_H_obs en data)
    r_F_obs  = r - STEADY_STATE(r);

    % === Processus AR(1) ===
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

steady;
resid;
check;

%----------------------------------------------------------------
% 5. Chocs : les 2 chocs energie sont CALIBRES (hors estim)
%----------------------------------------------------------------
shocks;
    % Correlation energie fixee (le coeur de l'asymetrie cost-push).
    % Les stderr eta_p_* sont ESTIMES (cf. estimated_params).
    corr eta_p_H, eta_p_F = 0.7;
    % Chocs sans observable de contrepartie : CALIBRES tight.
    var eta_g_H;  stderr 0.005;
    var eta_g_F;  stderr 0.005;
    var eta_x_H;  stderr 0.005;
    var eta_x_F;  stderr 0.005;
    var eta_r;    stderr 0.003;
    % NB iter 8 : les erreurs de mesure sont desormais ESTIMEES (cf.
    % estimated_params). Initial values donnees ici.
    var pi_H_obs; stderr 0.0015;
    var pi_F_obs; stderr 0.0020;
    var gy_H_obs; stderr 0.0015;
    var gy_F_obs; stderr 0.0025;
    var r_F_obs;  stderr 0.0008;
end;

%----------------------------------------------------------------
% 6. Observables et bloc d'estimation
%----------------------------------------------------------------
varobs gy_H_obs gy_F_obs pi_H_obs pi_F_obs r_F_obs;

estimated_params;
%   PARAM,                INITVAL,  LB,  UB,    PRIOR,           P1,    P2
    % --- Rigidites nominales (CUR du rapport) ---
    %     ITER 9 : INITVAL = mode iter 8 pour aider CMA-ES.
    xi_H,                 216,      10,  500,   gamma_pdf,       80,    30;
    xi_F,                 230,      10,  500,   gamma_pdf,       100,   30;

    % --- Habits ---
    %     ITER 9 : LB hc_H elargi 0.05 (iter 8 collait hc_H=0.10=LB).
    hc_H,                 0.30,     0.05, 0.97, beta_pdf,        0.7,   0.20;
    hc_F,                 0.50,     0.05, 0.97, beta_pdf,        0.7,   0.20;
    % sigmaC_H, sigmaC_F : CALIBRES a 1.5 (n'ont jamais bouge des priors).

    % --- Regle BCE ---
    %     ITER 9 : phi_pi UB elargi 5.0 (iter 8 collait phi_pi=3.0=UB).
    rho,                  0.85,     0.3, 0.99,  beta_pdf,        0.85,  0.10;
    phi_pi,               2.5,      1.0, 5.0,   gamma_pdf,       1.5,   0.40;
    % phi_y : CALIBRE a 0.125.

    % --- Persistance chocs de productivite (TFP : observable = gy_*_obs) ---
    rho_z_H,              0.90,     0.3, 0.99,  beta_pdf,        0.85,  0.10;
    rho_z_F,              0.75,     0.3, 0.99,  beta_pdf,        0.85,  0.10;
    % rho_x_*, rho_g_*, rho_p_* : CALIBRES.
    rho_r,                0.85,     0,   0.99,  beta_pdf,        0.5,   0.20;

    % --- Ecarts-types des chocs structurels ESTIMES ---
    %     ITER 9 : UB elargi 0.30 (iter 8 collait eta_p_*=0.10=UB sur les 2).
    stderr eta_z_H,       0.005,    1e-4, 0.30,  inv_gamma_pdf,   0.01,  0.01;
    stderr eta_z_F,       0.020,    1e-4, 0.30,  inv_gamma_pdf,   0.01,  0.01;
    stderr eta_p_H,       0.10,     1e-4, 0.30,  inv_gamma_pdf,   0.015, 0.015;
    stderr eta_p_F,       0.10,     1e-4, 0.30,  inv_gamma_pdf,   0.020, 0.020;

    % --- ERREURS DE MESURE ESTIMEES ---
    %     ITER 9 : UB elargi 0.02 (iter 8 collait 3 ME a UB=0.005).
    stderr pi_H_obs,      0.0009,   1e-5, 0.020, inv_gamma_pdf,   0.0015, 0.0015;
    stderr pi_F_obs,      0.005,    1e-5, 0.020, inv_gamma_pdf,   0.0015, 0.0015;
    stderr gy_H_obs,      0.005,    1e-5, 0.020, inv_gamma_pdf,   0.0015, 0.0015;
    stderr gy_F_obs,      0.005,    1e-5, 0.020, inv_gamma_pdf,   0.0025, 0.0025;
    stderr r_F_obs,       0.0016,   1e-5, 0.020, inv_gamma_pdf,   0.0008, 0.0008;
end;

%----------------------------------------------------------------
% 7. Estimation bayesienne
%----------------------------------------------------------------
estimation(
    datafile        = '../data/myobs_FR_DE.mat',
    first_obs       = 1,
    % mode_compute=9 (CMA-ES) : derivative-free, robuste aux regions plates.
    mode_compute    = 9,
    optim           = ('MaxIter', 3000, 'TolFun', 1e-7, 'TolX', 1e-7),
    mode_check,
    % ============================================================
    % ITER 9 : SOLUTION AU PROBLEME HESSIENNE NON-DP
    % ------------------------------------------------------------
    % Quand le mode est sur une paroi (UB/LB), la Hessienne calculee
    % par differences finies n'est pas Definie-Positive ; or MH-RWM
    % a besoin d'une matrice de covariance de proposition PD.
    %
    % MCMC_jumping_covariance = prior_variance utilise la MATRICE DE
    % VARIANCE DES PRIORS comme proposal covariance, ce qui garantit
    % la positive-definitude par construction. C'est l'option officielle
    % Dynare pour contourner ce probleme.
    %
    % Documentee dans le manuel Dynare 6, section 4.20.
    % ============================================================
    MCMC_jumping_covariance = 'prior_variance',
    mh_replic       = 5000,
    mh_nblocks      = 2,
    mh_jscale       = 0.30,
    prefilter       = 1,
    lik_init        = 2,
    forecast        = 8
) gy_H_obs gy_F_obs pi_H_obs pi_F_obs r_F_obs;

%----------------------------------------------------------------
% 8. Re-injection des posteriors pour scenarios post-estim
%----------------------------------------------------------------
fn = fieldnames(oo_.posterior_mean.parameters);
for ix = 1:size(fn,1)
    set_param_value(fn{ix}, eval(['oo_.posterior_mean.parameters.' fn{ix}]));
end
fx = fieldnames(oo_.posterior_mean.shocks_std);
for ix = 1:size(fx,1)
    idx = strmatch(fx{ix}, M_.exo_names, 'exact');
    M_.Sigma_e(idx,idx) = eval(['oo_.posterior_mean.shocks_std.' fx{ix}])^2;
end

%----------------------------------------------------------------
% 9. IRF et decomposition de variance aux estimations posterior
%----------------------------------------------------------------
stoch_simul(
    order           = 1,
    irf             = 20,
    conditional_variance_decomposition = [1,4,10,100],
    nograph
) gy_H_obs gy_F_obs pi_H_obs pi_F_obs pi_UEM r rer ex_H ex_F NFA_H ;

%----------------------------------------------------------------
% 10. Decomposition historique des chocs (2021-2023 surtout)
%----------------------------------------------------------------
shock_decomposition gy_H_obs gy_F_obs pi_H_obs pi_F_obs;
