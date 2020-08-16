%% Nonlinear Load current equation
function F = nonlin_I_load(x)
global q V k R_sh Rs
global i j T_cell i_0 i_l
F = x-i_l(i,j) + i_0(i,j)*(exp(q*(V+x*Rs)/(k*T_cell(j)))-1) + (V+x*Rs)/R_sh;