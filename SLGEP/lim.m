function l = lim(y)

n=size(y,2);
l=y(1,1);
for i=2:n
    l=l+exp(-i)*(y(1,i)-y(1,i-1));
end