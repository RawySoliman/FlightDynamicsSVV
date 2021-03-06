%Symmetric equations of motion in state space system

% C_1*x_dot + C_2*x + C_3*u = 0

g = 9.81;

mu_c = 100;
V0 = 100;
V = 100;
K_Y = sqrt(1.25*1.114);
c_bar = 2.0569 ;
th0 = 0;
m = 5000;
rho0 = 1.2250;
lambda = -0.0065;
hp0 = 10000;
Temp0 = 288.15;
R = 287.05;

W = m*g;
S = 30.00;
rho = rho0*((1+(lambda*hp0/Temp0)))^(-((g/(lambda*R))+1));

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
Cm_al = 1;
Cm_al_dot = +0.17800;
Cm_q = -8.79415;
Cm_de = 1;

C_1 = [-2*mu_c/V,0,0,0; 0,Cz_al_dot-2*mu_c,0,0;0,0,-1,0;0,Cm_al_dot,0,-2*mu_c*K_Y^2*c_bar/V];
C_2 = [Cx_u,Cx_al*V/c_bar,Cz_o*V/c_bar,Cx_q;Cz_u/c_bar,Cz_al*V/c_bar,Cx_o*V/c_bar,Cz_q+2*mu_c;0,0,0,1;Cm_u/c_bar,Cm_al*V/c_bar,0,Cm_q];
C_3 = [Cx_de*V/c_bar;Cz_de*V/c_bar;0;Cm_de*V/c_bar];

As = -inv(C_1) * C_2;
Bs = -inv(C_1) * C_3;

Cs = eye(4);
Ds = 0;

sys_s = ss(As,Bs,Cs,Ds);

step(sys_s)
%x_dot = A*x + B*u
%y = C*x + D*u

