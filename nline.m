function f = nline(res)

g=size(res,2);

value=res(1,1);
f=0;

for j=1:g
    if res(1,j) ~= value
        f=1;
    end
end