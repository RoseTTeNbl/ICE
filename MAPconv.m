function [A1,v,ex] = MAPconv(conv,A,cofb,group)
%A = containers.Map('KeyType','double','ValueType','any');

A1=A;
if isKey(A,conv)==true
    v=fun1(A(conv),cofb,group);
    ex=A(conv); 
else
    [v,ex]=testc(conv,cofb,group);
    A1(conv)=ex;
end