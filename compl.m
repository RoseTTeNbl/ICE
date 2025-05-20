function f = compl(chrom,D)

d0=11;
adf=3;
chr=chrom(1,1:D);

isr=0;
isi=0;
isvalid=zeros(1,adf);
com=zeros(1,adf);

function [] = decode_main(index,c)%% main part
        if index > size(c,2)
            return
        end
        
        if chrom(1, index) < 0
            if chrom(1, index) == -1
                isr=1;
                else
                if isi==0
                    isi=isvalid(1,0-1-chrom(1, index));
                end
            end
        else

        switch chrom(1, index)
            case {2, 3, 4, 5} % +-
                decode_main(index + 1,c);
                decode_main(index + 2,c);
            case {6,7,8,9} % 
                decode_main(index + 1,c);
        end
        end
end


function [] = decode_adf(index,c,k)%% main part
        if index > size(c,2)
            return;
        end
        
        if chrom(1, index) < 0
            if chrom(1, index) == -1
                isvalid(1,k)=1;
            end
        else

        switch chrom(1, index)
            case {2, 3, 4, 5} % +-
                decode_main(index + 1,c);
                decode_main(index + 2,c);
                
            case {6,7,8,9} % 
                decode_main(index + 1,c);
        end
        end
end

for k=1:adf
    sub=chrom(1,D+(k-1)*d0+1:D+k*d0);
    decode_adf(1,sub,k);
end

if isr==0
    f=0;
else
    if isi==0
        f=0.5;
    else
        f=1;
    end
end

end