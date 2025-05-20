function [A,P,CV,trace,prd,timec] = ICE(~,h,h1,h0,cof1,p1,cofb1,synum,G,group)
A=containers.Map('KeyType','double','ValueType','any');

% cof1=[1,2,3,4,5,6,7,8,9,exp(1),pi]; adf constants without i
% h1=7;
% p1=5;
% cofb1=cof1; RHS constants

cons=[1,0,1];%1-3,1const,2i,3R, 4+,5-,6*,7/
cofb=cof1;
%4~7 +-*/ 8sq,9log,10^2,11sin
P=[];
CV1=[];

NP=50;
u=2;%
l=h*(u-1)+1;
l0=h0*(u-1)+1;
l1=h1*(u-1)+1;
D1=h1+l1;
D=l+h;

adf=h0+l0;
ADFnum=3;
D0=ADFnum*adf;

F=0.95;
F1=0.5;
p=p1;%筛选容量
g=20;
dt=2;
mut=0.1;

lim1=1e-5;
lim2=1e3;

cofnum=size(cofb,2)+1; %include i as 1, size will be 13

x=zeros(NP,D+D0);    % :main:D=h+l//ADF:Adfnum*D0
v=zeros(NP,D+D0);    % 
fre=zeros(synum,1);
afre=zeros(ADFnum+1,1);
cfre=zeros(cofnum,1); 

%
x=[randi([1,synum],NP,h),0-randi([1,ADFnum+1],NP,l),randi([1,synum],NP,h0),0-randi([1,cofnum],NP,l0),randi([1,synum],NP,h0),0-randi([1,cofnum],NP,l0),randi([1,synum],NP,h0),0-randi([1,cofnum],NP,l0)];
%adf
for i=1:NP
    for j=1:D+D0
        if x(i,j)==1
            x(i,j)=0-randi([1,ADFnum+1],1,1);
        end
    end
end

[A,ob,~,~,~]=fun(x,cons,cofb,A,cofb1,D,group);  %fre8x1,obNPx1
trace=ones(G,1);
timec=zeros(G,1);
trace(1,1)=min(ob);

fre=fr(x,fre,1);
afre=fr(x(:,1:D),afre,2);
cfre=fr(x(:,D+1:D+D0),cfre,2);

[~,ind]=max(ob);%ind the best expr in the pop now
best=x(ind,:);
trb=ones(G,D+D0+D1);
trv=ones(G,1);
prd=zeros(G,1);

for gen=1:G
    %x
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
        PRE=zeros(p,size(x,2));

        for k=1:p
            % cut=randi([1,size(PRE,2)],1,1);
            % PRE(k,:)=[x(m,1:cut),x(r1,cut+1:size(PRE,2))];
            % continue;  
            for j=1:size(PRE,2)
                if rand(1) < F%
                    if x(m,j)==x(ind,j)
                    PRE(k,j)=x(m,j);
                    else
                            if j<=h %1-h
                            PRE(k,j)=rtwhell(fre);
                            if PRE(k,j)==1
                                if rand(1)<F1
                                    PRE(k,j)=-1;
                                else
                                    PRE(k,j)=0-rtwhell(afre);
                                end
                            end
                            else %h-
                                if j<=D %h-D
                                    if rand(1)<F1
                                            PRE(k,j)=-1;
                                    else
                                            PRE(k,j)=0-rtwhell(afre);
                                    end
                                else
                                    if mod(j-D,adf)<=h0 %ADF/1-h
                                        PRE(k,j)=rtwhell(fre);
                                        if PRE(k,j)==1
                                            if rand(1)<F1
                                                PRE(k,j)=-1;
                                            else
                                            PRE(k,j)=0-rtwhell(cfre);
                                            end
                                        end
                                    else %ADF/h-D
                                        if rand(1)<F1
                                            PRE(k,j)=-1;
                                        else
                                            PRE(k,j)=0-rtwhell(cfre);
                                        end
                                    end
                                end
                            end
                    end
                else
                PRE(k,j)=x(m,j);
                end

                if rand(1) < F%
                    if x(r1,j)==x(r2,j)
                    PRE(k,j)=x(m,j);
                    else
                           if j<=h %1-h
                            PRE(k,j)=rtwhell(fre);
                            if PRE(k,j)==1
                                if rand(1)<F1
                                    PRE(k,j)=-1;
                                else
                                    PRE(k,j)=0-rtwhell(afre);
                                end
                            end
                            else %h-
                                if j<=D %h-D
                                    if rand(1)<F1
                                            PRE(k,j)=-1;
                                    else
                                            PRE(k,j)=0-rtwhell(afre);
                                    end
                                else
                                    if mod(j-D,adf)<=h0 %ADF/1-h
                                        PRE(k,j)=rtwhell(fre);
                                        if PRE(k,j)==1
                                            if rand(1)<F1
                                                PRE(k,j)=-1;
                                            else
                                            PRE(k,j)=0-rtwhell(cfre);
                                            end
                                        end
                                    else %ADF/h-D
                                        if rand(1)<F1
                                            PRE(k,j)=-1;
                                        else
                                            PRE(k,j)=0-rtwhell(cfre);
                                        end
                                    end
                                end
                            end
                    end
                else
                PRE(k,j)=x(m,j);
                end

                if rand(1) < mut %%
                        if j<=h %1-h
                            PRE(k,j)=rtwhell(fre);
                            if PRE(k,j)==1
                                if rand(1)<F1
                                    PRE(k,j)=-1;
                                else
                                    PRE(k,j)=0-rtwhell(afre);
                                end
                            end
                        else %h-
                                if j<=D %h-D
                                    if rand(1)<F1
                                            PRE(k,j)=-1;
                                    else
                                            PRE(k,j)=0-rtwhell(afre);
                                    end
                                else
                                    if mod(j-D,adf)<=h0 %ADF/1-h
                                        PRE(k,j)=rtwhell(fre);
                                        if PRE(k,j)==1
                                            if rand(1)<F1
                                                PRE(k,j)=-1;
                                            else
                                            PRE(k,j)=0-rtwhell(cfre);
                                            end
                                        end
                                    else %ADF/h-D
                                        if rand(1)<F1
                                            PRE(k,j)=-1;
                                        else
                                            PRE(k,j)=0-rtwhell(cfre);
                                        end
                                    end
                                end
                        end
                end
            end
            
            [~,cpx(k,1)]=obj(PRE(k,:),cofb,g,dt,D,group);%%
        end
        [~,bst]=max(cpx);
        tem=PRE(bst,:);
        v(m,:)=tem;
       
    end

    [A,obnew,~,~,~]=fun(v,cons,cofb,A,cofb1,D,group);
    v(1,:)=best;

    for m=1:NP
        if obnew(m)>=ob(m)
            x(m,:)=v(m,:);
        else
            x(m,:)=x(m,:);
        end
        
    end

    [A,ob,res,CX,covg]=fun(x,cons,cofb,A,cofb1,D,group);
    fre=fr(x,fre,1);
    cfre=fr(x,cfre,2);

    %ob
    [trace(gen,1),ind]=max(ob);%ind the best expr in the pop now
    
    best=x(ind,:);

    bs=res(ind,:);

    cxp=CX(ind,:);

trb(gen,1:D+D0)=best;
[A,trv(gen,1),trb(gen,D+D0+1:D+D0+D1)]=MAPconv(covg(ind,1),A,cofb1,group);
ftem=fun1(trb(gen,D+D0+1:D+D0+D1),cofb1,group);

%fprintf('\nGeneration %d\n',gen);

% for i=1:NP
%     prt(x(i,1:D),1);
% end

%fprintf('\nBest ind: %.6f to %.6f with Fitness %.4f',covg(ind,1),ftem,ob(ind,1));

% fprintf('\nLHS: ');
% prt(trb(gen,1:D),1);

% for k=1:ADFnum
% fprintf('\nADF-%d: ',k);
% prt(trb(gen,D+(k-1)*adf+1:D+k*adf),2);
% end


% fprintf('\nRHS: ');
% prt(trb(gen,D+D0+1:D+D0+D1),3);


    if abs(covg(ind,1)-ftem)<=1e-4 && compl(trb(gen,:),D)>0
        P=[P;trb(gen,:)];
        [P,~,~]=unique(P,'rows');
        CV1=[CV1;trv(gen,1)];
        prd(gen,1)=size(P,1);
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
