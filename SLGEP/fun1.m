function f = fun1(x,cof,group)

%2~5:+-*/ 6sq,7log,8^2,9^3
d=size(x,2);
r=size(x,1);
f=zeros(r,1);

for i=1:r
    chrom=x(i,:);
    f(i,1)=decode_recursive(1,chrom,d,cof,group);
end

end

function value = decode_recursive(index,c,d,cof,group)
    if index > d
        value = [];
        return;
    end
    
    if c(1, index) < 0
        value = cof(1, 0 - c(1, index));
    else
        switch c(1, index)
            case {4, 5, 6, 7} % 二元操作符
                y1 = decode_recursive(index + 1,c,d,cof,group);
                y2 = decode_recursive(index + 2,c,d,cof,group);
                
                switch c(1, index)
                    case 4
                        value = y1 + y2;
                    case 5
                        value = y1 - y2;
                    case 6
                        value = y1 * y2;
                    case 7
                        if y2 == 0
                            value = 0;
                        else
                            value = y1 / y2;
                        end
                end
                
            case {8, 9, 10, 11} % 一元操作符
                y = decode_recursive(index + 1,c,d,cof,group);
                switch c(1, index)
                    case 8
                        % 使用组别参数控制操作
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
                            value = log(abs(y));
                        end
                    case 9
                        % 所有组别都使用相同的操作
                        value = sqrt(abs(y));
                    case 10
                        % 所有组别都使用相同的操作
                        value = y^2;
                    case 11
                        % 所有组别都使用相同的操作
                        value = exp(y);
                end
            otherwise
                value = 1; % 对于其他未考虑的情况返回 1
        end
    end
end

