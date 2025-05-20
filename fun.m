function [A,ob,res,cex,covg] = fun(x,cons,cof,A,cofb,D,group)

r=size(x,1);
c=size(x,2);
D1=15;
ob=ones(r,1);
g=20;
dt=1;%
covg=zeros(r,1);
res=zeros(r,g);
cex=zeros(r,D1);


d=zeros(r,1);
for i=1:r
    [res(i,:),d(i,1)]=obj(x(i,:),cof,g,dt,D,group);%res
end
for i=1:r
    if  d(i,1)==0 %太简单排除
        ob(i,:)=0;
    else
        [A,tmp,covg(i,1),cex(i,:)]=gpr(res(i,:),A,cofb,group);%%
        ob(i,:)=tmp;
    end
end


