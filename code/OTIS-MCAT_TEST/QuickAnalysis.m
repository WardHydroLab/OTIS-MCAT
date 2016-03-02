clear
clc
close all

%SIMPLE VISUALIZATION OF RESULTS FROM MONTE-CARLO DATA

%load the data
load Rundata.mat

%%
%*********************************************************************
% Figure 1 - Plot parameter values vs. quality of fit
%*********************************************************************
%Change Variables Here
    fitnessmetric=['RMSE'];


figure(1)
    clf
    set(gcf,'color','w','units','in')
    
    %Area
    thisvar=['AREA'];
    ax(1)=subplot(2,2,1);
        plot(Pars.(thisvar),Data.(fitnessmetric),'.')
        hold on
        plot(Pars.(thisvar)(Data.(fitnessmetric)==min(Data.(fitnessmetric))),min(Data.(fitnessmetric)),'ro');
        
        
    %Area2
    thisvar=['AREA2'];
    ax(2)=subplot(2,2,2);
        plot(Pars.(thisvar),Data.(fitnessmetric),'.')
        hold on
        plot(Pars.(thisvar)(Data.(fitnessmetric)==min(Data.(fitnessmetric))),min(Data.(fitnessmetric)),'ro');
            %Disp
    thisvar=['DISP'];
    ax(3)=subplot(2,2,3);
        plot(Pars.(thisvar),Data.(fitnessmetric),'.')        
        hold on
        plot(Pars.(thisvar)(Data.(fitnessmetric)==min(Data.(fitnessmetric))),min(Data.(fitnessmetric)),'ro');
            %Alpha
    thisvar=['ALPHA'];
    ax(4)=subplot(2,2,4);
        plot(Pars.(thisvar),Data.(fitnessmetric),'.')
        hold on
        plot(Pars.(thisvar)(Data.(fitnessmetric)==min(Data.(fitnessmetric))),min(Data.(fitnessmetric)),'ro');
                
        
   %formatting
        set(ax(2:4),'xscale','log')
        ylabel(ax(1),fitnessmetric)
        ylabel(ax(2),fitnessmetric)
        ylabel(ax(3),fitnessmetric)
        ylabel(ax(4),fitnessmetric)
        xlabel(ax(1),'AREA (m^2)')
        xlabel(ax(2),'AREA2 (m^2)')
        xlabel(ax(3),'DISP (m^2 s^-^1)')
        xlabel(ax(4),'\alpha (s^-^1)')
        
%%       
%*********************************************************************
% Extract some parameters based on an objective function
%*********************************************************************        

%EXAMPLE 1 - GRAB THE TOP ___ PARAMETER SETS BASED ON OBJECTIVE FUNCTION

    %Extract the top ____ parameter sets from the database
        topno=100;

    %Objective function to use
        objtouse=['RMSE'];

    %Sort the data based on that objective function
        %make a single matrix with all parameter values and the objective function
        sortemp=[Data.(objtouse),Pars.AREA,Pars.DISP,Pars.AREA2,Pars.ALPHA];

        %sort the data
        sorted=sortrows(sortemp,1);


    %Grab the values you want and store in a new structure
        Clipped.(objtouse)=sorted(1:topno,1);
        Clipped.AREA=sorted(1:topno,2);
        Clipped.DISP=sorted(1:topno,3);
        Clipped.AREA2=sorted(1:topno,4);
        Clipped.ALPHA=sorted(1:topno,5);

%EXAMPLE 2 - GRAB ALL VALUES ABOVE A SPECIFIED THRESHOLD

    %Objective functino threshold
        threshold=5;

    %Objective function to use
        objtouse=['RMSE'];

    %Grab the values and make a structure
        Clipped2.(objtouse)=Data.(objtouse)(Data.(objtouse)<=threshold);
        Clipped2.AREA=Pars.AREA(Data.(objtouse)<=threshold);
        Clipped2.DISP=Pars.DISP(Data.(objtouse)<=threshold);
        Clipped2.AREA2=Pars.AREA2(Data.(objtouse)<=threshold);
        Clipped2.ALPHA=Pars.ALPHA(Data.(objtouse)<=threshold);
        







