function dydt = ddefun(t,y,Z) % equation being solved
  ylag1 = Z(:,1);
  ylag2 = Z(:,2);

  dydt = [ylag1(1); 
          ylag1(1)+ylag2(2); 
          y(2)];
end
