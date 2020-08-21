clc;
clear all;
close all;

load('ECM_params.mat');
load('US06_profile.mat');

Current = I_data_US06;
t = linspace(0,22735,length(Current));
V = zeros(length(t),length(SOC));
v1 = zeros(1,length(t));
v2 = zeros(1,length(t));
% v1_0 = 0;
% v2_0 = 0;

for j = 1:length(SOC)
    for i = 1:length(t)
%         [time1,v1(i)] = ode45(@(time1,v1));
        v1(i) = (Current(i)*t(i)/C1)/(1+t(i)./(R1*C1));
        v2(i) = (Current(i)*t(i)/C2)/(1+t(i)./(R2*C2));
        V(i,j) = Voc(j)-R0(j)-v1(i)-v2(i);
    end
end