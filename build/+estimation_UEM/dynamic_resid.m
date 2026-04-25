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
    T = estimation_UEM.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(42, 1);
    residual(1) = (y(30)) - ((y(21)-params(7)*y(1))^(-params(1)));
    residual(2) = (y(41)) - ((y(32)-params(8)*y(6))^(-params(2)));
    residual(3) = (y(30)) - (params(5)*y(67)*y(43)/y(64));
    residual(4) = (y(41)) - (y(43)*params(5)*y(72)/y(69));
    residual(5) = (params(10)*y(26)^params(3)) - (y(30)*y(25));
    residual(6) = (params(11)*y(37)^params(4)) - (y(41)*y(36));
residual(7) = 1-params(14)+params(14)*y(48)*y(24)-params(12)*y(23)*(y(23)-params(25))+T(2)*(y(65)-params(25))*y(66)/y(27);
residual(8) = 1-params(15)+params(15)*y(52)*y(35)-params(13)*y(34)*(y(34)-params(25))+T(4)*(y(70)-params(25))*y(71)/y(38);
    residual(9) = (y(24)) - (y(25)*y(26)/(y(27)*params(6)));
    residual(10) = (y(35)) - (y(36)*y(37)/(y(38)*params(6)));
    residual(11) = (y(27)) - (params(29)*y(47)*T(5));
    residual(12) = (y(38)) - (params(29)*y(51)*T(6));
    residual(13) = (1) - (params(19)*y(28)^(1-params(16))+(1-params(19))*y(44)^(1-params(16)));
    residual(14) = (1) - (params(20)*y(39)^(1-params(16))+(1-params(20))*(1/y(44))^(1-params(16)));
    residual(15) = (y(28)/y(3)) - (y(23)/y(22));
    residual(16) = (y(39)/y(8)) - (y(34)/y(33));
    residual(17) = (y(27)) - (T(8)+y(32)*(1-params(20))*y(53)*T(9)*(1-params(21))/params(21)+params(26)*(steady_state(7))*y(50)+y(27)*T(10)+0.5*params(9)*(y(29)-(steady_state(9)))^2);
    residual(18) = (y(38)) - (y(32)*T(11)+params(21)*y(21)*(1-params(19))*y(49)*T(12)/(1-params(21))+params(27)*(steady_state(18))*y(54)+y(38)*T(13)-0.5*params(9)*(y(40)-(steady_state(20)))^2);
    residual(19) = (y(45)) - (y(22)*params(21)+y(33)*(1-params(21)));
    residual(20) = (y(46)) - (y(27)*params(21)+y(38)*(1-params(21)));
    residual(21) = (y(43)) - (T(14)*T(18)*y(55));
    residual(22) = (y(29)) - (y(10)/y(22)*y(4)+y(28)*(T(8)+y(32)*T(9)*T(19))-y(21));
residual(23) = params(21)*y(29)+(1-params(21))*y(40);
    residual(24) = (y(44)/y(11)) - (y(34)/y(23));
    residual(25) = (y(31)) - ((1-params(21))*y(32)*T(9)*(1-params(20))*y(49));
    residual(26) = (y(42)) - (params(21)*y(21)*T(12)*(1-params(19))*y(53));
    residual(27) = (y(56)) - (log(y(27)/y(2)));
    residual(28) = (y(57)) - (log(y(38)/y(7)));
    residual(29) = (y(58)) - (y(22)-params(25));
    residual(30) = (y(59)) - (y(33)-params(25));
    residual(31) = (y(60)) - (y(43)-(steady_state(23)));
    residual(32) = (y(61)) - (log(y(31)/y(5)));
    residual(33) = (y(62)) - (log(y(42)/y(9)));
    residual(34) = (log(y(47))) - (params(31)*log(y(12))+x(it_, 1));
    residual(35) = (log(y(48))) - (params(32)*log(y(13))+x(it_, 2));
    residual(36) = (log(y(49))) - (params(33)*log(y(14))+x(it_, 3));
    residual(37) = (log(y(50))) - (params(34)*log(y(15))+x(it_, 4));
    residual(38) = (log(y(51))) - (params(35)*log(y(16))+x(it_, 5));
    residual(39) = (log(y(52))) - (params(36)*log(y(17))+x(it_, 6));
    residual(40) = (log(y(53))) - (params(37)*log(y(18))+x(it_, 7));
    residual(41) = (log(y(54))) - (params(38)*log(y(19))+x(it_, 8));
    residual(42) = (log(y(55))) - (params(39)*log(y(20))+x(it_, 9));

end
