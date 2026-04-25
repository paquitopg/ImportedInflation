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
    T = estimation_UEM.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(42, 81);
g1(1,1)=(-((-params(7))*T(20)));
g1(1,21)=(-T(20));
g1(1,30)=1;
g1(2,6)=(-((-params(8))*T(24)));
g1(2,32)=(-T(24));
g1(2,41)=1;
g1(3,64)=(-((-(params(5)*y(67)*y(43)))/(y(64)*y(64))));
g1(3,30)=1;
g1(3,67)=(-(params(5)*y(43)/y(64)));
g1(3,43)=(-(params(5)*y(67)/y(64)));
g1(4,69)=(-((-(y(43)*params(5)*y(72)))/(y(69)*y(69))));
g1(4,41)=1;
g1(4,72)=(-(params(5)*y(43)/y(69)));
g1(4,43)=(-(params(5)*y(72)/y(69)));
g1(5,25)=(-y(30));
g1(5,26)=params(10)*getPowerDeriv(y(26),params(3),1);
g1(5,30)=(-y(25));
g1(6,36)=(-y(41));
g1(6,37)=params(11)*getPowerDeriv(y(37),params(4),1);
g1(6,41)=(-y(36));
g1(7,1)=y(66)*(y(65)-params(25))*y(65)*params(5)*params(12)*(-((y(63)-y(21)*params(7))*(-params(7))))/((y(21)-params(7)*y(1))*(y(21)-params(7)*y(1)))*T(21)/y(27);
g1(7,21)=y(66)*(y(65)-params(25))*y(65)*params(5)*params(12)*T(21)*((y(21)-params(7)*y(1))*(-params(7))-(y(63)-y(21)*params(7)))/((y(21)-params(7)*y(1))*(y(21)-params(7)*y(1)))/y(27);
g1(7,63)=y(66)*(y(65)-params(25))*y(65)*params(5)*params(12)*T(21)*1/(y(21)-params(7)*y(1))/y(27);
g1(7,23)=(-(params(12)*y(23)+params(12)*(y(23)-params(25))));
g1(7,65)=y(66)*(T(2)+T(1)*(y(65)-params(25)))/y(27);
g1(7,24)=params(14)*y(48);
g1(7,27)=(-(T(2)*(y(65)-params(25))*y(66)))/(y(27)*y(27));
g1(7,66)=T(2)*(y(65)-params(25))/y(27);
g1(7,48)=params(14)*y(24);
g1(8,6)=y(71)*(y(70)-params(25))*y(70)*params(5)*params(13)*(-((y(68)-y(32)*params(8))*(-params(8))))/((y(32)-params(8)*y(6))*(y(32)-params(8)*y(6)))*T(25)/y(38);
g1(8,32)=y(71)*(y(70)-params(25))*y(70)*params(5)*params(13)*T(25)*((y(32)-params(8)*y(6))*(-params(8))-(y(68)-y(32)*params(8)))/((y(32)-params(8)*y(6))*(y(32)-params(8)*y(6)))/y(38);
g1(8,68)=y(71)*(y(70)-params(25))*y(70)*params(5)*params(13)*T(25)*1/(y(32)-params(8)*y(6))/y(38);
g1(8,34)=(-(params(13)*y(34)+params(13)*(y(34)-params(25))));
g1(8,70)=y(71)*(T(4)+T(3)*(y(70)-params(25)))/y(38);
g1(8,35)=params(15)*y(52);
g1(8,38)=(-(T(4)*(y(70)-params(25))*y(71)))/(y(38)*y(38));
g1(8,71)=T(4)*(y(70)-params(25))/y(38);
g1(8,52)=params(15)*y(35);
g1(9,24)=1;
g1(9,25)=(-(y(26)/(y(27)*params(6))));
g1(9,26)=(-(y(25)*1/(y(27)*params(6))));
g1(9,27)=(-(y(25)*(-(y(26)*params(6)))/(y(27)*params(6)*y(27)*params(6))));
g1(10,35)=1;
g1(10,36)=(-(y(37)/(y(38)*params(6))));
g1(10,37)=(-(y(36)*1/(y(38)*params(6))));
g1(10,38)=(-(y(36)*(-(y(37)*params(6)))/(y(38)*params(6)*y(38)*params(6))));
g1(11,26)=(-(params(29)*y(47)*getPowerDeriv(y(26),params(6),1)));
g1(11,27)=1;
g1(11,47)=(-(params(29)*T(5)));
g1(12,37)=(-(params(29)*y(51)*getPowerDeriv(y(37),params(6),1)));
g1(12,38)=1;
g1(12,51)=(-(params(29)*T(6)));
g1(13,28)=(-(params(19)*getPowerDeriv(y(28),1-params(16),1)));
g1(13,44)=(-((1-params(19))*getPowerDeriv(y(44),1-params(16),1)));
g1(14,39)=(-(params(20)*getPowerDeriv(y(39),1-params(16),1)));
g1(14,44)=(-((1-params(20))*(-1)/(y(44)*y(44))*getPowerDeriv(1/y(44),1-params(16),1)));
g1(15,22)=(-((-y(23))/(y(22)*y(22))));
g1(15,23)=(-(1/y(22)));
g1(15,3)=(-y(28))/(y(3)*y(3));
g1(15,28)=1/y(3);
g1(16,33)=(-((-y(34))/(y(33)*y(33))));
g1(16,34)=(-(1/y(33)));
g1(16,8)=(-y(39))/(y(8)*y(8));
g1(16,39)=1/y(8);
g1(17,21)=(-T(7));
g1(17,23)=(-(y(27)*params(12)*0.5*2*(y(23)-params(25))));
g1(17,27)=1-T(10);
g1(17,28)=(-(T(22)+(1-params(21))*y(32)*(1-params(20))*y(53)*1/y(44)*T(23)/params(21)));
g1(17,29)=(-(0.5*params(9)*2*(y(29)-(steady_state(9)))));
g1(17,32)=(-((1-params(20))*y(53)*T(9)*(1-params(21))/params(21)));
g1(17,44)=(-((1-params(21))*y(32)*(1-params(20))*y(53)*T(27)/params(21)));
g1(17,50)=(-(params(26)*(steady_state(7))));
g1(17,53)=(-((1-params(21))*y(32)*(1-params(20))*T(9)/params(21)));
g1(18,21)=(-(params(21)*(1-params(19))*y(49)*T(12)/(1-params(21))));
g1(18,32)=(-T(11));
g1(18,34)=(-(y(38)*params(13)*0.5*2*(y(34)-params(25))));
g1(18,38)=1-T(13);
g1(18,39)=(-(y(32)*params(20)*getPowerDeriv(y(39),(-params(16)),1)+params(21)*y(21)*(1-params(19))*y(49)*y(44)*T(26)/(1-params(21))));
g1(18,40)=0.5*params(9)*2*(y(40)-(steady_state(20)));
g1(18,44)=(-(params(21)*y(21)*(1-params(19))*y(49)*y(39)*T(26)/(1-params(21))));
g1(18,49)=(-(params(21)*y(21)*(1-params(19))*T(12)/(1-params(21))));
g1(18,54)=(-(params(27)*(steady_state(18))));
g1(19,22)=(-params(21));
g1(19,33)=(-(1-params(21)));
g1(19,45)=1;
g1(20,27)=(-params(21));
g1(20,38)=(-(1-params(21)));
g1(20,46)=1;
g1(21,10)=(-(y(55)*T(18)*getPowerDeriv(y(10),params(22),1)));
g1(21,43)=1;
g1(21,45)=(-(y(55)*T(14)*T(16)*(steady_state(23))*1/params(25)*getPowerDeriv(y(45)/params(25),params(23),1)*T(28)));
g1(21,46)=(-(y(55)*T(14)*T(28)*T(15)*1/(steady_state(26))*getPowerDeriv(y(46)/(steady_state(26)),params(24),1)));
g1(21,55)=(-(T(14)*T(18)));
g1(22,21)=(-(y(28)*T(7)-1));
g1(22,22)=(-(y(4)*(-y(10))/(y(22)*y(22))));
g1(22,28)=(-(T(8)+y(32)*T(9)*T(19)+y(28)*(T(22)+y(32)*T(19)*1/y(44)*T(23))));
g1(22,4)=(-(y(10)/y(22)));
g1(22,29)=1;
g1(22,32)=(-(y(28)*T(9)*T(19)));
g1(22,10)=(-(y(4)*1/y(22)));
g1(22,44)=(-(y(28)*y(32)*T(19)*T(27)));
g1(22,53)=(-(y(28)*y(32)*T(9)*(1-params(20))*(1-params(21))/params(21)));
g1(23,29)=params(21);
g1(23,40)=1-params(21);
g1(24,23)=(-((-y(34))/(y(23)*y(23))));
g1(24,34)=(-(1/y(23)));
g1(24,11)=(-y(44))/(y(11)*y(11));
g1(24,44)=1/y(11);
g1(25,28)=(-((1-params(21))*y(32)*(1-params(20))*y(49)*1/y(44)*T(23)));
g1(25,31)=1;
g1(25,32)=(-((1-params(21))*T(9)*(1-params(20))*y(49)));
g1(25,44)=(-((1-params(21))*y(32)*(1-params(20))*y(49)*T(27)));
g1(25,49)=(-((1-params(21))*y(32)*(1-params(20))*T(9)));
g1(26,21)=(-(params(21)*T(12)*(1-params(19))*y(53)));
g1(26,39)=(-(params(21)*y(21)*(1-params(19))*y(53)*y(44)*T(26)));
g1(26,42)=1;
g1(26,44)=(-(params(21)*y(21)*(1-params(19))*y(53)*y(39)*T(26)));
g1(26,53)=(-(params(21)*y(21)*(1-params(19))*T(12)));
g1(27,2)=(-((-y(27))/(y(2)*y(2))/(y(27)/y(2))));
g1(27,27)=(-(1/y(2)/(y(27)/y(2))));
g1(27,56)=1;
g1(28,7)=(-((-y(38))/(y(7)*y(7))/(y(38)/y(7))));
g1(28,38)=(-(1/y(7)/(y(38)/y(7))));
g1(28,57)=1;
g1(29,22)=(-1);
g1(29,58)=1;
g1(30,33)=(-1);
g1(30,59)=1;
g1(31,43)=(-1);
g1(31,60)=1;
g1(32,5)=(-((-y(31))/(y(5)*y(5))/(y(31)/y(5))));
g1(32,31)=(-(1/y(5)/(y(31)/y(5))));
g1(32,61)=1;
g1(33,9)=(-((-y(42))/(y(9)*y(9))/(y(42)/y(9))));
g1(33,42)=(-(1/y(9)/(y(42)/y(9))));
g1(33,62)=1;
g1(34,12)=(-(params(31)*1/y(12)));
g1(34,47)=1/y(47);
g1(34,73)=(-1);
g1(35,13)=(-(params(32)*1/y(13)));
g1(35,48)=1/y(48);
g1(35,74)=(-1);
g1(36,14)=(-(params(33)*1/y(14)));
g1(36,49)=1/y(49);
g1(36,75)=(-1);
g1(37,15)=(-(params(34)*1/y(15)));
g1(37,50)=1/y(50);
g1(37,76)=(-1);
g1(38,16)=(-(params(35)*1/y(16)));
g1(38,51)=1/y(51);
g1(38,77)=(-1);
g1(39,17)=(-(params(36)*1/y(17)));
g1(39,52)=1/y(52);
g1(39,78)=(-1);
g1(40,18)=(-(params(37)*1/y(18)));
g1(40,53)=1/y(53);
g1(40,79)=(-1);
g1(41,19)=(-(params(38)*1/y(19)));
g1(41,54)=1/y(54);
g1(41,80)=(-1);
g1(42,20)=(-(params(39)*1/y(20)));
g1(42,55)=1/y(55);
g1(42,81)=(-1);

end
