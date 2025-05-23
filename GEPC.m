function [d,con] = GEPC(conv, cofb, group)

G=30;
NP=30;
h=7;%
u=2;%
l=h*(u-1)+1;
D=l+h;
F=0.95;

synum=9;%1+4+4
cofnum=size(cofb,2);%

x1=zeros(NP,D);    % 
v1=zeros(NP,D);    % 
obs=ones(NP,1);
fre=zeros(synum,1);
cfre=zeros(cofnum,1);


x1=[randi([1,synum],NP,h),0-randi([1,cofnum],NP,l)];

for i=1:NP
    for j=1:D
        if x1(i,j)==1
            x1(i,j)=0-randi([1,cofnum],1,1);
        end
    end
end
%   
fre=fr(x1,fre,1);
cfre=fr(x1,cfre,2);
obs=abs(fun1(x1,cofb,group)-conv);

for gen=1:G
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
                        if v1(m,j)==1
                            v1(m,j)=0-rtwhell(cfre);
                        end
                        else
                        v1(m,j)=0-rtwhell(cfre);
                        end
                    end
                else
                v1(m,j)=x1(r1,j);
                end
        end
    end
       

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
