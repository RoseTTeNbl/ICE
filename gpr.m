function [A,f,conv,bex]= gpr(y,A,cofb,group)

F1=1e-5;
F2=1e3;
GN=size(y,2);

conv=y(1,GN);

if isnan(conv)
    conv=F1;
end

if conv<F1
    conv=F1;
end

if conv>=F2
    conv=F2;
end

[A,bv,bex]=MAPconv(conv,A,cofb,group);

del=bv;

if nline(y)==0 || conv==F1 || conv==F2
    f=0;
else
    f=1-(1-exp(0-2*del))/(1+exp(0-2*del));
    %sig
end


