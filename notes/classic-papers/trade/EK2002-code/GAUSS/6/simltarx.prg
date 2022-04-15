@                        SIMLTARX.PRG                               @
@                                                                   @
@           (Include Changes in Tariff Revenues)                    @
@                                                                   @
@                         Simulate the                              @
@                                                                   @
@                       EATON-KORTUM model of                       @
@                     technology and bilateral trade                @
@                                                                   @
@                      KORTUM AND EATON 8/16/97                     @
@                                                                   @

@       This program takes as input the equilibrium computed        @
@       by EQUILX.PRG, and performs a tariff-reduction              @
@       experiment to generate the data described in section 6.4    @
@       and generates table XII                                     @     

@                                                                   @
@       set program to calculate effects of tariff reduction        @
@       worldwide, in the EU only, or in the USA only               @
@       in EXPERIMENTS section                                      @








NEW;
OUTPUT FILE = c:\research\eaton\tgt\simltarx.out RESET;
cls;


@ LIBRARY OPTMUM;
#include optmum.ext;
OPTSET; @

ncnty = 19;
nyear = 20;

@ sensitivity of wage response to excess demand @
mypsi = .1;

@ Tariff rate except for within the EU @
tarrate = .05;

labtol = .00005;

@ wage elasticity @
@ mytheta = 3.60; @
 mytheta = 8.28;

mybeta = .21221;
varian = (mybeta^(-mybeta))*((1-mybeta)^(-(1-mybeta)));

@ Load the real data from Ken @

@ base has eqmaw, myawage, awvec, realw, welfare, eqmrw,
rrealw, mprice, and rmprice and a trade matrix @

loadm realdat = c:\research\eaton\tgt\datafe;
loadm base = c:\research\eaton\tgt\basefe;

yvec = realdat[.,1];
xrate = realdat[.,2];
lvec = 2080*realdat[.,3];       @ measure labor in approx hours @
awvec = realdat[.,4]/2080;      @ absolute wage @
lmuvec = realdat[.,5];
distmat = realdat[.,6:24];      @ distance, ln dni^(-theta), as defined in section 2, page 5 @
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
@ " ";
" hk,awvec,lvec ";
hk~awvec~lvec; @
awvec = awvec.*(exp(-.06*hk));
lvec = lvec.*(exp(.06*hk));

@ " ";
" awvec, lvec ";
awvec~lvec; @


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
basempur = sumc(basetrad');     @ total purchases per country @

eu90vec = (eu71+eu73+eu81+eu86);

baseimpe = basetrad*eu90vec - eu90vec.*basexnn;


@ Create baseline tariff revenue @
noeu = 1 - eu90mat;
noeu = diagrv(noeu,zeros(ncnty,1));
basetar = tarrate*(1 - eye(ncnty));   @ assume same tariffs everywhere @
basetary = sumc(((basetar./(1+basetar)).*basetrad)');
newtary = basetary;

distmat = exp(distmat);
distmat = diagrv(distmat,ones(ncnty,1));
transmat = distmat^(-1/mytheta)-ones(ncnty,ncnty);     @ dni - 1 @

lwvec = ln(awvec);
lwvec = lwvec - lwvec[ncnty];
lmuvec = lmuvec - lmuvec[ncnty];
lmuvec = mybeta*(lmuvec + mytheta*lwvec);
muvec = exp(lmuvec);
rwvec = exp(lwvec);
scalew = awvec[ncnty];

awb = awvec.*lvec;                  @ manufacturing labor income @

yvec = 1000000*yvec./xrate;
impy = imprt./yvec;
expy = exprt./yvec;
yother = yvec - base[.,1].*lvec;    @ nonmanufactures @
yothtar = yother + newtary - basetary;
yvectar = yvec + newtary - basetary;




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

@ Let's change mu's @

lambdamu = 1;                    @ change country-specific technology @
@ lambdamu = 1.2; @              @ parameter, Ti, in testcnty         @
" lambdamu: " lambdamu;
muvec[testcnty] = lambdamu*muvec[testcnty];

@ Let's change labor forces @

lambdal = 1;
" lambdal: " lambdal;
lvec[testcnty] = lambdal*lvec[testcnty];

@ Tariff Experiments @
" ";
" ";
"**************************";
" EXPERIMENT IS: ";
" ";

  newtar = basetar;

    " elimination of tariffs ";
    " within 1990 EC "; 
     newtar = tarrate*noeu;            

  @  " U.S. unilateral tariff elimination ";        
    newtar = basetar;
    newtar[ncnty,1:(ncnty-1)] = zeros(1,(ncnty-1));   @

  @  " general multilateral tariff "; 
     " elimination ";
    newtar = zeros(ncnty,ncnty);      @

"**************************";
" ";
" ";

 
newtran = 1+transmat;
newtran = newtran.*(1+newtar)./(1+basetar);

distmat = (newtran)^(-mytheta);




@ Let's go to autarky @

@ distmat = eye(ncnty); @

@*********************EXPERIMENTS END********************@

wageshar = awb./yvec;

@ use wage share and trade to obtain alphas @
alphavec = wageshar + (imprt - exprt)./yvec;

@ use GDP weighted average share to obtain unified alpha @
yweight = yvec/sumc(yvec);
myalpha = sumc(yweight.*alphavec);

"alpha " myalpha;

@ "transport costs";
"from countries 1-4";
transmat[.,1:4];

"from countries 5-8";
transmat[.,5:8];

"from countries 9-12";
transmat[.,9:12];

"from countries 13-16";
transmat[.,13:16];

"from countries 17-19";
transmat[.,17:19];  @

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
        wb = inv(eye(ncnty) - mystma)*mystma*yothtar;
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
        wb = myalpha*mystm*yvectar;
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

" ";
"***************************************************************";
"Mobile Labor";
"***************************************************************";
" ";

@ Find new L's given wvec @

maxtard = 100;
oldtary = ones(ncnty,1);

do while maxtard > labtol;
   mylab = findlab(basewage,myalpha);
   @ tariff revenue @
     yvectar = yvec + newtary - basetary;
     @ total m demand @
     mywb = basewage.*mylab;
     mpurch = ((1-mybeta)/mybeta)*mywb + myalpha*yvectar;
     @ trade predictions @
     trademat = findtrad(basewage,mpurch);
     newtary = sumc(((newtar./(1+newtar)).*trademat)');
     extar = 1000*(newtary-oldtary)./baseimp;
     @ " ";
     " newtary, oldtary, extar "; 
     newtary~oldtary~extar; @
     maxtard = maxc(abs(extar));
     @ "maxtard " maxtard; @
     oldtary = newtary;
  endo;

phitvec = findphit(basewage);
phivec = findphi(basewage,phitvec);
mprice = phitvec^(-1/mytheta);
realw = basewage./((mprice)^(myalpha));
rrealw = realw/realw[ncnty];

lchange = 100*(mylab - lvec)./lvec;
lchange = round(10*lchange)/10;


welfare = yvectar.*((mprice)^(-myalpha));
gains = 100*(welfare - basewelf)./basewelf;
gains = round(100*gains)/100;
" percentage change in welfare ";
gains;

mywb = basewage.*mylab;

@ total m demand @
mpurch = ((1-mybeta)/mybeta)*mywb + myalpha*yvectar;


@ Calculate trade creation and diversion @

myxnn = diag(trademat);
myexp = sumc(trademat)-myxnn;
myimp = sumc(trademat')-myxnn;
myimpe = trademat*eu90vec - eu90vec.*myxnn;
dimpe = myimpe - baseimpe;
dimp = myimp - baseimp;
eucreate = 100*dimpe./baseimpe;
eucreate = round(10*eucreate)/10;
eudivert = 100*(dimpe-dimp)./dimpe;
eudivert = round(10*eudivert)/10;
" eu trade creation as percent of prior eu imports ";

eucreate;

" ";
"***************************************************************";
"Immobile Labor";
"***************************************************************";
" ";

maxexlab = 100;
oldaw = awvec;

do while maxexlab > labtol;
   wagebill = findwb(oldaw,myalpha);
   lpred = wagebill./oldaw;
   exlab = (lpred - lvec)./lvec;
   @ "wage, excess demand, newtary"; @
   newaw = oldaw.*(ones(ncnty,1) + mypsi*exlab);
   @ oldaw~exlab; @
   oldaw = newaw;
   @ tariff revenue @
   yothtar = yother + newtary - basetary;
   mpurch=((1-mybeta)/mybeta)*wagebill+myalpha*(yothtar+wagebill);
   trademat = findtrad(oldaw,mpurch);
   newtary = sumc(((newtar./(1+newtar)).*trademat)');
   maxexlab = maxc(abs(exlab));
   @ "maxexlab " maxexlab; @
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

newnormp = mprice/baseapri[ncnty];

welfare = (wagebill+yothtar).*((mprice)^(-myalpha));
gains = 100*(welfare - basewelf)./basewelf;
gains = round(100*gains)/100;

" percentage change in welfare";
gains;
" ";
@ " decompose percent change in welfare ";@
temp2 = -myalpha*100*ln(newnormp./baserpri);
temp3 = 100*(eqmaw-base[.,1]).*lvec./yvec;
temp4 = 100*(newtary - basetary)./yvec;

@ " price effect, wage effect, tariff effect ";
temp2~temp3~temp4; @
 



@ total m demand @
mpurch=((1-mybeta)/mybeta)*wagebill+myalpha*(yothtar+wagebill);

trademat = findtrad(eqmaw,mpurch);
myxnn = diag(trademat);
myexp = sumc(trademat)-myxnn;
myimp = sumc(trademat')-myxnn;



@ Calculate trade creation and diversion @

myimpe = trademat*eu90vec - eu90vec.*myxnn;
dimpe = myimpe - baseimpe;
dimp = myimp - baseimp;
eucreate = 100*dimpe./baseimpe;
eucreate = round(10*eucreate)/10;
eudivert = 100*(dimpe-dimp)./dimpe;
eudivert = round(10*eudivert)/10;
" eu trade creation as percent of prior eu imports ";
eucreate;

end;