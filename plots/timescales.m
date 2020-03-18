% R - drop diameter in microns
R = 15:1:70;
r0=0.3.*R;
D=15; % diffusion in um^2/sec
beta=1; % disassembly rate 1/min divJ=alpha-beta*rho
k=0.5; % speed factor v=k*(r-r0)
L = R; % network diameter

tau_dis=1/beta.*L./L; % disassembly time in min
tau_D=L.^2/2/D/60;  % diffusion time in min
tau_flow=1/k*(log(L./r0-1));% - log(0.1));  % flow time in min
Fig1 = figure;
plot(R*2,tau_dis,'linewidth',1.5)
hold on
plot(R*2,tau_D,'linewidth',1.5)
plot(R*2,tau_flow,'linewidth',1.5)
xlabel('Drop Diameter', 'fontsize',14);
ylabel('time[min]', 'fontsize',14)
legend({'\tau_{disassemly}','\tau_D','\tau_{flow}'}, 'fontsize',14)
