function [T_order, T] = static_resid_tt(y, x, params, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 14
    T = [T; NaN(14 - size(T, 1), 1)];
end
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
