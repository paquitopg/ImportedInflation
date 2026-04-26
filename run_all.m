% =====================================================================
%  run_all.m
%  ---------------------------------------------------------------------
%  Top-level reproducibility script for the ImportedInflation project
%  (ENSAE Macro Modelling 2025-2026).
%
%  Single-click replication of every result reported in the paper:
%    1. Optionally re-download FR/DE observables from DBnomics
%    2. Exploratory data analysis (descriptive figures fig1-fig4)
%    3. Model diagnostic at the deterministic steady state
%       (residuals, Blanchard-Kahn condition, IRF sign check)
%    4. Bayesian estimation of the two-country UEM model
%       (Metropolis-Hastings, ~10-30 minutes wall time)
%    5. Counterfactual scenario : energy shock + 2 ECB Taylor regimes
%    6. Historical shock decomposition (CSV + console summary)
%
%  Usage :
%      >> cd ImportedInflation
%      >> run_all
%
%  Pre-requisites :
%      - MATLAB R2021b or later
%      - Dynare 6.5 on the MATLAB path (>> addpath('/path/to/dynare/matlab'))
%      - Cached observables data/myobs_FR_DE.mat (shipped in the repo)
%        OR an active internet connection if SKIP_DBNOMICS = false.
%
%  Optional flags : edit the SETTINGS block below to skip slow steps.
%
%  Outputs (relative to project root) :
%      data/figures/        - all EPS+PDF figures (Dynare native)
%      data/figures/fig*.png- our descriptive figures
%      data/tables/         - posterior_summary.csv, variance_decomp,
%                             shock_decomp_*, scenario_impact.csv
%      build/               - Dynare artifacts and _results.mat
%      logs/                - raw Dynare logs (estimation, model check)
% =====================================================================

% --------------------- SETTINGS (edit if needed) ---------------------
SKIP_DBNOMICS  = true;   % true = use cached data/myobs_FR_DE.mat (default)
SKIP_ESTIMATION= false;  % true = re-use existing posterior in build/...
SKIP_EDA       = false;  % true = skip exploratory data analysis
SKIP_CHECK     = false;  % true = skip steady-state diagnostic
% ---------------------------------------------------------------------

t0_total = tic;
fprintf('\n');
fprintf('=====================================================================\n');
fprintf('  ImportedInflation -- single-click replication\n');
fprintf('  Date : %s\n', datestr(now,'yyyy-mm-dd HH:MM:SS'));
fprintf('=====================================================================\n\n');

% --- Resolve project root ----------------------------------------------
root = fileparts(mfilename('fullpath'));
if isempty(root); root = pwd; end
src_dir = fullfile(root, 'src');
assert(exist(src_dir,'dir')==7, 'src/ folder not found at %s', root);

% --- Sanity check : Dynare on path -------------------------------------
if isempty(which('dynare'))
    error(['Dynare is not on the MATLAB path. ' ...
           'Add it before running run_all, e.g. ' ...
           'addpath(''/Applications/Dynare/6.5-arm64/matlab'').']);
end
fprintf('Dynare found at : %s\n\n', fileparts(which('dynare')));

% --- Check cached data --------------------------------------------------
data_mat = fullfile(root, 'data', 'myobs_FR_DE.mat');
if exist(data_mat,'file') ~= 2 && SKIP_DBNOMICS
    warning(['Cached observables not found and SKIP_DBNOMICS = true. ' ...
             'Forcing SKIP_DBNOMICS = false (will hit DBnomics).']);
    SKIP_DBNOMICS = false;
end

% =====================================================================
% Step 1 : Data acquisition (DBnomics)
% =====================================================================
if ~SKIP_DBNOMICS
    fprintf('--- [1/6] DBnomics data download -----------------------------\n');
    cd(src_dir);
    try
        my_db_FR_DE;
        fprintf('  Wrote : %s\n', data_mat);
    catch ME
        warning(['DBnomics download failed (%s). ' ...
                 'Falling back on cached data, if any.'], ME.message);
    end
    cd(root);
else
    fprintf('--- [1/6] DBnomics download SKIPPED (using cached data) ------\n');
end

% =====================================================================
% Step 2 : Exploratory data analysis
% =====================================================================
if ~SKIP_EDA
    fprintf('\n--- [2/6] Exploratory data analysis --------------------------\n');
    cd(src_dir);
    try
        eda_FR_DE;
    catch ME
        warning('EDA step failed : %s', ME.message);
    end
    cd(root);
else
    fprintf('\n--- [2/6] EDA SKIPPED ----------------------------------------\n');
end

% =====================================================================
% Step 3 : Steady-state diagnostic
% =====================================================================
if ~SKIP_CHECK
    fprintf('\n--- [3/6] Model diagnostic (run_check_UEM) -------------------\n');
    cd(src_dir);
    try
        run_check_UEM;
    catch ME
        warning('Model diagnostic failed : %s', ME.message);
    end
    cd(root);
else
    fprintf('\n--- [3/6] Model diagnostic SKIPPED ---------------------------\n');
end

% =====================================================================
% Step 4 : Bayesian estimation (slow : 10-30 min)
% =====================================================================
if ~SKIP_ESTIMATION
    fprintf('\n--- [4/6] Bayesian estimation (slow ~10-30 min) --------------\n');
    cd(src_dir);
    try
        run_estimation_UEM;
    catch ME
        warning('Estimation failed : %s', ME.message);
    end
    cd(root);
else
    res_path = fullfile(root,'build','estimation_UEM','Output', ...
                        'estimation_UEM_results.mat');
    if exist(res_path,'file') ~= 2
        warning(['SKIP_ESTIMATION = true but %s does not exist. ' ...
                 'Steps 5-6 will fail.'], res_path);
    end
    fprintf('\n--- [4/6] Estimation SKIPPED (re-using existing posterior) ---\n');
end

% =====================================================================
% Step 5 : Counterfactual scenario
% =====================================================================
fprintf('\n--- [5/6] Counterfactual scenario (run_scenario_UEM) ---------\n');
cd(src_dir);
try
    run_scenario_UEM;
catch ME
    warning('Scenario step failed : %s', ME.message);
end
cd(root);

% =====================================================================
% Step 6 : Historical shock decomposition
% =====================================================================
fprintf('\n--- [6/6] Historical shock decomposition --------------------\n');
cd(src_dir);
try
    analyze_shock_decomposition;
catch ME
    warning('Decomposition step failed : %s', ME.message);
end
cd(root);

% =====================================================================
% Summary
% =====================================================================
elapsed = toc(t0_total);
fprintf('\n=====================================================================\n');
fprintf('  Replication finished in %.1f minutes.\n', elapsed/60);
fprintf('=====================================================================\n');
fprintf('  Figures   : %s\n', fullfile(root,'data','figures'));
fprintf('  Tables    : %s\n', fullfile(root,'data','tables'));
fprintf('  Logs      : %s\n', fullfile(root,'logs'));
fprintf('  Build     : %s\n', fullfile(root,'build'));
fprintf('=====================================================================\n');
