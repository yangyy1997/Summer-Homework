clc
clear

% optimization
x0 = [0.1;0.1];
ub = [0.5;0.5];
lb = [0.001;0.001];
options = optimset('display','off');
[x, fval, exitflag] = fmincon('obj', x0, [], [], [], [], lb, ub, 'nonlcon', options)