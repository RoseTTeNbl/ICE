function f = fun1(x,cof,group)

%2~5:+-*/ 6sq,7log,8^2,9^3
r=size(x,1);
f=ones(r,1);
d=size(x,2);

function value = decode_recursive(index,c)
        if index > d
            value = [];
            return;
        end
        
        if c(1, index) < 0
            value = cof(1, 0 - c(1, index));
        else

        switch c(1, index)
            case {2,3,4,5} % 二元操作符
                y1 = decode_recursive(index + 1,c);
                y2 = decode_recursive(index + 2,c);
                
                switch c(1, index)
                    case 2
                        value = y1 + y2;
                    case 3
                        value = y1 - y2;
                    case 4
                        value = y1 * y2;
                    case 5
                        if y2 == 0
                            value = 0;
                        else
                            value = y1 / y2;
                        end
                end
                
            case {6,7,8,9} % 
                y = decode_recursive(index + 1,c);
                switch c(1, index)
                    case 6
                        if group == 2
                            value = exp(y);
                        elseif group == 3
                            value = y^2;
                        elseif group == 4
                            value = y^2;
                        elseif group == 5
                            value = sqrt(abs(y));
                        elseif group == 6
                            value = y^2;
                        else
                            value = y^2;
                        end
                    case 7
                        if group == 2
                            value = exp(y);
                        elseif group == 3
                            value = y^3;
                        elseif group == 4
                            value = y^3;
                        elseif group == 5
                            value = sqrt(abs(y));
                        elseif group == 6
                            value = sqrt(abs(y));
                        else
                            value = y^3;
                        end
                    case 8
                        if group == 2
                            value = log(abs(y));
                        elseif group == 3
                            value = sin(y);
                        elseif group == 4
                            value = sin(y);
                        elseif group == 5
                            value = log(abs(y));
                        elseif group == 6
                            value = exp(y);
                        else
                            value = sqrt(abs(y));
                        end
                    case 9
                        value = log(abs(y));
                end
                
            otherwise
                value = 1; % 
        end
        end
end

for i=1:r
    chrom=x(i,:);
    f(i,1)=decode_recursive(1,chrom);
end

end

