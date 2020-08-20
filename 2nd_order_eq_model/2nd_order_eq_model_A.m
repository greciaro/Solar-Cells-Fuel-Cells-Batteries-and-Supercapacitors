clc;
clear all;
close all;

load('ECM_params.mat');
load('US06_profile.mat');

%IMPLEMENTING  EQUATIONS 
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

%Solving ODES of V1 and V2
tspan = linspace(0,length(I_data_US06)*0.1,length(I_data_US06))';
t = tspan;
% V1_0 = 0;
V1_0 = zeros(length(I_data_US06),1)';
[t1,V1] = ode45(@(t,V1) myode(V1,R1,C1,I_data_US06), tspan, V1_0);
V2_0 = V1_0;
[t2,V2] = ode45(@(t,V2) myode(V2,R2,C2,I_data_US06), tspan, V2_0);


%Plotting V1 and V2
figure('Color','w');
yyaxis right
plot(t1,V1(:,1),'-r','LineWidth',2);
ylabel('V1','FontWeight','bold');
hold on;
yyaxis left
plot(t2,V2(:,1),'LineWidth',2);
ylabel('V2','FontWeight','bold');
xlabel('time (s)','FontWeight','bold');
axis tight
grid on
hold off

%Calculating the model-predicted dynamic voltage
V_dyn = VOC-Rzero.*I_data_US06-V1(:,1)-V2(:,1);
%Ploting the model-predicted dynamic voltage
figure('Color','w');
plot(tspan,V_dyn,'-m','LineWidth',0.3);
ylabel('Model-predicted Voltage (V)','FontWeight','bold');
xlabel('time (s)','FontWeight','bold');
axis tight
grid on
hold off


%% COMPARING MODEL PREDICTED VOLTAGE WITH EXPERIMENTALLY MEASURED CELL VOLTAGE

%Calculating RMS
N = length(V_data_US06);
sum1 = 0;
sum2 = 0;
for i = 1:length(tspan)
   sum2 = sum2 + V_data_US06(i);
end
for i = 1:length(tspan)
    sum1 = sum1+(V_data_US06(i)-V_dyn(i)).^2;
end
RMS = sqrt(sum1/N)*(N/sum2)*100;

%Ploting the model-predicted and experiemntal voltages
figure('Color','w');
plot(tspan,V_dyn,'-b','LineWidth',3);
hold on
plot(tspan,V_data_US06,'-m','LineWidth',0.3);
ylabel('Voltage (V)','FontWeight','bold');
xlabel('time (s)','FontWeight','bold');
legend ('Model predicted','Experimental');
pbaspect([3 1 1])
axis tight
grid on
hold off

