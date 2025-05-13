function [bv,bex] = testc(conv,cofb,group)%%距离的最小值与对应常表达式

MAXN=100;
bv=1;

[bv,bex]=GEPC(conv,cofb,group);
for i=1:MAXN
    [v,ex]=GEPC(conv,cofb,group);
    if v<bv
        bv=v;
        bex=ex;
    end
end