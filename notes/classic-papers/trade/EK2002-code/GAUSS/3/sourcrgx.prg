@                       SOURCRGX.PRG                                @
@                                                                   @
@             Estimate Theta Using Source Effects                   @
@              (includes version with nontradeables)                @
@                                                                   @
@                       EATON-KORTUM model of                       @
@                     technology and bilateral trade                @
@                                                                   @
@                      KORTUM AND EATON 7/14/98                     @
@                                                                   @
@     Generates results given in section 5.4, and generates         @
@     Tables IV and V.                                              @
@                                                                   @
@                                                                   @



NEW;
OUTPUT FILE = c:\research\eaton\tgt\sourcrgx.out RESET;
cls;

@ LIBRARY OPTMUM;
#include optmum.ext;
OPTSET; @

ncnty = 19;

mybeta = .21221;

@ Load source effects @

loadm realdat = c:\research\eaton\tgt\datafe;

yvec = realdat[.,1];
xrate = realdat[.,2];
lvec = 2080*realdat[.,3]; @ measure labor in approx hours @
awvec = realdat[.,4]/2080;
lmuvec = realdat[.,5];

lwvec = ln(awvec);
lwvec = lwvec - lwvec[ncnty];
@ lmuvec = lmuvec - lmuvec[ncnty];  @
@ lmuvec = mybeta*(lmuvec + mytheta*lwvec); @

@ Load other data @

loadm trade1=c:\research\eaton\tgt\trade1;
loadm trade2=c:\research\eaton\tgt\trade2;
loadm trade3=c:\research\eaton\tgt\trade3;

nyear = 20;
ncnty = 19;
fobs = (ncnty^2)*(nyear-1) + 1;
lobs = (ncnty^2)*nyear;
trade1 = trade1[fobs:lobs,.];
trade2 = trade2[fobs:lobs,.];
trade3 = trade3[fobs:lobs,.];

xnn = trade2[.,9];
xni = trade2[.,10];
imp = trade3[.,1];

ihome = imp./xnn;
xrat = xnn./(imp+xnn);
ihome = reshape(ihome,ncnty,ncnty);
ihome = ihome[.,1];
xrat = reshape(xrat,ncnty,ncnty);
xrat = xrat[.,1];

fobs2 = ncnty*(ncnty-1) + 1;
lobs2 = ncnty^2;

lrdens = trade1[fobs2:lobs2,15];
lrwork = trade1[fobs2:lobs2,16];
lrwage = trade1[fobs2:lobs2,17];
lrrnd = trade1[fobs2:lobs2,13];     @ coe and helpman @
@ lrrnd = trade2[fobs2:lobs2,1]; @    @ RSE's in BE @
@ lrrnd = trade2[fobs2:lobs2,2]; @    @ RSE's total @
@ lrrnd = trade2[fobs2:lobs2,3]; @    @ Private R&D @

hk = trade2[fobs2:lobs2,6];       @ Kyriacou @
@ hk = trade2[fobs2:lobs2,8]; @      @ Barro @

funchk = 1/hk;   @ default functional form @
@ funchk = ln(hk); @  @ cobb-douglas @
@ funchk = hk; @    @ Bils and Klenow @



@ adjust wages for skills @
lrwageb = lrwage - .06*hk;
lrworkb = lrwork + .06*hk;
" ";

format /mat /sa /on /lds 16,8;

" ";
"Table IV";
" ";
"research stock, years of schooling, labor force (HK adjusted), population density";

exp(lrrnd)~hk~exp(lrworkb-lrworkb[ncnty])~exp(lrdens);


/* @  Try epsilons from the Economic Policy paper @
load epeps[441,1] = c:\research\eaton\tgt\epsilon.dat;
epeps = reshape(epeps,21,21);
epeps = epeps';   @ now dest is row and source is column @
iextra = zeros(21,1);
iextra[10] = 1;
iextra[19] = 1;   @ get rid of Ireland and Switzerland @
epeps = delif(epeps,iextra);
epeps = delif(epeps',iextra);
epeps = epeps'; 

rnd = exp(lrrnd);    @ now U.S. = 1 @

rnd = epeps*rnd;    @ Take account of diffusion @

lrrnde = ln(rnd);

@ lrrnd = .19*lrrnd + .81*(lrwork+.06*(hki-hkn)); @

@ "lrrnd lrrnde";
lrrnd~lrrnde; @  */

@ Try per worker research stock @
@ lrrnd = lrrnd - .5*lrwork; @


@ lrwork = lrwork + .06*(hki-hkn); @

@ Proc to do TSLS given  @
@ returns coefficients in column 1 and std. errors in column 2 @
@ remember that x must include the constant term if you want it @
@ You supply appropriate degrees of freedom @

 proc(3)= tsls(y,x,xhat,dof);
    local betahat,eps,sighat2,varcov,stdb;
    betahat = inv(xhat'*xhat)*xhat'*y;
    eps = y - x*betahat;
    sighat2 = eps'*eps/dof;
    print "Sum of Squared Residuals: " sighat2*dof;
    varcov = sighat2*inv(xhat'*xhat);
    stdb = sqrt(diag(varcov));
    retp(betahat,stdb,eps);
 endp;


y = lmuvec;
xmat = lrrnd~funchk~lrwageb;

"  ";
"                     basic OLS regression (table V, column 1)";
" (xmat = lrrnd~funchk~lrwageb)";
" ";
call ols(0,y,xmat);

" ";
" ";
"*********************2SLS (table V, column 2)";

"                     Instrument for wages ";
"   ";
"        *************First Stage";
" ";
" (zmat = ones(ncnty,1)~lrrnd~funchk~lrworkb~lrdens) ";
"  ";
zmat = ones(ncnty,1)~lrrnd~funchk~lrworkb~lrdens;
_olsres = 1;


{j1,j2,j3,j4,j5,j6,j7,j8,j9,lwresid,j11} = ols(0,lrwageb,zmat);

lwfit = lrwageb - lwresid;

"  ";
"        **************Second Stage";
"   ";
" (xmatf = ones(ncnty,1)~lrrnd~funchk~lwfit)";
" ";
xmat = ones(ncnty,1)~lrrnd~funchk~lrwageb;
xmatf = ones(ncnty,1)~lrrnd~funchk~lwfit;
dof = rows(xmat)-cols(xmat);

{b3,stdb3,resid3}=tsls(y,xmat,xmatf,dof);
"  ";
print b3~stdb3;
" ";
" residuals ";
resid3;





end;



