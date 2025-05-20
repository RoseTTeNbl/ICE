function re = decode_exp(chrom, cof, cons, G , g, sy, group)
    % return adf value with i as cons or main iteration value with adf values as cons 
    c = length(chrom); %
    i = G - g + 1; %  
    cof = [i,cof];

    function value = decode_recursive(index) %%ADF part
        if index > c
            value = [];
            return;
        end
        
        if chrom(1, index) < 0
            value = cof(1, 0 - chrom(1, index));
        else

        switch chrom(1, index)
            case {2, 3, 4, 5} % 
                y1 = decode_recursive(index + 1);
                y2 = decode_recursive(index + 2);
                
                switch chrom(1, index)
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
                y = decode_recursive(index + 1);
                switch chrom(1, index)
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
       
        end
        end
    end

    function value = decode_main(index)%% main part
        if index > c
            value = [];
            return;
        end
        
        if chrom(1, index) < 0
            value = cons(1, 0 - chrom(1, index));
        else

        switch chrom(1, index)
            case {2, 3, 4, 5} % 
                y1 = decode_main(index + 1);
                y2 = decode_main(index + 2);
                
                switch chrom(1, index)
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
                y = decode_main(index + 1);
                switch chrom(1, index)
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
        end
        end
    end

    if sy==1 %% main
        re = decode_main(1);
    else
        re = decode_recursive(1);
    end
end
