function [f,ds] = obj_abl(chr,co,cof,GEN,d,group)


cons=co;%cons=shangyidai
chrom=chr;
f=zeros(1,GEN);
c=size(chr,2);
ds=compl_abl(chrom(1:c));


INFL=1e3;%大于INF即可认为
INFS=1e-5;
%4~7 +-*/ 8sq(++),9log(^3),10^2,11sin(+++)

for i=1:GEN
    G=i*d;
    cons=co;
for g=1:G%一次以G为深度的迭代
    stk=[];
    for k=c:-1:1
        cons(1,2)=G-g+1;%g as parameter, from Gen to 1,cons2=i   
        
        if chrom(1,k)==3
            stk=[cons(1,3),stk];%模拟栈
        end 
        if chrom(1,k)<0
            stk=[cof(1,0-chrom(1,k)),stk];
        end
        if chrom(1,k)==2
                stk=[cons(1,2),stk];%模拟栈
        else
            if chrom(1,k)>=8 
                y=(stk(1,1));
                if chrom(1,k)==8
                    % 使用组别参数控制操作
                    if group == 2
                        y=log(abs(y));
                    elseif group == 3
                        y=sin(y);
                    elseif group == 4
                        y=sin(y);
                    elseif group == 5
                        y=log(abs(y));
                    elseif group == 6
                        y=exp(y);
                    else
                        y=log(abs(y));
                    end
                end
                if chrom(1,k)==9
                    y=sqrt(abs(y));
                    
                end
                if chrom(1,k)==10
                    y=y^2;
                end
                if chrom(1,k)==11
                    %if y>0
                       y=exp(y); 
                    %end
                end
                stk=[y,stk(2:size(stk,2))];
            end
            if chrom(1,k)>=4 && chrom(1,k)<8
                y1=stk(1,1);
                y2=stk(1,2);
                y=0;
                w=chrom(1,k);
                switch(w)
                case {4}
                    y=y1+y2;
                case {5}
                    y=y1-y2;
                case {6}
                    y=y1*y2;
                case {7}
                    if y2==0
                        y=0;
                    else
                    y=y1/y2;
                    end
                end
            stk=[y,stk(3:size(stk,2))];
            end
        end
    end
    re=stk(1,1);%
    cons(1,3)=re;%for next iteration
    if g==G
        f(1,i)=re;
    end
end
    if f(1,i)>INFL
        for j=i:GEN
            f(1,j)=INFL;
        end
        break;
    end
    if f(1,i)<INFS
        for j=i:GEN
            f(1,j)=INFS;
        end
        break;
    end
end
    


