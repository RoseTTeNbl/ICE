function [A,P,CV,trace,prd,timec] = T2(~,h,h1,h0,cof1,p1,cofb1,synum,G,group)
 A=containers.Map('KeyType','double','ValueType','any');
% cof1=[1,2,3,4,5,6,7,8,9,exp(1),pi];
% h1=7;
% p1=5;
% cofb1=cof1;
% synum=10;

cons=[1,0,1];%1-3,1const,2i,3R, 4+,5-,6*,7/
cofb=cof1;
%4~7 +-*/ 8sq,9log,10^2,11sin
P=[];
CV1=[];

NP=50;
h=h1;%头部符号位
u=2;%最大对象数
l=h*(u-1)+1;
D=l+h;
F=0.95;
p=p1;%筛选容量

l1=8;
h1=7;
D1=15;%
g=20;
dt=2;
mut=0.1;

cofnum=size(cofb,2);

x=zeros(NP,D+D1);    % 初始种群
v=zeros(NP,D+D1);    % 变异种群
fre=zeros(synum,1);
cfre=zeros(cofnum,1); 

%ADF:4-7+-*/,8SQrt,9sq2,10sq3.11exp
x=[randi([1,synum],NP,h),randi([1,3],NP,l),randi([1,synum],NP,h1),0-randi([1,cofnum],NP,l1)];
%adf
for i=1:NP
    for j=1:D
        if x(i,j)==1
            x(i,j)=0-randi([1,cofnum],1,1);
        end
    end
end

%   计算目标值和频率
[A,ob,~,~,~]=fun(x,cons,cofb,A,cofb1,D,group);  %fre8x1,obNPx1
trace=ones(G,1);
timec=zeros(G,1);
trace(1,1)=min(ob);
fre=fr(x,fre,1);
cfre=fr(x,cfre,2);
best=x(1,:);
trb=ones(G,D+D1);
trv=ones(G,1);
prd=zeros(G,1);

for gen=1:G
    tic;
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
        cpx=zeros(p,1);
        q=0;%nline=0-->line
        PRE=zeros(p,size(x,2));
        for k=1:p
            cut=randi([1,size(PRE,2)],1,1);
            PRE(k,:)=[x(m,1:cut),x(r1,cut+1:size(PRE,2))];
            continue;
            for j=1:size(PRE,2)
                if rand(1) < F%差分步长
                    if x(r1,j)==x(r2,j)
                    PRE(k,j)=x(r1,j);
                    else
                        if j<=D
                            if j<=h
                            PRE(k,j)=rtwhell(fre);
                            else
                            PRE(k,j)=rtwhell(fre(1:3,:));
                            end
                        else
                            if j<=D+h1
                                PRE(k,j)=rtwhell(fre);
                                if PRE(k,j)==1
                                    PRE(k,j)=0-rtwhell(cfre);
                                end
                            else
                                PRE(k,j)=0-rtwhell(cfre);
                            end
                        end
                    end
                else
                PRE(k,j)=x(r1,j);
                end
              
            end
            for i=1:p
                for j=1:D
                     if PRE(i,j)==1
                     PRE(i,j)=0-rtwhell(cfre);
                     end
                end
                
            end
        end
        %[~,bst]=max(cpx);
        tem=PRE(1,:);
        v(m,:)=tem;
       
    end
    % 自然选择
    % 计算新的适应度

    [A,obnew,res1,CX,~]=fun(v,cons,cofb,A,cofb1,D,group);
    v(1,:)=best;

    for m=1:NP
        if obnew(m)>=ob(m)
            x(m,:)=v(m,:);
        else
            x(m,:)=x(m,:);
        end
        
    end

    [A,ob,~,~,covg]=fun(x,cons,cofb,A,cofb1,D,group);
    fre=fr(x,fre,1);
    cfre=fr(x,cfre,2);

    [trace(gen,1),ind]=min(ob);%ind the best expr in the pop now
    
    best=x(ind,:);


    trb(gen,:)=best;
    ftem=fun1(trb(gen,D+1:D+D1),cofb1,group);
    trv(gen,1)=abs(covg(ind,:)-ftem);

    if abs(covg(ind,1)-ftem)<=1e4 && ob(ind,1)>0
        P=[P;trb(gen,:)];
        CV1=[CV1;trv(gen,1)];
        prd(gen,1)=prd(gen,1)+1;
    end

estime=toc;
timec(gen,1)=estime;
end

[P,ia,~]=unique(P,'rows');
unir=size(P,1);
CV=zeros(unir,1);
for i=1:unir
    CV(i,1)=CV1(ia(i,1),1);%CV be the convergence value vector
end
