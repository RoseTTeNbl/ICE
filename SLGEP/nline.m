function f = nline(res)

g=size(res,2);

f=0;

for j=3:g
    f=f+(abs(res(1,j)-res(1,j-1))-abs(res(1,j-1)-res(1,j-2)));%斜率差
end