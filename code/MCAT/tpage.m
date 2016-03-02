function tpage(progname,author,additional,elps)

% function tpage(progname,author,elps)
%
% flashes up an IC & PSU title page
%
% progname is the program name string
% author is the author and date string
% elps is the pause time
%
% Matthew Lees & Thorsten Wagener, Imperial College London, April 1998
% Thorsten Wagener, Imperial College London, June 2000
% Thorsten Wagener, Penn State, October 2004

% requires loadbmp, psu1.bmp, logo.bmp

[xl,mapl]=loadbmp('psu');
%[xc,mapc]=loadbmp('logo');

bgc=[1 1 0]; % yellow
%bgc=[1 1 1]; % white
txtc=[0 0 .3333]; % blue
txtc=[0 0 0];

mapl(xl(1,1),:)=bgc;
%mapc(xc(1,1),:)=bgc;

ssize=get(0,'screensize');
px=ssize(3)/2-250;
py=ssize(4)/2-125;

fth=figure('pos',[px py 500 250],'number','off'...
  ,'menu','none','color',bgc,'resize','off');
set(gcf,'defaultaxesunits','pixels')
axes('visible','off')

teh=text(0,0.9,progname);
set(teh,'fontsize',30,'color',txtc);
teh=text(0,0.7,[setstr(169) ' ' author]);
set(teh,'fontsize',12,'color',txtc);
teh=text(0,0.6,[additional]);
set(teh,'fontsize',12,'color',txtc);

%axes('position',[50 20 267 102])
axes('position',[150 20 180 102])
image(xl);
colormap(mapl);
set(gca,'visible','off');

%axes('position',[350 19 101 105])
%image(xc);
%colormap(mapc);
%set(gca,'visible','off');
%colormap(mapl);

pause(elps)
close(fth);