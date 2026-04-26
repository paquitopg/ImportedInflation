function T = dynamic_g1_tt(T, y, x, params, steady_state, it_)
% function T = dynamic_g1_tt(T, y, x, params, steady_state, it_)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double  vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double  vector of endogenous variables in the order stored
%                                                    in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double  matrix of exogenous variables (in declaration order)
%                                                    for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double  vector of steady state values
%   params        [M_.param_nbr by 1]        double  vector of parameter values in declaration order
%   it_           scalar                     double  time period for exogenous variables for which
%                                                    to evaluate the model
%
% Output:
%   T           [#temp variables by 1]       double  vector of temporary terms
%

assert(length(T) >= 28);

T = scenario_UEM.dynamic_resid_tt(T, y, x, params, steady_state, it_);

T(20) = getPowerDeriv(y(19)-params(7)*y(1),(-params(1)),1);
T(21) = getPowerDeriv((y(58)-y(19)*params(7))/(y(19)-params(7)*y(1)),(-params(1)),1);
T(22) = y(19)*params(19)*getPowerDeriv(y(26),(-params(16)),1);
T(23) = getPowerDeriv(y(26)/y(42),(-params(16)),1);
T(24) = getPowerDeriv(y(30)-params(8)*y(5),(-params(2)),1);
T(25) = getPowerDeriv((y(63)-y(30)*params(8))/(y(30)-params(8)*y(5)),(-params(2)),1);
T(26) = getPowerDeriv(y(42)*y(37),(-params(16)),1);
T(27) = T(23)*(-y(26))/(y(42)*y(42));
T(28) = getPowerDeriv(T(17),1-params(22),1);

end
