function [f,ds] = obj(chr,cof,GEN,d,D,group)

d0=11;
adf=3;
chrom=chr(1,1:D);
f=zeros(1,GEN);

ds=compl(chr,D);
cons=zeros(1,adf+1); %[R,ADFk]

INFL=1e3;
INFS=1e-5;
%4~7 +-*/ 8sq(++),9log(^3),10^2,11sin(+++)

for i=1:GEN
    G=i*d;

    for g=1:G%一次以G为深度的迭代

    for k=1:adf
        sub=chr(1,D+(k-1)*d0+1:D+k*d0);
        cons(1,k+1)=decode_exp(sub,cof,cons,G,g,2,group);
    end
    re = decode_exp(chrom, cof, cons, G , g, 1, group);

    cons(1,1)=re;%for next iteration
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
    


