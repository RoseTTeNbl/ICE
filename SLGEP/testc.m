function [v,ex] = testc(conv,cofb,group)

    G=30;
    NP=30;
    h=7;%头部符号位
    u=2;%最大对象数
    l=h*(u-1)+1;
    D=l+h;
    
    x1=GEPC(conv,cofb,group);
    
    v=abs(fun1(x1,cofb,group)-conv);
    ex=x1;