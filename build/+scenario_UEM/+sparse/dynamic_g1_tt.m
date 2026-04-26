function [T_order, T] = dynamic_g1_tt(y, x, params, steady_state, T_order, T)
if T_order >= 1
    return
end
[T_order, T] = scenario_UEM.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
T_order = 1;
if size(T, 1) < 28
    T = [T; NaN(28 - size(T, 1), 1)];
end
T(20) = getPowerDeriv(y(40)-params(7)*y(1),(-params(1)),1);
T(21) = getPowerDeriv((y(79)-y(40)*params(7))/(y(40)-params(7)*y(1)),(-params(1)),1);
T(22) = y(40)*params(19)*getPowerDeriv(y(47),(-params(16)),1);
T(23) = getPowerDeriv(y(47)/y(63),(-params(16)),1);
T(24) = getPowerDeriv(y(51)-params(8)*y(12),(-params(2)),1);
T(25) = getPowerDeriv((y(90)-y(51)*params(8))/(y(51)-params(8)*y(12)),(-params(2)),1);
T(26) = getPowerDeriv(y(63)*y(58),(-params(16)),1);
T(27) = T(23)*(-y(47))/(y(63)*y(63));
T(28) = getPowerDeriv(T(17),1-params(22),1);
end
