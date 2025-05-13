function f = convin(y)

f=8;
c=size(y,2);
for i=1:c
    if y(1,i)==0
        f=i-1;
        break;
    end
end