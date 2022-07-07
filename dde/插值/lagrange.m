%%function fi=lagrange(x,y,xi)

fi=zeros(size(xi));
npl=length(y);
for i=1:npl
z=ones(size(xi));
for j=1:npl
if i~=j,z=z.*(xi-x(j))/(x(i)-x(j));
end
end
fi=fi+z*y(i);
end