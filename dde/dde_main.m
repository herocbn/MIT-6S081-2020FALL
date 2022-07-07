lags = [1 0.2];
tspan = [0 5];
sol = dde23(@ddefun, lags, @history, tspan);
plot(sol.x,sol.y,'-o')
%%plot(sol.y);
xlabel('Time t');
ylabel('Solution y');
legend('y_1','y_2','y_3','Location','NorthWest');