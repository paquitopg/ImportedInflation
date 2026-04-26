function T = dynamic_resid_tt(T, y, x, params, steady_state, it_)
% function T = dynamic_resid_tt(T, y, x, params, steady_state, it_)
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

assert(length(T) >= 19);

T(1) = params(5)*params(12)*((y(59)-y(19)*params(7))/(y(19)-params(7)*y(1)))^(-params(1));
T(2) = T(1)*y(61);
T(3) = params(5)*params(13)*((y(64)-y(30)*params(8))/(y(30)-params(8)*y(5)))^(-params(2));
T(4) = T(3)*y(66);
T(5) = y(24)^params(6);
T(6) = y(35)^params(6);
T(7) = params(19)*y(26)^(-params(16));
T(8) = y(19)*T(7);
T(9) = (y(26)/y(42))^(-params(16));
T(10) = params(12)*0.5*(y(21)-params(25))^2;
T(11) = params(20)*y(37)^(-params(16));
T(12) = (y(42)*y(37))^(-params(16));
T(13) = params(13)*0.5*(y(32)-params(25))^2;
T(14) = y(8)^params(22);
T(15) = (steady_state(23))*(y(43)/params(25))^params(23);
T(16) = (y(44)/(steady_state(26)))^params(24);
T(17) = T(15)*T(16);
T(18) = T(17)^(1-params(22));
T(19) = (1-params(20))*y(51)*(1-params(21))/params(21);

end
