% initialise variables
a = 0.1;                    % disease transmission probability
b = 3;                      % contact rate
beta = a*b;                 % infection rate
infectivePeriod = 8;        % how long infection lasts
gamma = 1/infectivePeriod;  % recovery rate
mu = 0.01;                  %rate of mortality

t0 = 0;         % start time
tf = 100;        % end time
h = 1;          % time step

N = 100000;     %population size
I = 300;        %infected population
R = 0;        %recovered population
S = N - I;    %susceptible population
D = 0;

%initial conditions for ODE
y0 = [S, I, R, D]; 

% Solving ODE
[t,y] = ode45(@(t,y) SIRDRHS(t,y,N,beta,gamma,mu), [t0 tf], y0);

%plotting solution
figure();
plot(t, y(:,1), '-g', 'LineWidth', 2)
hold on
plot(t, y(:,2), '-r', 'LineWidth', 2)
plot(t, y(:,3), '-b', 'LineWidth', 2)
plot(t, y(:,4), '-k', 'LineWidth', 2)
legend('S','I','R','D');
title('SIR Model', 'FontSize', 20);
xlabel('time', 'FontSize', 20),ylabel('people', 'FontSize', 20);
grid on;
ax = gca; ax.YAxis.FontSize = 15; ax.XAxis.FontSize = 15;
hold off