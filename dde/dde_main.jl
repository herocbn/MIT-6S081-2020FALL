include("bc_model.jl")

lags = [1; 0.2];
p = (1, 0.2);
tspan = (0.0, 5.0)
u0 = [1.0, 1.0, 1.0];
h(p, t) = u0;
prob = DDEProblem(bc_model, u0, h, tspan, p; constant_lags = lags);
alg = MethodOfSteps(BS3());
sol = solve(prob, alg, saveat = 0.01, abstol = 0.05, reltol = 0.05);
#,saveat=0.01,abstol= 0.05,reltol = 0.05
plot(sol.t, sol.u);
xlabel("Time (t)");
ylabel("Solution y");
legend();