clc;
clear all;
%

Tair_1 = 0;%(C)
Tair_2 = 40;%(C)
%
% Initializing constants
Cth = 320;% [J/Celsius]
Rth = 4.5;% [Celsius/W]
alpha = Cth;
betta = 1/Rth;
kappa = Tair_2/Rth;
heta = .90;
phi = 1-heta;
%
% By digitalization of the C and R graphs
% Rows = Temperature  Columns = R
Rf = [-17.5887 0.54778/1000; 25.0045 0.49089/1000; 50.1867 0.4962/1000];% Ohms
Rd = [-18.7769 0.2355; 24.7251 0.2231; 49.7618 0.221];% Ohms
% Rows = Temperature  Columns = C
Cf = [-17.9057 1342.501; 24.9214 1349.158; 49.9476 1459.1];% Faradhs
Cd = [-18.0379 63.0960; 24.8915 64.2740; 49.6082 112.0683];% Faradhs

% Time = i
% Cycles from a to d instructions = k
Idlc = zeros (1,3600);
Vdlc = zeros (1,3600);
Vdlc(1) = -10;
Tdlc = zeros (1,3600);
V_cf = zeros (1,3600);
V_cd = zeros (1,3600);
I_f = zeros (1,3600);
I_d = zeros (1,3600);
i = 1;

Tdlc(2) = 0;%[C]
y0 = ones(5,1)*0.001;
y0(5,1) = 0;
d = 0;
