@                         SIMPRM2X.PRG                             @
@                                                                  @
@                                                                  @
@                           8/19/98                                @
@                                                                  @
@   program to run Non-parametric trade regressions on 1990 data   @
@   and save the results for our simulations and tables            @
@                                                                  @
@                                                                  @
@   this program performs the non-parametric trade regressions     @
@   described in section 5.1, and generates the results found      @
@   in tables III, VI, and VII                                     @
@                                                                  @



new;
output file = ".\simprm2x.out" reset;
cls;


" ***** ";


" s = ratio of sigs2/sigd2 ";
s = 0;




ncnty = 19;
nyear=1;
myyear = 20;    @ The first year is 1971 and the last (20th) is 1990 @
@ myyear = 10; @

n1=(ncnty^2)*(myyear-1) + 1;
nn=(ncnty^2)*myyear;


"  ***** ";
" MYYEAR = " myyear;
" INCLUDES TALK, EU, and EFTA ";
" ***** ";

loadm trade1 = "./trade1.fmt";
trade1 = trade1[n1:nn,.];

loadm trade2 = "./trade2.fmt";
trade2 = trade2[n1:nn,.];

impcnty = trade1[.,1];
expcnty = trade1[.,2];
depvar = trade1[.,4];
depvarn = trade1[.,5];
dist1 = trade1[.,6];
dist2 = trade1[.,7];
dist3 = trade1[.,8];
dist4 = trade1[.,9];
dist5 = trade1[.,10];
dist6 = trade1[.,11];
border = trade1[.,12];
lrrnd = trade1[.,13];
lrhk = trade1[.,14];
lrwork = trade1[.,16];
lrwage = trade1[.,17];


mybeta = .21221;
mytheta1 = 8.28;
mytheta2 = 3.60;
mytheta3 = 12.86;

" ";
" ********************** ";
"mytheta1 = " mytheta1;
"mytheta2 = " mytheta2;
"mytheta3 = " mytheta3;
" ********************** "
" ";


@ adjust wage and labor for skills @

hk = trade2[1:ncnty,6]; /* 19�����ҵ� edu_year*/
mywage = exp(lrwage[1:ncnty]); @ relative to Australia @
mywage = mywage.*(exp(-.06*hk)); /* ��� */
mylrnd = lrrnd[1:ncnty];


@ technology implied by parametric regression @
partech = mybeta*(1.09399*mylrnd - 22.7*(1/hk));
partech = exp(partech);
partech = partech/partech[ncnty];
usresid = -.57788;
partech = partech*exp(-mybeta*usresid);

@ Create common language variable @

@          AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   @
english = {1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1};
french =  {0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
german =  {0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
talk = vec(english*english' + french*french' + german*german');
talk = ones(20,1).*.talk;

@ Create country trade blocks @

@          AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   @
eu71 =    {0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0};
eu73 =    {0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0};
eu81 =    {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
eu86 =    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0};
eu7172 = ones(2,1).*.vec(eu71*eu71');
eu7380 = ones(8,1).*.vec((eu71+eu73)*(eu71+eu73)');
eu8185 = ones(5,1).*.vec((eu71+eu73+eu81)*(eu71+eu73+eu81)');
eu8690 = ones(5,1).*.vec((eu71+eu73+eu81+eu86)*(eu71+eu73+eu81+eu86)');
eu = eu7172|eu7380|eu8185|eu8690;

@          AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   @
ef71 =    {0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0};
ef73 =    {0, 0, 0, 0,-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,-1, 0};
ef86 =    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,-1,-1, 0, 0, 0};
ef7172 = ones(2,1).*.vec(ef71*ef71');
 ef7385 = ones(13,1).*.vec((ef71+ef73)*(ef71+ef73)');
ef8690 = ones(5,1).*.vec((ef71+ef73+ef86)*(ef71+ef73+ef86)');
ef = ef7172|ef7385|ef8690;

euef7172 = ones(2,1).*.vec(eu71*ef71' + ef71*eu71');
temp7380 = (eu71+eu73)*(ef71+ef73)' + (ef71+ef73)*(eu71+eu73)';
euef7380 = ones(8,1).*.vec(temp7380);
temp8185 = (eu71+eu73+eu81)*(ef71+ef73)' + (ef71+ef73)*(eu71+eu73+eu81)';
euef8185 = ones(5,1).*.vec(temp8185);
temp8690 = (eu71+eu73+eu81+eu86)*(ef71+ef73+ef86)'
          + (ef71+ef73+ef86)*(eu71+eu73+eu81+eu86)';
euef8690 = ones(5,1).*.vec(temp8690);
euef = euef7172|euef7380|euef8185|euef8690;


@          AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   @
cp71   =  {1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0};
uk     =  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0};
cp73 =    {-1,0, 0,-1, 0, 0, 0, 0, 0, 0, 0, 0,-1, 0, 0, 0, 0,-1, 0};
cp7172 = ones(2,1).*.vec(cp71*uk' + uk*cp71');
cp7390 = ones(18,1).*.vec((cp71+cp73)*uk' + uk*(cp71+cp73)');
cp = cp7172|cp7390;

tblock = eu~ef;

@          AL AU BE CA DE FI FR GE GR IT JA NE NZ NO PO SP SW UK US   @
alnz0  =  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0};
alnz = ones(20,1).*.vec(alnz0*alnz0');

tblock = tblock[n1:nn,.];
talk   = talk[n1:nn,.];
alnz   = alnz[n1:nn,.];

@Create the source and destination dummy variables@
onecnty = ones(ncnty,1);
desdum = ones(nyear,1).*.(eye(ncnty).*.onecnty);
srcdum = ones(nyear,1).*.(onecnty.*.eye(ncnty));
reldum = srcdum-desdum;

desdumr = desdum[.,1:(ncnty-1)]-desdum[.,ncnty];
reldumr = reldum[.,1:(ncnty-1)]-reldum[.,ncnty];



/* ncnty = 3; */ 

@proc to calculate country pair time averages@
/* ����� n*(n-1) �еľ�����������൱��û���κα仯!*/
proc order2(datf);
   local avar,i,var,varmat,adatf;
     adatf = ones((ncnty*(ncnty-1)),cols(datf)); /* ����һ��ռλ���� */
     i = 1;
     do while i <= cols(datf);
        var = datf[.,i];
        varmat = reshape(var,nyear,(ncnty*(ncnty-1))); /* ת�ã�ԭ����ĵ�n�б�Ϊ�������� */
        adatf[.,i] = meanc(varmat); /* �о�ֵ�����м��ܣ��ֱ������ */
        i = i+1;
     endo;
   retp(adatf);
endp;

/*
aa = {1 2, 3 4, 5 6, 7 8, 9 10, 11 12};
aa;
order2(aa);
*/


ncnty = 19;

@ Procedure to do gls @
proc(7)=gls(y,x,icov,dof); /* ��ȫû���õ����ĸ����� */
    local betahat,eps,sighat2,varcov,stdb,srcus,stdsrcus,dstus,stddstus;

    /* icov �����Э�������������*/
    betahat = inv(x'*icov*x)*x'*icov*y; 
    eps = y - x*betahat; /* �в������������ò��� */
    print "Raw SS in this regression " eps'*eps; 
    print "Adjusted SS " eps'*icov*eps;
    varcov = inv(x'*icov*x);  /* GLS��������Э������� */

    /* Next, we get the variance for the usa in GLS */
    print "source effect: usa=";
    srcus = -ones(1,18)*betahat[11:28]; /*S1��S18������-1�ټ�����*/
	/* ��Ϊ����OLSʱ��ǰ18����ϵ�������������Ǽ�ȥ������S1�ǰĴ����Ǽ�����, ... */
	/* ����ȫ��չ����������ϵ������ -(S1+S2+..+S18) */
    srcus;


   @ print "source effect: stdb(usa)="; @
    stdsrcus = sqrt(ones(1,18)*varcov[11:28,11:28]*ones(1,18)');  
	/* ������Э������S1��S18��Э�������ļ������� */
	
   @ print "destination effect: usa="; @ /*m1��m18������-1�ټ�����*/
    dstus = -ones(1,18)*betahat[29:46];
	
   @ print "destination effect: stdb(usa)="; @
    stddstus = sqrt(ones(1,18)*varcov[29:46,29:46]*ones(1,18)');
	 
    stdb = sqrt(diag(varcov)); /*ֻȡ���Խ�Ԫ��Ϊһ����������ȡƽ����������GLS�������ı�׼��*/
    retp(betahat,stdb,eps,srcus,stdsrcus,dstus,stddstus); /* �ֱ���GLSϵ������׼��в�Լ�����������*/
endp;


@ Procedure to construct the correlation between dresid and usa @
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



dist = dist1~dist2~dist3~dist4~dist5~dist6~border;
dist = dist~talk~tblock;

xmat = dist~reldumr~desdumr;

@ remove home countries @
depvarnf = delif(depvarn,(impcnty .eq expcnty));
xmatf = delif(xmat,(impcnty .eq expcnty));



adepvarnf = order2(depvarnf); /* ������ȫһ����û���κα任 */
axmatf = order2(xmatf); /* ������ȫһ����û���κα任 */

"  ";
"         **********************(30) ʽOLS********************************** ";
"*********";
/* __output=0; */
__con=0;
_olsres=1;

{ nam,m,b1,stb,vc,std,sig,ex,rsq,resid,dbw } = ols(0,adepvarnf,axmatf);

"**********************************************************";
resid;


"*********";
ee=resid*resid'; /* 342*342 OLS�в����*/

/* I now need to compute the estimates for the values for the parameters
   of the variance-covariance matrix by taking averages of corresponding
   elements of ee matrix. Here I use an algorithm similar to the one
   I used in constructing the variance-covariance matrix. 
   ȡ ee ������ӦԪ�ص�ƽ��ֵ��Ϊ���Э�������Ĺ���ֵ��
   */

/* I start by creating a matrix r with I column impcnty subscript
   II column expcnty subscript and III column the matrix row number . The
   covariance matrix ( which includes home country obs) will have
   ncnty*ncnty row and columns 
   ����r����һ���ǽ��ڹ��±꣬�ڶ����ǳ��ڹ��±꣬���������кš�
   Э���������n��n��
*/


/* proc to create the weighting var-covariance matrix for GLS */
/* ����Ȩ�ؾ��� */
proc(3)=vinvs1(ee);
local n,i,r,c,p,q,sigdiag,sigss,indxss,sigds,indxds,sigdo,indxdo,sigso,
   indxso,sigun,indxun,sigeps2,sigu2,siggama2,sigs2,sigd2,vinvs,indxdiag,
   v,gama2,u2;

    n = 1; i = 1; p = 1; 
    r = zeros( ncnty*(ncnty-1), 3); /*��һ���ǽ��ڹ��±꣬�ڶ����ǳ��ڹ��±꣬��������Ȩ�ؾ���չ��Ϊ�������к�*/

   do while n <= ncnty;
      do while i <= ncnty;
        if ( n /= i );
            r[p,1] = n; r[p,2] = i; r[p,3] = p;
            p = p + 1;
        endif;
        i = i + 1;
      endo;
      i = 1;
      n = n + 1;
   endo;
   /* print r;*/ /* 342 ��*/

   /* Create a clone of r matrix */
   c = r;

   p = 1; q = 1; sigdiag=0; indxdiag=0;  sigdo=0; indxdo=0;  sigun=0; indxun=0;
   
   do while p <= ncnty*(ncnty-1);
     do while q <= ncnty*(ncnty-1);

        if p==q; sigdiag=ee[p,q]+sigdiag; indxdiag=indxdiag+1;
        /*Diagonal elements �Խ�Ԫ�أ��ǲв�ƽ�����ۼ�*/

        elseif ( r[p,1]==c[q,2] and  r[p,2]==c[q,1] );
        sigdo=ee[p,q]+sigdo; indxdo=indxdo+1;
        /*Double Opposite ��n��i���i��n����Э����*/
        /*��p=1����Ӧn=1, i=2�����Ӧ��qΪ19, n=2, i=1*/
        /*��p=2����Ӧn=1, i=3�����Ӧ��qΪ37, n=3, i=1*/
        /*����342����n��i��������ұ����걸������ÿ��p���ҽ���һ��q��֮��Ӧ*/

        else;
        sigun=ee[p,q]+sigun; indxun=indxun+1;
        /*��������Ϊ���� Uncorrelated */

        endif;
        q = q +1;
     endo;
     q = 1;
     p = p + 1;
    endo;

    /* Get means from the totals */

    sigdiag=sigdiag/indxdiag; /* �ۼƳ���������Ϊ342�����ƽ���͵ľ�ֵ�������еĵ�һ����� */
    sigdo=sigdo/indxdo; /* (n<-i)��(i<-n)�в�Э����ľ�ֵ�������еĵڶ������ */

    " ";
    print "sigdiag=" sigdiag "number of elements=" indxdiag;
    print "sigdo=  " sigdo "number of elements=" indxdo;

    /* Derive parameters of Variance-Covariance Matrix */

    siggama2 = sigdo;
    sigu2 = sigdiag-siggama2;
   
    print "siggama2= " siggama2;
    print "sigu2= " sigu2;
   /* print "siggama2= " siggama2;
    print "sigu2= " sigu2;
    print "sigeps2= " sigeps2;
    print "sigd2= " sigd2;
    print "sigs2= " sigs2; */

    sigeps2=0; sigd2=0; sigs2=0;

    
    " ";
    /* Now I construct the variance-covariance matrix ���������Э�������*/

    p = 1; q = 1; v=zeros(ncnty*(ncnty-1),ncnty*(ncnty-1));

    do while p <= ncnty*(ncnty-1);
     do while q <= ncnty*(ncnty-1);

        if p==q; v[p,q]=sigdiag;
        /*Diagonal elements */

        elseif ( r[p,1]==c[q,2] and  r[p,2]==c[q,1] );
        v[p,q]=sigdo;
        /*Double Opposite*/

        endif;
        q = q +1;
     endo;
     q = 1;
     p = p + 1;
    endo;

    /* invert the matrix using positive definite inverse */
    vinvs=invpd(v); /*����*/
    gama2=siggama2; u2=sigu2;
  retp(vinvs,gama2,u2);
endp;


{vinv,gama2,u2}=vinvs1(ee); /* ͨ��vinvs1() ������� gls ��������ĵ��������� vinv */
dof =  rows(adepvarnf) - cols(axmatf); /* ���ĸ����������ɶ� */


"          ******************* GLS  Estimation ********************* ";
/* �����췽��ʱ��Ҫʹ�ù�����С���˷� */
" ";
" Table III ";
" ";

/*gls�������ĸ�������ǰ�����Ǿ�������ı����ͱ����ͽ��ͱ�����
�������Ǽ�Ȩ����-Э������󣬵��ĸ������ɶ�*/
{betahat,stdb,eps,srcus,stdsrcus,dstus,stddstus}=gls(adepvarnf,axmatf,vinv,dof); 
betahatx = betahat[1:28,.]|srcus|betahat[29:46,.]|dstus; /*srcus��dstus��������src��dstϵ�������ǻ�׼��������������ڽ��ͱ�����*/
stdbx = stdb[1:28,.]|stdsrcus|stdb[29:46,.]|stddstus;
/*
betahatx = round(100*betahatx)./100;
stdbx = round(100*stdbx)./100;
*/
print betahatx~stdbx;
" ";





"                        **********************";



nparmfe = rows(b1);
ndist = cols(dist);

usa2=-sumc(betahat[(nparmfe-ncnty+2):nparmfe,.]);
print "F.E. usa destination effect" usa2;


distance2=dist*betahat[1:ndist,.];
distmat2=reshape(distance2,ncnty,ncnty);
distmat2=distmat2+(betahat[(nparmfe-ncnty+2):nparmfe,.]|usa2)*ones(1,ncnty);
distmat2=diagrv(distmat2,zeros(19,1));

source2=zeros(19,1);
source2[1:18,1]=betahat[(ndist+1):(ndist+ncnty-1),.];

source2[19,1]=-sumc(source2);

@ Save results for SIMDATA.PRG and in turn for EQUIL.PRG @
temp2=source2~distmat2;
@ save temp2;  @

@ print out some data @;
"source effects as estimated";
lmuvec = source2;
lmuvec;



techvec1 = mybeta*(lmuvec + mytheta1*ln(mywage));
techvec1 = exp(techvec1);
techvec1 = techvec1/techvec1[ncnty];

techvec2 = mybeta*(lmuvec + mytheta2*ln(mywage));
techvec2 = exp(techvec2);
techvec2 = techvec2/techvec2[ncnty];

techvec3 = mybeta*(lmuvec + mytheta3*ln(mywage));
techvec3 = exp(techvec3);
techvec3 = techvec3/techvec3[ncnty];

format 8,5;


partech = round(100*partech)/100;
source2 = round(100*source2)/100;
techvec1 = round(100*techvec1)/100;
techvec2 = round(100*techvec2)/100;
techvec3 = round(100*techvec3)/100;



" ";
" Technology Table (Table VI) ";
" source2, technology1, technology2, technology3 ";
source2~techvec1~techvec2~techvec3;


dvec=betahat[1:ndist,.]|betahat[(nparmfe-ncnty+2):nparmfe,.]|usa2;
dvec1 = 100*(exp(-dvec/mytheta1) - 1); /* ����theta ���Ƕ� ln dni ��ϵ���� 29ʽ*/
dvec2 = 100*(exp(-dvec/mytheta2) - 1);
dvec3 = 100*(exp(-dvec/mytheta3) - 1);

dvec = round(100*dvec)/100;
dvec1 = round(100*dvec1)/100;
dvec2 = round(100*dvec2)/100;
dvec3 = round(100*dvec3)/100;


" ";
" Impediments Table (Table VII) ";
" parameters,  dvec1, dvec2, dvec3 ";
dvec~dvec1~dvec2~dvec3;

end;
























