function [y, T] = dynamic_11(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(80)=y(63)-(steady_state(23));
  y(79)=y(53)-params(25);
  y(78)=y(42)-params(25);
  y(77)=log(y(58)/y(18));
  y(76)=log(y(47)/y(7));
  y(62)=params(21)*y(41)*T(2)*(1-params(19))*y(73);
  y(51)=(1-params(21))*y(52)*T(12)*(1-params(20))*y(69);
end
