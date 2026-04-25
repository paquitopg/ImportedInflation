function [y, T] = dynamic_11(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(64)=params(21)*y(43)*T(7)*(1-params(19))*y(75);
  y(53)=(1-params(21))*y(54)*T(12)*(1-params(20))*y(71);
  y(84)=log(y(64)/y(22));
  y(83)=log(y(53)/y(11));
  y(82)=y(65)-(steady_state(23));
  y(81)=y(55)-params(25);
  y(80)=y(44)-params(25);
  y(79)=log(y(60)/y(18));
  y(78)=log(y(49)/y(7));
end
