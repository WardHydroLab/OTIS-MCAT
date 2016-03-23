%Make and save the confidence interval distribution figures for each parameter

cd ..
cd ..

%Verify a directory exists to store the data
    if exist('Output_files/CI_plots')==0
       mkdir('Output_files/CI_plots');
    end



[a,b] = sort(Data.RMSE);
n = length(a);
nbins = 25;                            %number of bins used to create frequency plots


    
m = [0.2 0.1 0.05 0.01 0.005 0.001];   %behavioral thresholds used to make plot
                                       %corresponding to 20%,10%,5%,1%,etc
                                       %these can be changed to any values
                                       
                                       
% y-axis ranges
minhist = 0;
maxhist = 80;
   
%Set Colormap to the default for the user's version of Matlab
MAP = colormap;

%Loop through all of the different parameters included in these data
for parcol=1:size(pars,2)
	%Grab the raw parameter values
        partemp=pars(:,parcol);    

   
    %%Open a new figure
    figure(1)
        clf
        set(gcf,'Color',[1 1 1]);
        
        
    temp = linspace(min(partemp),max(partemp),nbins);
    
    
    for i = 1:length(m);
        p1 = partemp(b(1:round((n*m(i)))),1);
        [c1,d1] = hist(p1,temp);
        plot(d1,100*c1./(sum(c1)),'Color',MAP(i*floor(64/length(m)),:),'LineWidth',2);hold on;
    end;
    plot([partemp(b(1)) partemp(b(1))],[0 100*max(c1)./(sum(c1))+10],'Color',[0.5 0.5 0.5]);
    axis([min(partemp) max(partemp) 0 100*max(c1)./(sum(c1))+10]);


%add a legend
    legend(num2str(m'))
    
%format plot
    %Xlabel
        %make a vector of parameter name w/o any spaces
        storeloc=pstr(parcol,:);
        storeloc=storeloc(isspace(storeloc)==0);
        xlabel(storeloc)  
        
    %Ylabel
    ylabel('Frequency')

    
    
    drawnow

%Save the figure
    print(figure(1),'-depsc',['Output_files/CI_plots/',storeloc,'_CI.eps'])

    
    


end

close all

