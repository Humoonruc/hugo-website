/* maxdistx.prg */

/* Program to look at maximum price ratios as a proxy for trade frictions. */
/* Based on SIMPARM.PRG  这个是什么文件？？ */
/* Sam Kortum 7/20/98 */

/* This program generates:

	normalized import shares, (Xni/Xn)/(Xii/Xi), defined on p.12
	Dni, defined on p.14
	table II
    figure II

	method of moments estimate of theta(8.28), p.15
	OLS estimates of theta (with & without constant), footnote 27, p.15
	unrestricted pure price regressions, footnote 27, p.16
    

    Section 5.3
	OLS estimate of theta, with source & destination dummies, p.25
	2SLS estimate of theta with geography instruments, p. 25
	 */


new; /* remove all variables from your GAUSS workspace. */
cls; /* clear program output from the GAUSS Program Input/Output Window. */

output file = "./maxdistx.out" reset;

s = 0;              /* ??? */

ncnty = 19;         /* we consider 19 countries */
nyear = 1;


/******************************************************/
/*读取国别特征数据*/
/* 这是一个7220行*17列的各国特征数据，跨度为1971-1990，共20年 */
loadm tradeAll = "./data/trade1.fmt";

/* 查看 .fmt 数据文件的方法 */
/*
load trade1 = .\data\trade1.fmt;
output file = .\trade1.txt reset;
print trade1;
output off;
*/

n1 = 6860; nn = 7220;   @ 1990年数据，共19*19=361行 @
trade1 = tradeAll[n1:nn,.];   @只用1990年的数据切片@

impcnty = trade1[.,1];      @ 进口国/目的地国 id @
expcnty = trade1[.,2];      @ 出口国/来源国 id @
/*第三列均为90，代表什么未知*/
depvar = trade1[.,4];       @ln(Xni/Xnn)@
depvarn = trade1[.,5];      @ln(X'ni/X'nn) gitbook 5.2式@
dist1 = trade1[.,6];        @ 以下为6档距离的虚拟变量, dist1~dist6 @
dist2 = trade1[.,7];
dist3 = trade1[.,8];
dist4 = trade1[.,9];
dist5 = trade1[.,10];
dist6 = trade1[.,11];
border = trade1[.,12];     @ common border 虚拟变量 @
lrrnd = trade1[.,13];      @ 相对 R&D 存量 ln(R&D_i/R&D_n) @
lrhk = trade1[.,14];       @ 相对人力资本，平均受教育年限 ln(H_i/H_n) @
/*第15列代表什么未知*/
lrwork = trade1[.,16];     @ 相对制造业劳动力 ln(L_i/L_n)@
lrwage = trade1[.,17];     @ 相对工资 ln(w_i/w_n)@

mybeta = .21221; 

diff = -(depvarn-depvar)*mybeta/(1-mybeta); @ln((Xi/Xii)/(Xn/Xnn))@
depvarp = depvar + diff;    @ln(Xni/Xn)-ln(Xii/Xi)@


/******************************************************/
/* create common language variable: talk  */

/*        AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   */
english = {1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1}; @说英语的国家@
/* 19*1 matrix, 空格分隔同一行的元素，逗号分隔不同行*/
french =  {0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; @说法语的国家@
german =  {0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; @说德语的国家@

talk = vec(english*english' + french*french' + german*german'); @把19*19的矩阵列向量化@
talk = ones(20,1).*.talk; 
/* ones(m,n) creates an 'm' by 'n' matrix with all elements set to 1. */

/* 
.*. 表示 Kronecker product 克罗内克积: 如果 A 是一个 m × n 的矩阵
B 是一个 p × q 的矩阵, 则克罗内克积是一个 mp × nq 的 分块矩阵
 */

/* 此处相当于将长度为361的列向量talk重复20遍，扩展至 1971-1990 20年*/

talk = talk[n1:nn,.]; /* 1990年，是否有 common language, 361行 */


/******************************************************/
/* create country trade blocks */

/* European Community - European Union */
/*        AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   */
eu71 =    {0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0}; @71年的EU成员国@
eu73 =    {0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0}; @73年丹麦、英国加入@
eu81 =    {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; @81年希腊加入@
eu86 =    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0}; @86年葡萄牙、西班牙加入@
eu7172 = ones(2,1).*.vec(eu71*eu71'); /*71-72年*/
eu7380 = ones(8,1).*.vec((eu71+eu73)*(eu71+eu73)'); /*73-90年*/
eu8185 = ones(5,1).*.vec((eu71+eu73+eu81)*(eu71+eu73+eu81)'); /*81-85年*/
eu8690 = ones(5,1).*.vec((eu71+eu73+eu81+eu86)*(eu71+eu73+eu81+eu86)'); /*86-90年*/
eu = eu7172|eu7380|eu8185|eu8690; /*标记共处于EU的向量*/
/* | 表示 row bind（纵向合并）*/

/* EFTA */
/*        AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   */
ef71 =    {0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0};
ef73 =    {0, 0, 0, 0,-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,-1, 0}; @73年丹麦、英国退出@
ef86 =    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,-1,-1, 0, 0, 0}; @86年葡萄牙、西班牙退出@
ef7172 = ones(2,1).*.vec(ef71*ef71');
ef7385 = ones(13,1).*.vec((ef71+ef73)*(ef71+ef73)');
ef8690 = ones(5,1).*.vec((ef71+ef73+ef86)*(ef71+ef73+ef86)');
ef = ef7172|ef7385|ef8690;

tblock = eu~ef; /* ~ 表示 column bind（横向合并）*/

tblock = tblock[n1:nn,.]; /* 1990年，是否共处于一个贸易协定 */


/******************************************************/
/* create the source and destination DV 来源/目的地虚拟变量 */

onecnty = ones(ncnty,1); @19*1矩阵@
desdum = ones(nyear,1).*.(eye(ncnty).*.onecnty); @目的地（进口国）虚拟变量@
/* eye(k) 为 k 阶单位矩阵 I_k, desdum 为每行纵向重复19遍 */
/* print eye(3).*.ones(3,1); @ 可以观察 destination DV m1~m19 的形状@*/

srcdum = ones(nyear,1).*.(onecnty.*.eye(ncnty)); @来源地（出口国）虚拟变量@
/*srcdum 为整体纵向重复19遍 */
/* print ones(3,1).*.eye(3); @ 可以观察 source DV S1~S19 的形状@*/


reldum = srcdum-desdum; @来源国虚拟变量 S_i-S_n, 这个减法很精髓@

desdumr = desdum[.,1:(ncnty-1)]-desdum[.,ncnty]; @前18列减19列，变为相对值@
reldumr = reldum[.,1:(ncnty-1)]-reldum[.,ncnty]; @前18列减19列，变为相对值@


/******************************************************/
/* 几种回归的方法，定义几个函数？ */

/* proc to calculate country pair time averages */
proc order2(datf);
   local avar,i,var,varmat,adatf;
     adatf = ones((ncnty*(ncnty-1)),cols(datf)); /* adatf 是 342*cols(datf)矩阵，用1填充*/
     i = 1;
     do while i <= cols(datf);
        var = datf[.,i]; @第i列@
        varmat = reshape(var,nyear,(ncnty*(ncnty-1))); @@
        adatf[.,i] = meanc(varmat); @datf第i列的平均数@
        i = i+1;
     endo;
   retp(adatf); @adatf应该是datf各列的平均，压缩为一行@
endp;


/* Procedure to do gls */
proc(3)=gls(y,x,icov,dof);
    local betahat,eps,sighat2,varcov,stdb;
    betahat = inv(x'*icov*x)*x'*icov*y;
    eps = y - x*betahat;
    print "Raw SS in this regression " eps'*eps;
    print "Adjusted SS " eps'*icov*eps;
    varcov = inv(x'*icov*x);
    /* Next, we get the variance for the usa in GLS */
    print "source effect: usa=";
    -ones(1,18)*betahat[11:28];
    print "source effect: stdb(usa)=";
    sqrt(ones(1,18)*varcov[11:28,11:28]*ones(1,18)');
    print "destination effect: usa=";
    -ones(1,18)*betahat[29:46];
    print "destination effect: stdb(usa)=";
    sqrt(ones(1,18)*varcov[29:46,29:46]*ones(1,18)');
    stdb = sqrt(diag(varcov));
    retp(betahat,stdb,eps);
endp;


/* Procedure to construct the correlation between dresid and usa */
proc correl(resid,b,axmatf);
   local allresid,imp2,exp2,datloc,residmat,sresid,dresid,beta,
            temp1,temp2,temp3,usa;
   @ average the residuals across sources and destinations @
    allresid = zeros((ncnty^2),1);
    imp2 = seqa(1,1,ncnty).*.ones(ncnty,1);
    exp2 = ones(ncnty,1).*.seqa(1,1,ncnty);
    datloc = indexcat((imp2.==exp2),0);
    allresid[datloc] = resid;
    residmat = reshape(allresid,ncnty,ncnty);
    sresid = sumc(residmat)/(ncnty-1);
    dresid = sumc(residmat')/(ncnty-1);
   @ calculate lnmuhat-thetahat*lnwage @
    beta = b[(cols(axmatf)-2):cols(axmatf),1];
    temp1 = delif(lrrnd~lrhk~lrwage,(impcnty.eq expcnty));
    temp2 = order2(temp1);
    temp3 = temp2*beta;
    usa = zeros(ncnty,1);
    usa[1:ncnty-1,.] = temp3[ncnty*(ncnty-1)-ncnty+2:ncnty*(ncnty-1),1];
   @ calculate the correlation between dresid and usa @
    print "correlation between dresid and usa";
    corrx(dresid~usa);
    print "dresid~usa";
  retp(dresid~usa);
endp;


/* proc to do TSLS given */
@ returns coefficients in column 1 and std. errors in column 2 @
@ remember that x must include the constant term if you want it @
@ You supply appropriate degrees of freedom @

 proc(3)= tsls(y,x,xhat,dof);
    local betahat,eps,sighat2,varcov,stdb;
    betahat = inv(xhat'*xhat)*xhat'*y;
    eps = y - x*betahat;
    sighat2 = eps'*eps/dof;
    print "SS in this regression" sighat2*dof;
    varcov = sighat2*inv(xhat'*xhat);
    stdb = sqrt(diag(varcov));
    retp(betahat,stdb,eps);
 endp;


/******************************************************/
/* 3.2节最简单的估计方法 */

load pdat[900,1] = "./data/pppdat1.prn"; @其他18国50个行业的对数标准化价格数据@
pdat = pdat|zeros(50,1);   @ 加上美国（基准国）的对数标准化价格数据（50个0）在最后50行 @
pdat = reshape(pdat,19,50);  @ 重整为19*50维度的矩阵，countries in rows, goods in columns @
/* 假如去掉 17 列 office and computing，就不用再选第二大的值了*/
/* pdat = pdat[.,1:16]~pdat[.,18:cols(pdat)]; */

/* 第二大的r_{ni}(j) */
dpdat = pdat.*.ones(ncnty,1); /* 目的地国50种商品对数标准化价格 ln p_n(j) */
spdat = ones(ncnty,1).*.pdat; /* 来源地国50种商品对数标准化价格 ln p_i(j) */
rpdat = dpdat - spdat; 

/* 这是3.2.3节的 r_{ni}(j)矩阵(361*50)，每种商品的进口国价格 ln p_n(j) 减出口国价格 ln p_i(j) */
ldni1 = maxc(rpdat'); @ 转置后按列遍历商品种类，以最大的r_{ni}(j)作为d_{ni}的代理变量 @
max1 = maxindc(rpdat'); @ 最大值所在的行（即商品种类） index，返回列向量，所以这是一个361*1的矩阵 @

/*The following loops calculate the second, third, etc. highest
values of r_ni.  We use the second highest value, as described on page 14.*/

i = 1;
 do while i <= rows(rpdat);  @遍历361行@
    bigcol = max1[i];  @ 最大值的商品种类 index @
    rpdat[i,bigcol] = -100; @把该行最大值改为负数@
   i = i+1;
 endo;

ldni2 = maxc(rpdat'); @这就是每行第二大的r_{ni}(j)@

/*
max2 = maxindc(rpdat'); @第二大值得商品种类index@

i = 1;
 do while i <= rows(rpdat);
    bigcol = max2[i];
    rpdat[i,bigcol] = -100;
   i = i+1;
 endo;

ldni3 = maxc(rpdat');
max3 = maxindc(rpdat');

i = 1;
 do while i <= rows(rpdat);
    bigcol = max3[i];
    rpdat[i,bigcol] = -100;
   i = i+1;
 endo;

ldni4 = maxc(rpdat');
max4 = maxindc(rpdat');
*/

/* 对数价格指数 */
mpdat = meanc(pdat'); @转置后对列求平均，50种商品对数标准化价格的平均值作为各国对数价格指数的代理变量@
/* meanc() 表示按列计算平均值，结果再返回列向量*/

slpavg = ones(ncnty,1).*.mpdat; /* 来源地国价格指数 ln p_i */
dlpavg = mpdat.*.ones(ncnty,1); /* 目的地国价格指数 ln p_n */


/* Get distances between countries in thousands of miles */
/* 这个变量用来绘制 3.2.1 节的 Figure 1 */
load milevec[361,2] = "./data/getdist.dat";
milevec = milevec[.,2]; @此为地理距离向量/10^3 mile@
/* correct mistakes */
milevec[18] = 10.769;
milevec[324] = 10.769;



@ ************************************************************* @


dist = dist2~dist3~dist4~dist5~dist6~border; @合并自变量各列@
dist = dist~talk~tblock;


ldni = ldni2;   @ 第二大 r_{ni}(j)作为 ln d_{ni} 的代理变量@
xmat = slpavg - dlpavg + ldni; @D_{ni}=ln(p_i)-ln(p_n)+ln(d_{ni})@

/*
@ want to save matrix for a spreadsheet @
@ destinations are rows, sources are columns @

temp = reshape(xmat,19,19);

temp[.,1:4];
" ";
temp[.,5:8];
" ";
temp[.,9:12];
" ";
temp[.,13:16];
" ";
temp[.,17:19];
" ";
*/

/*
eupair = vec((eu71+eu73+eu81+eu86)*(eu71+eu73+eu81+eu86)'); @该变量只出现了一次，不知何用@
*/

@ remove home countries 删掉 n==i 的行，保留342行@

depvarpf = delif(depvarp,(impcnty .eq expcnty)); /*ln (Xni/Xn)/(Xii/Xi) 保留342行*/
depvarnf = delif(depvarn,(impcnty .eq expcnty)); /* ln(X'ni/X'nn) 保留342行*/

xmatf = delif(xmat,(impcnty .eq expcnty)); /* D_{ni} 保留342行 */

milef = delif(milevec,(impcnty .eq expcnty)); /* d_k 保留342行 */
lmilef = ln(milef); /* ln d_k 保留342行 */


"******************************************************************************";
"最简单的矩估计 theta：";
" ";
" mean(ln (Xbi/Xn)/(Xii/Xi)) ";
meanc(depvarpf);
" ";
" mean(D_ni) ";
meanc(xmatf);
" ";
" 矩估计theta（直接除）";
meanc(depvarpf)/meanc(xmatf);  @ method of moments theta, as described on p.15 @

" ";
" correlation ";
corrx(depvarpf~xmatf);
" ";
" ";
"******************************************************************************";
"Table II";
" ";

@ make index vectors @
dest = delif(impcnty, impcnty .eq expcnty); @第一列进口国，去掉n=i@
srce = delif(expcnty, impcnty .eq expcnty); @第二列出口国，去掉n=i@

@ convert Dni to exp(Dni) as in table II @
expxmatf=exp(xmatf); @exp(D_{ni})，用于表2@
x=expxmatf~srce~dest;

z=ones(19,8); @19*8 全1矩阵@

@从进口目的国的角度，看最近和最远的出口来源国@
i=1;
do while i <= 19;
	y=selif(x,x[.,3] .eq i); @提取部分行,后面是条件，第三列值（进口国index）等于i@
	w=y[.,1];
	z[i,1]=y[minindc(w),2]; @z第1列填充该进口国i对应的exp(D_{ni})最小的（即最邻近的）出口国index@
	z[i,2]=minc(w);         @z第2列填充该进口国i对应的最小的exp(D_{ni})@
	z[i,3]=y[maxindc(w),2]; @z第3列填充该进口国i对应的exp(D_{ni})最大的（即最遥远的）出口国index@
	z[i,4]=maxc(w);         @z第4列填充该进口国i对应的最大的exp(D_{ni})@
    i=i+1;
endo;

@从出口来源国的角度，看最近和最远的进口目的国@
i=1;
do while i <= 19;
	y=selif(x,x[.,2] .eq i);
	w=y[.,1];
	z[i,5]=y[minindc(w),3];
	z[i,6]=minc(w);
	z[i,7]=y[maxindc(w),3];
	z[i,8]=maxc(w);
	i=i+1;
endo; 

format 4,3;


@每行的index是国家index（默认不显示）@
$" "~"srce"~" "~" "~" "~"dest"~" "~" ";
$" "~"min"~" "~"max"~" "~"min"~" "~"max";
z;
" ";
" ";
"******************************************************************************";
" linear regression through the scatter in figure 2, no constant ";
"   (see footnote 27)";
" ";
" dependent variable is normalized import share: ln(Xni/Xn) - ln(Xii/Xi) ";
" independent variable is price measure: Dni ";
" ";
" ";
@" pure price regression (no constant) ";@
" ";
__con=0; /* 无截距项的线性回归 */ 
call ols(0,depvarpf,xmatf); 
" ";
" ";
" ";
"************************************************************************";
" linear regression through the scatter in figure 2, with constant ";
"   (see footnote 27) ";
" ";
" dependent variable is normalized import share: ln(Xni/Xn) - ln(Xii/Xi) ";
" independent variable is price measure: Dni ";
" ";
@" pure price regression (with constant) ";@
" ";
__con=1; /* 有截距项的线性回归 */
call ols(0,depvarpf,xmatf);
" ";
" ";
" *****************************************************************************";
"探讨 ln pi, ln pn, ln dni 对标准化贸易份额的分别贡献";
xmat2 = slpavg~dlpavg~ldni;  @ replaced xmat @

@ remove home countries @

xmat2f = delif(xmat2,(impcnty .eq expcnty));  @ replaced xmatf @
" ";
" ";
" OLS regression of trade shares on log of exporter price (pi), log of importer price (pn), ";
" and log of geographic barriers (dni), no constant  (see footnote 26, p.16)";
" ";
__con=0;
call ols(0,depvarpf,xmat2f);
" ";
" ";
"*******************************";
" OLS regression of trade shares on log of exporter price (pi), log of importer price (pn), ";
" and log of geographic barriers (dni), with constant  (see footnote 26, p.16)";
" ";
__con=1;
call ols(0,depvarpf,xmat2f);
" ";
" ";
"************************************************************************";
" Instrument for the price variable (using actual distance)";
" ";
_olsres=1;
__output=0; /*可以不显示回归结果*/

/*第一阶段，342行的Dni先对342行的lnd_k（千英里）做回归，myres是残差？*/
{x1,x2,x3,x4,x5,x6,x7,x8,x9,myres,x11} = ols(0,xmatf,lmilef); 

/* 
 * x3 是常数项和一次项系数的估计量
 * x4 似乎是x与y的相关系数  
 *
 * x6 似乎是两个系数的标准误 
 * x7 是Residual standard error，即MSE（残差平方和除以(n-p)）的平方根，该值越小说明模型拟合越好）
 * x8 是x与y的协方差矩阵
 * x9 是R^2
 * myres 是残差
 * x11 是 Durbin-Watson 估计量
*/


myfit = xmatf-myres; @模型预测值，即平均意义上，用距离估计的Dni@
" ";
" myres ";
" ";
" second stage ";

__output=0;

call ols(0,depvarpf,myfit); @第二阶段，对数标准化贸易份额再对 Dni^hat 回归@


@ do the standard errors right @


x = ones(rows(myfit),1)~xmatf; /* Dni前面加了一列1*/
xhat = ones(rows(myfit),1)~myfit; /* Dni_hat 前面加了一列1*/
dof = rows(x) - 1; /* 自由度,341 */

{betahat,stdb,eps} = tsls(depvarpf,x,xhat,dof); @tsls回归，因变量是对数标准化贸易份额@

(betahat~stdb);
"";
"";
"include source and destination dummies";


dvars = desdumr~reldumr;
dvars = delif(dvars,(impcnty .eq expcnty));
dvars = lmilef~dvars;

_olsres=1;
__output=0;

{x1,x2,x3,x4,x5,x6,x7,x8,x9,myres,x11} = ols(0,xmatf,dvars); @Dni先对lnd_k和一堆虚拟变量做回归@
myfit = xmatf-myres;
" ";
@ myres @

" ";
@ second stage @

__output=0;

call ols(0,depvarpf,myfit); /*第二阶段，对数标准化贸易份额再对 Dni^hat 回归*/


" ";
@ do the standard errors right @

x = ones(rows(myfit),1)~xmatf;
xhat = ones(rows(myfit),1)~myfit;
dof = rows(x) - 1;
{betahat,stdb,eps} = tsls(depvarpf,x,xhat,dof);
(betahat~stdb);

__output=1;

" ";
" ";
" ";
" ";
"*******************************************************************";
" include source and destination dummies ";
" dependent variable is now depvarnf ";
" ";
" 2SLS regression of the price measure on normalized trade shares "; 
"   with observed geography terms as instruments for price measure, Dni ";
"   (see section 5.3, page 24) ";
" ";

dumvars = desdumr~reldumr;
dumvars = delif(dumvars,(impcnty .eq expcnty));


dvars = dist~desdumr~reldumr;
dvars = delif(dvars,(impcnty .eq expcnty)); 



_olsres=1;
{x1,x2,x3,x4,x5,x6,x7,x8,x9,myres,x11} = ols(0,xmatf,dvars); @第一阶段ols，因变量为Dni，自变量为 30 式的那一堆@

myfit = xmatf-myres;
" ";
" myres ";
" "
" second stage ";
"    ";
myfit = myfit~dumvars;

call ols(0,depvarnf,myfit); @第二阶段ols，自变量为Dni_hat与虚拟变量的组合，即这些虚拟变量被视为外生变量了@

" ";
" do the standard errors right ";
x = ones(rows(myfit),1)~xmatf~dumvars;
xhat = ones(rows(myfit),1)~myfit;
dof = rows(x) - 1;
{betahat,stdb,eps} = tsls(depvarnf,x,xhat,dof);
(betahat~stdb); /* 所有系数及其标准误*/
" ";
" ";
" -----------------------------------------------------------------";
" 2SLS estimate of theta: " betahat[2] "          standard error: " stdb[2];
" ";
"这就是5.3中对 theta 的估计值12.86(1.64)";
" ";
" ";
"*****************************************************************************";
"  Do OLS but include source and destination dummies ";
" ";

dvars = xmatf~dumvars;

call ols(0,depvarnf,dvars);

"这就是5.3中对 theta 的估计值2.44(0.49)";

end;