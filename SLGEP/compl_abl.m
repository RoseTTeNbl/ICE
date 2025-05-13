function f = compl_abl(chrom)

col=size(chrom,2);
f=0;

isr=0;
isi=0;
ct=1;

stk=[];
    for k=col:-1:1
        if chrom(1,k)<=3 
            if chrom(1,k)==3
                stk=[2,stk];%模拟栈
            else
                stk=[1,stk];
            end
        else
            if chrom(1,k)>=8
                y=stk(1,1);
                w=chrom(1,k);
                switch(w)
                case {8}
                    y=2^y;
                case {9}
                    y=2^y;
                case {10}
                    y=y^2; 
                case {11}
                    y=2^y; 
                end
                stk=[y,stk(2:size(stk,2))];
            else
                y1=stk(1,1);
                y2=stk(1,2);
                y=0;
                w=chrom(1,k);
                switch(w)
                case {4}
                    y=y1+y2;
                case {5}
                    y=y1+y2;
                case {6}
                    y=y1*y2+1;
                case {7}
                    y=y1*y2+1;
                end
            stk=[y,stk(3:size(stk,2))];
            end
        end
    end
f=stk(1,1);

for i=1:col
    if ct==0
        break;
    end
    t=chrom(1,i);
    if t==2
        isi=1;
    end
    if t==3
        isr=1;
    end
    if t<=3
        ct=ct-1;
    else
        if t<8
            ct=ct+1;
        end
    end
end

if isr==0 || isi==0
    f=0;
end
