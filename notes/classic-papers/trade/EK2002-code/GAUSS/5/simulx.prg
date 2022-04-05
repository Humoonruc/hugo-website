@                           SIMULX.PRG                          @

@                                                               @
@                       KORTUM AND EATON 8/16/97                @

@       This program takes as input the equilibrium             @
@       computed by EQUILX.PRG, and performs one or more        @
@       experiments to generate the counterfactuals described   @
@       in section 6.  The output file generates tables         @
@       XI and X.                                               @

@       This program uses the value of theta that is            @
@       specified in EQUILX.PRG.  To change theta for           @
@       SIMULX.PRG, change theta at the beginning of            @
@       EQUILX.PRG.                                             @

@       set program to calculate counterfactuals for            @
@       autarky, zero gravity, and doubled trade                @
@       in EXPERIMENTS section                                  @





NEW;
CLS;
OUTPUT FILE = c:\research\eaton\tgt\simulx.out RESET;
cls;

@ LIBRARY OPTMUM;
#include optmum.ext;
OPTSET; @

ncnty = 19;
nyear = 20;

@ sensitivity of wage response to excess demand @
mypsi = .1;

labtol = .00005;

loadm base = c:\research\eaton\tgt\basefe;
mytheta = base[1,29];
" ";
"********************";
"theta =" mytheta;
"********************";
" ";


mybeta = .21221;
varian = (mybeta^(-mybeta))*((1-mybeta)^(-(1-mybeta)));



@ Load the real data from Ken @

@ base has eqmaw, myawage, awvec, realw, welfare, eqmrw,
rrealw, mprice, and rmprice, a trade matrix and the value of theta @

loadm realdat = c:\research\eaton\tgt\datafe;
loadm base = c:\research\eaton\tgt\basefe;

yvec = realdat[.,1];
xrate = realdat[.,2];
lvec = 2080*realdat[.,3]; 		@ measure labor in approx hours @
awvec = realdat[.,4]/2080;		@ absolute wage @
lmuvec = realdat[.,5];
distmat = realdat[.,6:24];		@ distance, ln dni^(-theta), as defined in section 2, page 5 @
xnimat = realdat[.,25:43];
xrmat = xrate*ones(1,ncnty);
xnimat = xnimat./xrmat;
xnimat = 1000000*xnimat;
xnn = diag(xnimat);
imprt = sumc(xnimat') - xnn;
exprt = sumc(xnimat) - xnn;
impsh = imprt./xnn;
expsh = exprt./xnn;
totprod = xnn + exprt;			

@ adjust data on wage and labor for skills @
loadm trade2=c:\research\eaton\tgt\trade2;
fobs = (ncnty^2)*(nyear-1)+1;
lobs = ncnty^2*nyear;
trade2 = trade2[fobs:lobs,.];
hk = trade2[1:ncnty,6];
" ";

awvec = awvec.*(exp(-.06*hk));
lvec = lvec.*(exp(.06*hk));




@ Create country trade blocks @

@          AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   @
eu71 =    {0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0};
eu73 =    {0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0};
eu81 =    {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
eu86 =    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0};
eu90mat = (eu71+eu73+eu81+eu86)*(eu71+eu73+eu81+eu86)';
eu90mat = diagrv(eu90mat,zeros(ncnty,1));

@          AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   @
nafta =    {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1};
nafta = nafta*nafta';
naftamat = diagrv(nafta,zeros(ncnty,1));

@ Get absolute and relative base wages @
basewage = base[.,1];
relbasew = basewage/basewage[ncnty];

@ Get absolute and relative base man prices @
baseapri = base[.,8];
baserpri = base[.,9];

@ Get base real wage @
baserw = base[.,4];

@ Get base welfare @
basewelf = base[.,5];

@ Get baseline trade @
basetrad = base[.,10:28];
basexnn = diag(basetrad);
baseexp = (sumc(basetrad)-basexnn);
baseimp = (sumc(basetrad')-basexnn);
basempur = sumc(basetrad');	 @ total purchases per country @

distmat = exp(distmat);
distmat = diagrv(distmat,ones(ncnty,1));
transmat = distmat^(-1/mytheta)-ones(ncnty,ncnty);	@ dni - 1 @

lwvec = ln(awvec);
lwvec = lwvec - lwvec[ncnty];
lmuvec = lmuvec - lmuvec[ncnty];
lmuvec = mybeta*(lmuvec + mytheta*lwvec);
muvec = exp(lmuvec);
rwvec = exp(lwvec);
scalew = awvec[ncnty];

awb = awvec.*lvec;			@ manufacturing labor income @

yvec = 1000000*yvec./xrate;
impy = imprt./yvec;
expy = exprt./yvec;
yother = yvec - base[.,1].*lvec;  @ nonmanufactures @


@**********************EXPERIMENTS*********************@



"Countries are: (1) Australia,   (2) Austria,  (3) Belgium,";
"               (4) Canada,      (5) Denmark,  (6) Finland,";
"               (7) France,      (8) Germany,  (9) Greece,";
"              (10) Italy,      (11) Japan,   (12) Netherlands,";
"              (13) New Zealand (14) Norway   (15) Portugal,";
"              (16) Spain       (17) Sweden,  (18) UK,";
"              (19) USA.";

testcnty = 19;
" testcnty: " testcnty;
@ Base has lambdaX = 1 @

@ Let's change mu's (states of technology) @

lambdamu = 1;  			@ change country-specific technology parameter, Ti, in testcnty @
@ lambdamu = 1.2; @		@ lambdamu = 1 represents no change @
" lambdamu: " lambdamu;
muvec[testcnty] = lambdamu*muvec[testcnty];



@ lambdal = 1;
lambdal = 1.1; 
" lambdal: " lambdal;
lvec[testcnty] = lambdal*lvec[testcnty]; @



@ Let's change transport costs  @

@ lambdat = 100; @		@ autarky @
@ lambdat = .001; @		@ zero gravity @
 lambdat = .69; 		@ doubled trade, for theta = 8.28 @


" lambdat: " lambdat;
transmat = lambdat*transmat;
distmat = (transmat + ones(ncnty,ncnty))^(-mytheta);



@*********************EXPERIMENTS END********************@

wageshar = awb./yvec;

@ use wage share and trade to obtain alphas @
alphavec = wageshar + (imprt - exprt)./yvec;

@ use GDP weighted average share to obtain unified alpha @
yweight = yvec/sumc(yvec);
myalpha = sumc(yweight.*alphavec);

"alpha " myalpha;


@ ******************************Procedures************************ @

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
        local phit, phi, phim, delm, biginv, mystm, wb, mystma;
        gammat = getgam(aw);
        phit = findphit(aw);
        phi = findphi(aw,phit);
        phim = phi*((phit^(-1))');
        delm = distmat'.*phim;
        biginv = inv(eye(ncnty) - (1-mybeta)*delm);
        mystm = mybeta*biginv*delm;
        mystma = myalpha*mystm;
        wb = inv(eye(ncnty) - mystma)*mystma*yother;
        retp(wb);
endp;

proc findlab(aw,myalpha);
        local phit, phi, phim, delm, biginv, mystm, wb, labor;
        gammat = getgam(aw);
        phit = findphit(aw);
        phi = findphi(aw,phit);
        phim = phi*((phit^(-1))');
        delm = distmat'.*phim;
        biginv = inv(eye(ncnty) - (1-mybeta)*delm);
        mystm = mybeta*biginv*delm;
        wb = myalpha*mystm*yvec;
        labor = wb./basewage;
        retp(labor);
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

proc finday(wb,aw);
        local phit, phi, phim, delm, biginv, mystm, ay;
        gammat = getgam(aw);
        phit = findphit(aw);
        phi = findphi(aw,phit);
        phim = phi*((phit^(-1))');
        delm = distmat'.*phim;
        biginv = inv(eye(ncnty) - (1-mybeta)*delm);
        mystm = mybeta*biginv*delm;
        ay = inv(mystm)*wb;
        retp(ay);
endp;

"***************************************************************";
"Mobile Labor";
"***************************************************************";

@ Find new L's given wvec @

mylab = findlab(basewage,myalpha);
phitvec = findphit(basewage);
phivec = findphi(basewage,phitvec);
mprice = phitvec^(-1/mytheta);
realw = basewage./((mprice)^(myalpha));
rrealw = realw/realw[ncnty];

lchange = 100*(mylab - lvec)./lvec;
lchange = round(10*lchange)/10;
@ "simulated and baseline labor forces";
mylab~lvec; 
"simulated percentage change in labor";
lchange; @

wchange = 100*(realw - baserw)./baserw;
@ "new and base real wage, and percentage change";
realw~baserw~wchange; @

newnormp = mprice/baseapri[ncnty];
@ "new and base rel real wage";
"new and base m price, normalized by US baseline"; 
rrealw~base[.,7]~newnormp~baserpri; @

welfare = yvec.*((mprice)^(-myalpha));
gains = 100*(welfare - basewelf)./basewelf;
@ "new and old welfare";
welfare~basewelf;
"percentage change welfare, as percent testcnty gain";
gains~(100*gains/gains[testcnty]); @

temp1 = 100*ln(welfare./basewelf);
temp2 = 100*ln(newnormp./baserpri);
temp3 = 100*ln(mylab./lvec);
temp4 = (base[.,1].*lvec)./yvec;
temp5 = (base[.,1].*mylab)./yvec;

"100 * log difference from actual to counterfactual ";
"percentage change in:";
" ";
$"welfare"~"prices"~"employ-";
$" "~" "~"-ment";
(temp1~temp2~temp3);
" ";
@ " base and counterfactual manufacturing share ";
(temp4~temp5);
" "; @


mywb = basewage.*mylab;

@ total m demand @
mpurch = ((1-mybeta)/mybeta)*mywb + myalpha*yvec;

@ trade predictions @
trademat = findtrad(basewage,mpurch);
myxnn = diag(trademat);
myexp = sumc(trademat)-myxnn;
myimp = sumc(trademat')-myxnn;
mytrad = myexp+myimp;
batrad = baseexp+baseimp;
lexp = 100*(myexp - baseexp)./baseexp;
limp = 100*(myimp - baseimp)./baseimp;


" ";
" percentage change in world trade ";
(100*(sumc(mytrad)-sumc(batrad))/sumc(batrad));
" ";



mytexp = trademat[.,testcnty];
basetexp = basetrad[.,testcnty];
mytimp = trademat[testcnty,.]';
basetimp = basetrad[testcnty,.]';
ltexp = 100*(mytexp - basetexp)./(basetexp);
ltimp = 100*(mytimp - basetimp)./(basetimp);



"***************************************************************";
"Immobile Labor";
"***************************************************************";

maxexlab = 100;
oldaw = awvec;

do while maxexlab > labtol;
   wagebill = findwb(oldaw,myalpha);
   lpred = wagebill./oldaw;
   exlab = (lpred - lvec)./lvec;
  @ "wage and excess demand"; @
   newaw = oldaw.*(ones(ncnty,1) + mypsi*exlab);
  @ oldaw~exlab; @
   oldaw = newaw;
   maxexlab = maxc(abs(exlab));
 @  "maxexlab " maxexlab; @
endo; 

eqmaw = oldaw;
eqmrw = eqmaw/eqmaw[ncnty];

wagebill = findwb(eqmaw,myalpha);
myawage = wagebill./lvec;
@ actual and predicted wages @

@ "wages from: (1) doloop, (2) wagebill, and (3) base"; 
eqmaw~myawage~base[.,1]; @

phitvec = findphit(eqmaw);
phivec = findphi(eqmaw,phitvec);
mprice = phitvec^(-1/mytheta);
realw = eqmaw./((mprice)^(myalpha));
rrealw = realw/realw[ncnty];

wchange = 100*(realw - baserw)./baserw;
wchange = round(10*wchange)/10;

@ "new and base real wage";
realw~baserw;
"percentage change of real wage";
wchange; @

@ wage in terms of manufacturing prices @
mrealw = eqmaw./mprice;
basemw = base[.,1]./baseapri;

mwchange = 100*(mrealw - basemw)./basemw;

@ "new and base manufacturing real wage";
mrealw~basemw;
"percentage change of manufacturing real wage";
mwchange; @

newnormp = mprice/baseapri[ncnty];
@ "new and base rel real wage";
"new and base m price, normalized by US baseline";
rrealw~base[.,7]~newnormp~baserpri; @

welfare = (wagebill + yother).*((mprice)^(-myalpha));
gains = 100*(welfare - basewelf)./basewelf;
@ "new and old welfare";
welfare~basewelf;
"percentage change welfare, and as percent testcnty gain";
gains~(100*gains/gains[testcnty]); @

temp1 = 100*ln(welfare./basewelf);
temp2 = 100*ln(newnormp./baserpri);
temp3 = 100*ln(eqmaw./base[.,1]);
temp4 = (base[.,1].*lvec)./yvec;
temp5 = (eqmaw.*lvec)./yvec;


"100 * log difference from actual to counterfactual ";
"percentage change in:";
" ";
$"welfare"~"prices"~"wage";
temp1~temp2~temp3;

@ " log difference wage, manufacturing share";
(temp3~temp4);
" ";
" base and counterfactual manufacturing share ";
(temp4~temp5);

" ";
" check approximation ";
check = temp1 + myalpha*temp2 - temp3.*temp4;
check;
" "; @



@ total m demand @
mpurch = ((1-mybeta)/mybeta)*wagebill + myalpha*(yother+wagebill);

trademat = findtrad(eqmaw,mpurch);
myxnn = diag(trademat);
myexp = sumc(trademat)-myxnn;
myimp = sumc(trademat')-myxnn;
mytrad = myexp+myimp;
batrad = baseexp+baseimp;
lexp = 100*(myexp - baseexp)./baseexp;
limp = 100*(myimp - baseimp)./baseimp;


" ";
" ****** ";
" percentage change in world trade ";
(100*(sumc(mytrad)-sumc(batrad))/sumc(batrad));
" ";


mytexp = trademat[.,testcnty];
basetexp = basetrad[.,testcnty];
mytimp = trademat[testcnty,.]';
basetimp = basetrad[testcnty,.]';
ltexp = 100*(mytexp - basetexp)./(basetexp);
ltimp = 100*(mytimp - basetimp)./(basetimp);


end;