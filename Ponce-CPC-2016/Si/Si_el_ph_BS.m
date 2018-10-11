% Plot electronic bandstructure

%  figure('Units', 'pixels', ...
%      'Position', [100 100 1300 950]);

SpecfunID = fopen('sibands.dat.gnu');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS = cell2mat(data);
fclose(SpecfunID);


size = 16
cm2mev = 0.12398 ;
Thz2meV = 4.13567;
ry2ev = 13.605698066 ;
ratio1 = 1.4 
ratio2 = 1


fermi = 6.296396; % eV

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
vert = 13*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
vert = -13*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
% Now plotvertical line
horizontal = 1*ones(100);
vert = linspace(min(BS(:,2))-2,max(BS(:,2))+2,100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 0.0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 1.5*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 2.2071*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 2.8195*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 3.8801*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 4.7462*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');


axis([0,max(BS(:,1)),-10,7]) % change axis limit

ylabel('E-E_F (eV)','FontSize',size);

% get(h(1),'Position');
% set(h(1),'position',[0.13 0.11 0.4 0.815]);

% annotation('textbox',...
%     [0.73 0.8 0.1 0.1],...
%     'String',{'T = 0.01 K ',['i\delta = 0.1 eV' ]},...
%     'FontSize',14,...
%     'FontName','Arial',...
%     'LineStyle','-',...
%     'EdgeColor',[0 0 0],...
%     'LineWidth',1,...
%     'BackgroundColor',[0.9  0.9 0.9],...
%     'Color',[0 0 0]);



ax = gca;
set(gca,'FontSize',size, 'LineWidth',2);
ax.YTick = [-10 -5 0 5];
ax.XTick = [0 1.0 1.5 2.2071 2.8195 3.8801 4.7462];
ax.XTickLabel = {'\Gamma','X','W','L','K','\Gamma','L','FontSize',size};



%title('Spectral function of B-doped diamond (meV^{-1})','FontSize',14)

% Now plot the DOS
SpecfunID = fopen('si.dos');
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


% pos1 = get(h(1),'Position');
% pos2 = get(h(2),'Position');
% 
% box off
% axes('Position',pos1,'xlim', [0 max(BS(:,1))], 'ylim', [-10,7], 'color', 'none',...
% 'YTick',[-10 -5 0 5 ],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
% 'XTick',[0 1.0 1.5 2.2071 2.8195 3.8801 4.7462],...
% 'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')
% axes('Position',pos2,'xlim', [0 2], 'ylim', [-10,7], 'color', 'none',...
% 'YTick',[-10 -5 0 5 ],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
% 'XTick',[0 1.0 1.5 2.2071 2.8195 3.8801 4.7462],...
% 'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')





h(3) = subplot(2,2,3);

SpecfunID = fopen('si.freq.gp');
data = textscan(SpecfunID,'%f %f %f %f %f %f  %f \n','CommentStyle','#','CollectOutput',true);
BS4 = cell2mat(data);
fclose(SpecfunID);



for ii = 2:6
  plot(BS4(:,1),BS4(:,ii)*cm2mev,'Color','blue','LineWidth',2,'LineStyle', '-');
  hold on;
end


hold on;


vert = linspace(0,4.7462,100);
horizontal = 80*ones(100);
plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
horizontal = 0*ones(100);
plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');

vert = linspace(min(BS4(:,2))-2,max(BS4(:,6))*cm2mev+20,100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
horizontal = 0.0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 1.0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 1.5*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 2.2071*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 2.8195*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 3.8801*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 4.7462*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');



axis([0,4.7462,0,70])

ylabel('\omega (meV)','FontSize',size);

% axis([0,3.461428,0,100]) % change axis limit
% 
% set(gca,'FontSize',size);
% set(gca,'LineWidth',2);
% set(gca,'ytick',[ 20, 40, 60, 80])
% set(gca,'xtick',[0, 0.66666, 1.0, 1.5774, 1.8841, 2.5508, 2.8841, 3.461428]);


ax = gca;
set(gca,'FontSize',size, 'LineWidth',2);
set(gca,'ytick',[ 20, 40, 60])
ax.XTick = [0 1.0 1.5 2.2071 2.8195 3.8801 4.7462];
ax.XTickLabel = {'\Gamma','X','W','L','K','\Gamma','L','FontSize',size};


%Experimental data

% Gamma - X(0.5 0.5 0.0)

x = [2.89020666667,3.03162, 3.17303333333, 3.31444666666, 3.45585999998, 3.59727333331, 3.73868666665];
y = [4.54,4.49, 4.24,3.8,3.15,2.28,1.22];
plot(x,y.*Thz2meV ,'k^','Markersize',7,'MarkerFaceColor','black');

x = [2.89020666667,3.03162, 3.17303333333, 3.31444666666, 3.45585999998, 3.59727333331, 3.73868666665];
y = [6.76, 6.66, 6.03, 5.16, 4.12,2.91, 1.53   ];
plot(x,y.*Thz2meV ,'k^','Markersize',7,'MarkerFaceColor','black');

x = [3.03162, 3.17303333333 ];
y = [11.92, 14.39];
plot(x,y.*Thz2meV ,'k^','Markersize',7,'MarkerFaceColor','black');

% Gamma - L(0.5 0.5 0.5)

x = [4.05332, 4.22654, 4.39976, 4.57298,4.57298, 4.7461];
y = [1.54, 2.63, 3.19, 3.37, 13.4, 3.41 ];
plot(x,y.*Thz2meV ,'k^','Markersize',7,'MarkerFaceColor','black');


x = [0,3.8801 , 1.0, 1.0, 1.5, 4.7461, 4.7461 ];
y = [15.53, 15.53, 13.91, 4.5, 14.42, 14.69, 3.42  ];
plot(x,y.*Thz2meV ,'.k','Markersize',30,'MarkerFaceColor','black');



h(4) =subplot(2,2,4)

SpecfunID = fopen('si.phdos');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
dos = cell2mat(data);
fclose(SpecfunID);



plot(dos(:,2),dos(:,1)*cm2mev,'Color','blue','LineWidth',2);
hold on;
axis([0,0.1,0,70]) % change axis limit
vert = linspace(0,0.2,100);
horizontal = 80*ones(100);
plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');

vert = 0.1*ones(100);
horizontal = linspace(0,80,100);
plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
set(gca,'YTickLabel',[]);
ax = gca;
set(gca,'FontSize',size, 'LineWidth',2);
ax.YTick = [0 20 40 60];

set(gca,'xticklabel',{[]}) 
%ax.XTick = [0 0.05 0.1];
%ax.XTickLabel = {'',' ','','FontSize',size};
% get(h(2),'Position');
% set(h(2),'position',[0.56 0.11 0.08 0.815]);
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

box off
axes('Position',pos1,'xlim', [0 4.7462], 'ylim', [-10 7], 'color', 'none',...
'YTick',[-10 -5 0 5 ],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 1.0 1.5 2.2071 2.8195 3.8801 4.7462],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')
axes('Position',pos2,'xlim', [0 2], 'ylim', [-10 7], 'color', 'none',...
'YTick',[20, 40, 60],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0,1,2],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')
axes('Position',pos3,'xlim', [0 4.7462], 'ylim', [0 70], 'color', 'none',...
'YTick',[20, 40, 60 ],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 1.0 1.5 2.2071 2.8195 3.8801 4.7462],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')
axes('Position',pos4,'xlim', [0 0.1], 'ylim', [0 70], 'color', 'none',...
'YTick',[20, 40, 60],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0,0.05, 0.1],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')


h=gcf
set(h, 'PaperPositionMode', 'auto');
set(h,'PaperOrientation','landscape');
set(h,'Position',[100 100 1200 650]);
print(h, '-dpdf', 'Si_bandstructures.pdf')



% set(gcf, 'PaperPositionMode', 'auto');
% print -depsc2 Pb_BS.eps
% print('Pb_BS','-dpng')
% close;

