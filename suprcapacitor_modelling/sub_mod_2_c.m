  
    % i = i-1;
    dwell = 0;
    % Instruction (d)
    while (dwell ~=15)
        dwell = dwell + 1;
        i = i+1;
        Idlc(i) = 0
        Vdlc (i) = Vdlc(i-1)
    end
    d = i;
% end

figure('Color','w');
yyaxis right
plot(Idlc(2:169),'--r','LineWidth',3,'LineColor',[0.5,0.5,0.5]);
ylabel('Current (A)','FontWeight','bold');
hold on;
yyaxis left;
plot(Vdlc(2:169),'-b','LineWidth',3);
ylabel('Voltage (V)','FontWeight','bold');
title('Electric and thermal modeling of a capacitor','FontWeight', 'bold');
xlabel('Time [s]','FontWeight','bold');
legend('Current','Voltage')
axis tight
grid on
pbaspect([2 1 1])
hold off
