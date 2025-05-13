function y = stk(command, e)

persistent d;
switch (command)
    case {'init'}
        d=[10];
    case {'pop'}
        %出栈
        y = d(1);
        d = d(2:size(d, 2));
    case {'push'}
        %压栈
        d=[e,d];
    case {'size'}
        y=size(d,2)-1;
    case {'top'}
        y=d(1);
end


