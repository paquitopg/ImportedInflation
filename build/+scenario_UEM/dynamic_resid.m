function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
% function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double   vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double   vector of endogenous variables in the order stored
%                                                     in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double   matrix of exogenous variables (in declaration order)
%                                                     for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double   vector of steady state values
%   params        [M_.param_nbr by 1]        double   vector of parameter values in declaration order
%   it_           scalar                     double   time period for exogenous variables for which
%                                                     to evaluate the model
%   T_flag        boolean                    boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = scenario_UEM.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(39, 1);
    residual(1) = (y(28)) - ((y(19)-params(7)*y(1))^(-params(1)));
    residual(2) = (y(39)) - ((y(30)-params(8)*y(5))^(-params(2)));
    residual(3) = (y(28)) - (params(5)*y(62)*y(41)/y(59));
    residual(4) = (y(39)) - (y(41)*params(5)*y(67)/y(64));
    residual(5) = (params(10)*y(24)^params(3)) - (y(28)*y(23));
    residual(6) = (params(11)*y(35)^params(4)) - (y(39)*y(34));
residual(7) = 1-params(14)+params(14)*y(46)*y(22)-params(12)*y(21)*(y(21)-params(25))+T(2)*(y(60)-params(25))*y(61)/y(25);
residual(8) = 1-params(15)+params(15)*y(50)*y(33)-params(13)*y(32)*(y(32)-params(25))+T(4)*(y(65)-params(25))*y(66)/y(36);
    residual(9) = (y(22)) - (y(23)*y(24)/(y(25)*params(6)));
    residual(10) = (y(33)) - (y(34)*y(35)/(y(36)*params(6)));
    residual(11) = (y(25)) - (params(29)*y(45)*T(5));
    residual(12) = (y(36)) - (params(29)*y(49)*T(6));
    residual(13) = (1) - (params(19)*y(26)^(1-params(16))+(1-params(19))*y(42)^(1-params(16)));
    residual(14) = (1) - (params(20)*y(37)^(1-params(16))+(1-params(20))*(1/y(42))^(1-params(16)));
    residual(15) = (y(26)/y(3)) - (y(21)/y(20));
    residual(16) = (y(37)/y(7)) - (y(32)/y(31));
    residual(17) = (y(25)) - (T(8)+y(30)*(1-params(20))*y(51)*T(9)*(1-params(21))/params(21)+params(26)*(steady_state(7))*y(48)+y(25)*T(10)+0.5*params(9)*(y(27)-(steady_state(9)))^2);
    residual(18) = (y(36)) - (y(30)*T(11)+params(21)*y(19)*(1-params(19))*y(47)*T(12)/(1-params(21))+params(27)*(steady_state(18))*y(52)+y(36)*T(13)-0.5*params(9)*(y(38)-(steady_state(20)))^2);
    residual(19) = (y(43)) - (y(20)*params(21)+y(31)*(1-params(21)));
    residual(20) = (y(44)) - (y(25)*params(21)+y(36)*(1-params(21)));
    residual(21) = (y(41)) - (T(14)*T(18)*y(53));
    residual(22) = (y(27)) - (y(8)/y(20)*y(4)+y(26)*(T(8)+y(30)*T(9)*T(19))-y(19));
residual(23) = params(21)*y(27)+(1-params(21))*y(38);
    residual(24) = (y(42)/y(9)) - (y(32)/y(21));
    residual(25) = (y(29)) - ((1-params(21))*y(30)*T(9)*(1-params(20))*y(47));
    residual(26) = (y(40)) - (params(21)*y(19)*T(12)*(1-params(19))*y(51));
    residual(27) = (y(54)) - (log(y(25)/y(2)));
    residual(28) = (y(55)) - (log(y(36)/y(6)));
    residual(29) = (y(56)) - (y(20)-params(25));
    residual(30) = (y(57)) - (y(31)-params(25));
    residual(31) = (log(y(45))) - (params(31)*log(y(10))+x(it_, 1));
    residual(32) = (log(y(46))) - (params(32)*log(y(11))+x(it_, 2));
    residual(33) = (log(y(47))) - (params(33)*log(y(12))+x(it_, 3));
    residual(34) = (log(y(48))) - (params(34)*log(y(13))+x(it_, 4));
    residual(35) = (log(y(49))) - (params(35)*log(y(14))+x(it_, 5));
    residual(36) = (log(y(50))) - (params(36)*log(y(15))+x(it_, 6));
    residual(37) = (log(y(51))) - (params(37)*log(y(16))+x(it_, 7));
    residual(38) = (log(y(52))) - (params(38)*log(y(17))+x(it_, 8));
    residual(39) = (log(y(53))) - (params(39)*log(y(18))+x(it_, 9));

end
