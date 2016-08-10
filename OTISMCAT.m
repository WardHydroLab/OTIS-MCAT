%Code Maintained at: https://github.com/WardHydroLab/OTIS-MCAT

%Clear the workspace, close figures, clear command line
    clear
    close all
    clc

%Start recording the command line
    diary off
    
    %delete old file
    if exist('Output_files/OTISMCATecho.txt')>0
        delete('Output_files/OTISMCATecho.txt');
    end
    
    diary('Output_files/OTISMCATecho.txt')

    %print the current date and time
    disp(['Run Start: ',datestr(now)])

%-------------------------------------------------------------------------
% Add working directories for code used here
%-------------------------------------------------------------------------
    %OTIS Mone Carlo Version
    addpath code/OTIS-MCAT_TEST
    
    %MCAT Toolbox
    addpath code/MCAT
    
    %input files
    addpath Input_files
    
    %output files
    addpath Output_files

    %OTIS-P write-out files
    addpath code/OTIS-P_WRITE
    

%-------------------------------------------------------------------------
% LOAD THE INPUT FILES
%-------------------------------------------------------------------------

    % Load the file of model controls
        [IN]=load('Input_files/OTIS_MCAT_CONTROL.txt');
    
    %Assign variables
    	OSFLAG=IN(1);
    	sim=IN(2);
    	mc=IN(3);
        WAITFLAG=IN(4);
    	dt=IN(5);
    	spatialstep=IN(6);
        QSTART=IN(7);
        reachlength=IN(8);
        N=IN(9);
        SEED=IN(10);
        DISPMIN=IN(11);
        DISPMAX=IN(12);
        ALPHAMIN=IN(13);
        ALPHAMAX=IN(14);
        AREA2MIN=IN(15);
        AREA2MAX=IN(16);
        AFLAG=IN(17);
        AMIN=IN(18);
        AMAX=IN(19);
        QLATINMIN=IN(20);
        QLATINMAX=IN(21);
        QLATOUTMIN=IN(22);
        QLATOUTMAX=IN(23);
        CLATMIN=IN(24);
        CLATMAX=IN(25);
        LAMMIN=IN(26);
        LAMMAX=IN(27);
        LAM2MIN=IN(28);
        LAM2MAX=IN(29);
        LAMHATMIN=IN(30);
        LAMHATMAX=IN(31);
        LAMHAT2MIN=IN(32);
        LAMHAT2MAX=IN(33);
        RHOMIN=IN(34);
        RHOMAX=IN(35);
        KDMIN=IN(36);
        KDMAX=IN(37);
        CBGRMIN=IN(38);
        CBGRMAX=IN(39);
        BTCFLAG=IN(40); 
        BOXFLAG=IN(41);
        BOXT=IN(42);
        METRICS=IN(43);
        CIFLAG=IN(44);

    disp('OTIS_MCAT_CONTROL.txt read correctly');

% WARN USER IF TOO FEW SIMULATIONS ARE REQUESTED
    if N<1000
        disp('N<1000 - some functionality may be limited')
        disp('including Boxplot and CI visualizations')
    end

% READ IN THE UPSTREAM BOUNDARY AND DOWNSTREAM OBSERVATIONS
    %read-in upstream data
    [USTIME,USCONC]=textread('Input_files/upstream.csv','%f %f','delimiter',',');
    disp('upstream.csv read correctly');

    %read-in downstream data
    [OBSTIME,OBSCONC]=textread('Input_files/downstream.csv','%f %f','delimiter',',');
    disp('downstream.csv read correctly');
    
    %Run BTC analysis for the observed downstream timeseries
        %analyze it
        BTC=BTCAnalysis(OBSTIME,OBSCONC,reachlength);

        %Write-out a summary of the BTC Metrics for the observed downstream data
            %specify the filename
            filename=['Output_files/BTCAnalysis.csv'];

            %Open the file, discard existing contents
            fid=fopen(filename,'w');

            %Write-out the data and code
            fprintf(fid,'t99, %.6f\r\n',BTC.t99);
            fprintf(fid,'M1, %.6f\r\n',BTC.M1);
            fprintf(fid,'M1norm, %.6f\r\n',BTC.M1norm);
            fprintf(fid,'mu2, %.6f\r\n',BTC.mu2);
            fprintf(fid,'mu2norm, %.6f\r\n',BTC.mu2norm);
            fprintf(fid,'mu3, %.6f\r\n',BTC.mu3);
            fprintf(fid,'mu3norm, %.6f\r\n',BTC.mu3norm);
            fprintf(fid,'skewness, %.6f\r\n',BTC.skewness);
            fprintf(fid,'skewnessnorm, %.6f\r\n',BTC.skewnessnorm);
            fprintf(fid,'appdispersivity, %.6f\r\n',BTC.appdispersivity);
            fprintf(fid,'appdispersion, %.6f\r\n',BTC.appdispersion);
            fprintf(fid,'Holdback, %.6f\r\n',BTC.Holdback);
            fprintf(fid,'t05, %.6f\r\n',BTC.t05);
            fprintf(fid,'t10, %.6f\r\n',BTC.t10);
            fprintf(fid,'t25, %.6f\r\n',BTC.t25);
            fprintf(fid,'t50, %.6f\r\n',BTC.t50);
            fprintf(fid,'t75, %.6f\r\n',BTC.t75);
            fprintf(fid,'t90, %.6f\r\n',BTC.t90);
            fprintf(fid,'t95, %.6f\r\n',BTC.t95);
            fprintf(fid,'t05norm, %.6f\r\n',BTC.t05norm);
            fprintf(fid,'t10norm, %.6f\r\n',BTC.t10norm);
            fprintf(fid,'t25norm, %.6f\r\n',BTC.t25norm);
            fprintf(fid,'t50norm, %.6f\r\n',BTC.t50norm);
            fprintf(fid,'t75norm, %.6f\r\n',BTC.t75norm);
            fprintf(fid,'t90norm, %.6f\r\n',BTC.t90norm);
            fprintf(fid,'t95norm, %.6f\r\n',BTC.t95norm);    
            fprintf(fid,'tpeak, %.6f\r\n',BTC.tpeak);
            fprintf(fid,'cpeak, %.6f\r\n',BTC.cpeak);
            fprintf(fid,'cpeakNORM, %.6f\r\n',BTC.cpeakNORM);


            %Close the file
            fclose(fid);

            disp('Results Saved as BTCAnalysis.csv')
    
        clear BTC
    
    
%-------------------------------------------------------------------------
% Run the Monte Carlo simulations, if requested
%-------------------------------------------------------------------------    
if sim==1

    %-------------------------------------------------------------------------
    % Launch "OTIS_Main_MCAT.m" to complete the Monte Carlo Simulations
    %-------------------------------------------------------------------------
        disp('Beginning Monte Carlo simulations')
        run code/OTIS-MCAT_TEST/OTISMain_MCAT.m
        disp('Monte Carlo simulations completed')

        %Store the Monte Carlo parameter values and outcome metrics
            filename=['Output_files/MCRunData.mat'];
            save(filename,'Data','Pars','Instate'); 
            disp('Monte Carlo simulation Data Saved')
        
        %Store the BTC timeseries, if requested
            if BTCFLAG==1
                filename=['Output_files/BTCs.mat'];
                save(filename,'MOD','OBSTIME');     
                 disp('Full BTCs Saved')
            end        

else
    disp('Monte Carlo runs not requested')
end  


%-------------------------------------------------------------------------
% MCAT and Outputs
%-------------------------------------------------------------------------
%IF simulations were not run - load up the required data here
if sim==0 & mc==1
    disp('Simulations not conducted, attempting to load existing output files')
    
        %load the Monte Carlo parameters and evaluation metrics
        %load the BTCs if they were saved
        if exist('Output_files/MCRunData.mat')~=0
            load('Output_files/MCRunData.mat');
            disp('MCRunData.mat loaded successfully')
        else
            disp('MCRunData.mat not found')
            disp('Analysis Terminated')
            return
        end        
        
            load('Output_files/MCRunData.mat');
    
        %load the BTCs if they were saved
        if exist('Output_files/BTCs.mat')~=0
            load('Output_files/BTCs.mat');
            disp('BTCs.mat loaded successfully')
        else
            disp('Breakthrough Curve Outputs Were Not Saved (BTCs.mat)')
            disp('Some MCAT functions are not enabled')
        end
    
end

%Build the MCAT Inputs no matter what options are selected
run code/OTIS-MCAT_TEST/BuildMCATInput.m
disp('MCAT input files built successfully')

% Make and save parameter-metric boxplots if requested and if all vars used
if METRICS==0
    if BOXFLAG==1
        disp('Creating and saving boxplots')
        if exist('Output_files/boxplots')==0
            mkdir('Output_files/boxplots')
        end
        run code/OTIS-MCAT_TEST/makeboxplots.m
    else
        disp('Box Plots not requested')
    end
else
        disp('Box Plots suppressed because Line 64 = 1 in input file')
end

%Figures of dotty plots and CI Distribution
if CIFLAG==1
    disp('Creating and saving CI distributions')
    if exist('Output_files/CI_plots')==0
       mkdir('Output_files/CI_plots');
    end
    run code/OTIS-MCAT_TEST/make_ci_distribution.m
else
    disp('CI Distributions not requested')
end


% Write-out the files for OTIS-P to be run by the user if outputs from 
% OTIS-P do not already exist
if sim==1
    if exist('OTIS-P_files/star.out')==0
        %execute a file to build OTIS-P inputs with the best-fit
        %Monte Carlo version here
        run code/OTIS-P_WRITE/OTISPWRITE.m
        
        %move files
        movefile('code/OTIS-P_WRITE/data.INP','OTIS-P_files/data.INP');
        movefile('code/OTIS-P_WRITE/PARAMS.INP','OTIS-P_files/PARAMS.INP');
        movefile('code/OTIS-P_WRITE/Q.INP','OTIS-P_files/Q.INP');
        movefile('code/OTIS-P_WRITE/control.INP','OTIS-P_files/control.INP');
        movefile('code/OTIS-P_WRITE/star.INP','OTIS-P_files/star.INP');

        disp('OTIS-P Input Files Written')
    else
        disp('OTIS-P *.out files already exist')
        disp('No OTIS-P files were written')
    end    
else
    disp('No OTIS-P files because simulations were not run')
end
    
    
% Launch the Monte Carlo Analysis Toolbox
if mc==1
    disp('Launching MCAT - OTISMCAT.m run complete')
    disp(['Run End: ',datestr(now)])
    diary off
    mcat(pars,crit,vars,mct,pao,obs,id,pstr,cstr,vstr,dt,t,BOXT);
else
    disp('MCAT Not Requested - Program Ended')
    disp(['Run End: ',datestr(now)])
    diary off
end

