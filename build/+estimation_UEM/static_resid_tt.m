function T = static_resid_tt(T, y, x, params)
% function T = static_resid_tt(T, y, x, params)
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

assert(length(T) >= 14);

T(1) = y(6)^params(6);
T(2) = y(17)^params(6);
T(3) = params(19)*y(8)^(-params(16));
T(4) = y(1)*T(3);
T(5) = (y(8)/y(24))^(-params(16));
T(6) = params(12)*0.5*(y(3)-params(25))^2;
T(7) = params(20)*y(19)^(-params(16));
T(8) = (y(24)*y(19))^(-params(16));
T(9) = params(13)*0.5*(y(14)-params(25))^2;
T(10) = y(23)^params(22);
T(11) = (y(25)/params(25))^params(23);
T(12) = (y(26)/(y(26)))^params(24);
T(13) = ((y(23))*T(11)*T(12))^(1-params(22));
T(14) = (1-params(20))*y(33)*(1-params(21))/params(21);

end
