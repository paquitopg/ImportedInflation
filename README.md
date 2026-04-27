# ImportedInflation

Two-country DSGE estimation of the **soft imported-inflation channel** between France and Germany during the 2021–2023 European energy shock.
ENSAE Paris — Macro Modelling Project 2025–2026.

> *To what extent does an energy price shock originating in Germany feed back into French inflation, output and the bilateral trade balance, given a single ECB monetary stance, and how would a different ECB reaction function have changed the transmission?*

The model adapts the open-economy NK framework of Kollmann (2001) and the IRBC structure of Backus–Kehoe–Kydland (1992) to a two-country EMU setting (Δe ≡ 1, single Taylor rule on area-wide inflation), estimated by Bayesian MH in Dynare 6.5 on five FR/DE quarterly observables (1999Q2–2025Q3).

## One-click replication

From the project root, in MATLAB:

```matlab
>> addpath('<path-to-dynare>/matlab')   % Dynare 6.5 must be on the path
>> run_all
```

`run_all.m` chains every step (data → EDA → diagnostic → estimation → counterfactual → decomposition) and produces every figure and table cited in `report/main.tex`. End-to-end wall time: ~5 min. Optional flags at the top of `run_all.m` (`SKIP_ESTIMATION`, `SKIP_DBNOMICS`, …) let you skip the slow steps and re-use the cached posterior.

## Repository structure

```
ImportedInflation/
├── run_all.m                       <- single-click replication driver
├── README.md                       <- this file
├── src/
│   ├── two_countries_UEM.mod       <- baseline two-country EMU model
│   ├── estimation_UEM.mod          <- estimation block (priors, data)
│   ├── scenario_UEM.mod            <- model at posterior mean for IRFs
│   ├── run_check_UEM.m             <- steady-state + Blanchard-Kahn
│   ├── run_estimation_UEM.m        <- Bayesian MH driver
│   ├── run_scenario_UEM.m          <- counterfactual ECB regimes
│   ├── analyze_shock_decomposition.m  <- historical decomposition
│   ├── eda_FR_DE.m                 <- exploratory descriptive plots
│   ├── my_db_FR_DE.m               <- DBnomics data acquisition
│   └── call_dbnomics.m             <- DBnomics REST helper
├── data/
│   ├── myobs_FR_DE.mat             <- 5 observables, 1999Q2-2025Q3
│   ├── stats_desc.csv              <- descriptive statistics
│   ├── figures/                    <- all .eps/.pdf/.png figures
│   ├── tables/                     <- posterior, vardec, scenario CSVs
│   └── notes/                      <- ECB-BASE comparison notes
├── build/                          <- Dynare artifacts (auto-generated)
├── logs/                           <- raw Dynare logs
└── resources/                      <- helper functions (Course codebook)
```

## Pipeline (what `run_all.m` does)

| Step | Script | Output | Wall time |
|------|------------------------------------|--------------------------------------------------|-----------|
| 1 | `my_db_FR_DE.m` (optional)         | `data/myobs_FR_DE.mat` (5 quarterly observables) | ~1 min    |
| 2 | `eda_FR_DE.m`                      | `data/figures/fig{1,2,3,4}*.png`                 | ~10 s     |
| 3 | `run_check_UEM.m`                  | `logs/model_check.log`                           | ~10 s     |
| 4 | `run_estimation_UEM.m`             | `build/estimation_UEM/Output/*_results.mat`, posterior figures, `data/tables/posterior_summary.csv`, `data/tables/variance_decomposition.csv` | 5 min |
| 5 | `run_scenario_UEM.m`               | `data/figures/scenario_energy_2regimes.png`, `data/tables/scenario_impact.csv`, baseline IRFs | ~30 s     |
| 6 | `analyze_shock_decomposition.m`    | `data/tables/shock_decomp_pi_{H,F}_obs.csv`, console summary 2021Q1–2023Q4 | ~5 s      |

## Data

Five quarterly observables, 1999Q2–2025Q3 (N = 106), pulled from DBnomics (Eurostat / ECB):

- `gy_H_obs`, `gy_F_obs` — log-difference real GDP, FR and DE
- `pi_H_obs`, `pi_F_obs` — quarterly HICP inflation in deviation from a 2% annualised target, FR and DE
- `r_obs` — ECB main refinancing rate in deviation from steady state

Pre-processing follows Pfeifer (2014). The Dynare option `prefilter` absorbs sample means.

## Simplifying assumptions and their justification

The model deliberately stays small to remain identifiable on five observables. Key assumptions:

- **EMU constraint Δe ≡ 1.** France and Germany share the euro, so the bilateral nominal exchange rate is identically one and the bilateral real exchange rate is purely the cumulated inflation differential (Equation 3 in the paper). This rules out the Galí–Monacelli small-open-economy channel by construction and isolates the *soft* transmission via trade and the common Taylor rule.
- **Single ECB Taylor rule on area-wide HICP** with country weight `n = 0.40` matching the FR/(FR+DE) GDP share in 2024. Rule-of-thumb fiscal blocks are absent.
- **Calibrated parameters.** β = 0.995, σ_C = 1.5, σ_H = 2, α = 0.65, ε = 10, μ = 1.5 (Armington). Bilateral openness `α^c_H = 0.220` and `α^c_F = 0.117` match observed bilateral trade-to-GDP ratios. Justification: standard EMU-DSGE calibration (Smets–Wouters 2007, Coenen et al. 2018).
- **Aggregation.** No sectoral disaggregation (no separate energy / non-energy sectors). Energy enters as a residual cost-push shock `e_{p,F}` in the NKPC, with cross-country correlation 0.7 to capture the European common gas-price component. A fully sectoralised model would require six additional observables (sectoral price indices) that are not used here, breaking identification.
- **Estimated subset.** Only 16 parameters with a clear data counterpart are estimated (Rotemberg costs ξ_H, ξ_F, habits, two Taylor coefficients ρ and φ_π, three persistences, four shock std-devs, five measurement-error std-devs). The remaining shocks (preference, government, investment) are tightly calibrated to avoid acting as residual catch-alls.
- **Inference at the mode.** MCMC chains under-mix because the numerical Hessian is non-PD; we use `MCMC_jumping_covariance = 'prior_variance'` and rely on the Laplace approximation around the mode for posterior moments. Documented honestly in §5.2 of the report.

## Outputs reproducing the paper

- Posterior table 1 in §4 ⇐ `data/tables/posterior_summary.csv`
- Variance decomposition table 2 in §5.2 ⇐ `data/tables/variance_decomposition.csv`
- Counterfactual table impact ⇐ `data/tables/scenario_impact.csv`
- Body figures 1–5 ⇐ files in `data/figures/` listed in `report/main.tex` `\graphicspath`
- Appendix figures A1–A4 ⇐ idem (Brooks–Gelman, density set 2, German hist-decomp, motivating panels)

## License

MIT — see `LICENSE`. The DBnomics data is © Eurostat/ECB redistributed under DBnomics open terms.
