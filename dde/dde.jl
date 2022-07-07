
using DifferentialEquations
tau = [1; 0.2]
lags = tau

p = (1, 0.2);
h(p, t) = ones(2)
tspan = (0.0, 5.0)

u0 = [1.0, 1.0, 1.0]
function bc_model(du, u, h, p, t)
  tau = p
  hist1 = h(p, t - tau[1])[1]
  hist2 = h(p, t - tau[2])[2]
  du[1] = hist1
  du[2] = hist1 + hist2
  du[3] = u[2]
end
prob = DDEProblem(bc_model, u0, h, tspan, p; constant_lags = lags)


alg = MethodOfSteps(Tsit5());
sol = solve(prob, alg)

plot(sol)
