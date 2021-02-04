function dydt = SIRDRHS(t, y, N, beta, gamma, mu)
% Projectile ODE right-hand side function
% Inputs: t = time value in approximation
%         y = vector of x, y, u and v for input to ODE system
%         beta = infection rate
%         gamma = recovery rate
%
% Outputs:  dydt = column vector of output derivatives

dydt1 = (-beta*y(1)*y(2))/N;                %RoC of susceptible
dydt2 = ((beta*y(1)*y(2))/N) - (gamma*y(2))- (mu*y(2)); %RoC of infected
dydt3 = gamma*y(2);                         %RoC of recovered
dydt4 = mu*y(2);

dydt = [dydt1;dydt2;dydt3;dydt4];

end

