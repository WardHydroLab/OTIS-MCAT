% Write-out the necessary files for OTIS-P

%These should already be set from running the Monte Carlo simulations
    PRTOPT  = Instate.PRTOPT;                          
    PSTEP   = Instate.PSTEP;                
    TSTEP   = Instate.TSTEP;                 
    TSTART  = Instate.TSTART;                      
    TFINAL  = Instate.TFINAL;                        
    XSTART  = Instate.XSTART;                    
    DSBOUND = Instate.DSBOUND;

    NPRINT  = Instate.NPRINT;
    IOPT    = Instate.IOPT;
    PRINTLOC= Instate.PRINTLOC;

    NREACH  = Instate.NREACH;           
    RCHLEN  = Instate.RCHLEN;
    NSEG    = Instate.NSEG;

    NSOLUTE = Instate.NSOLUTE;
    IDECAY  = Instate.IDECAY;
    ISORB   = Instate.ISORB;

    NBOUND  = Instate.NBOUND;
    IBOUND  = Instate.IBOUND;
    USTIME_USBC = Instate.USTIME_USBC;

    QSTEP   = Instate.QSTEP;
    QSTART  = Instate.QSTART;


%Grab the best-fit parameters based on minimizing RMSE

    %Find the row with the minimum RMSE

    bestrow = min(find(Data.RMSE==min(Data.RMSE)));
    
    DISP  = Pars.DISP(bestrow);
    AREA  = Pars.AREA(bestrow);
    AREA2 = Pars.AREA2(bestrow);
    ALPHA = Pars.ALPHA(bestrow);

    QLATIN = Pars.QLATIN(bestrow);
    QLATOUT = Pars.QLATOUT(bestrow);
    CLATIN = Pars.CLAT(bestrow);

    LAMBDA = Pars.LAM(bestrow);
    LAMBDA2 = Pars.LAM2(bestrow);

    LAMHAT = Pars.LAMHAT(bestrow);
    LAMHAT2 = Pars.LAMHAT2(bestrow);
    RHO = Pars.RHO(bestrow);
    KD = Pars.KD(bestrow);
    CSBACK = Pars.CBGR(bestrow);
    


%open OTIS template and parameter input text files 
%Edit values in the PARAMS.INP text file
template=fopen('params.template', 'rt');
params=fopen('params.inp','wt');

for i=1:107;
    tline = fgetl(template);
        if ~ischar(tline),   break,   end  ;    
    switch i;
        case 19;
            fprintf(params, '%1i\r\n', PRTOPT);
        case 20;
            fprintf(params, '%9f\r\n', PSTEP);
        case 21;
            fprintf(params, '%9f\r\n', TSTEP);
        case 22;
            fprintf(params, '%9f\r\n', TSTART);
        case 23;
            fprintf(params, '%9f\r\n', TFINAL);
        case 24;
            fprintf(params, '%9f\r\n', XSTART);
        case 25;
            fprintf(params, '%9f\r\n', DSBOUND);
        case 26;
            fprintf(params, '%1i\r\n', NREACH);
        case 41;
            fprintf(params, '%5i%13i%13f%13f%13f\r\n', NSEG, RCHLEN, DISP, AREA2, ALPHA);
        case 53;
            fprintf(params, '%5i%5i%5i\r\n', NSOLUTE, IDECAY, ISORB);
        case 63
            if IDECAY~=0
                fprintf(params, '%13f%13f\r\n', LAMBDA, LAMBDA2);
            end
        case 73
            if ISORB~=0
                fprintf(params, '%13i%13f%13f%13f%13f\r\n', LAMHAT, LAMHAT2, RHO, KD, CSBACK);
            end            
        case 85;
            fprintf(params, '%5i%5i\r\n', NPRINT, IOPT);
        case 89;
            fprintf(params, '%f\r\n', PRINTLOC);
        case 103;
            fprintf(params, '%5i%5i\r\n', NBOUND, IBOUND);
        case 107;
            for h=1:length(USTIME_USBC);
                fprintf(params, '%13f%13f\r\n', USTIME_USBC(h,:));
            end;
        otherwise ;   
            fprintf(params, '%s\r\n', tline);
    end;
end;

fclose(template);
fclose(params);


%Edit values in the Q.INP text file
template=fopen('q.template','rt');
discharge=fopen('q.inp','wt');

for i=1:31
    tline = fgetl(template);
        if ~ischar(tline),   break,   end ;     
    switch i;
        case 13;
            fprintf(discharge, '%5i\r\n', QSTEP);
        case 17;
            fprintf(discharge, '%5f\r\n', QSTART);
        case 31;
            fprintf(discharge, '%13f%13f%13f%13f%\r\n',QLATIN,QLATOUT,AREA,CLATIN);
        otherwise;    
            fprintf(discharge, '%s\r\n', tline);
    end
end

fclose(template);
fclose(discharge);



%Edit values in the control.inp file, depending on sorption option
template=fopen('control.template','rt');
control=fopen('control.inp','wt');

for i=1:25
    tline = fgetl(template);
        if ~ischar(tline),   break,   end ;     
    switch i;
        case 25;
            if ISORB>0
                fprintf(control, 'sorbout.out\r\n');
            end
        otherwise;    
            fprintf(params, '%s\r\n', tline);
    end
end

fclose(template);
fclose(control);




%Write out the data.inp file
template=fopen('data.template','rt');
datafile=fopen('data.inp','wt');

for i=1:22
    tline = fgetl(template);
        if ~ischar(tline),   break,   end ;     
    switch i;
        case 20;
            %Print the number of points in the observed file
            fprintf(datafile, '%5i\r\n', length(Data.time));
        case 21;
            %Print all of the observed data just like in the params file
            for h=1:length(Data.time);
                fprintf(datafile, '%13f%13f\r\n', Data.time(h),Data.solute(h));
            end;
        otherwise;    
            fprintf(datafile, '%s\r\n', tline);
    end
end

%print an extra line
fprintf(datafile, '\r\n');

fclose(template);
fclose(datafile);

%Write out the star.inp file
template=fopen('star.template','rt');
starfile=fopen('star.inp','wt');

for i=1:47
    tline = fgetl(template);
        if ~ischar(tline),   break,   end ;     
    switch i;
        case 37;
            
            if DISPMIN==DISPMAX
                %fixed
                fprintf(starfile,'1    0.0D0             | Dispersion Coefficient, DISP\r\n');
            else
                %variable
                fprintf(starfile,'0    0.0D0             | Dispersion Coefficient, DISP\r\n');
            end
            
        case 38;
            
            if AMIN==AMAX
                %fixed
                fprintf(starfile,'1    0.0D0             | Main Channel Cross-Sectional Area, AREA\r\n');
            else
                %variable
                fprintf(starfile,'0    0.0D0             | Main Channel Cross-Sectional Area, AREA\r\n');
            end
            
        case 39;
            
            if AREA2MIN==AREA2MAX
                %fixed
                fprintf(starfile,'1    0.0D0             | Storage Zone Cross-Sectional Area, AREA2\r\n');
            else
                %variable
                fprintf(starfile,'0    0.0D0             | Storage Zone Cross-Sectional Area, AREA2\r\n');
            end            
            
        case 40;
            
            if ALPHAMIN==ALPHAMAX
                %fixed
                fprintf(starfile,'1    0.0D0             | Storage Zone Exchange Coeffiecient, ALPHA\r\n');
            else
                %variable
                fprintf(starfile,'0    0.0D0             | Storage Zone Exchange Coeffiecient, ALPHA\r\n');
            end                
            
        case 41;
            
            if LAMMIN==LAMMAX
                %fixed
                fprintf(starfile,'1    0.0D0             | Main Channel First-Order Decay Coefficient, LAMBDA\r\n');
            else
                %variable
                fprintf(starfile,'0    0.0D0             | Main Channel First-Order Decay Coefficient, LAMBDA\r\n');
            end             
            
        case 42;
            
            if LAM2MIN==LAM2MAX
                %fixed
                fprintf(starfile,'1    0.0D0             | Storage Zone First-Order Decay Coefficient, LAMBDA2\r\n');
            else
                %variable
                fprintf(starfile,'0    0.0D0             | Storage Zone First-Order Decay Coefficient, LAMBDA2\r\n');
            end    
            
        case 43;
            
            if RHOMIN==RHOMAX
                %fixed
                fprintf(starfile,'1    0.0D0             | Mass of Accessbile Sediment/Volume Water, RHO\r\n');
            else
                %variable
                fprintf(starfile,'0    0.0D0             | Mass of Accessbile Sediment/Volume Water, RHO\r\n');
            end    
            
        case 44;
            
            if KDMIN==KDMAX
                %fixed
                fprintf(starfile,'1    0.0D0             | Distribution Coefficient, KD\r\n');
            else
                %variable
                fprintf(starfile,'0    0.0D0             | Distribution Coefficient, KD\r\n');
            end    
            
        case 45;
            
            if LAMHATMIN==LAMHATMAX
                %fixed
                fprintf(starfile,'1    0.0D0             | Main Channel Sorption Rate Coefficient, LAMHAT\r\n');
            else
                %variable
                fprintf(starfile,'0    0.0D0             | Main Channel Sorption Rate Coefficient, LAMHAT\r\n');
            end   
            
        case 46;
            
            if LAMHAT2MIN==LAMHAT2MAX
                %fixed
                fprintf(starfile,'1    0.0D0             | Storage Zone Sorption Rate Coefficient, LAMHAT2\r\n');
            else
                %variable
                fprintf(starfile,'0    0.0D0             | Storage Zone Sorption Rate Coefficient, LAMHAT2\r\n');
            end               
            
        otherwise;    
            fprintf(starfile, '%s\r\n', tline);
    end
end

fclose(template);
fclose(starfile);


