function g1 = static_g1(T, y, x, params, T_flag)
% function g1 = static_g1(T, y, x, params, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%                                              to evaluate the model
%   T_flag    boolean                 boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   g1
%

if T_flag
    T = scenario_UEM.static_g1_tt(T, y, x, params);
end
g1 = zeros(39, 39);
g1(1,1)=(-((1-params(7))*getPowerDeriv(y(1)-y(1)*params(7),(-params(1)),1)));
g1(1,10)=1;
g1(2,12)=(-((1-params(8))*getPowerDeriv(y(12)-y(12)*params(8),(-params(2)),1)));
g1(2,21)=1;
g1(3,2)=(-((-(y(10)*params(5)*y(23)))/(y(2)*y(2))));
g1(3,10)=1-params(5)*y(23)/y(2);
g1(3,23)=(-(y(10)*params(5)/y(2)));
g1(4,13)=(-((-(y(23)*y(21)*params(5)))/(y(13)*y(13))));
g1(4,21)=1-params(5)*y(23)/y(13);
g1(4,23)=(-(y(21)*params(5)/y(13)));
g1(5,5)=(-y(10));
g1(5,6)=params(10)*getPowerDeriv(y(6),params(3),1);
g1(5,10)=(-y(5));
g1(6,16)=(-y(21));
g1(6,17)=params(11)*getPowerDeriv(y(17),params(4),1);
g1(6,21)=(-y(16));
g1(7,3)=y(3)*params(5)*params(12)+(y(3)-params(25))*params(5)*params(12)-(params(12)*y(3)+params(12)*(y(3)-params(25)));
g1(7,4)=params(14)*y(28);
g1(7,28)=params(14)*y(4);
g1(8,14)=y(14)*params(5)*params(13)+(y(14)-params(25))*params(5)*params(13)-(params(13)*y(14)+params(13)*(y(14)-params(25)));
g1(8,15)=params(15)*y(32);
g1(8,32)=params(15)*y(15);
g1(9,4)=1;
g1(9,5)=(-(y(6)/(y(7)*params(6))));
g1(9,6)=(-(y(5)*1/(y(7)*params(6))));
g1(9,7)=(-(y(5)*(-(y(6)*params(6)))/(y(7)*params(6)*y(7)*params(6))));
g1(10,15)=1;
g1(10,16)=(-(y(17)/(y(18)*params(6))));
g1(10,17)=(-(y(16)*1/(y(18)*params(6))));
g1(10,18)=(-(y(16)*(-(y(17)*params(6)))/(y(18)*params(6)*y(18)*params(6))));
g1(11,6)=(-(params(29)*y(27)*getPowerDeriv(y(6),params(6),1)));
g1(11,7)=1;
g1(11,27)=(-(params(29)*T(1)));
g1(12,17)=(-(params(29)*y(31)*getPowerDeriv(y(17),params(6),1)));
g1(12,18)=1;
g1(12,31)=(-(params(29)*T(2)));
g1(13,8)=(-(params(19)*getPowerDeriv(y(8),1-params(16),1)));
g1(13,24)=(-((1-params(19))*getPowerDeriv(y(24),1-params(16),1)));
g1(14,19)=(-(params(20)*getPowerDeriv(y(19),1-params(16),1)));
g1(14,24)=(-((1-params(20))*(-1)/(y(24)*y(24))*getPowerDeriv(1/y(24),1-params(16),1)));
g1(15,2)=(-((-y(3))/(y(2)*y(2))));
g1(15,3)=(-(1/y(2)));
g1(16,13)=(-((-y(14))/(y(13)*y(13))));
g1(16,14)=(-(1/y(13)));
g1(17,1)=(-T(3));
g1(17,3)=(-(y(7)*params(12)*0.5*2*(y(3)-params(25))));
g1(17,7)=1-(T(6)+params(26)*y(30));
g1(17,8)=(-(T(15)+(1-params(21))*y(12)*(1-params(20))*y(33)*1/y(24)*T(16)/params(21)));
g1(17,12)=(-((1-params(20))*y(33)*T(5)*(1-params(21))/params(21)));
g1(17,24)=(-((1-params(21))*y(12)*(1-params(20))*y(33)*T(19)/params(21)));
g1(17,30)=(-(params(26)*(y(7))));
g1(17,33)=(-((1-params(21))*y(12)*(1-params(20))*T(5)/params(21)));
g1(18,1)=(-(params(21)*(1-params(19))*y(29)*T(8)/(1-params(21))));
g1(18,12)=(-T(7));
g1(18,14)=(-(y(18)*params(13)*0.5*2*(y(14)-params(25))));
g1(18,18)=1-(T(9)+params(27)*y(34));
g1(18,19)=(-(y(12)*params(20)*getPowerDeriv(y(19),(-params(16)),1)+params(21)*y(1)*(1-params(19))*y(29)*y(24)*T(17)/(1-params(21))));
g1(18,24)=(-(params(21)*y(1)*(1-params(19))*y(29)*y(19)*T(17)/(1-params(21))));
g1(18,29)=(-(params(21)*y(1)*(1-params(19))*T(8)/(1-params(21))));
g1(18,34)=(-(params(27)*(y(18))));
g1(19,2)=(-params(21));
g1(19,13)=(-(1-params(21)));
g1(19,25)=1;
g1(20,7)=(-params(21));
g1(20,18)=(-(1-params(21)));
g1(20,26)=1;
g1(21,23)=1-y(35)*(T(13)*getPowerDeriv(y(23),params(22),1)+T(10)*T(11)*T(12)*T(18));
g1(21,25)=(-(y(35)*T(10)*T(18)*T(12)*(y(23))*1/params(25)*getPowerDeriv(y(25)/params(25),params(23),1)));
g1(21,26)=(-(y(35)*T(10)*T(18)*(y(23))*T(11)*((y(26))-y(26))/((y(26))*(y(26)))*getPowerDeriv(y(26)/(y(26)),params(24),1)));
g1(21,35)=(-(T(10)*T(13)));
g1(22,1)=(-(y(8)*T(3)-1));
g1(22,2)=(-(y(9)*(-y(23))/(y(2)*y(2))));
g1(22,8)=(-(T(4)+y(12)*T(5)*T(14)+y(8)*(T(15)+y(12)*T(14)*1/y(24)*T(16))));
g1(22,9)=1-y(23)/y(2);
g1(22,12)=(-(y(8)*T(5)*T(14)));
g1(22,23)=(-(y(9)*1/y(2)));
g1(22,24)=(-(y(8)*y(12)*T(14)*T(19)));
g1(22,33)=(-(y(8)*y(12)*T(5)*(1-params(20))*(1-params(21))/params(21)));
g1(23,9)=params(21);
g1(23,20)=1-params(21);
g1(24,3)=(-((-y(14))/(y(3)*y(3))));
g1(24,14)=(-(1/y(3)));
g1(25,8)=(-((1-params(21))*y(12)*(1-params(20))*y(29)*1/y(24)*T(16)));
g1(25,11)=1;
g1(25,12)=(-((1-params(21))*T(5)*(1-params(20))*y(29)));
g1(25,24)=(-((1-params(21))*y(12)*(1-params(20))*y(29)*T(19)));
g1(25,29)=(-((1-params(21))*y(12)*(1-params(20))*T(5)));
g1(26,1)=(-(params(21)*T(8)*(1-params(19))*y(33)));
g1(26,19)=(-(params(21)*y(1)*(1-params(19))*y(33)*y(24)*T(17)));
g1(26,22)=1;
g1(26,24)=(-(params(21)*y(1)*(1-params(19))*y(33)*y(19)*T(17)));
g1(26,33)=(-(params(21)*y(1)*(1-params(19))*T(8)));
g1(27,36)=1;
g1(28,37)=1;
g1(29,2)=(-1);
g1(29,38)=1;
g1(30,13)=(-1);
g1(30,39)=1;
g1(31,27)=1/y(27)-params(31)*1/y(27);
g1(32,28)=1/y(28)-params(32)*1/y(28);
g1(33,29)=1/y(29)-params(33)*1/y(29);
g1(34,30)=1/y(30)-params(34)*1/y(30);
g1(35,31)=1/y(31)-params(35)*1/y(31);
g1(36,32)=1/y(32)-params(36)*1/y(32);
g1(37,33)=1/y(33)-params(37)*1/y(33);
g1(38,34)=1/y(34)-params(38)*1/y(34);
g1(39,35)=1/y(35)-params(39)*1/y(35);

end
