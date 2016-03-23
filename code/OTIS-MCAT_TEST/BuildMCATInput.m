%Set-up MCAT Input Vectors

%USE LOGIC TO BUILD THE INPUT FILES, DEPENDING ON WHAT WAS VARIED MCAT

%Parameters
%pars = parameter values
%pstr = strings of parameter names

%initialize
pars=[];
pstr=[];

%Test varaible-by-variable to see what was varied, and build the
%input file accordingly
if DISPMIN~=DISPMAX
    parname=['DISP'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
    
end

if AMIN~=AMAX
    parname=['AREA'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end

if AREA2MIN~=AREA2MAX
    parname=['AREA2'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end

if ALPHAMIN~=ALPHAMAX
    parname=['ALPHA'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end

if LAMMIN~=LAMMAX
    parname=['LAM'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end

if LAM2MIN~=LAM2MAX
    parname=['LAM2'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end

if RHOMIN~=RHOMAX
    parname=['RHO'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end

if KDMIN~=KDMAX
    parname=['KD'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end


if LAMHATMIN~=LAMHATMAX
    parname=['LAMHAT'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end

if LAMHAT2MIN~=LAMHAT2MAX
    parname=['LAMHAT2'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end


if QLATINMIN~=QLATINMAX
    parname=['QLATIN'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end

if QLATOUTMIN~=QLATOUTMAX
    parname=['QLATOUT'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end

if CLATMIN~=CLATMAX
    parname=['CLAT'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end

if CBGRMIN~=CBGRMAX
    parname=['CBGR'];
    
    if log10(max(Pars.(parname)))-log10(min(Pars.(parname))) > 1
        %use the log-transformed values
        pars=[pars log10(Pars.(sprintf('%s',parname)))];
        pstr=str2mat(pstr,sprintf('log10(%s)',parname));
    else
        %use the unedited values
        pars=[pars Pars.(sprintf('%s',parname))];
        pstr=str2mat(pstr,parname);
    end
end

pstr=pstr(2:end,:);

% MC criteria matrix [no. of sims x no. of criteria]
crit= [ Data.RMSE Data.oppR2 Data.RMSElog Data.oppR2log Data.M1...
    Data.M1norm Data.mu2 Data.mu2norm Data.mu3 Data.mu3norm Data.skewness...
    Data.skewnessnorm Data.appdispersivity Data.appdispersion Data.Holdback...
    Data.t05 Data.t10 Data.t25 Data.t50 Data.t75 Data.t90 Data.t95 Data.t99...
    Data.t05norm Data.t10norm Data.t25norm Data.t50norm Data.t75norm Data.t90norm Data.t95norm...
    Data.tpeak Data.cpeak Data.cpeaknorm];

% MC variable matrix [no. of sims x no. of pars]
vars=[];

% MC ouput time-series matrix [no. of sims x no. of samples]
%leave blank if timeseries not saved
mct=[];

%point to BTC outcomes if they were saved
if BTCFLAG==1
    mct=MOD;
end

% Pareto population
pao=[];

% observed time-series vector [no. of samples x 1]
obs=Data.OBSERVATION.DSCONC;

% descriptor [string]
id='OTIS Simulation';

% criteria names [string matrix - use str2mat to create]
cstr=str2mat('RMSE','Opp. r2','log RMSE','log R2','M1','M1norm','mu2',...
    'mu2norm','mu3','mu3norm','skewness','skewnessnorm','App. Dispersivity',...
    'App. Dispersion','Holdback','t05','t10','t25','t50','t75','t90','t95','t99',...
    't05norm','t10norm','t25norm','t50norm','t75norm','t90norm','t95norm',...
    't at Peak','C peak','Cnorm Peak');



%USER SELECTION OF METRICS
    if METRICS==0
        disp('All metrics being input to MCAT')
        a=size(cstr,1);
    elseif METRICS==1
        % Get objective functions:
        disp('Pick 10 objective functions to evaluate in MCAT:');
        disp('1. RMSE       2. r2 (transf)    3. log RMSE;  4. log R2')
        disp('5.M1;         6.M1norm          7. mu2       8. mu2norm')
        disp('9. mu3;       10. mu3norm       11. skewness 12. skewnessnorm')
        disp('13. App. Dispersivity           14. App. Dispersion');
        disp('15. Holdback; 16. t05           17. t10;      18. t25');
        disp('19. t50       20. t75           21. t90;      22. t95');
        disp('23. t99       24. t05norm       25. t10norm  26. t25norm');
        disp('27. t50norm   28. t75norm       29. t90norm   30. t95norm'); 
        disp('31. t at Peak     32. C peak    33. Cnorm Peak');
        disp('Select up to 10 objective functions for MCAT analysis:');
        disp('(Leave field blank and press return to skip a field and include less than 10 objective functions)');
        in1 = input('Objective function 1: ');
        in2 = input('Objective function 2: ');
        in3 = input('Objective function 3: ');
        in4 = input('Objective function 4: ');
        in5 = input('Objective function 5: ');
        in6 = input('Objective function 6: ');
        in7 = input('Objective function 7: ');
        in8 = input('Objective function 8: ');
        in9 = input('Objective function 9: ');
        in10 = input('Objective function 10: ');
        a = horzcat(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10);
        crit = crit(:,a);
        cstr = cstr(a,:);
    end

%cstr=str2mat('RMSE','Opp. r2','log RMSE','log R2');
% variable names [string matrix - use str2mat to create] - NOT USED
vstr=str2mat();

% sampling interval - NOT USED b/c we read in the actual times in case it is unequal spacing
dt=[1];

% time vector if irregularly spaced samples
t=Data.OBSERVATION.DSTIME;

