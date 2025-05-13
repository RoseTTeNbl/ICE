A = containers.Map('KeyType','double','ValueType','any');
%load('Ac.mat')
G=50;

T=10;
Gd=4;
Gt=25;
tv=[];
tchr=[];
tcons=[];
cons=[1,0,1];
era=0.5772156649;
cof=[1,2,3,4,5,6,7,8,9,exp(1),pi,era];
cofb=[1,2,3,4,5,6,7,8,9,exp(1),pi,era];
res=[];
epr=0;
suc=0;
rate=zeros(T,G);
fit=zeros(T,G);
prod=zeros(T,G);
timc=zeros(T,G);
sumcf=0;
synum=11;%3+4+3
%4~7 +-*/ 8sq,9log,10^2,11sin
h=[5,7,9];
h1=7;
p=5;

sm=[];
for s=1:1  
for t=1:T
    [A,P,CV,trace,prd,ctime]=gep(A,7,cof,p,cofb,synum);
    D=15;
    D1=2*h1+1;
    fit(t,:)=trace';
    prod(t,:)=prd';
    timc(t,:)=ctime';
    R=size(P,1);
    
    if R~=0
        suc=suc+1;
        for i=1:R
            [fs,~]=obj(P(i,1:D),cons,cof,60,1);

            fconv=fs(1,60);%LHS convergence
            
            CV(i,1)
            tst=chk(CV(i,1),P(i,1:D),Gt,cof,cons);
            cf=convin(tst);
            sm=[sm,cf];
            sumcf=sumcf+cf;

            prt(P(i,1:D),1);
            fprintf('\n');
            ql=CV(i,1);
            fprintf('\n');
            prt(P(i,D+1:D+D1),2);
            qw=fun1(P(i,D+1:D+D1),cofb);
                epr=epr+1;
            fprintf('\n');
       end
    end
    fprintf('%d generations completed\n',t);
    save('Ac.mat', 'A');
end
    for i=1:T
        for j=1:G
            rate(i,j)=1-(fit(i,j))^(1/j);
        end
    end
    avr=sum(rate,1)/T;
    avrp=sum(prod,1)/T;
    avrt=sum(timc,1)/T;
    avrf=sum(fit,1)/T;
    for i=2:size(avrp,2)
        avrp(1,i)=avrp(1,i)+avrp(1,i-1);
    end
    for i=2:size(avrt,2)
        avrt(1,i)=avrt(1,i)+avrt(1,i-1);
    end
    sumcf=sumcf/epr;

fprintf('Experement, Success,Rate,Avg cf');
st = std(sm);
save(strcat('result2_5.mat'),'avr','avrp','epr','suc','sumcf','avrf','avrt','st');  
end

