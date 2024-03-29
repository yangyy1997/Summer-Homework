function [g, geq] = nonlcon(x)

[stress, Q] = ten_bar_truss(x);

ys = 250*10^6; % Pa
Q_limit = 0.02;  %m

% The stress of each element needs to be less than yielding stress.
% The displacement of node 2 needs to be less than 0.02.
g_stress = abs(stress) - ys;
g_disp = sqrt(Q(3)^2 + Q(4)^2) - Q_limit;

g = [g_stress; g_disp];
geq = [];
