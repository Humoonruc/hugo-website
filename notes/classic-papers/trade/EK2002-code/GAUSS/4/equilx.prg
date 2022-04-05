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
OUTPUT FILE = c:\research\eaton\tgt\equilx.out RESET;

@ LIBRARY OPTMUM;
#include optmum.ext;
OPTSET; @

ncnty = 19;
nyear = 20;

@ sensitivity of wage response to excess demand @
mypsi = .1;

labtol = .00005;

@ wage elasticity @
  
@  mytheta = 3.60; @
 mytheta = 8.28; 
"theta =" mytheta;

mybeta = .21221;
varian = (mybeta^(-mybeta))*((1-mybeta)^(-(1-mybeta)));

@ Load the real data from Ken @

loadm realdat = c:\research\eaton\tgt\datafe;
@ loadm realdat = c:\research\eaton\tgt\data; @
yvec = realdat[.,1];
xrate = realdat[.,2];
lvec = realdat[.,3];
awvec = realdat[.,4];
lvec = 2080*lvec;                 @ measure labor in approx hours @
awvec = awvec/2080;               @ absolute wage (not relative) @
lmuvec = realdat[.,5];
distmat = realdat[.,6:24];        @ distance measure, ln(dni^(-theta)), as defined in section 2, page 5 @
xnimat = realdat[.,25:43];


@ check some numbers @

xnn = diag(xnimat);
imprt = sumc(xnimat') - xnn;
exprt = sumc(xnimat) - xnn;   @ can't do exports this way @
" xnn, imprt ";
xnn~imprt;


xrmat = xrate*ones(1,ncnty);
xnimat = xnimat./xrmat;
xnimat = 1000000*xnimat;
xnn = diag(xnimat);
imprt = sumc(xnimat') - xnn;
exprt = sumc(xnimat) - xnn;

t1 = imprt./xnn;
t2 = exprt./xnn;
" t1, t2";
t1~t2;


@ adjust wage and labor for skills @
loadm trade2=c:\research\eaton\tgt\trade2;
fobs = (ncnty^2)*(nyear-1)+1;
lobs = ncnty^2*nyear;
trade2 = trade2[fobs:lobs,.];
hk = trade2[1:ncnty,6];
" ";
" hk,awvec,lvec ";
hk~(awvec/awvec[19])~(lvec/lvec[19]);
awvec = awvec.*(exp(-.06*hk));
lvec = lvec.*(exp(.06*hk));

" ";
" awvec, lvec ";
(awvec/awvec[19])~(lvec/lvec[19]);
" ";
" share in GDP ";

(100*awvec.*lvec./(1000000*yvec./xrate));

" canadian imports ";
xnimat[4,.]/1000000;

" US imports ";
xnimat[19,.]/1000000;



impsh = imprt./xnn;
expsh = exprt./xnn;
totprod = xnn + exprt;
@ xnn~imprt~exprt; @
@ impsh~expsh; @

@ print out some data @;
"source effects as estimated";
lmuvec;

distmat = exp(distmat);
distmat = diagrv(distmat,ones(ncnty,1));

lwvec = ln(awvec);
lwvec = lwvec - lwvec[ncnty];
lmuvec = lmuvec - lmuvec[ncnty];
lmuvec = mybeta*(lmuvec + mytheta*lwvec);
muvec = exp(lmuvec);
rwvec = exp(lwvec);
scalew = awvec[ncnty];

"muvec and rwvec";
muvec~rwvec;

awb = awvec.*lvec;

"check beta";
awb./(xnn + exprt);

yvec = 1000000*yvec./xrate;
impy = imprt./yvec;
expy = exprt./yvec;
"imports and exports over GDP";
impy~expy;

wageshar = awb./yvec;

"$ income, wageshare, wage, employment";
yvec~wageshar~awvec~lvec;

@ use wage share and trade to obtain alphas @
alphavec = wageshar + (imprt - exprt)./yvec;
"wageshare and alphavec";
wageshar~alphavec;

@ use GDP weighted average share to obtain unified alpha @
yweight = yvec/sumc(yvec);
myalpha = sumc(yweight.*alphavec);

"alpha " myalpha;

"exchange rate, muvec, and actual wage";
xrate~muvec~awvec;

transmat = distmat^(-1/mytheta)-ones(ncnty,ncnty);

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
ldistmat  = ln(distmat);
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
    muwvec = muvec.*(aw^(-mybeta*mytheta));
    muwmat = ones(ncnty,1)*muwvec';
    gammat = (varian^(mytheta))*(distmat.*muwmat);
    retp(gammat);
endp;

@ gammat is a global that gets updated @

gammat = getgam(awvec);

proc(2) = phtbound(gammat);
    local gammax, phitlow, phithigh;
    gammax = maxc(sumc(gammat'));
    phitlow = (diag(gammat))^(1/mybeta);
    phithigh = gammax^(1/mybeta)*ones(ncnty,1);
    retp(phitlow,phithigh);
endp;

@ phitmin and phitmax are globals that get updated @

{phitmin,phitmax} = phtbound(gammat);

@ Newton-Raphson to solve system, usrfun(x) = 0: Numerical Recipes, pg. 269 @
proc mnewt(&usrfun,x);
  local n,ntrial,tolf,tolx,k,good,dalpha,fbeta,errf,dx,errx, xupper, xlower;
  local usrfun:proc;
   ntrial = 100;  @ maximum number of iterations @
   tolf = .0000001;  @ tolerance for satisfying the system @
   tolx = .0000001;  @ tolerance for change in x @
   xupper = phitmax;
@ x must be between phitmin and phitmax @
   xlower = phitmin;
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
  gaminv = inv(gammat);
  func = xbeta1 - gaminv*x;   @ negative of the function @
  dfunc = gaminv - (1-mybeta)*diagrv(eye(ncnty),xbeta2);
 @ derivative of the function @
  retp(dfunc,func);
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
   exlab = (lpred - lvec)./lvec;
   "wage and excess demand";
   newaw = oldaw.*(ones(ncnty,1) + mypsi*exlab);
   oldaw~exlab;
   oldaw = newaw;
   maxexlab = maxc(abs(exlab));
   "maxexlab " maxexlab;
endo;

eqmaw = oldaw;
eqmrw = eqmaw/eqmaw[ncnty];

wagebill = findwb(eqmaw,myalpha);
myawage = wagebill./lvec;
@ actual and predicted wages @

base1 = eqmaw~myawage~awvec;

"wages from: (1) doloop, (2) wagebill, and (3) data";
base1;

mse = meanc((ln(eqmaw) - ln(awvec))^2);
rmse = sqrt(mse);
"root mean square error " rmse;

phitvec = findphit(eqmaw);
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

rrealw = realw/realw[ncnty];
rmprice = mprice/mprice[ncnty];
base3 = eqmrw~rrealw~mprice~rmprice;

"relative supply wage, real wage, abs and rel man price";
base3;

@ total m demand @
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

save c:\research\eaton\tgt\basefe = base;

end;



