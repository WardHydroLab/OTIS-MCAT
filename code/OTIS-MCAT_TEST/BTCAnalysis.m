function BTC = BTCAnalysis(time,conc,L)

%Inputs:
    %Time
    %Concentration
    %Distance between observation sets
    
    
%Analyses  

    %Calculate t99
        %cumulative summation
            junk=cumtrapz(time,conc);
            junk=junk./junk(end);
            
        %pick the two points that bound the point of interest
        lim=0.99;
        indexLOW=find(junk<lim);
        indexHIGH=find(junk>lim);
        
        %linear interpolation to calc t99
        BTC.t99=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[time(max(indexLOW)),time(min(indexHIGH))],lim);
        clear junk lim
        
    %clip time and conc to values of t<=t99
        cclip=conc(time<=BTC.t99);
        tclip=time(time<=BTC.t99);
        
    %Make a normalized concentration timeseries
        %zeroth temporal moment
        M0=cumtrapz(tclip,cclip);
        
        %do the normalization
        cnorm=cclip./M0(end);
        
        
    %First Temporal Moment (M1)
        M1=cumtrapz(tclip,cclip .* tclip.^1);
        BTC.M1=M1(end);
        
        M1norm=cumtrapz(tclip,cnorm .* tclip.^1);
        BTC.M1norm=M1norm(end);

    %Second Central Moment (mu2)
        mu2=cumtrapz(tclip,cclip .* (tclip-BTC.M1).^2);
        BTC.mu2=mu2(end);
        
        mu2norm=cumtrapz(tclip,cnorm .* (tclip-BTC.M1norm).^2);
        BTC.mu2norm=mu2norm(end);

    %Third Central Moment (mu3)
        mu3=cumtrapz(tclip,cclip .* (tclip-BTC.M1).^3);
        BTC.mu3=mu3(end);
        
        mu3norm=cumtrapz(tclip,cnorm .* (tclip-BTC.M1norm).^3);
        BTC.mu3norm=mu3norm(end);
        
	%Skewness
        BTC.skewness=BTC.mu3./(BTC.mu2.^(3/2));
        
        BTC.skewnessnorm=BTC.mu3norm./(BTC.mu2norm.^(3/2));
        
    %Apparant Dispersivity
        BTC.appdispersivity=BTC.mu2norm.*L./2;
        
    %Apparant Dispersion
        BTC.appdispersion=(BTC.mu2norm.*L.^2)./(2.*BTC.M1norm);

    %Holdback Function
        BTC.Holdback=interp1(tclip./BTC.M1norm,cumtrapz(tclip,cnorm),1);


    %time for different percentiles
        %RAW
            junk=cumtrapz(tclip,cclip);
            junk=junk./junk(end);
        
            %5
            	lim=0.05;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t05=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);
        
            %10
            	lim=0.10;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t10=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);                
                
            %25
            	lim=0.25;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t25=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);
                
                
            %50
            	lim=0.50;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t50=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);                
                
            %75
            	lim=0.05;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t75=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);                
                
                
            %90
            	lim=0.90;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t90=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);                
                
            %95
            	lim=0.95;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t95=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);                
                
        %NORMALIZED
            junk=cumtrapz(tclip,cnorm);
        
            %5
            	lim=0.05;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t05norm=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);
        
            %10
            	lim=0.10;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t10norm=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);                
                
            %25
            	lim=0.25;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t25norm=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);
                
                
            %50
            	lim=0.50;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t50norm=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);                
                
            %75
            	lim=0.05;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t75norm=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);                
                
                
            %90
            	lim=0.90;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t90norm=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);                
                
            %95
            	lim=0.95;
                %pick the two points that bound the point of interest
                indexLOW=find(junk<lim);
                indexHIGH=find(junk>lim);
        
                %linear interpolation to calc t99
                BTC.t95norm=interp1([junk(max(indexLOW)),junk(min(indexHIGH))],[tclip(max(indexLOW)),tclip(min(indexHIGH))],lim);                
                
                

	%Peak time
        junk=tclip(cclip==max(cclip));
        
        %if this peak value has more than one timestamp, use the mean
            if length(junk)>1
                junk=mean(junk);
            end
        
        %store it
        BTC.tpeak=junk;
            
	%Peak conc
        junk=max(cclip);
        
        %if this peak value has more than one timestamp, use the mean
            if length(junk)>1
                junk=mean(junk);
            end
        
        %store it
        BTC.cpeak=junk;
        
	%Peak conc NORM
        junk=max(cnorm);
        
        %if this peak value has more than one timestamp, use the mean
            if length(junk)>1
                junk=mean(junk);
            end
        
        %store it
        BTC.cpeakNORM=junk;        
       

% disp('Analysis Complete')
        
        

    
        
