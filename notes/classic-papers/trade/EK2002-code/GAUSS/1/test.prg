/* maxdistx.prg */

/* Program to look at maximum price ratios as a proxy for trade frictions. */
/* Based on SIMPARM.PRG  �����ʲô�ļ����� */
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
/*��ȡ������������*/
/* ����һ��7220��*17�еĸ����������ݣ����Ϊ1971-1990����20�� */
loadm tradeAll = "./data/trade1.fmt";

/* �鿴 .fmt �����ļ��ķ��� */
/*
load trade1 = .\data\trade1.fmt;
output file = .\trade1.txt reset;
print trade1;
output off;
*/

n1 = 6860; nn = 7220;   @ 1990�����ݣ���19*19=361�� @
trade1 = tradeAll[n1:nn,.];   @ֻ��1990���������Ƭ@

impcnty = trade1[.,1];      @ ���ڹ�/Ŀ�ĵع� id @
expcnty = trade1[.,2];      @ ���ڹ�/��Դ�� id @
/*�����о�Ϊ90������ʲôδ֪*/
depvar = trade1[.,4];       @ln(Xni/Xnn)@
depvarn = trade1[.,5];      @ln(X'ni/X'nn) gitbook 5.2ʽ@
dist1 = trade1[.,6];        @ ����Ϊ6��������������, dist1~dist6 @
dist2 = trade1[.,7];
dist3 = trade1[.,8];
dist4 = trade1[.,9];
dist5 = trade1[.,10];
dist6 = trade1[.,11];
border = trade1[.,12];     @ common border ������� @
lrrnd = trade1[.,13];      @ ��� R&D ���� ln(R&D_i/R&D_n) @
lrhk = trade1[.,14];       @ ��������ʱ���ƽ���ܽ������� ln(H_i/H_n) @
/*��15�д���ʲôδ֪*/
lrwork = trade1[.,16];     @ �������ҵ�Ͷ��� ln(L_i/L_n)@
lrwage = trade1[.,17];     @ ��Թ��� ln(w_i/w_n)@

mybeta = .21221; 

diff = -(depvarn-depvar)*mybeta/(1-mybeta); @ln((Xi/Xii)/(Xn/Xnn))@
depvarp = depvar + diff;    @ln(Xni/Xn)-ln(Xii/Xi)@


/******************************************************/
/* create common language variable: talk  */

/*        AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   */
english = {1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1}; @˵Ӣ��Ĺ���@
/* 19*1 matrix, �ո�ָ�ͬһ�е�Ԫ�أ����ŷָ���ͬ��*/
french =  {0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; @˵����Ĺ���@
german =  {0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; @˵����Ĺ���@

talk = vec(english*english' + french*french' + german*german'); @��19*19�ľ�����������@
talk = ones(20,1).*.talk; 
/* ones(m,n) creates an 'm' by 'n' matrix with all elements set to 1. */

/* 
.*. ��ʾ Kronecker product �����ڿ˻�: ��� A ��һ�� m �� n �ľ���
B ��һ�� p �� q �ľ���, ������ڿ˻���һ�� mp �� nq �� �ֿ����
 */

/* �˴��൱�ڽ�����Ϊ361��������talk�ظ�20�飬��չ�� 1971-1990 20��*/

talk = talk[n1:nn,.]; /* 1990�꣬�Ƿ��� common language, 361�� */


/******************************************************/
/* create country trade blocks */

/* European Community - European Union */
/*        AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   */
eu71 =    {0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0}; @71���EU��Ա��@
eu73 =    {0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0}; @73�굤��Ӣ������@
eu81 =    {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; @81��ϣ������@
eu86 =    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0}; @86��������������������@
eu7172 = ones(2,1).*.vec(eu71*eu71'); /*71-72��*/
eu7380 = ones(8,1).*.vec((eu71+eu73)*(eu71+eu73)'); /*73-90��*/
eu8185 = ones(5,1).*.vec((eu71+eu73+eu81)*(eu71+eu73+eu81)'); /*81-85��*/
eu8690 = ones(5,1).*.vec((eu71+eu73+eu81+eu86)*(eu71+eu73+eu81+eu86)'); /*86-90��*/
eu = eu7172|eu7380|eu8185|eu8690; /*��ǹ�����EU������*/
/* | ��ʾ row bind������ϲ���*/

/* EFTA */
/*        AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   */
ef71 =    {0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0};
ef73 =    {0, 0, 0, 0,-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,-1, 0}; @73�굤��Ӣ���˳�@
ef86 =    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,-1,-1, 0, 0, 0}; @86�����������������˳�@
ef7172 = ones(2,1).*.vec(ef71*ef71');
ef7385 = ones(13,1).*.vec((ef71+ef73)*(ef71+ef73)');
ef8690 = ones(5,1).*.vec((ef71+ef73+ef86)*(ef71+ef73+ef86)');
ef = ef7172|ef7385|ef8690;

tblock = eu~ef; /* ~ ��ʾ column bind������ϲ���*/

tblock = tblock[n1:nn,.]; /* 1990�꣬�Ƿ񹲴���һ��ó��Э�� */


/******************************************************/
/* create the source and destination DV ��Դ/Ŀ�ĵ�������� */

onecnty = ones(ncnty,1); @19*1����@
desdum = ones(nyear,1).*.(eye(ncnty).*.onecnty); @Ŀ�ĵأ����ڹ����������@
/* eye(k) Ϊ k �׵�λ���� I_k, desdum Ϊÿ�������ظ�19�� */
/* print eye(3).*.ones(3,1); @ ���Թ۲� destination DV m1~m19 ����״@*/

srcdum = ones(nyear,1).*.(onecnty.*.eye(ncnty)); @��Դ�أ����ڹ����������@
/*srcdum Ϊ���������ظ�19�� */
/* print ones(3,1).*.eye(3); @ ���Թ۲� source DV S1~S19 ����״@*/


reldum = srcdum-desdum; @��Դ��������� S_i-S_n, ��������ܾ���@

desdumr = desdum[.,1:(ncnty-1)]-desdum[.,ncnty]; @ǰ18�м�19�У���Ϊ���ֵ@
reldumr = reldum[.,1:(ncnty-1)]-reldum[.,ncnty]; @ǰ18�м�19�У���Ϊ���ֵ@


/******************************************************/
/* ���ֻع�ķ��������弸�������� */

/* proc to calculate country pair time averages */
proc order2(datf);
   local avar,i,var,varmat,adatf;
     adatf = ones((ncnty*(ncnty-1)),cols(datf)); /* adatf �� 342*cols(datf)������1���*/
     i = 1;
     do while i <= cols(datf);
        var = datf[.,i]; @��i��@
        varmat = reshape(var,nyear,(ncnty*(ncnty-1))); @@
        adatf[.,i] = meanc(varmat); @datf��i�е�ƽ����@
        i = i+1;
     endo;
   retp(adatf); @adatfӦ����datf���е�ƽ����ѹ��Ϊһ��@
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
/* 3.2����򵥵Ĺ��Ʒ��� */

load pdat[900,1] = "./data/pppdat1.prn"; @����18��50����ҵ�Ķ�����׼���۸�����@
pdat = pdat|zeros(50,1);   @ ������������׼�����Ķ�����׼���۸����ݣ�50��0�������50�� @
pdat = reshape(pdat,19,50);  @ ����Ϊ19*50ά�ȵľ���countries in rows, goods in columns @
/* ����ȥ�� 17 �� office and computing���Ͳ�����ѡ�ڶ����ֵ��*/
/* pdat = pdat[.,1:16]~pdat[.,18:cols(pdat)]; */

/* �ڶ����r_{ni}(j) */
dpdat = pdat.*.ones(ncnty,1); /* Ŀ�ĵع�50����Ʒ������׼���۸� ln p_n(j) */
spdat = ones(ncnty,1).*.pdat; /* ��Դ�ع�50����Ʒ������׼���۸� ln p_i(j) */
rpdat = dpdat - spdat; 

/* ����3.2.3�ڵ� r_{ni}(j)����(361*50)��ÿ����Ʒ�Ľ��ڹ��۸� ln p_n(j) �����ڹ��۸� ln p_i(j) */
ldni1 = maxc(rpdat'); @ ת�ú��б�����Ʒ���࣬������r_{ni}(j)��Ϊd_{ni}�Ĵ������ @
max1 = maxindc(rpdat'); @ ���ֵ���ڵ��У�����Ʒ���ࣩ index����������������������һ��361*1�ľ��� @

/*The following loops calculate the second, third, etc. highest
values of r_ni.  We use the second highest value, as described on page 14.*/

i = 1;
 do while i <= rows(rpdat);  @����361��@
    bigcol = max1[i];  @ ���ֵ����Ʒ���� index @
    rpdat[i,bigcol] = -100; @�Ѹ������ֵ��Ϊ����@
   i = i+1;
 endo;

ldni2 = maxc(rpdat'); @�����ÿ�еڶ����r_{ni}(j)@

/*
max2 = maxindc(rpdat'); @�ڶ���ֵ����Ʒ����index@

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

/* �����۸�ָ�� */
mpdat = meanc(pdat'); @ת�ú������ƽ����50����Ʒ������׼���۸��ƽ��ֵ��Ϊ���������۸�ָ���Ĵ������@
/* meanc() ��ʾ���м���ƽ��ֵ������ٷ���������*/

slpavg = ones(ncnty,1).*.mpdat; /* ��Դ�ع��۸�ָ�� ln p_i */
dlpavg = mpdat.*.ones(ncnty,1); /* Ŀ�ĵع��۸�ָ�� ln p_n */


/* Get distances between countries in thousands of miles */
/* ��������������� 3.2.1 �ڵ� Figure 1 */
load milevec[361,2] = "./data/getdist.dat";
milevec = milevec[.,2]; @��Ϊ�����������/10^3 mile@
/* correct mistakes */
milevec[18] = 10.769;
milevec[324] = 10.769;



@ ************************************************************* @


dist = dist2~dist3~dist4~dist5~dist6~border; @�ϲ��Ա�������@
dist = dist~talk~tblock;


ldni = ldni2;   @ �ڶ��� r_{ni}(j)��Ϊ ln d_{ni} �Ĵ������@
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
eupair = vec((eu71+eu73+eu81+eu86)*(eu71+eu73+eu81+eu86)'); @�ñ���ֻ������һ�Σ���֪����@
*/

@ remove home countries ɾ�� n==i ���У�����342��@

depvarpf = delif(depvarp,(impcnty .eq expcnty)); /*ln (Xni/Xn)/(Xii/Xi) ����342��*/
depvarnf = delif(depvarn,(impcnty .eq expcnty)); /* ln(X'ni/X'nn) ����342��*/

xmatf = delif(xmat,(impcnty .eq expcnty)); /* D_{ni} ����342�� */

milef = delif(milevec,(impcnty .eq expcnty)); /* d_k ����342�� */
lmilef = ln(milef); /* ln d_k ����342�� */


"******************************************************************************";
"��򵥵ľع��� theta��";
" ";
" mean(ln (Xbi/Xn)/(Xii/Xi)) ";
meanc(depvarpf);
" ";
" mean(D_ni) ";
meanc(xmatf);
" ";
" �ع���theta��ֱ�ӳ���";
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
dest = delif(impcnty, impcnty .eq expcnty); @��һ�н��ڹ���ȥ��n=i@
srce = delif(expcnty, impcnty .eq expcnty); @�ڶ��г��ڹ���ȥ��n=i@

@ convert Dni to exp(Dni) as in table II @
expxmatf=exp(xmatf); @exp(D_{ni})�����ڱ�2@
x=expxmatf~srce~dest;

z=ones(19,8); @19*8 ȫ1����@

@�ӽ���Ŀ�Ĺ��ĽǶȣ����������Զ�ĳ�����Դ��@
i=1;
do while i <= 19;
	y=selif(x,x[.,3] .eq i); @��ȡ������,������������������ֵ�����ڹ�index������i@
	w=y[.,1];
	z[i,1]=y[minindc(w),2]; @z��1�����ý��ڹ�i��Ӧ��exp(D_{ni})��С�ģ������ڽ��ģ����ڹ�index@
	z[i,2]=minc(w);         @z��2�����ý��ڹ�i��Ӧ����С��exp(D_{ni})@
	z[i,3]=y[maxindc(w),2]; @z��3�����ý��ڹ�i��Ӧ��exp(D_{ni})���ģ�����ңԶ�ģ����ڹ�index@
	z[i,4]=maxc(w);         @z��4�����ý��ڹ�i��Ӧ������exp(D_{ni})@
    i=i+1;
endo;

@�ӳ�����Դ���ĽǶȣ����������Զ�Ľ���Ŀ�Ĺ�@
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


@ÿ�е�index�ǹ���index��Ĭ�ϲ���ʾ��@
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
__con=0; /* �޽ؾ�������Իع� */ 
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
__con=1; /* �нؾ�������Իع� */
call ols(0,depvarpf,xmatf);
" ";
" ";
" *****************************************************************************";
"̽�� ln pi, ln pn, ln dni �Ա�׼��ó�׷ݶ�ķֱ���";
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
__output=0; /*���Բ���ʾ�ع���*/

/*��һ�׶Σ�342�е�Dni�ȶ�342�е�lnd_k��ǧӢ����ع飬myres�ǲв*/
{x1,x2,x3,x4,x5,x6,x7,x8,x9,myres,x11} = ols(0,xmatf,lmilef); 

/* 
 * x3 �ǳ������һ����ϵ���Ĺ�����
 * x4 �ƺ���x��y�����ϵ��  
 *
 * x6 �ƺ�������ϵ���ı�׼�� 
 * x7 ��Residual standard error����MSE���в�ƽ���ͳ���(n-p)����ƽ��������ֵԽС˵��ģ�����Խ�ã�
 * x8 ��x��y��Э�������
 * x9 ��R^2
 * myres �ǲв�
 * x11 �� Durbin-Watson ������
*/


myfit = xmatf-myres; @ģ��Ԥ��ֵ����ƽ�������ϣ��þ�����Ƶ�Dni@
" ";
" myres ";
" ";
" second stage ";

__output=0;

call ols(0,depvarpf,myfit); @�ڶ��׶Σ�������׼��ó�׷ݶ��ٶ� Dni^hat �ع�@


@ do the standard errors right @


x = ones(rows(myfit),1)~xmatf; /* Dniǰ�����һ��1*/
xhat = ones(rows(myfit),1)~myfit; /* Dni_hat ǰ�����һ��1*/
dof = rows(x) - 1; /* ���ɶ�,341 */

{betahat,stdb,eps} = tsls(depvarpf,x,xhat,dof); @tsls�ع飬������Ƕ�����׼��ó�׷ݶ�@

(betahat~stdb);
"";
"";
"include source and destination dummies";


dvars = desdumr~reldumr;
dvars = delif(dvars,(impcnty .eq expcnty));
dvars = lmilef~dvars;

_olsres=1;
__output=0;

{x1,x2,x3,x4,x5,x6,x7,x8,x9,myres,x11} = ols(0,xmatf,dvars); @Dni�ȶ�lnd_k��һ������������ع�@
myfit = xmatf-myres;
" ";
@ myres @

" ";
@ second stage @

__output=0;

call ols(0,depvarpf,myfit); /*�ڶ��׶Σ�������׼��ó�׷ݶ��ٶ� Dni^hat �ع�*/


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
{x1,x2,x3,x4,x5,x6,x7,x8,x9,myres,x11} = ols(0,xmatf,dvars); @��һ�׶�ols�������ΪDni���Ա���Ϊ 30 ʽ����һ��@

myfit = xmatf-myres;
" ";
" myres ";
" "
" second stage ";
"    ";
myfit = myfit~dumvars;

call ols(0,depvarnf,myfit); @�ڶ��׶�ols���Ա���ΪDni_hat�������������ϣ�����Щ�����������Ϊ����������@

" ";
" do the standard errors right ";
x = ones(rows(myfit),1)~xmatf~dumvars;
xhat = ones(rows(myfit),1)~myfit;
dof = rows(x) - 1;
{betahat,stdb,eps} = tsls(depvarnf,x,xhat,dof);
(betahat~stdb); /* ����ϵ�������׼��*/
" ";
" ";
" -----------------------------------------------------------------";
" 2SLS estimate of theta: " betahat[2] "          standard error: " stdb[2];
" ";
"�����5.3�ж� theta �Ĺ���ֵ12.86(1.64)";
" ";
" ";
"*****************************************************************************";
"  Do OLS but include source and destination dummies ";
" ";

dvars = xmatf~dumvars;

call ols(0,depvarnf,dvars);

"�����5.3�ж� theta �Ĺ���ֵ2.44(0.49)";

end;