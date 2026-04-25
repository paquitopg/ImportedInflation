function [T_order, T] = static_g1_tt(y, x, params, T_order, T)
if T_order >= 1
    return
end
[T_order, T] = estimation_UEM.sparse.static_resid_tt(y, x, params, T_order, T);
T_order = 1;
if size(T, 1) < 19
    T = [T; NaN(19 - size(T, 1), 1)];
end
T(15) = y(1)*params(19)*getPowerDeriv(y(8),(-params(16)),1);
T(16) = getPowerDeriv(y(8)/y(24),(-params(16)),1);
T(17) = getPowerDeriv(y(24)*y(19),(-params(16)),1);
T(18) = getPowerDeriv((y(23))*T(11)*T(12),1-params(22),1);
T(19) = T(16)*(-y(8))/(y(24)*y(24));
end
