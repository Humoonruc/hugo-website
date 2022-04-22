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
xrate = realdat[.,2]; /* ���� */
lvec = realdat[.,3]; /* ����ҵ�Ͷ��� */
awvec = realdat[.,4]; /* ���Թ��� */

lvec = 2080*lvec;                 @ measure labor in approx hours ���깤��Сʱ������Ͷ�@
awvec = awvec/2080;               @ absolute wage (not relative) ��λ�Ͷ��Ĺ���@

lmuvec = realdat[.,5]; /* S1-S19 */
"S1-S19"
lmuvec;

distmat = realdat[.,6:24];        @ distance measure, ln(dni^(-theta)), as defined in section 2, page 5 @
"      ";
"      ";
"distance measure";
distmat; /* -theta*ln(dni)������index��n����index��i */

/* 25~43�У�19*19����*/
xnimat = realdat[.,25:43]; /* Xni��ó�׶����ֵ, ��index��n����index��i */
/* ��n��ó�׶����n�����Ҽ�����*/


xrmat = xrate*ones(1,ncnty); /* ��չΪ19*19 */
xnimat = xnimat./xrmat; /* ������Ϊ million ��Ԫ*/
xnimat = 1000000*xnimat;
xnn = diag(xnimat);
"Xnn";
xnn;
"";
imprt = sumc(xnimat') - xnn; /* ���ڶ� */
exprt = sumc(xnimat) - xnn; /* ���ڶ� */

t1 = imprt./xnn;
t2 = exprt./xnn;


@ adjust wage and labor for skills @
loadm trade2=.\trade2;
fobs = (ncnty^2)*(nyear-1)+1;
lobs = ncnty^2*nyear;
trade2 = trade2[fobs:lobs,.]; /* 1990 ������*/
hk = trade2[1:ncnty,6]; /* �˾��ܽ������� */ 
awvec = awvec.*(exp(-.06*hk)); /* ��Ч���� actual wage*/
lvec = lvec.*(exp(.06*hk)); /* ��Ч�Ͷ� */

/*
" ";
" awvec, lvec ";
(awvec/awvec[19])~(lvec/lvec[19]);
" ";
" industry % share in GDP ";

(100*awvec.*lvec./(1000000*yvec./xrate));
*/

impsh = imprt./xnn; /* ���ڷݶ� */ 
expsh = exprt./xnn; /* ���ڷݶ� */
totprod = xnn + exprt; /* ����ҵ�ܲ��� */

@ print out some data @;

distmat = exp(distmat); 
distmat; /* distmat ���ˣ������� d_{ni}^(-theta) */
distmat = diagrv(distmat,ones(ncnty,1)); /* �ƺ����ޱ仯 */
distmat;

lwvec = ln(awvec);
lwvec = lwvec - lwvec[ncnty]; /* ������Ч���ʣ��������*/

lmuvec = lmuvec - lmuvec[ncnty]; /*Sn-S19*/
lmuvec = mybeta*(lmuvec + mytheta*lwvec); /*27ʽ������ln(T_n/T_19)*/
muvec = exp(lmuvec); /* T_n/T_19�� TABLE VI theta=8.28 ����һ�� */
"T_n/T_19";
muvec;
rwvec = exp(lwvec);  /* ��Ч����֮�� */
scalew = awvec[ncnty]; /* ��������Ч���� */

awb = awvec.*lvec; /* 19������ҵ�������룬����*/

"check beta";
awb./(xnn + exprt); /* �����ֱ���� beta������ */

yvec = 1000000*yvec./xrate;
impy = imprt./yvec; /* ó�������� */
expy = exprt./yvec;

wageshar = awb./yvec; /* industry wage share in GDP*/

@ use wage share and trade to obtain alphas @
alphavec = wageshar + (imprt - exprt)./yvec; 
/* ������ alpha�����ڶ�����ҵ���ղ�Ʒ��֧��������֧����
��������ҵ���ղ�Ʒ��֧���������м侭�������м��Ʒ�㼶�����ն���ת��Ϊ����ҵ�Ĺ�������
ֻ���������������ҵ��Ʒ��֧�������ջ�ת��Ϊ�������ҵ���˵Ĺ�������
���Ա�������ҵ���˵�������Ͼ����ڵ�����ҵ��Ʒ��ֵ��
�ŵ��ڶ�����ҵ���ղ�Ʒ����֧��*/

yweight = yvec/sumc(yvec);
myalpha = sumc(yweight.*alphavec); /* �ø���GDP��ΪȨ�أ�����һ����Ȩ�� alpha */
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
    gammax = maxc(sumc(gammat'));  /* �к͵����ֵ */
    phitlow = (diag(gammat))^(1/mybeta);
    phithigh = gammax^(1/mybeta)*ones(ncnty,1);
    retp(phitlow,phithigh);
endp;

@ phitmin and phitmax are globals that get updated @

{phitmin,phitmax} = phtbound(gammat); /* p��ʼ���������ֵ����Сֵ */





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
  gaminv = inv(gammat); /*gammat�� D %*% gTw^(-beta*theta) */
  func = xbeta1 - gaminv*x;   @ negative of the function @
  dfunc = gaminv - (1-mybeta)*diagrv(eye(ncnty),xbeta2); /*Jacobi*/
 @ derivative of the function @ 
  retp(dfunc,func); /*����F(x)����Jacobi��������*/
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
   exlab = (lpred - lvec)./lvec; /* �����Ͷ��������� (Y_L/w)/L-1*/
   "wage and excess demand"; /* �������ٴΣ���������ٴ�*/
   newaw = oldaw.*(ones(ncnty,1) + mypsi*exlab);
   oldaw~exlab;
   oldaw = newaw;
   maxexlab = maxc(abs(exlab));
   "maxexlab " maxexlab;
endo;

eqmaw = oldaw;
eqmrw = eqmaw/eqmaw[ncnty];


wagebill = findwb(eqmaw,myalpha);
myawage = wagebill./lvec; /* ����ҵ����/�Ͷ� */
@ actual and predicted wages @

base1 = eqmaw~myawage~awvec; /*���⹤��  ����ʱ����ҵ����/�Ͷ�  */

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


@ total m demand @ /* һ��������ҵ����֧�� */
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