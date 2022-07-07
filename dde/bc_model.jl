function bc_model(du,u,h,p,t)
  tau = p;
  h1 = h(p, t-tau[1])[1];
  h2 = h(p, t-tau[2])[2];
  du[1] =   h1
  du[2] =   h1+h2
  du[3] =  u[2];
end