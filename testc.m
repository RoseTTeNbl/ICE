function [bv,bex] = testc(conv,cofb,group)%%

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