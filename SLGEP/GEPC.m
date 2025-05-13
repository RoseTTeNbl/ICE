function [d,con] = GEPC(conv, cofb, group)

G=30;
NP=30;
h=7;%头部符号位
u=2;%最大对象数
l=h*(u-1)+1;
D=l+h;
F=0.95;

synum=11;%
cofnum=size(cofb,2);%

x1=zeros(NP,D);    % 初始种群
v1=zeros(NP,D);    % 变异种群
obs=ones(NP,1);
fre=zeros(synum,1);
cfre=zeros(cofnum,1);


x1=[randi([2,synum],NP,h),0-randi([1,cofnum],NP,l)];
%x1
%   计算目标值和频率
fre=fr(x1,fre,1);
cfre=fr(x1,cfre,2);
obs=abs(fun1(x1,cofb,group)-conv);

for gen=1:G
    %   变异操作\
    for m=1:NP
        r1=randi([1,NP],1,1);
        while(r1==m)
            r1=randi([1,NP],1,1);
        end
        r2=randi([1,NP],1,1);
        while(r2==r1)||(r2==m)
            r2=randi([1,NP],1,1);
        end
        for j=1:D
                if rand(1) < F%差分步长
                    if x1(r1,j)==x1(r2,j)
                    v1(m,j)=x1(r1,j);
                    else
                        if j<=h
                        v1(m,j)=rtwhell(fre);
                        else
                        v1(m,j)=0-rtwhell(cfre);
                        end
                    end
                else
                v1(m,j)=x1(r1,j);
                end
        end
    end
       
    % 自然选择
    % 计算新的适应度

    obs1=abs(fun1(v1,cofb,group)-conv);
    
    for m=1:NP
        if obs1(m)<obs(m)
            x1(m,:)=v1(m,:);
        else
            x1(m,:)=x1(m,:);
        end
        
    end

    obs=abs(fun1(x1,cofb,group)-conv);
    fre=fr(x1,fre,1);
    cfre=fr(x1,cfre,2);

end

[~,indx]=min(obs);
con=x1(indx,:);
d=obs(indx);
