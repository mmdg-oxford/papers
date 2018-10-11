% Plot electronic bandstructure

figure('Units', 'pixels', ...
    'Position', [100 100 1300 850]);
hold on;

size = 16

SpecfunID = fopen('ganbands2.dat.gnu');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS = cell2mat(data);
fclose(SpecfunID);

fermi = 10.9375; % eV
ry2ev = 13.605698066 ;

BS(:,2) = BS(:,2)*ry2ev - fermi;

%%%%%%%%%
% KS BS %
%%%%%%%%%
plot(BS(:,1),BS(:,2),'Color','blue','LineWidth',2);
hold on;
range = 33015:33309;
plot(BS(range,1),BS(range,2),'Color','red','LineWidth',3);
hold on;
range = 31000:32510;
plot(BS(range,1),BS(range,2),'Color','red','LineWidth',3);
hold on;
range = 29918:31200;
plot(BS(range,1),BS(range,2),'Color','red','LineWidth',3);
hold on;

% Now plot horizontal line to show Fermi level
vert = zeros(100);
horizontal = linspace(0,max(BS(:,1)),100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '--');
vert = 13*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
% Now plotvertical line
horizontal = 1*ones(100);
vert = linspace(min(BS(:,2))-2,max(BS(:,2))+2,100);
horizontal = 0.0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 0.666666*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 1.0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 1.5774*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 1.8841*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 2.5508*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 2.8841*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 3.461428*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');


axis([0,max(BS(:,1)),-8,8]) % change axis limit

ylabel('E-E_F (eV)','FontSize',size);
ay = gca;
set(gca,'FontSize',size);
set(gca,'LineWidth',2);
ay.YTick = [-8 -6 -4 -2 0 2 4 6 8];


ax = gca;
set(gca,'FontSize',size);
set(gca,'LineWidth',2);
ax.XTick = [0 0.66666 1.0 1.5774 1.8841 2.5508 2.8841 3.461428];
ax.XTickLabel = {'\Gamma','K','M','\Gamma','A','H','L','A','FontSize',size};



box off
axes('xlim', [0 3.461428], 'ylim', [-8 8], 'color', 'none',...
'YTick',[-8 -6 -4 -2 0 2 4 6 8],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 0.66666 1.0 1.5774 1.8841 2.5508 2.8841 3.461428],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')


%set(gcf, 'PaperPositionMode', 'auto');
%print -depsc2 GaN_BS2.eps
%print('GaN_BS2','-dpng')
%close;

