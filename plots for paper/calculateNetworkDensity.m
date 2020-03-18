R = 50;
r0 = R/5;
alpha = 3;
beta = 1.5;
k = 0.6;
%%
syms rho(r)
ode = (r-r0)*diff(rho,r) + rho * (3 - 2*r0/r - beta/k) + alpha/k == 0;
cond = rho(R) == 0;
rhoSol(r) = dsolve(ode,cond);
figure;
fplot(rhoSol,[r0+0.1,R])

%%
syms J(r)
ode = diff(J,r) + 2*J/r - alpha - J * beta/(k*(r-r0)) == 0;
cond = J(R) == 0;
JSol(r) = dsolve(ode,cond);
figure;
fplot(JSol./(-k*(r-r0)),[r0+0.1,R])
