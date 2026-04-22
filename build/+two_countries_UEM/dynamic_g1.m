function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
% function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
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
%   g1
%

if T_flag
    T = two_countries_UEM.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(39, 76);
g1(1,1)=(-((-params(7))*T(20)));
g1(1,19)=(-T(20));
g1(1,28)=1;
g1(2,5)=(-((-params(8))*T(24)));
g1(2,30)=(-T(24));
g1(2,39)=1;
g1(3,59)=(-((-(params(5)*y(62)*y(41)))/(y(59)*y(59))));
g1(3,28)=1;
g1(3,62)=(-(params(5)*y(41)/y(59)));
g1(3,41)=(-(params(5)*y(62)/y(59)));
g1(4,64)=(-((-(y(41)*params(5)*y(67)))/(y(64)*y(64))));
g1(4,39)=1;
g1(4,67)=(-(params(5)*y(41)/y(64)));
g1(4,41)=(-(params(5)*y(67)/y(64)));
g1(5,23)=(-y(28));
g1(5,24)=params(10)*getPowerDeriv(y(24),params(3),1);
g1(5,28)=(-y(23));
g1(6,34)=(-y(39));
g1(6,35)=params(11)*getPowerDeriv(y(35),params(4),1);
g1(6,39)=(-y(34));
g1(7,1)=y(61)*(y(60)-params(25))*y(60)*params(5)*params(12)*(-((y(58)-y(19)*params(7))*(-params(7))))/((y(19)-params(7)*y(1))*(y(19)-params(7)*y(1)))*T(21)/y(25);
g1(7,19)=y(61)*(y(60)-params(25))*y(60)*params(5)*params(12)*T(21)*((y(19)-params(7)*y(1))*(-params(7))-(y(58)-y(19)*params(7)))/((y(19)-params(7)*y(1))*(y(19)-params(7)*y(1)))/y(25);
g1(7,58)=y(61)*(y(60)-params(25))*y(60)*params(5)*params(12)*T(21)*1/(y(19)-params(7)*y(1))/y(25);
g1(7,21)=(-(params(12)*y(21)+params(12)*(y(21)-params(25))));
g1(7,60)=y(61)*(T(2)+T(1)*(y(60)-params(25)))/y(25);
g1(7,22)=params(14)*y(46);
g1(7,25)=(-(T(2)*(y(60)-params(25))*y(61)))/(y(25)*y(25));
g1(7,61)=T(2)*(y(60)-params(25))/y(25);
g1(7,46)=params(14)*y(22);
g1(8,5)=y(66)*(y(65)-params(25))*y(65)*params(5)*params(13)*(-((y(63)-y(30)*params(8))*(-params(8))))/((y(30)-params(8)*y(5))*(y(30)-params(8)*y(5)))*T(25)/y(36);
g1(8,30)=y(66)*(y(65)-params(25))*y(65)*params(5)*params(13)*T(25)*((y(30)-params(8)*y(5))*(-params(8))-(y(63)-y(30)*params(8)))/((y(30)-params(8)*y(5))*(y(30)-params(8)*y(5)))/y(36);
g1(8,63)=y(66)*(y(65)-params(25))*y(65)*params(5)*params(13)*T(25)*1/(y(30)-params(8)*y(5))/y(36);
g1(8,32)=(-(params(13)*y(32)+params(13)*(y(32)-params(25))));
g1(8,65)=y(66)*(T(4)+T(3)*(y(65)-params(25)))/y(36);
g1(8,33)=params(15)*y(50);
g1(8,36)=(-(T(4)*(y(65)-params(25))*y(66)))/(y(36)*y(36));
g1(8,66)=T(4)*(y(65)-params(25))/y(36);
g1(8,50)=params(15)*y(33);
g1(9,22)=1;
g1(9,23)=(-(y(24)/(y(25)*params(6))));
g1(9,24)=(-(y(23)*1/(y(25)*params(6))));
g1(9,25)=(-(y(23)*(-(y(24)*params(6)))/(y(25)*params(6)*y(25)*params(6))));
g1(10,33)=1;
g1(10,34)=(-(y(35)/(y(36)*params(6))));
g1(10,35)=(-(y(34)*1/(y(36)*params(6))));
g1(10,36)=(-(y(34)*(-(y(35)*params(6)))/(y(36)*params(6)*y(36)*params(6))));
g1(11,24)=(-(params(29)*y(45)*getPowerDeriv(y(24),params(6),1)));
g1(11,25)=1;
g1(11,45)=(-(params(29)*T(5)));
g1(12,35)=(-(params(29)*y(49)*getPowerDeriv(y(35),params(6),1)));
g1(12,36)=1;
g1(12,49)=(-(params(29)*T(6)));
g1(13,26)=(-(params(19)*getPowerDeriv(y(26),1-params(16),1)));
g1(13,42)=(-((1-params(19))*getPowerDeriv(y(42),1-params(16),1)));
g1(14,37)=(-(params(20)*getPowerDeriv(y(37),1-params(16),1)));
g1(14,42)=(-((1-params(20))*(-1)/(y(42)*y(42))*getPowerDeriv(1/y(42),1-params(16),1)));
g1(15,20)=(-((-y(21))/(y(20)*y(20))));
g1(15,21)=(-(1/y(20)));
g1(15,3)=(-y(26))/(y(3)*y(3));
g1(15,26)=1/y(3);
g1(16,31)=(-((-y(32))/(y(31)*y(31))));
g1(16,32)=(-(1/y(31)));
g1(16,7)=(-y(37))/(y(7)*y(7));
g1(16,37)=1/y(7);
g1(17,19)=(-T(7));
g1(17,21)=(-(y(25)*params(12)*0.5*2*(y(21)-params(25))));
g1(17,25)=1-T(10);
g1(17,26)=(-(T(22)+(1-params(21))*y(30)*(1-params(20))*y(51)*1/y(42)*T(23)/params(21)));
g1(17,27)=(-(0.5*params(9)*2*(y(27)-(steady_state(9)))));
g1(17,30)=(-((1-params(20))*y(51)*T(9)*(1-params(21))/params(21)));
g1(17,42)=(-((1-params(21))*y(30)*(1-params(20))*y(51)*T(27)/params(21)));
g1(17,48)=(-(params(26)*(steady_state(7))));
g1(17,51)=(-((1-params(21))*y(30)*(1-params(20))*T(9)/params(21)));
g1(18,19)=(-(params(21)*(1-params(19))*y(47)*T(12)/(1-params(21))));
g1(18,30)=(-T(11));
g1(18,32)=(-(y(36)*params(13)*0.5*2*(y(32)-params(25))));
g1(18,36)=1-T(13);
g1(18,37)=(-(y(30)*params(20)*getPowerDeriv(y(37),(-params(16)),1)+params(21)*y(19)*(1-params(19))*y(47)*y(42)*T(26)/(1-params(21))));
g1(18,38)=0.5*params(9)*2*(y(38)-(steady_state(20)));
g1(18,42)=(-(params(21)*y(19)*(1-params(19))*y(47)*y(37)*T(26)/(1-params(21))));
g1(18,47)=(-(params(21)*y(19)*(1-params(19))*T(12)/(1-params(21))));
g1(18,52)=(-(params(27)*(steady_state(18))));
g1(19,20)=(-params(21));
g1(19,31)=(-(1-params(21)));
g1(19,43)=1;
g1(20,25)=(-params(21));
g1(20,36)=(-(1-params(21)));
g1(20,44)=1;
g1(21,8)=(-(y(53)*T(18)*getPowerDeriv(y(8),params(22),1)));
g1(21,41)=1;
g1(21,43)=(-(y(53)*T(14)*T(16)*(steady_state(23))*1/params(25)*getPowerDeriv(y(43)/params(25),params(23),1)*T(28)));
g1(21,44)=(-(y(53)*T(14)*T(28)*T(15)*1/(steady_state(26))*getPowerDeriv(y(44)/(steady_state(26)),params(24),1)));
g1(21,53)=(-(T(14)*T(18)));
g1(22,19)=(-(y(26)*T(7)-1));
g1(22,20)=(-(y(4)*(-y(8))/(y(20)*y(20))));
g1(22,26)=(-(T(8)+y(30)*T(9)*T(19)+y(26)*(T(22)+y(30)*T(19)*1/y(42)*T(23))));
g1(22,4)=(-(y(8)/y(20)));
g1(22,27)=1;
g1(22,30)=(-(y(26)*T(9)*T(19)));
g1(22,8)=(-(y(4)*1/y(20)));
g1(22,42)=(-(y(26)*y(30)*T(19)*T(27)));
g1(22,51)=(-(y(26)*y(30)*T(9)*(1-params(20))*(1-params(21))/params(21)));
g1(23,27)=params(21);
g1(23,38)=1-params(21);
g1(24,21)=(-((-y(32))/(y(21)*y(21))));
g1(24,32)=(-(1/y(21)));
g1(24,9)=(-y(42))/(y(9)*y(9));
g1(24,42)=1/y(9);
g1(25,26)=(-((1-params(21))*y(30)*(1-params(20))*y(47)*1/y(42)*T(23)));
g1(25,29)=1;
g1(25,30)=(-((1-params(21))*T(9)*(1-params(20))*y(47)));
g1(25,42)=(-((1-params(21))*y(30)*(1-params(20))*y(47)*T(27)));
g1(25,47)=(-((1-params(21))*y(30)*(1-params(20))*T(9)));
g1(26,19)=(-(params(21)*T(12)*(1-params(19))*y(51)));
g1(26,37)=(-(params(21)*y(19)*(1-params(19))*y(51)*y(42)*T(26)));
g1(26,40)=1;
g1(26,42)=(-(params(21)*y(19)*(1-params(19))*y(51)*y(37)*T(26)));
g1(26,51)=(-(params(21)*y(19)*(1-params(19))*T(12)));
g1(27,2)=(-((-y(25))/(y(2)*y(2))/(y(25)/y(2))));
g1(27,25)=(-(1/y(2)/(y(25)/y(2))));
g1(27,54)=1;
g1(28,6)=(-((-y(36))/(y(6)*y(6))/(y(36)/y(6))));
g1(28,36)=(-(1/y(6)/(y(36)/y(6))));
g1(28,55)=1;
g1(29,20)=(-1);
g1(29,56)=1;
g1(30,31)=(-1);
g1(30,57)=1;
g1(31,10)=(-(params(31)*1/y(10)));
g1(31,45)=1/y(45);
g1(31,68)=(-1);
g1(32,11)=(-(params(32)*1/y(11)));
g1(32,46)=1/y(46);
g1(32,69)=(-1);
g1(33,12)=(-(params(33)*1/y(12)));
g1(33,47)=1/y(47);
g1(33,70)=(-1);
g1(34,13)=(-(params(34)*1/y(13)));
g1(34,48)=1/y(48);
g1(34,71)=(-1);
g1(35,14)=(-(params(35)*1/y(14)));
g1(35,49)=1/y(49);
g1(35,72)=(-1);
g1(36,15)=(-(params(36)*1/y(15)));
g1(36,50)=1/y(50);
g1(36,73)=(-1);
g1(37,16)=(-(params(37)*1/y(16)));
g1(37,51)=1/y(51);
g1(37,74)=(-1);
g1(38,17)=(-(params(38)*1/y(17)));
g1(38,52)=1/y(52);
g1(38,75)=(-1);
g1(39,18)=(-(params(39)*1/y(18)));
g1(39,53)=1/y(53);
g1(39,76)=(-1);

end
