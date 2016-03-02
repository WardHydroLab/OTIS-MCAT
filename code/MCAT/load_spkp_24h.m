% load the data in order to use MCAT
clear all;
disp('load data of spkp1/24hour ...' );

disp('  load parameter');
[tmp tmp1 spkp1.snpars(:,1) spkp1.snpars(:,2) spkp1.snpars(:,3) spkp1.snpars(:,4) spkp1.snpars(:,5) ...
    spkp1.pars(:,1) spkp1.pars(:,2) spkp1.pars(:,3) spkp1.pars(:,4) spkp1.pars(:,5) ...
    spkp1.pars(:,6) spkp1.pars(:,7) spkp1.pars(:,8) spkp1.pars(:,9) spkp1.pars(:,10) ...
    spkp1.pars(:,11) spkp1.pars(:,12) spkp1.pars(:,13)]=textread('../24h/output/output.par', ...
    '%u%u%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',30000,'headerlines',1);
clear tmp tmp1;

disp('  load objectives');
[tmp tmp1 tmp2 tmp3 spkp1.crit(:,1),spkp1.crit(:,2)] ...
    =textread('../24h/output/output.hyd','%u%u%u%u%f%f','headerlines',1);
clear tmp tmp1 tmp2 tmp3;

spkp1.vars=[];


spkp1.mct=[];
spkp1.obs=[];

disp('  load others');
spkp1.pao = [];
spkp1.id = 'spkp1_24h';
spkp1.snpstr = str2mat('SCF','MFMAX','MFMIN','UADJ','SI');%snow model parameters
spkp1.pstr = str2mat('uztwm','uzfwm','uzk','pctim','adimp','zperc','rexp','lztwm', ...
    'lzfsm','lzfpm','lzsk','lzpk','pfree');
spkp1.cstr = str2mat('RMSE','TRMSE');
spkp1.vstr=[];
spkp1.dt=1440;
spkp1.t=[];

disp('  load parameter');
[tmp tmp1 spkp2.snpars(:,1) spkp2.snpars(:,2) spkp2.snpars(:,3) spkp2.snpars(:,4) spkp2.snpars(:,5) ...
    spkp2.pars(:,1) spkp2.pars(:,2) spkp2.pars(:,3) spkp2.pars(:,4) spkp2.pars(:,5) ...
    spkp2.pars(:,6) spkp2.pars(:,7) spkp2.pars(:,8) spkp2.pars(:,9) spkp2.pars(:,10) ...
    spkp2.pars(:,11) spkp2.pars(:,12) spkp2.pars(:,13)]=textread('../24h/output/output.par', ...
    '%u%u%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',30000,'headerlines',30001);
clear tmp tmp1;

disp('  load objectives');
[tmp tmp1 tmp2 tmp3 spkp2.crit(:,1),spkp2.crit(:,2)] ...
    =textread('../24h/output/output.hyd','%u%u%u%u%f%f','headerlines',1);
clear tmp tmp1 tmp2 tmp3;

spkp2.vars=[];


spkp2.mct=[];
spkp2.obs=[];

disp('  load others');
spkp2.pao = [];
spkp2.id = 'spkp2_24h';
spkp2.snpstr = str2mat('SCF','MFMAX','MFMIN','UADJ','SI');%snow model parameters
spkp2.pstr = str2mat('uztwm','uzfwm','uzk','pctim','adimp','zperc','rexp','lztwm', ...
    'lzfsm','lzfpm','lzsk','lzpk','pfree');
spkp2.cstr = str2mat('RMSE','TRMSE');
spkp2.vstr=[];
spkp2.dt=1440;
spkp2.t=[];

disp('  load parameter');
[tmp tmp1 spkp3.snpars(:,1) spkp3.snpars(:,2) spkp3.snpars(:,3) spkp3.snpars(:,4) spkp3.snpars(:,5) ...
    spkp3.pars(:,1) spkp3.pars(:,2) spkp3.pars(:,3) spkp3.pars(:,4) spkp3.pars(:,5) ...
    spkp3.pars(:,6) spkp3.pars(:,7) spkp3.pars(:,8) spkp3.pars(:,9) spkp3.pars(:,10) ...
    spkp3.pars(:,11) spkp3.pars(:,12) spkp3.pars(:,13)]=textread('../24h/output/output.par', ...
    '%u%u%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',30000,'headerlines',60001);
clear tmp tmp1;

disp('  load objectives');
[tmp tmp1 tmp2 tmp3 spkp3.crit(:,1),spkp3.crit(:,2)] ...
    =textread('../24h/output/output.hyd','%u%u%u%u%f%f','headerlines',1);
clear tmp tmp1 tmp2 tmp3;

spkp3.vars=[];


spkp3.mct=[];
spkp3.obs=[];

disp('  load others');
spkp3.pao = [];
spkp3.id = 'spkp3_24h';
spkp3.snpstr = str2mat('SCF','MFMAX','MFMIN','UADJ','SI');%snow model parameters
spkp3.pstr = str2mat('uztwm','uzfwm','uzk','pctim','adimp','zperc','rexp','lztwm', ...
    'lzfsm','lzfpm','lzsk','lzpk','pfree');
spkp3.cstr = str2mat('RMSE','TRMSE');
spkp3.vstr=[];
spkp3.dt=1440;
spkp3.t=[];

save('spkp_24h.mat');