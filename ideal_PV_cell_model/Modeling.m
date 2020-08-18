clear all
close all
clc
global q V k R_sh Rs
mu_sc = 1.3e-3; % A/K
Eq = 1.16; %eV
i_0_ref = 4e-11;
i_l_ref = 3.8; %A (short circuit current under STC)
q = 1.6e-19; %C
k = 1.38e-23; %J/K
T_nom = 298; %K
G_ref = 1000; %W/m^2
n = 36; % cells in series
Voc = 21.1;
Vm = 17.1;
V = Voc/n;
%% Variables
G = [200, 400, 600, 800, 1000]; %W/m^2
T = [25, 30, 40, 50]; % celsius
T_cell = T+273; %K


%% Ideal Case
for i = 1:length(G)
for j = 1:length(T_cell)
delta_T(j) = T_nom - T_cell(j);
i_l(i,j) = (i_l_ref + mu_sc*delta_T(j))*G(i)/G_ref;
i_0(i,j) = i_0_ref*((T_cell(j)/T_nom)^3)*exp((1/T_nom -1/T_cell(j))*q*Eq/k);
I_load(i,j) = i_l(i,j) - i_0(i,j)*(exp(q*V/(k*T_cell(j)))-1);
end
end
figure();hold all; grid on
%% Non-ideal Case
R_sh = 50;
Rs = 1.2/36;
global i j T_cell i_0 i_l
for i = 1:length(G)
for j = 1:length(T_cell)
fun = @nonlin_I_load;
x0 = [i_l_ref];
I_load(i,j) = fsolve(fun,x0);
end
end


%% IV Plot
T_count = length(T_cell);
for i = 1:length(G)
for j = 1:length(T_cell)
I_sc(j+(i-1)*T_count,:) = linspace(0,i_l(i,j));
for index = 1:length(I_sc)
Voc_calc(j+(i-1)*T_count,index) = ...
(k*T_cell(j)/q)*log(I_sc(j+(i-1)*T_count,index)/i_0(i,j) + 1);
end
end
end
% Figures
for i=1:length(G)
for j=1:length(T_cell)
Lin_style = {'-','--',':','-.'};
figure(i+2);grid on
plot(fliplr(Voc_calc(j+(i-1)*T_count,:)),I_sc((1+(i-1)*T_count),:),...
'LineStyle',Lin_style{j},'LineWidth',3)
hold on; legend('T=25^{o}C','T=30^{o}C','T=40^{o}C','T=50^{o}C')
set(gca,'FontSize',16); xlabel('V [V]','Fontsize',16)
ylabel('I [A]','Fontsize',16);
title(['Non-ideal Solar Cell for G=',sprintf('%d',G(i)),'W/m^2'],'FontSize',16)
end
end
