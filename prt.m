function prt(c,sy)

%c
d=size(c,2);

function expr = decode_adf(index,c)
        if index > d
            expr = '';
            return;
        else
            if c(1, index)<0
                if c(1, index)==-1
                expr = 'i';
                else
                    if c(1, index)>=-10
                        expr = num2str(0-c(1, index)-1);
                    end
                    if c(1, index)==-11
                        expr = 'e';
                    end
                    if c(1, index)==-12
                        expr = 'PI';
                    end
                    if c(1, index)==-13
                        expr = 'EA';
                    end
                end
            else
            switch c(1, index)
                case {2,3,4,5} % 
                    y1 = decode_adf(index + 1,c);
                    y2 = decode_adf(index + 2,c);
                    switch c(1, index)
                        case 2
                            expr = ['(' y1 ' + ' y2 ')'];
                        case 3
                            expr = ['(' y1 ' - ' y2 ')'];
                        case 4
                            expr = ['(' y1 ' * ' y2 ')'];
                        case 5
                            if str2double(y2) == 0
                                expr = '0';
                            else
                                expr = ['(' y1 ' / ' y2 ')'];
                            end
                    end
                case {6,7,8,9} % 一元操作符
                    y1 = decode_adf(index + 1,c);
                    switch c(1, index)
                        case 6
                            expr = ['sqrt(' y1 ')'];
                        case 7
                            expr = ['(' y1 '^3)'];
                        case 8
                            expr = ['(' y1 '^2)'];
                        case 9
                            expr = ['log(' y1 ')'];
                    end
            end
            end
        end
end

function expr = decode_main(index,c)
        if index > d
            expr = '';
            return;
        else
            if c(1, index)<0
                if c(1, index) == -1
                    expr='R';
                else
                    expr = ['A_{' num2str(0-c(1, index)-1) '}'];
                end
            else
            switch c(1, index)
                case {2,3,4,5} % 
                    y1 = decode_main(index + 1,c);
                    y2 = decode_main(index + 2,c);
                    switch c(1, index)
                        case 2
                            expr = ['(' y1 ' + ' y2 ')'];
                        case 3
                            expr = ['(' y1 ' - ' y2 ')'];
                        case 4
                            expr = ['(' y1 ' * ' y2 ')'];
                        case 5
                            if str2double(y2) == 0
                                expr = '0';
                            else
                                expr = ['(' y1 ' / ' y2 ')'];
                            end
                    end
                case {6,7,8,9} % 
                    y1 = decode_main(index + 1,c);
                    switch c(1, index)
                        case 6
                            expr = ['sqrt(' y1 ')'];
                        case 7
                            expr = ['(' y1 '^3)'];
                        case 8
                            expr = ['(' y1 '^2)'];
                        case 9
                            expr = ['log(' y1 ')'];
                    end
            end
            end
        end
end

function expr = decode_constant(index,c)
        if index > d
            expr = '';
            return;
        else
            if c(1, index)<0
                if c(1, index)>=-9
                expr = num2str(0-c(1, index));
                end
                if c(1, index)==-10
                expr = 'e';
                end
                if c(1, index)==-11
                expr = 'PI';
                end
                if c(1, index)==-12
                expr = 'EA';
                end
            else
            switch c(1, index)
                case {2, 3, 4, 5} % 
                    y1 = decode_constant(index + 1,c);
                    y2 = decode_constant(index + 2,c);
                    switch c(1, index)
                        case 2
                            expr = ['(' y1 ' + ' y2 ')'];
                        case 3
                            expr = ['(' y1 ' - ' y2 ')'];
                        case 4
                            expr = ['(' y1 ' * ' y2 ')'];
                        case 5
                            if str2double(y2) == 0
                                expr = '0';
                            else
                                expr = ['(' y1 ' / ' y2 ')'];
                            end
                    end
                case {6,7,8, 9, 10} % 
                    y1 = decode_constant(index + 1,c);
                    switch c(1, index)
                        case 6
                            expr = ['sqrt(' y1 ')'];
                        case 7
                            expr = ['log(' y1 ')'];
                        case 8
                            expr = ['(' y1 '^2)'];
                        case 9
                            expr = ['(' y1 '^3)'];
                        case 10
                            expr = ['exp(' y1 ')'];
                    end
            end
            end
        end
end



if sy==1
    expr=decode_main(1,c);
end

if sy==2
    expr=decode_adf(1,c);
end

if sy==3
    expr=decode_constant(1,c);
end

fprintf(expr);

end




