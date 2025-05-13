function res = rtwhell(fre)%

S=sum(fre/20);
fre=fre+S;
fre=fre/sum(fre);
    fp=cumsum(fre);
    res=find(fp>=rand,1);


