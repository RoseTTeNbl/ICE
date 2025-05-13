function tst = chk_abl(conv,chrom,g,cof,D,group)
%计算过程表达式与常迭代过程表达式的距离比值
r=size(chrom,1);

cons=[1,0,1];
tst=zeros(1,g);
for i=1:g
    y=zeros(1,g);
    for k=1:i
        [y,~]=obj_abl(chrom(1,1:D),cons,cof,i,1,group);
    end
    tst(1,i)=abs(y(1,i)-conv);
end

end



