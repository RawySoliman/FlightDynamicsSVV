clear; close all; clc;

%Symmetric equations of motion in state space system

% C_1*x_dot + C_2*x + C_3*u = 0

K_Y = sqrt(1.25*1.114);
c_bar = 2.0569 ;

th0 = 0;

hp0    = 5000;      	  % pressure altitude in the stationary flight condition [m]
V0     = 100;             % true airspeed in the stationary flight condition [m/sec]
m      = 9500;            % Kg

rho0   = 1.2250;          % air density at sea level [kg/m^3] 
lambda = -0.0065;         % temperature gradient in ISA [K/m]
Temp0  = 288.15;          % temperature at sea level in ISA [K]
R      = 287.05;          % specific gas constant [m^2/sec^2K]
g      = 9.81;            % [m/sec^2] (gravity constant)

rho    = rho0*((1+(lambda*hp0/Temp0)))^(-((g/(lambda*R))+1));   % [kg/m^3]  (air density)
W      = m*g;
b = 15.911;
S = 30;
mu_c = m/(rho*S*c_bar);
C_L = 2*W/(rho*V0^2*S);
V = V0;

Q = 1;%V/c_bar;


Cx_o = W*sin(th0)/(0.5*rho*V0^2*S);
Cx_u = -0.02792;
Cx_al = -0.47966;
Cx_q = -0.28170;
Cx_de = -0.03728;

Cz_o = -W*cos(th0)/(0.5*rho*V0^2*S);
Cz_u = -0.37616;
Cz_al = -5.74340;
Cz_al_dot = -0.00350;
Cz_q = -5.66290;
Cz_de = -0.69612;

Cm_u = +0.06990;
Cm_al = -0.5626;
Cm_al_dot = +0.17800;
Cm_q = -8.79415;
Cm_de = -1.1642;

X_u  = Q * Cx_u/(2*mu_c);
X_al = Q * Cx_al/(2*mu_c);
X_th = Q * Cz_o/(2*mu_c);
X_q  = Q * Cx_q/(2*mu_c);
X_de = Q * Cx_de/(2*mu_c);

Z_u  = Q * Cz_u/(2*mu_c - Cz_al_dot);
Z_al = Q * Cz_al/(2*mu_c - Cz_al_dot);
Z_th = - Q * Cx_o/(2*mu_c - Cz_al_dot);
Z_q  = Q * (2*mu_c + Cz_q)/(2*mu_c - Cz_al_dot);
Z_de = Q * Cz_de/(2*mu_c - Cz_al_dot);

m_u  =  Q * (Cm_u  + Cz_u  *Cm_al_dot                /(2*mu_c - Cz_al_dot))/(2*mu_c*K_Y^2);
m_al =  Q * (Cm_al + Cz_al *Cm_al_dot                /(2*mu_c - Cz_al_dot))/(2*mu_c*K_Y^2);
m_th = -Q * (        Cx_o  *Cm_al_dot                /(2*mu_c - Cz_al_dot))/(2*mu_c*K_Y^2);
m_q  =  Q * (Cm_q  +        Cm_al_dot*(2*mu_c + Cz_q) /(2*mu_c - Cz_al_dot))/(2*mu_c*K_Y^2);
m_de =  Q * (Cm_de + Cz_de *Cm_al_dot                /(2*mu_c - Cz_al_dot))/(2*mu_c*K_Y^2);

As = [X_u,X_al,X_th,0;Z_u,Z_al,Z_th,Z_q;0,0,0,Q;m_u,m_al,m_th,m_q];
Bs = [X_de;Z_de;0;m_de];

Cs = [V,0,0,0;0,1,0,0;0,0,1,0;0,0,0,V/c_bar];
Ds = 0;

sys_s = ss(As,Bs,Cs,Ds);
init = [0,0,0,0];
t = 0:0.1:100000;
step = ones(1, length(t));
% [y,t]=step(0.1*sys_s);

[y, t] = lsim(sys_s, 0.001*step, t, init);

subplot(4, 1, 1);
plot(t, y(:, 1));
xlabel("time [s]")
ylabel("u [m/s]")

subplot(4, 1, 2);
plot(t, y(:, 2));
xlabel("time [s]")
ylabel("AoA [rad]")

subplot(4, 1, 3);
plot(t, y(:, 3));
xlabel("time [s]")
ylabel("theta [rad]")

subplot(4, 1, 4);
plot(t, y(:, 4));
xlabel("time [s]")
ylabel("q [rad/s]")

eig(As)























