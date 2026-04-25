function [T_order, T] = dynamic_resid_tt(y, x, params, steady_state, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 19
    T = [T; NaN(19 - size(T, 1), 1)];
end
T(1) = params(5)*params(12)*((y(85)-y(43)*params(7))/(y(43)-params(7)*y(1)))^(-params(1));
T(2) = T(1)*y(87);
T(3) = params(5)*params(13)*((y(96)-y(54)*params(8))/(y(54)-params(8)*y(12)))^(-params(2));
T(4) = T(3)*y(98);
T(5) = y(48)^params(6);
T(6) = y(59)^params(6);
T(7) = params(19)*y(50)^(-params(16));
T(8) = y(43)*T(7);
T(9) = (y(50)/y(66))^(-params(16));
T(10) = params(12)*0.5*(y(45)-params(25))^2;
T(11) = params(20)*y(61)^(-params(16));
T(12) = (y(66)*y(61))^(-params(16));
T(13) = params(13)*0.5*(y(56)-params(25))^2;
T(14) = y(23)^params(22);
T(15) = (steady_state(23))*(y(67)/params(25))^params(23);
T(16) = (y(68)/(steady_state(26)))^params(24);
T(17) = T(15)*T(16);
T(18) = T(17)^(1-params(22));
T(19) = (1-params(20))*y(75)*(1-params(21))/params(21);
end
