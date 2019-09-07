function f = obj(x)
rho = 7860; % kg/m^3
L1 = 9.14;  % m
L2 = 9.14*sqrt(2);  % m
f = pi*(x(1))^2*L1*rho + pi*(x(2))^2*L2*rho;