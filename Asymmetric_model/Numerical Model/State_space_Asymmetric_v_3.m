clear all
clc
%Asymmetric equations of Motion in State Space System
run("Check_par.m")
% Parameters
% 
% hp0    = 5000;      	  % pressure altitude in the stationary flight condition [m]
% V0     = 100;            % true airspeed in the stationary flight condition [m/sec]
% m      = 9500;         % Kg
% 
% rho0   = 1.2250;          % air density at sea level [kg/m^3] 
% lambda = -0.0065;         % temperature gradient in ISA [K/m]
% Temp0  = 288.15;          % temperature at sea level in ISA [K]
% R      = 287.05;          % specific gas constant [m^2/sec^2K]
% g      = 9.81;            % [m/sec^2] (gravity constant)
% 
% rho    = rho0*((1+(lambda*hp0/Temp0)))^(-((g/(lambda*R))+1));   % [kg/m^3]  (air density)
% W      = m*g;
% b = 15.911;
% S = 30;
% mu_b = m/(rho*S*b);
% C_L = 2*W/(rho*V0^2*S);
% V = V0;
% 
% 
% 
% Cy_bt_dot = 0;
% Cy_bt = -0.7500;
% Cy_p = -0.0304;
% Cy_r = +0.8495;
% Cy_da = -0.0400;
% Cy_dr = +0.2300;
% 
% K_x = sqrt(0.019);
% K_xz = 0.002;
% K_z = sqrt(0.042);
% 
% 
% Cn_bt_dot = 0;
% Cn_bt = +0.1348;
% Cn_p = -0.0602;
% Cn_r = -0.2061;
% Cn_da = -0.0120;
% Cn_dr = -0.0939;
% 
% Cl_bt = -0.10260;
% Cl_p = -0.71085;
% Cl_r = +0.23760;
% Cl_da = -0.23088;
% Cl_dr = +0.03440;


% Rewritten form 
% C1*x_dot + C2*x + C3*u = 0
dim_cnst = b/V;

C_1 = [(Cy_bt_dot -(2*mu_b))*dim_cnst   ,  0    ,  0    ,  0    ;   ...
        0   ,  -dim_cnst/2  ,    0  ,  0    ; ...
        0   ,  0    ,  -4*mu_b*(K_x^2)*dim_cnst   ,   4*mu_b*K_xz*dim_cnst  ; ...
        Cn_bt_dot*dim_cnst  , 0 ,  4*mu_b*K_xz*dim_cnst   , -4*mu_b*(K_z^2)*dim_cnst];
    
C_2 = [Cy_bt    ,   C_L     ,    Cy_p    ,    (Cy_r - 4*mu_b) ;...
        0   ,  0    ,    1     ,   0   ;...
        Cl_bt   ,    0    ,     Cl_p     ,   Cl_r     ;...
        Cn_bt   ,   0   ,   Cn_p ,   Cn_r     ];

C_3 = [ Cy_da ,     Cy_dr   ; ...
        0   ,   0   ;   ...
        Cl_da   ,   Cl_dr   ;   ...
        Cn_da   ,   Cn_dr       ];



% State Space System

% y = x (chosen output vector is same as state vector)
% Aa = -(C1^-1)*C2
% Ba = - (C1^-1)*C1
% Ca = Identity(4)
% Da = null vector

Aa = inv(C_1)*(-1*C_2);
Ba = inv(C_1)*(-1*C_3);
Ca = eye(4);
Ca(3,3) = 2/dim_cnst;
Ca(4,4) = 2/dim_cnst;
Da = zeros(4,2);

t = linspace(0,50,100);
x_0 = [0,0,0,0];
t = linspace(0,50,100);
u = zeros(2,length(t));
u(1,:) = 1;

sys_a = ss(Aa,Ba,Ca,Da);
sys_a.StateName = {'\beta','\phi','p','r'};
sys_a.InputName = {'Aileron','Rudder'};
sys_a.OutputName = {'\beta','\phi','p','r'};

figure();
lsim(sys_a,u,t);

eig(Aa)

