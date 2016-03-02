function Model = OTIS(Instate, Pars, n, OSFLAG)

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




%Grab set "n" of Monte Carlo parameters
    DISP  = Pars.DISP(n);
    AREA  = Pars.AREA(n);
    AREA2 = Pars.AREA2(n);
    ALPHA = Pars.ALPHA(n);

    QLATIN = Pars.QLATIN(n);
    QLATOUT = Pars.QLATOUT(n);
    CLATIN = Pars.CLAT(n);

    LAMBDA = Pars.LAM(n);
    LAMBDA2 = Pars.LAM2(n);

    LAMHAT = Pars.LAMHAT(n);
    LAMHAT2 = Pars.LAMHAT2(n);
    RHO = Pars.RHO(n);
    KD = Pars.KD(n);
    CSBACK = Pars.CBGR(n);



%open OTIS template and parameter input text files 
%Edit values in the PARAMS.INP text file
template=fopen('params.template', 'rt');
params=fopen('PARAMS.INP','wt');

for i=1:107;
    tline = fgetl(template);
        if ~ischar(tline),   break,   end  ;    
    switch i;
        case 19;
            fprintf(params, '%1i\n', PRTOPT);
        case 20;
            fprintf(params, '%9f\n', PSTEP);
        case 21;
            fprintf(params, '%9f\n', TSTEP);
        case 22;
            fprintf(params, '%9f\n', TSTART);
        case 23;
            fprintf(params, '%9f\n', TFINAL);
        case 24;
            fprintf(params, '%9f\n', XSTART);
        case 25;
            fprintf(params, '%9f\n', DSBOUND);
        case 26;
            fprintf(params, '%1i\n', NREACH);
        case 41;
            fprintf(params, '%5i%13i%13f%13f%13f\n', NSEG, RCHLEN, DISP, AREA2, ALPHA);
        case 53;
            fprintf(params, '%5i%5i%5i\n', NSOLUTE, IDECAY, ISORB);
        case 63
            if IDECAY~=0
                fprintf(params, '%13f%13f\n', LAMBDA, LAMBDA2);
            end
        case 73
            if ISORB~=0
                fprintf(params, '%13i%13f%13f%13f%13f\n', LAMHAT, LAMHAT2, RHO, KD, CSBACK);
            end            
        case 85;
            fprintf(params, '%5i%5i\n', NPRINT, IOPT);
        case 89;
            fprintf(params, '%f\n', PRINTLOC);
        case 103;
            fprintf(params, '%5i%5i\n', NBOUND, IBOUND);
        case 107;
            for h=1:length(USTIME_USBC);
                fprintf(params, '%13f%13f\n', USTIME_USBC(h,:));
            end;
        otherwise ;   
            fprintf(params, '%s\n', tline);
    end;
end;

fclose(template);
fclose(params);


%Edit values in the Q.INP text file
template=fopen('q.template','rt');
discharge=fopen('Q.INP','wt');

for i=1:31
    tline = fgetl(template);
        if ~ischar(tline),   break,   end ;     
    switch i;
        case 13;
            fprintf(discharge, '%5i\n', QSTEP);
        case 17;
            fprintf(discharge, '%5f\n', QSTART);
        case 31;
            fprintf(discharge, '%13f%13f%13f%13f%\n',QLATIN,QLATOUT,AREA,CLATIN);
        otherwise;    
            fprintf(discharge, '%s\n', tline);
    end
end

fclose(template);
fclose(discharge);

if n==1
%Edit values in the control.inp file, depending on sorption option
template=fopen('control.template','rt');
control=fopen('control.inp','wt');

for i=1:17
    tline = fgetl(template);
        if ~ischar(tline),   break,   end ;     
    switch i;
        case 17;
            if ISORB>0
                fprintf(control, 'sorbout.out\n');
            end
        otherwise;    
            fprintf(params, '%s\n', tline);
    end
end

fclose(template);
fclose(control);
end

%call the OTIS executable to run the model(must be in current working
%directory)

    %FOR A PC
    if OSFLAG==1
        !OTIS.EXE
    end

    %FOR A UNIX/LINUX
    if OSFLAG==2
        !./otis
    end
    
%read in output data from OTIS
    %a=column #1: time in hrs
    %b=column #2: stream solute concentration 
    %c=column #3: transient storage zone concentration
    [a, b] = textread('soluteout.out','%s %s') ;

%define empty arrays
    ctime =  zeros(1,length(a));
    conc = zeros(1,length(b));
    
%extract values from cell arrays, test to make sure formatting is correct,
%then write values into numeric arrays in scientific format
for i = 1:length(a);
    atest = isstrprop(a{i,1}, 'alpha');
    btest = isstrprop(b{i,1}, 'alpha');

    if sum(atest) > 0.0;
        ctime(1,i) = sscanf(a{i,1}, '%13E');  
    else
        ctime(1,i) = sscanf('0','%13E');
    end

    if sum(btest) > 0.0;
        conc(1,i) = sscanf(b{i,1},'%13E');
    else
        conc(1,i) = sscanf('0','%13E');
    end
end





%Pass data back to the main file
Model.ctime = ctime;  %Model computed time interval
Model.conc  = conc;    %Model computed downstream concentration 


 
    
    
    
    
    
    
    
    
    
    
    