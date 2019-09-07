function [stress,Q] = ten_bar_truss(x)
%   The variables that need to be entered are
%   E(Young's modulus), F(forces), node(node coordinates) and ele(end points of each element).

% problem defination
E = 200*10^9;    % Pa
F = zeros(8,1);
F(4,1) = -10^7;   % N (downward)
F(8,1) = -10^7;   % N (downward)
r1 =  x(1);
r2 =  x(2);

% test
% r1 = 0.1;
% r2 = 0.05;

% element table
node = [18.28, 9.14; 18.28, 0; 9.14, 9.14; 9.14, 0; 0, 9.14; 0, 0];
A1 = pi*r1^2;
A2 = pi*r2^2;
A = [A1*ones(6,1); A2*ones(4,1)];
ele = [1, 3, 5; 2, 1, 3; 3, 4, 6; 4, 2, 4; 5, 3, 4; 6, 1, 2; 7, 4, 5; 8, 3, 6; 9, 2, 3; 10, 1, 4];

L = zeros(10,1);    % length (m)
c = zeros(10,1);    % cos theta
s = zeros(10,1);    % sin theta
for i=1:10
    L(i) = sqrt((node(ele(i,3),1)-node(ele(i,2),1))^2+(node(ele(i,3),2)-node(ele(i,2),2))^2);
    c(i) = (node(ele(i,3),1)-node(ele(i,2),1))/L(i);
    s(i) = (node(ele(i,3),2)-node(ele(i,2),2))/L(i);
end

ET = [ele, E*ones(10,1), A, L, c, s];

% stiffness matrix
k = zeros(12);
for j=1:10  % stiffness matrix of each element
    matrix = [c(j)^2, c(j)*s(j), -c(j)^2, -c(j)*s(j);
        c(j)*s(j), s(j)^2, -c(j)*s(j), -s(j)^2;
        -c(j)^2, -c(j)*s(j), c(j)^2, c(j)*s(j);
        -c(j)*s(j), -s(j)^2, c(j)*s(j), s(j)^2];
    row = 1;
    column = 1;
    for p=2:3   % overall stiffness matrix
        for q=2:3
            k(ET(j,p)*2-1,ET(j,q)*2-1) = k(ET(j,p)*2-1,ET(j,q)*2-1)+E*A(j,1)/L(j,1)*matrix(row,column);
            k(ET(j,p)*2,ET(j,q)*2-1) = k(ET(j,p)*2,ET(j,q)*2-1)+E*A(j,1)/L(j,1)*matrix(row+1,column);
            column = column+1;
            k(ET(j,p)*2-1,ET(j,q)*2) = k(ET(j,p)*2-1,ET(j,q)*2)+E*A(j,1)/L(j,1)*matrix(row,column);
            k(ET(j,p)*2,ET(j,q)*2) = k(ET(j,p)*2,ET(j,q)*2)+E*A(j,1)/L(j,1)*matrix(row+1,column);
            if column == 4
                column = 1;
            else
                column = column+1;
            end
        end
        row = row+2;
    end
end

% displacement
k_reaction = k;
k(:,9:12) = [];
k(9:12,:) = [];
Q = k\F;
Q = [Q; 0; 0; 0; 0];

% stress
stress = zeros(10,1);
for i=1:10
    stress(i,1) = E/L(i)*[-c(i), -s(i), c(i), s(i)]...
    *[Q(ele(i,2)*2-1,1); Q(ele(i,2)*2,1); Q(ele(i,3)*2-1,1); Q(ele(i,3)*2,1)];
end

% reaction force
k_reaction(1:8,:) = [];
R = k_reaction*Q;
