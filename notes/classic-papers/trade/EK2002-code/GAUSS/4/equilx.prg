@                          EQUILX.PRG                               @
@                                                                   @
@              Solve for the Equilibrium of the                     @
@                                                                   @
@                       EATON-KORTUM model of                       @
@                     technology and bilateral trade                @
@                                                                   @
@                      KORTUM AND EATON 8/16/97                     @
@                                                                   @
@     This program computes equilibrium as described in section     @
@     4.  This equilibrium is used as the baseline from which       @
@     the counterfactuals described in section 6.1 and 6.3 are      @
@     computed using SIMUL.PRG, and from which the counterfactuals  @
@     described in section 6.4 are computed using SIMULTAR.PRG      @
@                                                                   @


NEW;
OUTPUT FILE = .\equilx.out RESET;
cls;

/* LIBRARY OPTMUM;
#include optmum.ext;
OPTSET; */

ncnty = 19;
nyear = 20;

@ sensitivity of wage response to excess demand @
mypsi = .1;
labtol = .00005;

@ wage elasticity @

 mytheta = 8.28; 
"theta =" mytheta;
"-------------------";

mybeta = .21221;
varian = (mybeta^(-mybeta))*((1-mybeta)^(-(1-mybeta)));


@ Load the real data from Ken @

loadm realdat = .\datafe;

yvec = realdat[.,1]; /* GDP in million */
xrate = realdat[.,2]; /* 汇率 */
lvec = realdat[.,3]; /* 制造业劳动力 */
awvec = realdat[.,4]; /* 绝对工资 */

lvec = 2080*lvec;                 @ measure labor in approx hours 以年工作小时计算的劳动@
awvec = awvec/2080;               @ absolute wage (not relative) 单位劳动的工资@

lmuvec = realdat[.,5]; /* S1-S19 */
"S1-S19"
lmuvec;

distmat = realdat[.,6:24];        @ distance measure, ln(dni^(-theta)), as defined in section 2, page 5 @
"      ";
"      ";
"distance measure";
distmat; /* -theta*ln(dni)矩阵，行index是n，列index是i */

/* 25~43列，19*19矩阵*/
xnimat = realdat[.,25:43]; /* Xni，贸易额绝对值, 行index是n，列index是i */
/* 第n行贸易额都是用n国货币计量的*/


xrmat = xrate*ones(1,ncnty); /* 扩展为19*19 */
xnimat = xnimat./xrmat; /* 都换算为 million 美元*/
xnimat = 1000000*xnimat;
xnn = diag(xnimat);
"Xnn";
xnn;
"";
imprt = sumc(xnimat') - xnn; /* 进口额 */
exprt = sumc(xnimat) - xnn; /* 出口额 */

t1 = imprt./xnn;
t2 = exprt./xnn;


@ adjust wage and labor for skills @
loadm trade2=.\trade2;
fobs = (ncnty^2)*(nyear-1)+1;
lobs = ncnty^2*nyear;
trade2 = trade2[fobs:lobs,.]; /* 1990 年数据*/
hk = trade2[1:ncnty,6]; /* 人均受教育年限 */ 
awvec = awvec.*(exp(-.06*hk)); /* 有效工资 actual wage*/
lvec = lvec.*(exp(.06*hk)); /* 有效劳动 */

/*
" ";
" awvec, lvec ";
(awvec/awvec[19])~(lvec/lvec[19]);
" ";
" industry % share in GDP ";

(100*awvec.*lvec./(1000000*yvec./xrate));
*/

impsh = imprt./xnn; /* 进口份额 */ 
expsh = exprt./xnn; /* 出口份额 */
totprod = xnn + exprt; /* 制造业总产出 */

@ print out some data @;

distmat = exp(distmat); 
distmat; /* distmat 变了，现在是 d_{ni}^(-theta) */
distmat = diagrv(distmat,ones(ncnty,1)); /* 似乎毫无变化 */
distmat;

lwvec = ln(awvec);
lwvec = lwvec - lwvec[ncnty]; /* 对数有效工资，相对美国*/

lmuvec = lmuvec - lmuvec[ncnty]; /*Sn-S19*/
lmuvec = mybeta*(lmuvec + mytheta*lwvec); /*27式，这是ln(T_n/T_19)*/
muvec = exp(lmuvec); /* T_n/T_19， TABLE VI theta=8.28 的那一列 */
"T_n/T_19";
muvec;
rwvec = exp(lwvec);  /* 有效工资之比 */
scalew = awvec[ncnty]; /* 美国的有效工资 */

awb = awvec.*lvec; /* 19国制造业工资收入，向量*/

"check beta";
awb./(xnn + exprt); /* 各国分别计算 beta，向量 */

yvec = 1000000*yvec./xrate;
impy = imprt./yvec; /* 贸易依赖度 */
expy = exprt./yvec;

wageshar = awb./yvec; /* industry wage share in GDP*/

@ use wage share and trade to obtain alphas @
alphavec = wageshar + (imprt - exprt)./yvec; 
/* 各国的 alpha，等于对制造业最终产品的支出除以总支出。
而对制造业最终产品的支出，无论中间经过多少中间产品层级，最终都会转化为制造业的工资收入
只不过，对外国制造业产品的支出，最终会转化为外国制造业工人的工资收入
所以本国制造业工人的收入加上净进口的制造业产品产值，
才等于对制造业最终产品的总支出*/

yweight = yvec/sumc(yvec);
myalpha = sumc(yweight.*alphavec); /* 用各国GDP作为权重，计算一个加权的 alpha */
"alpha";
myalpha;

transmat = distmat^(-1/mytheta)-ones(ncnty,ncnty); /* d_{ni}-1 */

"transport costs";
"from countries 1-4";
transmat[.,1:4];

"from countries 5-8";
transmat[.,5:8];

"from countries 9-12";
transmat[.,9:12];

"from countries 13-16";
transmat[.,13:16];

"from countries 17-19";
transmat[.,17:19];


"log distances";
ldistmat  = ln(distmat); /* ln(dni^(-theta)) */
"from countries 1-4";
ldistmat[.,1:4];

"from countries 5-8";
ldistmat[.,5:8];

"from countries 9-12";
ldistmat[.,9:12];

"from countries 13-16";
ldistmat[.,13:16];

"from countries 17-19";
ldistmat[.,17:19];




proc getgam(aw);
    local muwvec, muwmat, gammat;
    muwvec = muvec.*(aw^(-mybeta*mytheta)); /* T w^(\beta*theta)*/
    muwmat = ones(ncnty,1)*muwvec';
    gammat = (varian^(mytheta))*(distmat.*muwmat); /* g * D %*% Tw^(-beta*theta) */
    retp(gammat);
endp;

@ gammat is a global that gets updated @

gammat = getgam(awvec);  /*  D %*% gTw^(-beta*theta)  */

proc(2) = phtbound(gammat);
    local gammax, phitlow, phithigh;
    gammax = maxc(sumc(gammat'));  /* 行和的最大值 */
    phitlow = (diag(gammat))^(1/mybeta);
    phithigh = gammax^(1/mybeta)*ones(ncnty,1);
    retp(phitlow,phithigh);
endp;

@ phitmin and phitmax are globals that get updated @

{phitmin,phitmax} = phtbound(gammat); /* p初始迭代的最大值和最小值 */





@ Newton-Raphson to solve system, usrfun(x) = 0: Numerical Recipes, pg. 269 @

proc mnewt(&usrfun,x);
  local n,ntrial,tolf,tolx,k,good,dalpha,fbeta,errf,dx,errx, xupper, xlower;
  local usrfun:proc;

   ntrial = 100;  @ maximum number of iterations @
   tolf = .0000001;  @ tolerance for satisfying the system @
   tolx = .0000001;  @ tolerance for change in x @
   
   xupper = phitmax;
   xlower = phitmin;
   @ x must be between phitmin and phitmax @
   
   k = 1;
   good = 0;
   do while ((k <= ntrial) and (good==0));
      @" x " x;@
      {dalpha, fbeta} = usrfun(x);  @ deriv matrix and -func vector @
      errf=sumc(abs(fbeta));
      if errf < tolf;
        good = 1;
      endif;
      dx = inv(dalpha)*fbeta;
      @" dx " dx;@
      errx=sumc(abs(dx));
      if errx < tolx;
         good = 1;
      endif;
      x = x + dx;
      x = maxc((x~xlower)');
      x = minc((x~xupper)');
      k = k+1;
   endo;
  @" number of iterations " k; @
  if good==0;
     " mnewt did not converge ";
     " **************";
     " x " x;
     " ****************";
  endif;
 retp(x);
endp;


@ non linear system to evaluate a func given phitilde (== x) @
proc(2) = phifunc(x);
  local xbeta1,xbeta2,gaminv,func,dfunc;
  xbeta1 = x^(1-mybeta); 
  xbeta2 = x^(-mybeta);
  gaminv = inv(gammat); /*gammat是 D %*% gTw^(-beta*theta) */
  func = xbeta1 - gaminv*x;   @ negative of the function @
  dfunc = gaminv - (1-mybeta)*diagrv(eye(ncnty),xbeta2); /*Jacobi*/
 @ derivative of the function @ 
  retp(dfunc,func); /*返回F(x)及其Jacobi导数矩阵*/
endp;


@ solve for phitilde @
proc findphit(aw);
   local myphitil,phitil0;
   gammat = getgam(aw);
   {phitmin,phitmax} = phtbound(gammat);
   phitil0 = .5*(phitmin+phitmax);
   myphitil = mnewt(&phifunc,phitil0);
   retp(myphitil);
endp;


@ create phi @
proc findphi(aw,phit);
   local phi;
   phi = (varian^(mytheta))*
         (muvec.*(aw^(-mybeta*mytheta)).*(phit^(1-mybeta)));
   retp(phi);
endp;


proc findwb(aw,myalpha);
        local phit, phi, phim, delm, biginv, mystm, wb;
        gammat = getgam(aw);
        phit = findphit(aw);
        phi = findphi(aw,phit);
        phim = phi*((phit^(-1))');
        delm = distmat'.*phim;
        biginv = inv(eye(ncnty) - (1-mybeta)*delm);
        mystm = mybeta*biginv*delm;
        wb = myalpha*(mystm*yvec);
        retp(wb);
endp;


proc findtrad(aw,ym);
    local phit, phi, tphim, tdelm, ymat, tmat;
    gammat = getgam(aw);
    phit = findphit(aw);
    phi = findphi(aw,phit);
    tphim = ((phit^(-1))*phi');
    tdelm = distmat.*tphim;
    ymat = ym*ones(1,ncnty);
    tmat = tdelm.*ymat;
    retp(tmat);
endp;


maxexlab = 100;
oldaw = awvec;


do while maxexlab > labtol;
   wagebill = findwb(oldaw,myalpha);
   lpred = wagebill./oldaw;
   exlab = (lpred - lvec)./lvec; /* 超额劳动引致需求 (Y_L/w)/L-1*/
   "wage and excess demand"; /* 迭代多少次，就输出多少次*/
   newaw = oldaw.*(ones(ncnty,1) + mypsi*exlab);
   oldaw~exlab;
   oldaw = newaw;
   maxexlab = maxc(abs(exlab));
   "maxexlab " maxexlab;
endo;

eqmaw = oldaw;
eqmrw = eqmaw/eqmaw[ncnty];


wagebill = findwb(eqmaw,myalpha);
myawage = wagebill./lvec; /* 制造业收入/劳动 */
@ actual and predicted wages @

base1 = eqmaw~myawage~awvec; /*均衡工资  均衡时制造业收入/劳动  */

"wages from: (1) doloop, (2) wagebill, and (3) data";
base1;

mse = meanc((ln(eqmaw) - ln(awvec))^2);
rmse = sqrt(mse);
"root mean square error " rmse;

phitvec = findphit(eqmaw); /* P=p^(-theta)*/
phivec = findphi(eqmaw,phitvec);
mprice = phitvec^(-1/mytheta);
realw = eqmaw./((mprice)^(myalpha));

@ Presenting summary statistics @

"phis and phitildes";
phivec~phitvec;

welfare = yvec.*mprice^(-myalpha);
base2 = realw~welfare;
"real wages and welfare";
base2;
"Y and price"
yvec~mprice;

rrealw = realw/realw[ncnty];
rmprice = mprice/mprice[ncnty];
base3 = eqmrw~rrealw~mprice~rmprice;

"relative supply wage, real wage, absolute and relative manufacture price";
base3;


@ total m demand @ /* 一国对制造业的总支出 */
mpurch = ((1-mybeta)/mybeta)*wagebill + myalpha*yvec;

trademat = findtrad(eqmaw,mpurch);
myxnn = diag(trademat);
myexpsh = (sumc(trademat)-myxnn)./myxnn;
myimpsh = (sumc(trademat')-myxnn)./myxnn;
mympurch = sumc(trademat');
"predicted and actual export and import shares";
myexpsh~expsh~myimpsh~impsh;

"myxnn, xnn, mympurch and mpurch";
myxnn~xnn~mympurch~mpurch;

" ";
" Canada's exports, by destination ";
" (actual and predicted) ";
 ((xnimat[.,4]/1000000)~(trademat[.,4])/1000000);

thetavec = zeros(19,1);
thetavec[1,1]=mytheta;

base = base1~base2~base3~trademat~thetavec;

save C:\Users\humoo\OneDrive\ICT\Website\static\notes\classic-papers\trade\EK2002-code\GAUSS\4\basefe = base;

end;