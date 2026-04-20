% New Keynesian Model with 3 equations

%----------------------------------------------------------------
% 0. Housekeeping (close all graphic windows)
%----------------------------------------------------------------
close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------
var    y pi r e_D e_S e_R;
varexo eta_D eta_S eta_R;
parameters  beta sigma varphi rho phi_pi phi_y theta rho_D rho_S rho_R;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------
beta    	= 0.9951;			% discount factor
sigma		= 1;				% risk aversion consumption
varphi		= 1;				% labor disutility
theta		= 0.75;				% new keynesian Philips Curve, forward term
rho			= 0.80;				% MPR Smoothing
phi_pi		= 1.5;				% MPR Inflation
phi_y		= 0.2;				% MPR GDP

% shock processes
rho_D   = 0.80;
rho_S   = 0.95;
rho_R 	= 0.40;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------
model(linear); 
	[name='IS curve']
	y = y(+1) - 1/sigma*(r-pi(+1)) + e_D;
	[name='AS curve']
	pi = beta*pi(+1) + ((1-theta)*(1-beta*theta)/theta)*(sigma+varphi)*y + e_S;
	[name='Monetary Policy Rule']
	r = rho*r(-1) +  (1-rho)*( phi_pi*pi + phi_y*y ) + e_R  ;
	[name='demand shock']
	e_D = rho_D*e_D(-1)+eta_D;
	[name='supply shock']
	e_S = rho_S*e_S(-1)+eta_S;
	[name='monetary policy shock']
	e_R = rho_R*e_R(-1)+eta_R;
end;


shocks;
var eta_D;  stderr 0.02;
var eta_S;  stderr 0.004;
var eta_R;  stderr 0.001;
end;

stoch_simul(order=1,irf=30) y pi r;




