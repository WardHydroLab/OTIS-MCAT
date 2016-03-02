% load the data in order to use MCAT
clear all;
disp('load data of sxtp1/24hour ...' );

disp('  load parameter');
[tmp tmp1 sxtp1.snpars(:,1) sxtp1.snpars(:,2) sxtp1.snpars(:,3) sxtp1.snpars(:,4) sxtp1.snpars(:,5) ...
    sxtp1.pars(:,1) sxtp1.pars(:,2) sxtp1.pars(:,3) sxtp1.pars(:,4) sxtp1.pars(:,5) ...
    sxtp1.pars(:,6) sxtp1.pars(:,7) sxtp1.pars(:,8) sxtp1.pars(:,9) sxtp1.pars(:,10) ...
    sxtp1.pars(:,11) sxtp1.pars(:,12) sxtp1.pars(:,13)]=textread('../24h/output/output.par', ...
    '%u%u%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',30000,'headerlines',1);
clear tmp tmp1;

disp('  load objectives');
[tmp tmp1 tmp2 tmp3 sxtp1.crit(:,1),sxtp1.crit(:,2)] ...
    =textread('../24h/output/output.hyd','%u%u%u%u%f%f','headerlines',1);
clear tmp tmp1 tmp2 tmp3;

sxtp1.vars=[];


sxtp1.mct=[];
sxtp1.obs=[];

disp('  load others');
sxtp1.pao = [];
sxtp1.id = 'sxtp1_24h';
sxtp1.snpstr = str2mat('SCF','MFMAX','MFMIN','UADJ','SI');%snow model parameters
sxtp1.pstr = str2mat('uztwm','uzfwm','uzk','pctim','adimp','zperc','rexp','lztwm', ...
    'lzfsm','lzfpm','lzsk','lzpk','pfree');
sxtp1.cstr = str2mat('RMSE','TRMSE');
sxtp1.vstr=[];
sxtp1.dt=1440;
sxtp1.t=[];

disp('  load parameter');
[tmp tmp1 sxtp2.snpars(:,1) sxtp2.snpars(:,2) sxtp2.snpars(:,3) sxtp2.snpars(:,4) sxtp2.snpars(:,5) ...
    sxtp2.pars(:,1) sxtp2.pars(:,2) sxtp2.pars(:,3) sxtp2.pars(:,4) sxtp2.pars(:,5) ...
    sxtp2.pars(:,6) sxtp2.pars(:,7) sxtp2.pars(:,8) sxtp2.pars(:,9) sxtp2.pars(:,10) ...
    sxtp2.pars(:,11) sxtp2.pars(:,12) sxtp2.pars(:,13)]=textread('../24h/output/output.par', ...
    '%u%u%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',30000,'headerlines',30001);
clear tmp tmp1;

disp('  load objectives');
[tmp tmp1 tmp2 tmp3 sxtp2.crit(:,1),sxtp2.crit(:,2)] ...
    =textread('../24h/output/output.hyd','%u%u%u%u%f%f','headerlines',1);
clear tmp tmp1 tmp2 tmp3;

sxtp2.vars=[];


sxtp2.mct=[];
sxtp2.obs=[];

disp('  load others');
sxtp2.pao = [];
sxtp2.id = 'sxtp2_24h';
sxtp2.snpstr = str2mat('SCF','MFMAX','MFMIN','UADJ','SI');%snow model parameters
sxtp2.pstr = str2mat('uztwm','uzfwm','uzk','pctim','adimp','zperc','rexp','lztwm', ...
    'lzfsm','lzfpm','lzsk','lzpk','pfree');
sxtp2.cstr = str2mat('RMSE','TRMSE');
sxtp2.vstr=[];
sxtp2.dt=1440;
sxtp2.t=[];

disp('  load parameter');
[tmp tmp1 sxtp3.snpars(:,1) sxtp3.snpars(:,2) sxtp3.snpars(:,3) sxtp3.snpars(:,4) sxtp3.snpars(:,5) ...
    sxtp3.pars(:,1) sxtp3.pars(:,2) sxtp3.pars(:,3) sxtp3.pars(:,4) sxtp3.pars(:,5) ...
    sxtp3.pars(:,6) sxtp3.pars(:,7) sxtp3.pars(:,8) sxtp3.pars(:,9) sxtp3.pars(:,10) ...
    sxtp3.pars(:,11) sxtp3.pars(:,12) sxtp3.pars(:,13)]=textread('../24h/output/output.par', ...
    '%u%u%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',30000,'headerlines',60001);
clear tmp tmp1;

disp('  load objectives');
[tmp tmp1 tmp2 tmp3 sxtp3.crit(:,1),sxtp3.crit(:,2)] ...
    =textread('../24h/output/output.hyd','%u%u%u%u%f%f','headerlines',1);
clear tmp tmp1 tmp2 tmp3;

sxtp3.vars=[];


sxtp3.mct=[];
sxtp3.obs=[];

disp('  load others');
sxtp3.pao = [];
sxtp3.id = 'sxtp3_24h';
sxtp3.snpstr = str2mat('SCF','MFMAX','MFMIN','UADJ','SI');%snow model parameters
sxtp3.pstr = str2mat('uztwm','uzfwm','uzk','pctim','adimp','zperc','rexp','lztwm', ...
    'lzfsm','lzfpm','lzsk','lzpk','pfree');
sxtp3.cstr = str2mat('RMSE','TRMSE');
sxtp3.vstr=[];
sxtp3.dt=1440;
sxtp3.t=[];

save('sxtp_24h.mat');