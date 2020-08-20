clc;
clear all;
close all;

load('ECM_params.mat');
load('US06_profile.mat');


% Plotting experimental current and voltage to find Voc when there is no
% cuirrent

figure('Color','w');
yyaxis right
plot(I_data_US06,'-r','LineWidth',0.5);
ylabel('Current (A)','FontWeight','bold');
hold on;
yyaxis left
plot(V_data_US06,'LineWidth',0.5);
ylabel('Voltage (V)','FontWeight','bold');
xlabel('time (0.1xs)','FontWeight','bold');
axis tight
grid on
hold off
%From the graph we obtain VOC
VOC = 3.81; 

%knowing Voc now I used the VOC-SOC plot to find SOC
figure('Color','w');
plot(SOC,Voc,'LineWidth',3);
xlabel('SOC','FontWeight','bold'); ylabel('Voc','FontWeight','bold');
axis tight
grid on
pbaspect([2 1 1])
hold off
%From the graph we obtain soc
soc = 0.71; 

%To obtain Rzero we interpolate with respect to SOC
Rzero = interp1(SOC_R0,R0,soc);

%Solving ODES of V1 and v2
tspan = linspace(0,length(I_data_US06)*0.1,length(I_data_US06))';
V1_0 = zeros(length(I_data_US06),1);
[t1,V1] = ode45(@(t,V1) myode(V1,R1,C1,I_data_US06), tspan, V1_0);
V2_0 = V1_0;
[t2,V2] = ode45(@(t,V2) myode(V2,R2,C2,I_data_US06), tspan, V2_0);





%% FIRST TRY

Current = I_data_US06;
t = linspace(0,2273.5,length(Current));
V = zeros(length(t),length(SOC_R0));
v1 = zeros(1,length(t));
v2 = zeros(1,length(t));
% [sharedVals,idxsIntoSOC_RO,idxsIntoSOC] = intersect(SOC_R0,SOC);

Voc_new = [Voc(21) Voc(31) Voc(41) Voc(51) Voc(61) Voc(71) Voc(81) Voc(91) Voc(101)];
% v1_0 = 0;
% v2_0 = 0;


figure('Color','w');
yyaxis left
plot(SOC_R0,Voc_new,'LineWidth',3);
hold on;
yyaxis right;
plot(SOC_R0,R0,'LineWidth',3);
xlabel('SOC','FontWeight','bold');
legend('Voc','R0')
axis tight
grid on
pbaspect([2 1 1])
hold off

for j = 1:length(SOC_R0)
    for i = 1:length(t)
%         [time1,v1(i)] = ode45(@(time1,v1));
        v1(i) = (Current(i)*t(i)/C1)/(1+t(i)./(R1*C1));
        v2(i) = (Current(i)*t(i)/C2)/(1+t(i)./(R2*C2));
        V(i,j) = Voc_new(j)-R0(j)-v1(i)-v2(i);
%         V(i,j) = Voc(j)-R0(j);
    end
end


SOC_plot = repmat(SOC_R0,length(t),1);
t_plot = repmat(t,length(SOC_R0),1);

figure('Color','w');
mesh(SOC_plot,t_plot',V)
colormap parula    % change color map
shading interp    % interpolate colors across lines and faces
  alpha 0.9 
hold on
title('Dynamic Voltage Response of the Battery','FontWeight', 'bold'); 
xlabel('SOC','FontWeight','bold');
% xticklabels({'0.20','0.30','0.40','0.50','0.60','0.70','0.80','0.90','1.00'})
ylabel(' Time (s)','FontWeight','bold');
zlabel('Voltage (v)','FontWeight','bold');
% xlim([0 inf])
pbaspect([5 5 1])
axis tight
grid on;
hold off


RMS = zeros(length(SOC_R0),1);
N = length(V_data_US06);
sum1 = zeros(length(SOC_R0),1);
sum2 = 0;
% sum2 = zeros(length(SOC_R0),1);
for i = 1:length(t)
   sum2 = sum2 + V_data_US06(i);
end

for j = 1:length(SOC_R0)
    for i = 1:length(t)
   sum1(j) = sum1(j)+(V_data_US06(i)-V(i,j)).^2;
    end
end

for k = 1:length(SOC_R0)
RMS(k) = sqrt(sum1(k)./N)*(N/sum2)*100;
end

figure('Color','w');
plot(SOC_R0,RMS,'LineWidth',3);
hold on;
xlabel('SOC','FontWeight','bold');
ylabel('RMS','FontWeight','bold');
axis tight
grid on
hold off

% Adding the experimental values
SOC_plot2 = zeros(length(t),1);

figure('Color','w');
mesh(SOC_plot,t_plot',V)
colormap parula    % change color map
shading interp    % interpolate colors across lines and faces
alpha 0.9 
hold on
plot3(SOC_plot2+0.8,t',V_data_US06,'-.r*','LineWidth',0.3,'MarkerSize',0.6)
title('Experimental match','FontWeight', 'bold'); 
xlabel('SOC','FontWeight','bold');
% xticklabels({'0.20','0.30','0.40','0.50','0.60','0.70','0.80','0.90','1.00'})
ylabel(' Time (s)','FontWeight','bold');
zlabel('Voltage (v)','FontWeight','bold');
% xlim([0 inf])
pbaspect([5 5 1])
axis tight
grid on;
hold off

figure('Color','w');
yyaxis left
plot(V(:,7),'LineWidth',3);
ylabel('Model Predicted Voltage (V)','FontWeight','bold');
hold on;
yyaxis right
plot(V_data_US06,'-.r*','LineWidth',0.3,'MarkerSize',0.6);
ylabel(' Experimentally meassuredVoltage (V)','FontWeight','bold');
xlabel('Time (s)','FontWeight','bold');
pbaspect([4 1 1])
axis tight
grid on
hold off
