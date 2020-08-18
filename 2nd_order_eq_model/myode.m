function dVdt = myode(V,R,C,I)
dVdt = -(1/(R*C))*V+(1/C)*I;