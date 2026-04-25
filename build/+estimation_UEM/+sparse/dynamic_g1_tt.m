function [T_order, T] = dynamic_g1_tt(y, x, params, steady_state, T_order, T)
if T_order >= 1
    return
end
[T_order, T] = estimation_UEM.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
T_order = 1;
if size(T, 1) < 28
    T = [T; NaN(28 - size(T, 1), 1)];
end
T(20) = getPowerDeriv(y(43)-params(7)*y(1),(-params(1)),1);
T(21) = getPowerDeriv((y(85)-y(43)*params(7))/(y(43)-params(7)*y(1)),(-params(1)),1);
T(22) = y(43)*params(19)*getPowerDeriv(y(50),(-params(16)),1);
T(23) = getPowerDeriv(y(50)/y(66),(-params(16)),1);
T(24) = getPowerDeriv(y(54)-params(8)*y(12),(-params(2)),1);
T(25) = getPowerDeriv((y(96)-y(54)*params(8))/(y(54)-params(8)*y(12)),(-params(2)),1);
T(26) = getPowerDeriv(y(66)*y(61),(-params(16)),1);
T(27) = T(23)*(-y(50))/(y(66)*y(66));
T(28) = getPowerDeriv(T(17),1-params(22),1);
end
