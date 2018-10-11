% Plot electronic bandstructure

% figure('Units', 'pixels', ...
%     'Position', [150 100 900 550]);
% hold on;


SpecfunID = fopen('pbbands.dat.gnu');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('pbbands_noncol.dat.gnu');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS_noncol = cell2mat(data);
fclose(SpecfunID);

size = 16

fermi = 11.6078; % eV
fermi_noncol = 11.3329
ry2ev = 13.605698066 ;

BS(:,2) = BS(:,2)*ry2ev - fermi;
BS_noncol(:,2) = BS_noncol(:,2)*ry2ev - fermi_noncol;

%%%%%%%%%
% KS BS %
%%%%%%%%%
v=subplot(1,2,1)
plot(BS_noncol(:,1),BS_noncol(:,2),'Color','red','LineWidth',2);
hold on;
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


axis([0,max(BS(:,1)),-13,13]) % change axis limit

ylabel('E-E_F (eV)','FontSize',size);

get(v,'Position');
set(v,'position',[0.13 0.11 0.4 0.815]);

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
ax.XTick = [0 1.0 1.5 2.2071 2.8195 3.8801 4.7462];
ax.XTickLabel = {'\Gamma','X','W','L','K','\Gamma','L','FontSize',size};









%title('Spectral function of B-doped diamond (meV^{-1})','FontSize',14)

% Now plot the DOS
SpecfunID = fopen('pb.dos');
data = textscan(SpecfunID,'%f %f %f\n','CommentStyle','#','CollectOutput',true);
dos = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('pb_noncol.dos');
data = textscan(SpecfunID,'%f %f %f\n','CommentStyle','#','CollectOutput',true);
dos_noncol = cell2mat(data);
fclose(SpecfunID);


h=subplot(1,2,2)
plot(dos_noncol(:,2),dos_noncol(:,1)-fermi_noncol,'Color','red','LineWidth',2);
hold on;
plot(dos(:,2),dos(:,1)-fermi,'Color','blue','LineWidth',2);
hold on;
axis([0,1,-13,13]) % change axis limit
vert = zeros(100);
horizontal = linspace(0,1,100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '--');
set(gca,'YTickLabel',[]);
ax = gca;
set(gca,'FontSize',size, 'LineWidth',2);

get(h,'Position');
set(h,'position',[0.54 0.11 0.08 0.815]);
set(gca,'xticklabel',{[]}) 
xlabel('DOS','FontSize',size);


pos1 = get(v,'Position');
pos2 = get(h,'Position');

box off
axes('Position',pos1,'xlim', [0 max(BS(:,1))], 'ylim', [-13,13], 'color', 'none',...
'YTick',[-10 -5 0 5 10],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 1.0 1.5 2.2071 2.8195 3.8801 4.7462],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')
axes('Position',pos2,'xlim', [0 1], 'ylim', [-13,13], 'color', 'none',...
'YTick',[-10 -5 0 5 10],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 1.0 1.5 2.2071 2.8195 3.8801 4.7462],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')



h=gcf
set(h, 'PaperPositionMode', 'auto');
set(h,'PaperOrientation','landscape');
set(h,'Position',[50 50 1000 600]);

print(h, '-dpdf', 'Pb_BS2.pdf')


% h=gcf
% set(h, 'PaperPositionMode', 'auto');
% %set(h,'PaperOrientation','landscape');
% set(h,'Position',[50 50 900 600]);
% print(h, '-dpdf', 'Pb_BS.pdf')

%set(gcf, 'PaperPositionMode', 'auto');
%print -depsc2 Pb_BS.eps
%print('Pb_BS','-dpng')
%close;

