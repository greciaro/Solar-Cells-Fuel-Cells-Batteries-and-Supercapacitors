function dv1dt = myode(v1,Current,R1,C1,i)
dv1dt(i) = -(1/(R1*C1)).*v1(i)+(1/C1)*Current(i);