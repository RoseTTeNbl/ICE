function tst = chk(conv,chrom,g,cof,D,group)
%计算过程表达式与常迭代过程表达式的距离比值
r=size(chrom,1);

cons=[1,0,1];
tst=zeros(1,g);
for i=1:g
    [y,~]=obj(chrom(1,:),cof,i,1,D,group);
    tst(1,i)=abs(y(1,i)-conv);
end

end



