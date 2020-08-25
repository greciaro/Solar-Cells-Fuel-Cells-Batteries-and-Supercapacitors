 
    
    for i=b+1:3600
        % Instruction (d)
        Idlc(i) = 100; %[A] Discharging
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calculate Vdlc (i)
        C_d(i) = interp1(Cd(:,1),Cd(:,2),Tdlc(i));
        C_f(i) = interp1(Cf(:,1),Cf(:,2),Tdlc(i));
        R_d(i) = interp1(Rd(:,1),Rd(:,2),Tdlc(i));
        R_f(i) = interp1(Rf(:,1),Rf(:,2),Tdlc(i));
        delta = (Idlc(i)^2)*Rth;
        gamma = 1/C_f(i);
        lambda = 1/C_d(i);
        sigma = R_f(i);
        omicron = Idlc(i);
        rho = R_d(i);
        syms y1(t) y2(t) y3(t) y4(t) y5(y)
        eqn1 = diff(y1(t),1) == gamma*y3(t);
        eqn2 = diff(y2(t),1) == lambda*y4(t);
        eqn3 = diff(y5(t),1) == (1/alpha)*(kappa+delta-betta*y5(t));
        eqn4 = 0 == y3(t) + y4(t)- omicron;
        eqn5 = 0 == rho*y4(t)+y2(t)+y1(t)-sigma*y3(t);
        eqns = [eqn1 eqn2 eqn3 eqn4 eqn5];
        vars = [y1(t); y2(t); y3(t); y4(t); y5(t)];
        f = daeFunction(eqns, vars);
        F = @(t,Y,YP)f(t,Y,YP);
        yp0 = ones(5,1);
        opt = odeset('RelTol', 10.0^(-7), 'AbsTol' , 10.0^(-7));
        ti = i-1;
        tspan = [0, ti];
        [tSol,ySol] = ode15i(F, tspan, y0,yp0, opt);
        Tdlc(i) = ySol(end,5);
        Vdlc(i) = ySol(end,2)+ySol(end,4)*R_d(i)
        y0 = [ySol(end,1); ySol(end,2); 0; 0; ySol(end,5)];
        % %%%%%%%%%%%%%%%%%%%%%%%%%%
        if Vdlc(i) <= 1.35
            Vdlc(i) = 1.35;
            break;
        end
    end
  