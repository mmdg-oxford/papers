% Plot electronic bandstructure

%  figure('Units', 'pixels', ...
%      'Position', [100 100 1300 950]);

SpecfunID = fopen('MgB2bands.dat.gnu');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS = cell2mat(data);
fclose(SpecfunID);


size = 16
cm2mev = 0.12398 ;
Thz2meV = 4.13567;
ry2ev = 13.605698066 ;
ratio1 = 1.4 
ratio2 = 1


fermi = 7.4273; % eV

BS(:,2) = BS(:,2)*ry2ev - fermi;


%%%%%%%%%
% KS BS %
%%%%%%%%%
h(1) =subplot(2,2,1)
plot(BS(:,1),BS(:,2),'Color','blue','LineWidth',2);
hold on;



% Now plot horizontal line to show Fermi level
vert = zeros(100);
horizontal = linspace(0,max(BS(:,1)),100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '--');
vert = 7*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
vert = -10*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');

vert = linspace(-11,10,100);
horizontal = 0.*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
horizontal = 0.666666*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 1.0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 1.5774*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 2.0151*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 2.6818*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 3.0151*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 3.592502*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');

axis([0,3.592502,0,110]) % change axis limit


axis([0,max(BS(:,1)),-10,7]) % change axis limit

ylabel('E-E_F (eV)','FontSize',size);


ax = gca;
set(gca,'FontSize',size, 'LineWidth',2);
ax.XTick = [0 0.66666 1.0 1.5774 2.0151 2.6818 3.0151 3.5925];
ax.XTickLabel = {'\Gamma','K','M','\Gamma','A','H','L','A','FontSize',size};



%title('Spectral function of B-doped diamond (meV^{-1})','FontSize',14)

% Now plot the DOS
SpecfunID = fopen('MgB2.dos');
data = textscan(SpecfunID,'%f %f %f\n','CommentStyle','#','CollectOutput',true);
dos = cell2mat(data);
fclose(SpecfunID);

h(2) =subplot(2,2,2)
plot(dos(:,2),dos(:,1)-fermi,'Color','blue','LineWidth',2);
hold on;
axis([0,2,-10,7]) % change axis limit
vert = zeros(100);
horizontal = linspace(0,2,100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '--');
set(gca,'YTickLabel',[]);
ax = gca;
set(gca,'FontSize',size, 'LineWidth',2);
ax.YTick = [-10 -5 0 5];

% get(h(2),'Position');
% set(h(2),'position',[0.56 0.11 0.08 0.815]);
%xlabel('DOS','FontSize',size);



h(3) = subplot(2,2,3);

SpecfunID = fopen('MgB2.freq.gp');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS = cell2mat(data);
fclose(SpecfunID);



for ii = 2:10
  plot(BS(:,1),BS(:,ii)*cm2mev,'Color','blue','LineWidth',2,'LineStyle', '-');
  hold on;
end
hold on;


SpecfunID = fopen('xyscan_MgB2_expPRL90_095506.txt');
data = textscan(SpecfunID,'%f %f %f %f %f %f \n','CommentStyle','#','CollectOutput',true);
exp = cell2mat(data);
fclose(SpecfunID);


for ii = 1:length(exp(:,1))
    if exp(ii,1) < 1.02 
      plot(exp(ii,1)+1.0,exp(ii,2),'.', 'markersize',15,'Color','black' );
    else 
      plot(3.592502+1.01514030509-exp(ii,1),exp(ii,2),'.', 'markersize',15,'Color','black' );  
    end
end

plot(3.592502,27.551,'.', 'markersize',15,'Color','black' );
plot(3.592502,58.9796,'.', 'markersize',15,'Color','black' );


vert = linspace(0,110,100);
horizontal = 0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
horizontal = 0.666666*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 1.0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 1.5774*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 2.0151*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 2.6818*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 3.0151*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 3.592502*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');



axis([0,3.592502,0,110]) % change axis limit

ylabel('\omega (meV)','FontSize',size);
ay = gca;
set(gca,'FontSize',size,'LineWidth',2);
ay.YTick = [0 20 40 60 80 100];




ax = gca;
set(gca,'FontSize',size, 'LineWidth',2);
ax.XTick = [0 0.66666 1.0 1.5774 2.0151 2.6818 3.0151 3.592502];
ax.XTickLabel = {'\Gamma','K','M','\Gamma','A','H','L','A','FontSize',size};




h(4) =subplot(2,2,4)

SpecfunID = fopen('MgB2.phdos');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
dos = cell2mat(data);
fclose(SpecfunID);


plot(dos(:,2),dos(:,1)*cm2mev,'Color','blue','LineWidth',2);
hold on;
axis([0,0.1,0,110]) % change axis limit
vert = linspace(0,0.2,100);
horizontal = 110*ones(100);
plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');

vert = 0.1*ones(100);
horizontal = linspace(0,110,100);
plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
vert = 0.0*ones(100);
plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
set(gca,'YTickLabel',[]);
ax = gca;
set(gca,'FontSize',size, 'LineWidth',2);
ax.YTick = [0 20 40 60 80 100];
ax.XTick = [0 0.05 0.1];
ax.XTickLabel = {'0',' ','X','FontSize',size};
% get(h(2),'Position');
% set(h(2),'position',[0.56 0.11 0.08 0.815]);
set(gca,'xticklabel',{[]}) 
xlabel('DOS','FontSize',size);



%set(h, 'box', 'off');

pos1 = get(h(1),'Position');
pos2 = get(h(2),'Position');
pos3 = get(h(3),'Position');
pos4 = get(h(4),'Position');


set(h(1),'XTickLabel','');

pos3(2) = pos1(2) - pos3(4)-0.02;
set(h(3),'Position',pos3);

set(h(2),'XTickLabel','');

pos4(2) = pos2(2) - pos4(4)-0.02;
set(h(4),'Position',pos4);

get(h(2),'Position');
set(h(2),'position',[0.48 0.5838 0.08 0.3412]);

get(h(4),'Position')
set(h(4),'position',[0.48 0.2227 0.08 0.3412]);

pos1 = get(h(1),'Position');
pos2 = get(h(2),'Position');
pos3 = get(h(3),'Position');
pos4 = get(h(4),'Position');


 text(pos1(1)+3.2,pos1(3)-8.9,['(',char(1+96),') '],...
     'color','k','fontw','b','FontSize',size,'Parent', h(1));
 text(pos2(1)+0.88,pos2(3)-8.8,['(',char(2+96),') '],...
     'color','k','fontw','b','FontSize',size,'Parent', h(2));
  text(pos3(1)+3.2,pos3(3)+9,['(',char(3+96),') '],...
     'color','k','fontw','b','FontSize',size,'Parent', h(3));
   text(pos4(1)-0.412,pos4(3)+9,['(',char(4+96),') '],...
     'color','k','fontw','b','FontSize',size,'Parent', h(4));

box off
axes('Position',pos1,'xlim', [0 3.592502], 'ylim', [-10 7], 'color', 'none',...
'YTick',[-10 -5 0 5 ],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 0.66666 1.0 1.5774 2.0151 2.6818 3.0151 3.592502],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')
axes('Position',pos2,'xlim', [0 2], 'ylim', [-10 7], 'color', 'none',...
'YTick',[20, 40, 60],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0,1,2],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')
axes('Position',pos3,'xlim', [0 3.592502], 'ylim', [0 110], 'color', 'none',...
'YTick',[20, 40, 60, 80, 100 ],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 0.66666 1.0 1.5774 2.0151 2.6818 3.0151 3.592502],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')
axes('Position',pos4,'xlim', [0 0.1], 'ylim', [0 110], 'color', 'none',...
'YTick',[20, 40, 60, 80, 100],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0,0.05, 0.1],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')


h=gcf
set(h, 'PaperPositionMode', 'auto');
set(h,'PaperOrientation','landscape');
set(h,'Position',[100 100 1200 650]);
print(h, '-dpdf', 'MgB2_BS.pdf')



%set(gcf, 'PaperPositionMode', 'auto');
%print -depsc2 Pb_BS.eps
%print('Pb_BS','-dpng')
%close;

