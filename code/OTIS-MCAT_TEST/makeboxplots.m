%Make and save the boxplot figures for each parameter
threshold=BOXT;

cd ..
cd ..

    %Loop through parameters
    for parcol=1:size(pars,2)

        %Grab the raw parameter values
            partemp=pars(:,parcol);        
            
        %make a place to store the results
            parvals=[];        
        
        %loop through all metrics for a given parameter
        
        for i=1:a
            
            
            %grab criteria output
            crittemp=crit(:,i);

            %make a vector of param values and criteria
            tempdata=[partemp,crittemp];

            %sort by criteria in ASCENDING ORDER 
                %NOTE - first values = lowest crit = best fits!
            tempdata=sortrows(tempdata,2);

            %grab only the top __% of the data
            tempdata=tempdata(1:floor(threshold/100*size(tempdata,1)),:);

            %store parameters in a place to make a boxplot
            parvals=[parvals,tempdata(:,1)];

        end

        %Make the boxplot
            figure(1)
                clf
                set(gcf,'color','w','position',[0   0   900   900])

                %make the list of labels for the metrics that were input
                lablist={ones(size(cstr))};
                for k=1:a
                   
                    ltemp=cstr(k,:);
                    ltemp=ltemp(isspace(ltemp)==0);
                    lablist(k)={ltemp};
                    
                end

                
            btemp = boxplot(parvals,'labels',lablist,'labelorientation',...
                    'inline','plotstyle','compact','orientation','horizontal',...
                    'symbol','.k');
        
            h2 = findobj(gca,'Tag','Outliers'); 
            set(h2(:,:),'markeredgecolor',[0.5 0.5 0.5]);
                
            h3 = findobj(gca,'Tag','MedianOuter'); 
            set(h3(:,:),'markeredgecolor','k');
            
            h4 = findobj(gca,'Tag','MedianInner'); 
            set(h4(:,:),'visible','off');
                            
            
            
            for junk=1:33
                set(btemp(1,junk),'color','k')
                set(btemp(2,junk),'color',[0 0 0])
            end
            
    

            %make a vector of parameter name w/o any spaces
            storeloc=pstr(parcol,:);
            storeloc=storeloc(isspace(storeloc)==0);

            
            xlabel(storeloc)

        %Make a boxplot folder if ones doesn't exist
            if exist('Output_files/Boxplots')==0
               mkdir('Output_files/Boxplots')
            end

        %Save the figure
            print(figure(1),'-depsc',['Output_files/Boxplots/',storeloc,'_boxplot.eps'])

            
    end
    
    close all