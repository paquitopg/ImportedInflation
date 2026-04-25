function T = static_g1_tt(T, y, x, params)
% function T = static_g1_tt(T, y, x, params)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%
% Output:
%   T         [#temp variables by 1]  double   vector of temporary terms
%

assert(length(T) >= 19);

T = estimation_UEM.static_resid_tt(T, y, x, params);

T(15) = y(1)*params(19)*getPowerDeriv(y(8),(-params(16)),1);
T(16) = getPowerDeriv(y(8)/y(24),(-params(16)),1);
T(17) = getPowerDeriv(y(24)*y(19),(-params(16)),1);
T(18) = getPowerDeriv((y(23))*T(11)*T(12),1-params(22),1);
T(19) = T(16)*(-y(8))/(y(24)*y(24));

end
