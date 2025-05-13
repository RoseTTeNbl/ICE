% Start the algorithm here.
% The main thread contains calls on ICE(code in ICE.m) which include a full round of conjecture search. 
% Change the args:group to decide what kind of symbols to be included in the conjectures.
%

A = containers.Map('KeyType','double','ValueType','any');
%load('Ac.mat')
G=50; %keep same as in gep.m

T=1;%test round
Gd=4;
testnum=100;
Gt=20; %g in the gep.m
tv=[];
tchr=[];
tcons=[];
cons=[1,0,1];
era=0.5772156649;
cof=[1,2,3,4,5,6,7,8,9,exp(1),pi,era];
cofb=[1,2,3,4,5,6,7,8,9,exp(1),pi,era];
res=[];
epr=0;
suc=0;
synum=9;%1/4/4

h=9;%LHS head length
h1=7;%RHS head length
h0=5;%ADF head length
p=5;%Pre-selection size
u=2;%operator

l=h*(u-1)+1;
l1=h1*(u-1)+1;
l0=h0*(u-1)+1;
adf=h0+l0;
ADFnum=3;
D0=ADFnum*adf;
D=l+h;
D1=l1+h1;

% 设置算法名称数组，注意ICE_Abl2将使用SLGEP下的gep函数
algo_names = {'ICE'};
algo_count = length(algo_names);

% 设置组别数量
group_count = 6;

% 添加SLGEP路径，以便直接调用SLGEP下的函数
addpath('SLGEP');

% 确保newresult目录存在
if ~exist('newresult', 'dir')
    mkdir('newresult');
end

% 遍历所有算法和组别
for algo_idx = 1:algo_count
    algo_name = algo_names{algo_idx};
    
    for group = 1:group_count
        % 重置统计数据
        sucset = zeros(1,T);
        rate=zeros(T,G);
        prod=zeros(T,G);
        fit=zeros(T,G);
        timc=zeros(T,G);
        sumcf=0;
        suc=0;
        epr=0;
        cl=[];
        sm=[];
        
        fprintf('\n\n正在运行算法 %s，组别 %d\n', algo_name, group);
        
        % 运行T轮实验
        for t=1:T
            % 使用函数句柄调用相应的算法
            if strcmp(algo_name, 'SLGEP_gep')
                % 对于SLGEP的gep函数，参数不同
                % 确保SLGEP算法能够正确处理输入数据
                [A,P,CV,trace,prd,ctime]=gep(A,h1,cof,p,cofb,synum,G,group);
                
                % 截断P矩阵的大小，避免越界访问
                if ~isempty(P)
                    P_size = size(P, 2);
                    if P_size > D+D1
                        P = P(:, 1:D+D1);
                    end
                end
                
                % 将结果文件命名为ICE_Abl2，以保持一致性
                algo_name_save = 'ICE_Abl2';
            else
                algo_handle = str2func(algo_name);
                [A,P,CV,trace,prd,ctime]=algo_handle(A,h,h1,h0,cof,p,cofb,synum,G,group);
                algo_name_save = algo_name;
            end
            
            fit(t,:)=trace';
            prod(t,:)=prd';
            timc(t,:)=ctime';
            R=size(P,1);
            sucset(1,t) = R;

            if R~=0
                for i=1:R
                    if ~strcmp(algo_name, 'SLGEP_gep')
                        [fs,ds]=obj(P(i,1:D+D0),cof,60,1,D,group);
                        fconv=fs(1,60);%LHS convergence
                        
                        bv=1;
                        for k=1:testnum %%
                            [v,ex]=GEPC(fconv,cofb,group);
                            if v<bv
                                bv=v;
                                bex=ex;
                            end
                        end
    
                        if bv<abs(CV(i,1)-fconv)
                            CV(i,1)=fun1(bex,cofb,group);
                            A(fconv)=bex;
                            P(i,D+D0+1:D+D0+D1)=A(fconv);
                        end
                        
                        tst=chk(CV(i,1),P(i,1:D+D0),Gt,cof,D,group);
                        if ds<1
                            continue;
                        end
                    else
                        % 对于SLGEP的gep函数，使用SLGEP下重命名的obj_abl函数
                        % 需要调整相应逻辑
                        SLGEP_cons = [1,0,1]; % SLGEP的cons格式
                        [fs,ds]=obj_abl(P(i,1:D1),SLGEP_cons,cof,60,1,group);
                        fconv=fs(1,60);%LHS convergence
                        
                        bv=1;
                        for k=1:testnum %%
                            [v,ex]=GEPC(fconv,cofb,group);
                            if v<bv
                                bv=v;
                                bex=ex;
                            end
                        end
    
                        if bv<abs(CV(i,1)-fconv)
                            CV(i,1)=fun1(bex,cofb,group);
                            A(fconv)=bex;
                            P(i,D1+1:D1+D1)=A(fconv);
                        end
                        
                        % 使用SLGEP目录下重命名的chk函数
                        tst=chk_abl(CV(i,1),P(i,1:D1),Gt,cof,D1,group);
                    end

                 
                    cf=convin(tst);
                    sumcf=sumcf+cf;

                    sm=[sm,cf];

                    fprintf('\n\nProposed result: %.6f with delta %.6f',fconv,bv);

                    fprintf('\nLHS: ');
                    prt(P(i,1:D),1);

                    if ~strcmp(algo_name, 'SLGEP_gep')
                        for k=1:ADFnum
                            fprintf('\nADF-%d: ',k);
                            prt(P(i,D+(k-1)*adf+1:D+k*adf),2);
                        end
                    end

                    fprintf('\nRHS: ');
                    if ~strcmp(algo_name, 'SLGEP_gep')
                        prt(P(i,D+D0+1:D+D0+D1),3);
                        qw=fun1(P(i,D+D0+1:D+D0+D1),cofb,group);
                    else
                        prt(P(i,D+1:D+D1),3);
                        qw=fun1(P(i,D1+1:D1+D1),cofb,group);
                    end
                    
                    epr=epr+1;
                    fprintf('\nError level: %d\n', cf);
               end
            end
            fprintf('%d Round completed\n',t);
            if R>0
                suc=suc+1;
            end
        end

        for i=1:T
                for j=1:G
                    rate(i,j)=1-(1-fit(i,j))^(1/j);
                end
        end

        avr=sum(rate,1)/T;
        avrp=sum(prod,1)/T;
        avrt=sum(timc,1)/T;
        avrf=sum(fit,1)/T;

        for i=2:size(avrp,2)
            avrp(1,i)=avrp(1,i);%+avrp(1,i-1);
        end
        for i=2:size(avrt,2)
            avrt(1,i)=avrt(1,i)+avrt(1,i-1);
        end
            
        suc = suc/T;
        st = std(sm);

        if epr > 0
            sumcf = sumcf/epr;
        end

        if strcmp(algo_name, 'SLGEP_gep')
            fprintf('算法 ICE_Abl2, 组别 %d: 实验 %d, 成功率 %.2f, 平均错误水平 %.2f, 标准差 %.2f\n', ...
                group, epr, suc, sumcf, st);
            
            % 保存结果到newresult目录
            result_file = sprintf('newresult/result_ICE_Abl2_g%d.mat', group);
        else
            fprintf('算法 %s, 组别 %d: 实验 %d, 成功率 %.2f, 平均错误水平 %.2f, 标准差 %.2f\n', ...
                algo_name, group, epr, suc, sumcf, st);
                
            % 保存结果到newresult目录
            result_file = sprintf('newresult/result_%s_g%d.mat', algo_name, group);
        end
        
        save(result_file,'avr','avrp','epr','suc','sumcf','avrt','avrf','st','sucset','rate','prod','timc','fit');
    end
end

