function f = fr(x,fq,sy)

fqr=size(fq,1);
f=zeros(fqr,1);
r=size(x,1);
c=size(x,2);

if sy==1
for i=1:r
    for j=1:c
        nt=x(i,j);
        if nt>1
            f(nt,1)=f(nt,1)+1;
        else
            f(1,1)=f(1,1)+1;
        end
    end
end
else
    for i=1:r
    for j=1:c
        nt=x(i,j);
        if nt<0
            nt=0-nt;
            f(nt,1)=f(nt,1)+1;
        end
    end
    end
end
