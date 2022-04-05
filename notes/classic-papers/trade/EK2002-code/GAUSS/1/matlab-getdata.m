%% Get data from EK files

%% 分节符
% Ctrl+Enter，只运行一节
clc
diary('getdata.out');
clc
clear all

%%
load DATA_EK

%%
% First index is importing country (column 1)
% Second is exporting country (column 2)

n = 19; % 19 countries，每年有 19*19=361行

% 全部数据跨度为1971-1990共20年，共361*7220行
% only use 1990 Data，则为第6860-7220行

n1 = 6860; % 起始行 index
nn = 7220; % 结束行 index

%% Trade shares from data on exports and domestic sales
% datafe 是一个19*43的矩阵
xnimat = datafe(:,25:43);           % 19列，19行，这是X_{ni}矩阵
xrate = datafe(:,2);                % 第2列是Exchange rates
xratemat = xrate*ones(1,n);         % ones(1,n)为1*19的单位矩阵，
% 这里是矩阵乘法，将汇率向量扩展为矩阵

xnimat = 1000000*xnimat; % 乘以单位
xnimat = xnimat./xratemat; % ./ 似乎是对应项相除的意思，结果是以进口国货币衡量的双边贸易额

%%
xn = sum(xnimat,2);                 % 按行求和，进口国的 total spending on manufactures
xnmat = xn*ones(1,n);               % 进口国支出扩展为矩阵
Pi_in = xnimat./xnmat;              % 对应项相除，π_{ni} 矩阵
% Note: on the diagonal of Pi we see domestic sales as a fraction of total spending, Xnn/Xn
% 对角线位置是 π_{nn}，相对比较大

%%
xnn = diag(xnimat);                   % a country's spending on domestic manufactures
% 取对角元素，组成一个19*1的向量

exps = sum(xnimat)' - xnn;            % Exports 
% sum()自动按列求和，得到1*19矩阵，每列都是出口国出口量+供应国内市场量的加总
% 转置为列向量，减去X_{nn}列向量，就是出口列向量

imps = sum(xnimat,2) - xnn;           % Imports
% 按行求和为支出列向量，减去对本国产品的支出，就是进口列向量

%% Geographic barriers matrix  
D = datafe(:,6:24); %19**19，地理障碍矩阵
D = exp(D);                 % Data is ln(dni^(-theta))

%% Labor and wages
l = datafe(:,3);            % 第3列为制造业劳动力
l = 2080*l;                 % Labor in hours
aw = datafe(:,4);           % 第4列为Absolute wage
aw = aw/2080;               % Adjust for hours

%% Adjust labor and wages for skills
% Human capital
trade2 = trade2(n1:nn,:);   % Data for 1990
hk = trade2(1:n,6);         % 人力资本列向量

% Adjust labor and wages for human capital
l = l.*(exp(0.06*hk));      % 对应项相乘
aw = aw.*(exp(-0.06*hk));

%% Income and shares parameters
y = 1000000*(datafe(:,1)./xrate);   % 第1列是GDP，统一为一种货币
yl = aw.*l;                         % Manufacturing labor income
yo = y - yl;                        % Nonmanufacturing income

% Check value of beta
betacheck = yl./(xnn+exps);         % 制造业劳动收入除以制造业总产值，这是beta

% Check alpha，制造业最终产品占GDP（所有最终产品）之比
myalpha = (yl + (imps - exps))./y; % 该式由gitbook版笔记脚注18推出=>beta(Xnn+出口)+进口-出口=alpha*Y
weight = y/sum(y);
myalpha = weight'*myalpha; % 各国的alpha加权平均，实为19国对制造业最终产品需求的总和除以19国所有最终产品需求之和

%% Competitiveness
S = datafe(:,5);                     % 第5列为Source-country competitiveness
S = S - S(n,1);                      % Relative to US


%% Clear unused data
clear datafe trade1 trade2 trade3 pppdat1 getdist
save DATA
diary('off');