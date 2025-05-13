% cof=[1,2,3,exp(1),pi, sqrt(2),5, sqrt(3), 8];
% N=80;
% f=3;
% for s=1:N-1
%     i=N-s;
%    f=log(abs(exp(1)-(i+1)*f))^2;
% end
% bv=1;
% conv=f;
% for k=1:1000
%     [v,ex]=GEPC(conv);
%     if v<bv
%         bv=v;
%         bex=ex;
%     end
% end
% bv
% prt(bex,2);
% x=fun1(bex,cof)
% conv
% 
G=25;
data=zeros(4,G);
for i=1:G
    data(1,i)=i;
end
load('5-7-5-result.mat');
data(2,:)=avrp;
load('7-7-5-result.mat');
data(4,:)=avrp;
load('9-7-5-result.mat');
data(3,:)=avrp;

data=data';

fontSize=28; 
lineWidthBox=1.5; 
lineWidth=0.5; 
figure
hold on  
box on 
for i=2:4
    plot(data(:,1),data(:,i),'-*')
end  
axis([1.4,0.8])
legend('Group1','Group2','Group3');
legend('boxoff');


