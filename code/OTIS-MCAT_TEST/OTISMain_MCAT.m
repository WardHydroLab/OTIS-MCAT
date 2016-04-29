
%Some info about units, variables, etc.
    %---------------------------------------------------------
    %  PRTOPT					Format of solute output files (1=main channel only, 2=main channel and storage zone)
    %  PSTEP  [hours]			Time interval at which results are printed (check solution integration time step)
    %  TSTEP  [hours]			Integration time step (0=steady state solution, >0=time variable solution)
    %  TSTART [hour]			Simulation start time
    %  TFINAL [hour]			Simulation end time
    %  XSTART [L]				Stream distance at upstream boundary (usaully 0)
    %  DSBOUND [(L/sec)mg/L]	Downstream boundary condition describes conc. gradient at dowstream boundary (usually 0)
    %  NREACH					Number of modeled reachesPrint Option = PRTOPT
    %  NSEG                     Number of x-sectional segments within the reach. Max of 5000 (RCLEN/2 seems to work well)
    %  RCLEN(m)                 Reach length
    %  NSOLUTE                  Number of solutes (max of 3)
    %  IDECAY                   Decay option (0 = OFF)
    %  ISORB                    Sorption option (0 = OFF)
    %  NPRINT                   Number of locations along the stream where output is desired
    %  IOPT                     Interpolation option for print locations (1=linear interpolation used, 0=nearest upstream segment value used)
    %  PRINTLOC                 Downstream distance to a given print location, repeated NPRINT times (max of 30) %
    %  NBOUND					Define total number of upstream boundary time steps (max of 200) 
    %  IBOUND					Boundary condition option (1=concentration step profile, 2=flux step profile, 3=concentration continuous profile)
    %  QSTEP                    Change-in-flow indicator, time-step for updating flow changes (steady-state conditions = 0.0)
    %  QSTART(m^3/second)       Discharge at upstream boundary
    %  QLATIN(m^3 sec-1 m-1) 	Lateral inflow rate 
    %  QLATOUT(m^3 sec-1 m-1) 	Lateral outflow rate			
    %  CLATIN(mg/l)             Lateral inflow solute concentration (repeats for each solute modeled)
    %
    %  USTIME_USBC
    %       Column#1:USTIME(hour)				 Define each time step for upstream boundary condition(max of 200)    
    %       Column#2:USBC(mg/l; mg/l m^3/sec) 	 Solute concentration values corresponding to each USTIME (units depend on IBOUND) 
    %  
    %  DISP(m^2/sec)            Dispersion
    %  AREA2(m^2)               Transient storage zone area (must be a non-zero value) 
    %  ALPHA(sec-1)             Transient storage exchange coefficient
    %  AREA(m^2)                Channel cross-sectional area
    %---------------------------------------------------------

    
%TRANSLATE THE INPUT FILE INTO MEANINGFUL VALUES THAT ARE USED THROUGHOUT
%THIS FILE




% GUESS CROSS-SECTIONAL AREA AND TRAVEL TIME

    %estimate a travel time and convert to units of seconds
        tpeakus=USTIME(USCONC==max(USCONC));
        if length(tpeakus>1)
            tpeakus=mean(tpeakus);
        end
        
        tpeakds=OBSTIME(OBSCONC==max(OBSCONC));
        if length(tpeakds>1)
            tpeakds=mean(tpeakds);
        end
        
        %calc peak travel time (s)
        traveltime=3600.*(tpeakds-tpeakus);
        
        %estimate velocity (m/s)
        velocity=reachlength/traveltime;

    %Guess cross-sectional area
        AGUESS=QSTART/velocity;

%CHECK COURANT CONDITON
    CFL=(velocity.*dt)./spatialstep;
    
    if CFL>1
        disp('CFL ERROR - CFL>1 - need larger dx or smaller dt')
        return
    end
    
    if CFL>0.5
        disp('CFL > 0.5 - suggest using larger dx or smaller dt')
        disp('calcuations will proceed')
    end
        
        
        
%Filter to be sure no duplicate points in time exist
    %If they do, display an error message and break
    if length(unique(USTIME))~=length(USTIME)
        disp('ERROR IN upstream.csv - duplicate points in time exist')
        return
    end
    
    if length(unique(OBSTIME))~=length(OBSTIME)
        disp('ERROR IN downstream.csv - duplicate points in time exist')
        return
    end    

   
%Make a vector of times to use at the upstream boundary

    %Grab some times that define the start and end points of the
    %observational data set

    %Starting time at first upstream observations
        TSTART=min(USTIME);
    
    %ending time at last downstream observation
        TEND=max(OBSTIME);    
    
    %LIMIT IS 200 POINS.
    
    if length(USTIME)>198
    %ASSIGNED HERE AS:

    % 50 points from Tstart to Tpeak
        stemp=TSTART;
        etemp=tpeakus;
        step=(etemp-stemp)/49;
        t1=[stemp:step:etemp];
        
    % 50 points from peak to 2*tpeak
        stemp=etemp+step;
        etemp=2*tpeakus;
        step=(etemp-stemp)/49;
        t2=[stemp:step:etemp];
    % 98 points from 2*tpeak to Tend
        stemp=etemp+step;
        etemp=TEND;
        step=(etemp-stemp)/97;
        t3=[stemp:step:etemp];

        
    
    %slam these 3 segments together into one vector
        usboundtimes=[t1,t2,t3]';
    
       
    clear t1 t2 t3 stemp etemp step
    

    %linear interpolation to calc the concs that go with these times
        usboundconcs=interp1(USTIME,USCONC,usboundtimes);
    else
        usboundtimes=USTIME;
        usboundconcs=USCONC;
    end
            
    %Add a point for t=0 if it is not already present
        if usboundtimes(1)~=0
            usboundtimes=[0;usboundtimes];
            usboundconcs=[usboundconcs(1);usboundconcs];
        end

    %Add a point for t = 2*Tend to force the model at late times
        usboundtimes=[usboundtimes;2*TEND];
        usboundconcs=[usboundconcs;usboundconcs(end)];


    %Make vectors of observed u/s and d/s concentration timeseries
        Upbound=[usboundtimes usboundconcs];

    %store these in the Instate vector   
        Instate.USTIME_USBC=Upbound;
        Instate.NBOUND=size(Upbound,1);



%Make a vector of times to use at the DOWNSTREAM boundary

    %Grab some times that define the start and end points of the
    %observational data set

    %Starting time at first upstream observations
        TSTART=min(USTIME);
    
    %ending time at last downstream observation
        TEND=max(OBSTIME);    
    
    %LIMIT IS 200 POINS.
    
    if length(OBSTIME)>198
    %ASSIGNED HERE AS:

    % 50 points from Tstart to Tpeak
        stemp=min(OBSTIME);
        etemp=tpeakds;
        step=(etemp-stemp)/49;
        if step<dt
            step2=step.*(ceil((dt/3600)./step));
            t1=[stemp:step2:etemp];
            clear step2
        else
        t1=[stemp:step:etemp];
        end
        
    % 50 points from peak to 2*tpeak
        stemp=etemp+step;
        etemp=((TEND-tpeakds)/2)+tpeakds; % edited this line, 2*tpeak can be outside of range and cause series to go backward
        step=(etemp-stemp)/49;
        if step<dt
            step2=step.*(ceil((dt/3600)./step));
            t2=[stemp:step2:etemp];
            clear step2
        else
        t2=[stemp:step:etemp];
        end
        
    % 98 points from 2*tpeak to Tend
        stemp=etemp+step;
        etemp=TEND;
        step=(etemp-stemp)/97;
        if step<dt
            step2=step.*(ceil((dt/3600)./step));
            t3=[stemp:step2:etemp];
            clear step2
        else
        t3=[stemp:step:etemp];
        end

        
    
    %slam these 3 segments together into one vector
        dsboundtimes=[t1,t2,t3]';
    
       
    clear t1 t2 t3 stemp etemp step
    

    %linear interpolation to calc the concs that go with these times
        dsboundconcs=interp1(OBSTIME,OBSCONC,dsboundtimes);
        
        Data.time = dsboundtimes;
        Data.solute = dsboundconcs;
        OBSTIME = dsboundtimes;
        OBSCONC = dsboundconcs;
        
    else
        Data.time   = OBSTIME;  
        Data.solute = OBSCONC; 
    end
            

    
%Set Model Solution Conditions and Output Structure
    Instate.TSTART=TSTART;
    Instate.TFINAL=TEND*2;
    Instate.PRTOPT=1;%OTIS model function will only work with PRTOPT set to 1                         
    Instate.PSTEP=dt/3600;%Print results at this interval (hours)              
    Instate.TSTEP=dt/3600;%Calculate solution at this interval (hours)                                  
    Instate.XSTART=0;                    
    Instate.DSBOUND=0;
%Set Print Location(s)
    Instate.NPRINT=1;
    Instate.IOPT=0;
    Instate.PRINTLOC=reachlength; %reach length

%Set Reach Characteristics
    %running for just a single reach
    Instate.NREACH=1;           
    
    %Make the simulated reach twice as long as your actual reach of
    %interest - this keep the d/s boundary condition from having an impact
    %on the reach that you are interested in -- common practice in OTIS
    Instate.RCHLEN=round(Instate.PRINTLOC+200*spatialstep);%ensures downstream boundary conditions are met at PRINTLOC
    
    %set number of segments for a given reach length and spatial step
    Instate.NSEG=round(Instate.RCHLEN/spatialstep);
    
%Set Solute Characteristics
    Instate.NSOLUTE=1;
    
%Set Decay (or not)
    if LAMMIN==0 & LAMMAX==0  & LAM2MIN==0 & LAM2MAX==0
        Instate.IDECAY=0;
    else
        Instate.IDECAY=1;
    end
    
%Set Sorption (or not)
    if LAMHATMIN==0 & LAMHATMAX==0 & LAMHAT2MIN==0 & LAMHAT2MAX==0 & RHOMIN==0 & RHOMAX==0 & KDMIN==0 & KDMAX==0 & CBGRMIN==0 & CBGRMAX==0
        Instate.ISORB=0;
    else
        Instate.ISORB=1;
    end
    
%Set Upstream Boundary Condition Type
    Instate.IBOUND=3;
    
    
%Initialize the random number generator
    if SEED==0
        %Randomization based on computer clock time
        rand('seed',sum(100*clock));
    else
        %Randomization based on a specified seed
        rand('seed',SEED);
    end
    

%Define the vectors of random variables
    %note that each exeuction of "rand" changes the seed for the generator,
    %so the "rand(N,1)" is different for each of these parameters. 
    

    param=['DISP'];

    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end

    


    
    param=['ALPHA'];
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   
   
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
    
    
    param=['AREA2'];
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
    
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end


   
    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
    

    
    
    param=['AREA'];
    
    if AFLAG==1
        AREAMIN=(AGUESS*AMIN);
        AREAMAX=(AGUESS*AMAX);
    elseif AFLAG==2
        AREAMIN=AMIN;
        AREAMAX=AMAX;
    end
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   

    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
    
    
    param=['QLATIN'];
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   
   
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
        %ADJUST TO m3/s per m of length!
        Pars.(param)=Pars.(param)./reachlength;
        
        
    param=['QLATOUT'];
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   
   
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
        %ADJUST TO m3/s per m of length!
        Pars.(param)=Pars.(param)./reachlength;
    
    param=['CLAT'];
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   
   
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
    
    
    param=['LAM'];
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   
   
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
    
    
    param=['LAM2'];
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   
   
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
    
    
    param=['LAMHAT'];
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   
   
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
    
    
    
    
    param=['LAMHAT2'];
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   
   
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
    
    
    param=['RHO'];
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   
   
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
    
    
    param=['KD'];
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   
   
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
    
    
    
    param=['CBGR'];
    
    junk.(sprintf('%sMIN',param))=eval(sprintf('%sMIN',param));
    junk.(sprintf('%sMAX',param))=eval(sprintf('%sMAX',param));
   
   
    %run a check
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))~=0 
        disp(sprintf('Error in values for %s; MIN cannot be 0 with non-zero MAX',param))
        break
    elseif junk.(sprintf('%sMIN',param))~=0 & junk.(sprintf('%sMAX',param))==0 
        disp(sprintf('Error in values for %s; MAX cannot be 0 with non-zero MIN',param))
        break     
    elseif junk.(sprintf('%sMIN',param))>junk.(sprintf('%sMAX',param)) 
        disp(sprintf('Error in values for %s; Specified MIN > MAX',param))
        break 
    end

    %if both are zeros
    if junk.(sprintf('%sMIN',param))==0 & junk.(sprintf('%sMAX',param))==0
    	Pars.(param)=zeros(N,1);
            
    else
            junk.(sprintf('%sMIN',param))=log10(junk.(sprintf('%sMIN',param)));
            junk.(sprintf('%sMAX',param))=log10(junk.(sprintf('%sMAX',param)));
            Pars.(param)  = 10.^(rand(N,1)*(junk.(sprintf('%sMAX',param))-junk.(sprintf('%sMIN',param)))+junk.(sprintf('%sMIN',param)));
    end
    
   
%define a vector of the SIMULATION times
    simtimes=[TSTART:Instate.PSTEP:2*TEND+2*Instate.PSTEP];

   
%Pre-allocation of location to store simulated breakthrough curves (if requested) 
    if BTCFLAG==1
        MOD = zeros(N,length(OBSTIME));
    end
    
    
%Pre-allocation locations to store the measures of quality of fit
    Data.t99 = zeros(N,1);
    Data.M1 = zeros(N,1);
    Data.M1norm = zeros(N,1);
    Data.mu2 = zeros(N,1);
    Data.mu2norm = zeros(N,1);
    Data.mu3 = zeros(N,1);
    Data.mu3norm = zeros(N,1);
    Data.skewness = zeros(N,1);
    Data.skewnessnorm = zeros(N,1);
    Data.appdispersivity = zeros(N,1);
    Data.appdispersion = zeros(N,1);
    Data.Holdback = zeros(N,1);
    Data.t05 = zeros(N,1);
    Data.t10 = zeros(N,1);
    Data.t25 = zeros(N,1);
    Data.t50 = zeros(N,1);
    Data.t75 = zeros(N,1);
    Data.t90 = zeros(N,1);
    Data.t95 = zeros(N,1);
    Data.t05norm = zeros(N,1);
    Data.t10norm = zeros(N,1);
    Data.t25norm = zeros(N,1);
    Data.t50norm = zeros(N,1);
    Data.t75norm = zeros(N,1);
    Data.t90norm = zeros(N,1);
    Data.t95norm = zeros(N,1);
    Data.tpeak = zeros(N,1);
    Data.cpeak = zeros(N,1);
    Data.cpeaknorm = zeros(N,1);

    Data.RMSE = zeros(N,1);
    Data.RMSElog = zeros(N,1);
    Data.R2 = zeros(N,1);
    Data.R2log = zeros(N,1);
    Data.oppR2 = zeros(N,1);
    Data.oppR2log = zeros(N,1);

    
%Analysis of the observation data set

    BTCOBS=BTCAnalysis(OBSTIME,OBSCONC,reachlength);
    disp('Analysis of Observed BTC Complete');

%NEED TO DEAL WITH THIS!
%Set Discharge Characteristics
    Instate.QSTEP=0.00;
    Instate.QSTART=QSTART;
    
%start the waitbar
if WAITFLAG==1
    X=waitbar(0,'Completing Monte Carlo simulation runs. Please wait.');
end

% Pull parameter set "i" from the random vectors and run the model
for i = 1:N
    
    %Run the forward model for parameter set i 
        Model = OTIS(Instate,Pars,i,OSFLAG);
      
    %Interpolate simulation times to model times
        Sim = interp1(Model.ctime,Model.conc,OBSTIME);
        %plot(OBSTIME,OBSCONC,'.',Model.ctime,Model.conc,'.',usboundtimes,usboundconcs),legend('obs','mod')
        %keyboard
        
    %Store model output data
        if BTCFLAG==1
            MOD(i,:)= Sim; %(skipped because the files get wildly large)
        end
        
    %Analysis of simulated output
        BTCMOD = BTCAnalysis(OBSTIME,Sim,reachlength);
               
	%Store the absolute error for the different metrics from BTCAnalysis
        Data.t99(i) = abs(BTCOBS.t99-BTCMOD.t99);
        Data.M1(i) = abs(BTCOBS.M1-BTCMOD.M1);
        Data.M1norm(i) = abs(BTCOBS.M1norm-BTCMOD.M1norm);
        Data.mu2(i) = abs(BTCOBS.mu2 - BTCMOD.mu2);
        Data.mu2norm(i) = abs(BTCOBS.mu2norm - BTCMOD.mu2norm);
        Data.mu3(i) = abs(BTCOBS.mu3 - BTCMOD.mu3);
        Data.mu3norm(i) = abs(BTCOBS.mu3norm - BTCMOD.mu3norm);
        Data.skewness(i) = abs(BTCOBS.skewness-BTCMOD.skewness);
        Data.skewnessnorm(i) = abs(BTCOBS.skewness-BTCMOD.skewnessnorm);
        Data.appdispersivity(i) = abs(BTCOBS.appdispersivity-BTCMOD.appdispersivity);
        Data.appdispersion(i) = abs(BTCOBS.appdispersion-BTCMOD.appdispersion);
        Data.Holdback(i) = abs(BTCOBS.Holdback-BTCMOD.Holdback);
        Data.t05(i) = abs(BTCOBS.t05-BTCMOD.t05);
        Data.t10(i) = abs(BTCOBS.t10-BTCMOD.t10);
        Data.t25(i) = abs(BTCOBS.t25-BTCMOD.t25);
        Data.t50(i) = abs(BTCOBS.t50-BTCMOD.t50);
        Data.t75(i) = abs(BTCOBS.t75-BTCMOD.t75);
        Data.t90(i) = abs(BTCOBS.t90-BTCMOD.t90);
        Data.t95(i) = abs(BTCOBS.t95-BTCMOD.t95);
        Data.t05norm(i) = abs(BTCOBS.t05norm-BTCMOD.t05norm);
        Data.t10norm(i) = abs(BTCOBS.t10norm-BTCMOD.t10norm);
        Data.t25norm(i) = abs(BTCOBS.t25norm-BTCMOD.t25norm);
        Data.t50norm(i) = abs(BTCOBS.t50norm-BTCMOD.t50norm);
        Data.t75norm(i) = abs(BTCOBS.t75norm-BTCMOD.t75norm);
        Data.t90norm(i) = abs(BTCOBS.t90norm-BTCMOD.t90norm);
        Data.t95norm(i) = abs(BTCOBS.t95norm-BTCMOD.t95norm);        
        Data.tpeak(i) = abs(BTCOBS.tpeak - BTCMOD.tpeak);
        Data.cpeak(i) = abs(BTCOBS.cpeak - BTCMOD.cpeak);
        Data.cpeaknorm(i) = abs(BTCOBS.cpeakNORM - BTCMOD.cpeakNORM);


    %Calcualte objective functions
        %FOR THE OBSERVED CONCS

            %RMSE
                Data.RMSE(i) = sqrt(sum((OBSCONC-Sim).^2)/length(OBSCONC));

            %R-squared
                A=corrcoef(OBSCONC',Sim');
                Data.R2(i) = A(1,2).^2;
                Data.oppR2(i) = 1-A(1,2).^2;
        
        %FOR THE LOG TRANSFORMED VALUES
            %first, get rid of any negative simulated values and their
            %observed counterparts (which arne't possible for a log
            %transform)
            
            OBSPOS=OBSCONC(Sim>0);
            SIMPOS=Sim(Sim>0);

            %RMSE, R-squared for log of observed values (minimize effect of
            %extremes, puts more weight on tails)
                RMSElog(i,1) = sqrt(sum((log10(OBSPOS)-log10(SIMPOS)).^2)/length(OBSPOS));
                
            %R-squared    
                A=corrcoef(log10(OBSPOS)',log10(SIMPOS)');
                Data.R2log(i) = A(1,2);
                Data.oppR2log(i) = 1-A(1,2);                


            
 	%Waitbar update
    if WAITFLAG==1
        waitbar(i/N)
    end

end

if WAITFLAG==1
    close(X)
end

%Put the input and output timeseries in the Data structure
    Data.OBSERVATION.USTIME=USTIME;
    Data.OBSERVATION.USCONC=USCONC;
    Data.OBSERVATION.DSTIME=OBSTIME;
    Data.OBSERVATION.DSCONC=OBSCONC;
    Data.OBSERVATION.BTCMetrics=BTCOBS;

%Data.OBSERVATION.BTCMetrics

% %Write-out a summary of the BTC Metrics for the observed downstream data
%     %specify the filename
%     filename=['BTCAnalysis.csv'];
%     
%     %Open the file, discard existing contents
%     fid=fopen(filename,'w');
% 
%     %Write-out the data and code
%     fprintf(fid,'t99, %.6f\r\n',BTC.t99);
%     fprintf(fid,'M1, %.6f\r\n',BTC.M1);
%     fprintf(fid,'M1norm, %.6f\r\n',BTC.M1norm);
%     fprintf(fid,'mu2, %.6f\r\n',BTC.mu2);
%     fprintf(fid,'mu2norm, %.6f\r\n',BTC.mu2norm);
%     fprintf(fid,'mu3, %.6f\r\n',BTC.mu3);
%     fprintf(fid,'mu3norm, %.6f\r\n',BTC.mu3norm);
%     fprintf(fid,'skewness, %.6f\r\n',BTC.skewness);
%     fprintf(fid,'skewnessnorm, %.6f\r\n',BTC.skewnessnorm);
%     fprintf(fid,'appdispersivity, %.6f\r\n',BTC.appdispersivity);
%     fprintf(fid,'appdispersion, %.6f\r\n',BTC.appdispersion);
%     fprintf(fid,'Holdback, %.6f\r\n',BTC.Holdback);
%     fprintf(fid,'t05, %.6f\r\n',BTC.t05);
%     fprintf(fid,'t10, %.6f\r\n',BTC.t10);
%     fprintf(fid,'t25, %.6f\r\n',BTC.t25);
%     fprintf(fid,'t50, %.6f\r\n',BTC.t50);
%     fprintf(fid,'t75, %.6f\r\n',BTC.t75);
%     fprintf(fid,'t90, %.6f\r\n',BTC.t90);
%     fprintf(fid,'t95, %.6f\r\n',BTC.t95);
%     fprintf(fid,'t05norm, %.6f\r\n',BTC.t05norm);
%     fprintf(fid,'t10norm, %.6f\r\n',BTC.t10norm);
%     fprintf(fid,'t25norm, %.6f\r\n',BTC.t25norm);
%     fprintf(fid,'t50norm, %.6f\r\n',BTC.t50norm);
%     fprintf(fid,'t75norm, %.6f\r\n',BTC.t75norm);
%     fprintf(fid,'t90norm, %.6f\r\n',BTC.t90norm);
%     fprintf(fid,'t95norm, %.6f\r\n',BTC.t95norm);    
%     fprintf(fid,'tpeak, %.6f\r\n',BTC.tpeak);
%     fprintf(fid,'cpeak, %.6f\r\n',BTC.cpeak);
%     fprintf(fid,'cpeakNORM, %.6f\r\n',BTC.cpeakNORM);
% 
% 
%     %Close the file
%     fclose(fid);
%     
%     disp('Results Saved as BTCAnalysis.csv')
