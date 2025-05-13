function prt(expr,sy)

if sy==1
for itr=1:size(expr,2)
        cht=expr(1,itr);
        if cht<0
            if cht>=-9
                fprintf(num2str(0-cht));
            end
            if cht==-10
                fprintf('e')
            end
            if cht==-11
                fprintf('pi')
            end
        else
            
            switch(cht)
            case {2}
                fprintf('i');
            case {3}
                fprintf('R');
            case {4}
                fprintf('+');
            case {5}
                fprintf('-');
            case {6}
                fprintf('*');
            case {7}
                fprintf('/');
            case {8}
                fprintf('#');
            case {9}
                fprintf('^3');
            case {10}
                fprintf('^2');
            case {11}
                fprintf('#@');
            end
        end
end
end

if sy==2
    for i=1:size(expr,2)
    cht=expr(1,i);
    if cht<0
            if cht>=-9
                fprintf(num2str(0-cht));
            end
            if cht==-10
                fprintf('e')
            end
            if cht==-11
                fprintf('pi')
            end

    else
        switch(cht)
            case {2}
                fprintf('+');
            case {3}
                fprintf('-');
            case {4}
                fprintf('*');
            case {5}
                fprintf('/');
            case {6}
                fprintf('sq');
            case {7}
                fprintf('log');
            case {8}
                fprintf('^2');
            case {9}
                fprintf('^3');
            case {10}
                fprintf('exp');
       end
    end

    end
end
