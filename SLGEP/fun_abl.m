function [A,ob,res,cex,covg] = fun_abl(x,cons,cof,A,cofb,D,group)

r=size(x,1);
c=size(x,2);
D1=15;
ob=ones(r,1);
g=20;
dmin=3;%最小复杂度
dt=1;%迭代间距
covg=zeros(r,1);
res=zeros(r,g);
cex=zeros(r,D1);

xr=fun1(x(:,D+1:c),cofb,group);

d=zeros(r,1);
for i=1:r
    [res(i,:),d(i,1)]=obj_abl(x(i,:),cons,cof,g,dt,group);%res为迭代结果
end
for i=1:r
    if d(i,1)<=dmin %太简单排除
        ob(i,:)=1;
    else
        [A,tmp,covg(i,1),cex(i,:)]=gpr(res(i,:),A,cofb,group);%%过程返回值
        c=0;
        for j=1:r
            cs=0;
            for k=g/2:g
                if res(i,k)~=res(j,k)
                    cs=1;
                    break;
                end
            end
            if cs==0
                c=c+1;
            end
        end
        if c>1%%乘法值
        ob(i,:)=tmp^(c);
        end
    end
end
cex=x(:,D+1:c);


