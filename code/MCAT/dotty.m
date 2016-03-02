% function dotty

% function dotty
%
% dotty plots objective functions
%
% Matthew Lees & Thorsten Wagener, Imperial College London, May 2000


gvs=get(0,'userdata');
ff=gvs.ff;
id=gvs.id;
pars=gvs.pars;
lhoods=gvs.lhoods;
vars=gvs.vars;
dat=gvs.dat;
PS=gvs.PS;
pstr=gvs.pstr;

%If an OTIS-P solution exists, load it
if exist('OTIS-P_files/star.out')~=0
    
    %Make summary vectors for best best fits, lower CI, upper CI for only
    %the variables that are actually of interest
        
        %make a place to store them
        otisp.bestfits = [];
        otisp.lower95=[];
        otisp.upper95=[];
        %...then they are saved one-by-one as we go through parameters
        %below
    
    %read it in
    junk = textread('OTIS-P_files/star.out','%s');
    
    %find the header row within the text
    upperrow = find(strcmp(junk,'UPPER')==1);
    
    %start a "ticker" for which line of the pstr to search
    pstrtick=1;
    
    %grab all of the data for each variable
        paramname = ['DISP'];
        paramno = 1;
            otisp.(paramname).index = str2double(junk{upperrow+1+7*(paramno-1)});
            otisp.(paramname).fixed = junk{upperrow+2+7*(paramno-1)};
            otisp.(paramname).value = str2double(junk{upperrow+3+7*(paramno-1)});
            otisp.(paramname).stdev = str2double(junk{upperrow+4+7*(paramno-1)});
            otisp.(paramname).ratio = str2double(junk{upperrow+5+7*(paramno-1)});
            otisp.(paramname).lower95 = str2double(junk{upperrow+6+7*(paramno-1)});
            otisp.(paramname).upper95 = str2double(junk{upperrow+7+7*(paramno-1)});
            

            
            %store the values in the summary vectors if they are varied
            if strcmp(otisp.(paramname).fixed,'NO')==1
                
                %make the value log transformed to match if needed
                if strfind('log10',pstr(pstrtick))>0
                    otisp.bestfits = [otisp.bestfits;log10(otisp.(paramname).value)];
                    otisp.lower95=[otisp.lower95;log10(otisp.(paramname).lower95)];
                    otisp.upper95=[otisp.upper95;log10(otisp.(paramname).upper95)];
                else
                    %use non log-transformed version
                    otisp.bestfits = [otisp.bestfits;otisp.(paramname).value];
                    otisp.lower95=[otisp.lower95;otisp.(paramname).lower95];
                    otisp.upper95=[otisp.upper95;otisp.(paramname).upper95];
                end
                
                pstrtick=pstrtick+1;
                
            end
            
            
        paramname = ['AREA'];
        paramno = 2;
            otisp.(paramname).index = str2double(junk{upperrow+1+7*(paramno-1)});
            otisp.(paramname).fixed = junk{upperrow+2+7*(paramno-1)};
            otisp.(paramname).value = str2double(junk{upperrow+3+7*(paramno-1)});
            otisp.(paramname).stdev = str2double(junk{upperrow+4+7*(paramno-1)});
            otisp.(paramname).ratio = str2double(junk{upperrow+5+7*(paramno-1)});
            otisp.(paramname).lower95 = str2double(junk{upperrow+6+7*(paramno-1)});
            otisp.(paramname).upper95 = str2double(junk{upperrow+7+7*(paramno-1)});
            
            %store the values in the summary vectors if they are varied
            if strcmp(otisp.(paramname).fixed,'NO')==1
                
                %make the value log transformed to match if needed
                if strfind('log10',pstr(pstrtick))>0
                    otisp.bestfits = [otisp.bestfits;log10(otisp.(paramname).value)];
                    otisp.lower95=[otisp.lower95;log10(otisp.(paramname).lower95)];
                    otisp.upper95=[otisp.upper95;log10(otisp.(paramname).upper95)];
                else
                    %use non log-transformed version
                    otisp.bestfits = [otisp.bestfits;otisp.(paramname).value];
                    otisp.lower95=[otisp.lower95;otisp.(paramname).lower95];
                    otisp.upper95=[otisp.upper95;otisp.(paramname).upper95];
                end
                
                pstrtick=pstrtick+1;
                
            end
            
            
        paramname = ['AREA2'];
        paramno = 3;
            otisp.(paramname).index = str2double(junk{upperrow+1+7*(paramno-1)});
            otisp.(paramname).fixed = junk{upperrow+2+7*(paramno-1)};
            otisp.(paramname).value = str2double(junk{upperrow+3+7*(paramno-1)});
            otisp.(paramname).stdev = str2double(junk{upperrow+4+7*(paramno-1)});
            otisp.(paramname).ratio = str2double(junk{upperrow+5+7*(paramno-1)});
            otisp.(paramname).lower95 = str2double(junk{upperrow+6+7*(paramno-1)});
            otisp.(paramname).upper95 = str2double(junk{upperrow+7+7*(paramno-1)});
            
            %store the values in the summary vectors if they are varied
            if strcmp(otisp.(paramname).fixed,'NO')==1
                
                %make the value log transformed to match if needed
                if strfind('log10',pstr(pstrtick))>0
                    otisp.bestfits = [otisp.bestfits;log10(otisp.(paramname).value)];
                    otisp.lower95=[otisp.lower95;log10(otisp.(paramname).lower95)];
                    otisp.upper95=[otisp.upper95;log10(otisp.(paramname).upper95)];
                else
                    %use non log-transformed version
                    otisp.bestfits = [otisp.bestfits;otisp.(paramname).value];
                    otisp.lower95=[otisp.lower95;otisp.(paramname).lower95];
                    otisp.upper95=[otisp.upper95;otisp.(paramname).upper95];
                end
                
                pstrtick=pstrtick+1;
                
            end
            
            
        paramname = ['ALPHA'];
        paramno = 4;
            otisp.(paramname).index = str2double(junk{upperrow+1+7*(paramno-1)});
            otisp.(paramname).fixed = junk{upperrow+2+7*(paramno-1)};
            otisp.(paramname).value = str2double(junk{upperrow+3+7*(paramno-1)});
            otisp.(paramname).stdev = str2double(junk{upperrow+4+7*(paramno-1)});
            otisp.(paramname).ratio = str2double(junk{upperrow+5+7*(paramno-1)});
            otisp.(paramname).lower95 = str2double(junk{upperrow+6+7*(paramno-1)});
            otisp.(paramname).upper95 = str2double(junk{upperrow+7+7*(paramno-1)});
            
            
            %store the values in the summary vectors if they are varied
            if strcmp(otisp.(paramname).fixed,'NO')==1
                
                %make the value log transformed to match if needed
                if strfind('log10',pstr(pstrtick))>0
                    otisp.bestfits = [otisp.bestfits;log10(otisp.(paramname).value)];
                    otisp.lower95=[otisp.lower95;log10(otisp.(paramname).lower95)];
                    otisp.upper95=[otisp.upper95;log10(otisp.(paramname).upper95)];
                else
                    %use non log-transformed version
                    otisp.bestfits = [otisp.bestfits;otisp.(paramname).value];
                    otisp.lower95=[otisp.lower95;otisp.(paramname).lower95];
                    otisp.upper95=[otisp.upper95;otisp.(paramname).upper95];
                end
                
                pstrtick=pstrtick+1;
                
            end
            
            
            
            
        paramname = ['LAM'];
        paramno = 5;
            otisp.(paramname).index = str2double(junk{upperrow+1+7*(paramno-1)});
            otisp.(paramname).fixed = junk{upperrow+2+7*(paramno-1)};
            otisp.(paramname).value = str2double(junk{upperrow+3+7*(paramno-1)});
            otisp.(paramname).stdev = str2double(junk{upperrow+4+7*(paramno-1)});
            otisp.(paramname).ratio = str2double(junk{upperrow+5+7*(paramno-1)});
            otisp.(paramname).lower95 = str2double(junk{upperrow+6+7*(paramno-1)});
            otisp.(paramname).upper95 = str2double(junk{upperrow+7+7*(paramno-1)});
            
            
            %store the values in the summary vectors if they are varied
            if strcmp(otisp.(paramname).fixed,'NO')==1
                
                %make the value log transformed to match if needed
                if strfind('log10',pstr(pstrtick))>0
                    otisp.bestfits = [otisp.bestfits;log10(otisp.(paramname).value)];
                    otisp.lower95=[otisp.lower95;log10(otisp.(paramname).lower95)];
                    otisp.upper95=[otisp.upper95;log10(otisp.(paramname).upper95)];
                else
                    %use non log-transformed version
                    otisp.bestfits = [otisp.bestfits;otisp.(paramname).value];
                    otisp.lower95=[otisp.lower95;otisp.(paramname).lower95];
                    otisp.upper95=[otisp.upper95;otisp.(paramname).upper95];
                end
                
                pstrtick=pstrtick+1;
                
            end
            
            
            
        paramname = ['LAM2'];
        paramno = 6;
            otisp.(paramname).index = str2double(junk{upperrow+1+7*(paramno-1)});
            otisp.(paramname).fixed = junk{upperrow+2+7*(paramno-1)};
            otisp.(paramname).value = str2double(junk{upperrow+3+7*(paramno-1)});
            otisp.(paramname).stdev = str2double(junk{upperrow+4+7*(paramno-1)});
            otisp.(paramname).ratio = str2double(junk{upperrow+5+7*(paramno-1)});
            otisp.(paramname).lower95 = str2double(junk{upperrow+6+7*(paramno-1)});
            otisp.(paramname).upper95 = str2double(junk{upperrow+7+7*(paramno-1)});
            
            
            %store the values in the summary vectors if they are varied
            if strcmp(otisp.(paramname).fixed,'NO')==1
                
                %make the value log transformed to match if needed
                if strfind('log10',pstr(pstrtick))>0
                    otisp.bestfits = [otisp.bestfits;log10(otisp.(paramname).value)];
                    otisp.lower95=[otisp.lower95;log10(otisp.(paramname).lower95)];
                    otisp.upper95=[otisp.upper95;log10(otisp.(paramname).upper95)];
                else
                    %use non log-transformed version
                    otisp.bestfits = [otisp.bestfits;otisp.(paramname).value];
                    otisp.lower95=[otisp.lower95;otisp.(paramname).lower95];
                    otisp.upper95=[otisp.upper95;otisp.(paramname).upper95];
                end
                
                pstrtick=pstrtick+1;
                
            end
            
            
        paramname = ['RHO'];
        paramno = 7;
            otisp.(paramname).index = str2double(junk{upperrow+1+7*(paramno-1)});
            otisp.(paramname).fixed = junk{upperrow+2+7*(paramno-1)};
            otisp.(paramname).value = str2double(junk{upperrow+3+7*(paramno-1)});
            otisp.(paramname).stdev = str2double(junk{upperrow+4+7*(paramno-1)});
            otisp.(paramname).ratio = str2double(junk{upperrow+5+7*(paramno-1)});
            otisp.(paramname).lower95 = str2double(junk{upperrow+6+7*(paramno-1)});
            otisp.(paramname).upper95 = str2double(junk{upperrow+7+7*(paramno-1)});
            
            
            %store the values in the summary vectors if they are varied
            if strcmp(otisp.(paramname).fixed,'NO')==1
                
                %make the value log transformed to match if needed
                if strfind('log10',pstr(pstrtick))>0
                    otisp.bestfits = [otisp.bestfits;log10(otisp.(paramname).value)];
                    otisp.lower95=[otisp.lower95;log10(otisp.(paramname).lower95)];
                    otisp.upper95=[otisp.upper95;log10(otisp.(paramname).upper95)];
                else
                    %use non log-transformed version
                    otisp.bestfits = [otisp.bestfits;otisp.(paramname).value];
                    otisp.lower95=[otisp.lower95;otisp.(paramname).lower95];
                    otisp.upper95=[otisp.upper95;otisp.(paramname).upper95];
                end
                
                pstrtick=pstrtick+1;
                
            end
            
            
        paramname = ['KD'];
        paramno = 8;
            otisp.(paramname).index = str2double(junk{upperrow+1+7*(paramno-1)});
            otisp.(paramname).fixed = junk{upperrow+2+7*(paramno-1)};
            otisp.(paramname).value = str2double(junk{upperrow+3+7*(paramno-1)});
            otisp.(paramname).stdev = str2double(junk{upperrow+4+7*(paramno-1)});
            otisp.(paramname).ratio = str2double(junk{upperrow+5+7*(paramno-1)});
            otisp.(paramname).lower95 = str2double(junk{upperrow+6+7*(paramno-1)});
            otisp.(paramname).upper95 = str2double(junk{upperrow+7+7*(paramno-1)});
            
            
            %store the values in the summary vectors if they are varied
            if strcmp(otisp.(paramname).fixed,'NO')==1
                
                %make the value log transformed to match if needed
                if strfind('log10',pstr(pstrtick))>0
                    otisp.bestfits = [otisp.bestfits;log10(otisp.(paramname).value)];
                    otisp.lower95=[otisp.lower95;log10(otisp.(paramname).lower95)];
                    otisp.upper95=[otisp.upper95;log10(otisp.(paramname).upper95)];
                else
                    %use non log-transformed version
                    otisp.bestfits = [otisp.bestfits;otisp.(paramname).value];
                    otisp.lower95=[otisp.lower95;otisp.(paramname).lower95];
                    otisp.upper95=[otisp.upper95;otisp.(paramname).upper95];
                end
                
                pstrtick=pstrtick+1;
                
            end
            
            
        paramname = ['LAMHAT'];
        paramno = 9;
            otisp.(paramname).index = str2double(junk{upperrow+1+7*(paramno-1)});
            otisp.(paramname).fixed = junk{upperrow+2+7*(paramno-1)};
            otisp.(paramname).value = str2double(junk{upperrow+3+7*(paramno-1)});
            otisp.(paramname).stdev = str2double(junk{upperrow+4+7*(paramno-1)});
            otisp.(paramname).ratio = str2double(junk{upperrow+5+7*(paramno-1)});
            otisp.(paramname).lower95 = str2double(junk{upperrow+6+7*(paramno-1)});
            otisp.(paramname).upper95 = str2double(junk{upperrow+7+7*(paramno-1)});
            
            
            %store the values in the summary vectors if they are varied
            if strcmp(otisp.(paramname).fixed,'NO')==1
                
                %make the value log transformed to match if needed
                if strfind('log10',pstr(pstrtick))>0
                    otisp.bestfits = [otisp.bestfits;log10(otisp.(paramname).value)];
                    otisp.lower95=[otisp.lower95;log10(otisp.(paramname).lower95)];
                    otisp.upper95=[otisp.upper95;log10(otisp.(paramname).upper95)];
                else
                    %use non log-transformed version
                    otisp.bestfits = [otisp.bestfits;otisp.(paramname).value];
                    otisp.lower95=[otisp.lower95;otisp.(paramname).lower95];
                    otisp.upper95=[otisp.upper95;otisp.(paramname).upper95];
                end
                
                pstrtick=pstrtick+1;
                
            end
            
            
        paramname = ['LAMHAT2'];
        paramno = 10;
            otisp.(paramname).index = str2double(junk{upperrow+1+7*(paramno-1)});
            otisp.(paramname).fixed = junk{upperrow+2+7*(paramno-1)};
            otisp.(paramname).value = str2double(junk{upperrow+3+7*(paramno-1)});
            otisp.(paramname).stdev = str2double(junk{upperrow+4+7*(paramno-1)});
            otisp.(paramname).ratio = str2double(junk{upperrow+5+7*(paramno-1)});
            otisp.(paramname).lower95 = str2double(junk{upperrow+6+7*(paramno-1)});
            otisp.(paramname).upper95 = str2double(junk{upperrow+7+7*(paramno-1)});
            
            
            %store the values in the summary vectors if they are varied
            if strcmp(otisp.(paramname).fixed,'NO')==1
                
                %make the value log transformed to match if needed
                if strfind('log10',pstr(pstrtick))>0
                    otisp.bestfits = [otisp.bestfits;log10(otisp.(paramname).value)];
                    otisp.lower95=[otisp.lower95;log10(otisp.(paramname).lower95)];
                    otisp.upper95=[otisp.upper95;log10(otisp.(paramname).upper95)];
                else
                    %use non log-transformed version
                    otisp.bestfits = [otisp.bestfits;otisp.(paramname).value];
                    otisp.lower95=[otisp.lower95;otisp.(paramname).lower95];
                    otisp.upper95=[otisp.upper95;otisp.(paramname).upper95];
                end
                
                pstrtick=pstrtick+1;
                
            end
            
            
            
        clear junk
            
end




%Eliminate data that is below the slider threshold
dat = sortrows(dat,ff(1)+PS);
numdat = floor((slider_value / 100) * size(dat));
dat(numdat+1:size(dat),:) = [];

perfs=str2mat(lhoods,vars);
lp=PS;

% READ PARETO RANKING
if ~isempty(gvs.pareto)
   pranks = gvs.pareto;
end

if ff(1)<=4
  subp='2,2,';
elseif ff(1)>4&ff(1)<=9
   subp='3,3,';
elseif ff(1)>9&ff(1)<=12
   subp='4,3,';
else %ff(1)>12&ff(1)<=16
   subp='4,4,';
end

for i=1:ff(1)
if ff(1)>1,eval(['subplot(' subp num2str(i) ')']),end
nn=find(dat(:,ff(1)+lp)==min(dat(:,ff(1)+lp)));
nn=nn(1);
plot(dat(:,i),dat(:,ff(1)+lp),'o','markersize',3,'MarkerEdgeColor','k','MarkerFaceColor','b'); hold on, 
plot(dat(nn,i),dat(nn,ff(1)+lp),'s','markersize',10,'MarkerEdgeColor','k','MarkerFaceColor','m'); % best parameter
if ~isempty(gvs.pareto)
   hold on;
   plot(pranks(:,1+i),pranks(:,1+ff(1)+lp),'d','MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',5); %pareto set
end

yaxmin=min(dat(:,ff(1)+lp))-0.1*(max(dat(:,ff(1)+lp))-min(dat(:,ff(1)+lp)));
yaxmax=max(dat(:,ff(1)+lp))+0.1*(max(dat(:,ff(1)+lp))-min(dat(:,ff(1)+lp)));

if exist('OTIS-P_files/star.out')~=0
%IF OTIS-P results exist, plot them
    %best fit
        plot([otisp.bestfits(i) otisp.bestfits(i)],[yaxmin yaxmax],'r')
    %lower 95% CI
        plot([otisp.lower95(i) otisp.lower95(i)],[yaxmin yaxmax],'r--')
    %upper 95% CI
        plot([otisp.upper95(i) otisp.upper95(i)],[yaxmin yaxmax],'r--')
    %set axis to show data and OTIS-P outcomes    
        axis([min([dat(:,i);otisp.lower95(i)]-0.1) max([dat(:,i);otisp.upper95(i)+0.1]) yaxmin yaxmax]);

else
%set axis as usual and move on with your life
	axis([min(dat(:,i)) max(dat(:,i)) yaxmin yaxmax]);
    
end
        
        
hold off;

temp=deblank(perfs(lp,:));
ylabel(temp)
xlabel(pars(i,:));
end




