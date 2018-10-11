% Plot electronic bandstructure


SpecfunID = fopen('linewidth_30000k150000q_01_0K.elself');
data = textscan(SpecfunID,'%f %f %f %f\n','CommentStyle','#','CollectOutput',true);
scattering_01 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('linewidth_30000k150000q_01_300K.elself');
data = textscan(SpecfunID,'%f %f %f %f\n','CommentStyle','#','CollectOutput',true);
scattering_02 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('linewidth_40000k80000q_001_0K.elself');
data = textscan(SpecfunID,'%f %f %f %f\n','CommentStyle','#','CollectOutput',true);
scattering_03 = cell2mat(data);
fclose(SpecfunID);


size = 12

% CBM = 6.7531
fermi_coarse = 6.2988; % eV
%fermi = 6.367118;
fermi = 6.546396  ;
shift = 0.15
ry2ev = 13.605698066 ;
meV2ps = 4.13567;

% scattering = 2pi/hbar in meV ps
%meV2ps = 2*pi/0.6582119514
meV2ps = 2/0.6582119514

%CBM = 6.546396



scattering_01(:,3) = scattering_01(:,3)+shift;
scattering_01(:,4) = (scattering_01(:,4)*meV2ps); %goes from meV to ps-1
scattering_02(:,3) = scattering_02(:,3)+shift;
scattering_02(:,4) = (scattering_02(:,4)*meV2ps); %goes from meV to ps-1
scattering_03(:,3) = scattering_03(:,3)+shift;
scattering_03(:,4) = (scattering_03(:,4)*meV2ps); %goes from meV to ps-1

hold on;
plot(NaN,'r.','markersize', 30);
plot(NaN,'g.','markersize', 30);
plot(NaN,'k','LineWidth',2);
legend('0 K','300 K', 'DOS','Location','northwest');

plot(scattering_01(:,3),scattering_01(:,4),'r.','markersize', 6);
hold on;
plot(scattering_02(:,3),scattering_02(:,4),'g.','markersize', 6);
hold on;
%plot(scattering_03(:,3),scattering_03(:,4),'b.','markersize', 10);
%hold on;



%DOS


fermi = 6.296396 + 0.21; % eV


SpecfunID = fopen('si.dos');
data = textscan(SpecfunID,'%f %f %f\n','CommentStyle','#','CollectOutput',true);
dos = cell2mat(data);
fclose(SpecfunID);

plot(dos(1:145,1)-fermi,dos(1:145,2)*180,'Color','black','LineWidth',2);
hold on;

fermi = 6.296396 + 0.0; % eV
plot(dos(146:281,1)-fermi,dos(146:281,2)*180,'Color','black','LineWidth',2);
hold on;

%legend('0 K','300 K', 'DOS','Location','northwest')


vert = 400*ones(100);
horizontal = linspace(-4,4,100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
hold on;
vert = 4.0*ones(100);
horizontal = linspace(0,400,100);
plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
hold on;
axis([-4,4,0.001,400]) % change axis limit





ylabel('Scattering rate (1/ps)','FontSize',size);
xlabel('Electron energy (eV)','FontSize',size);
hold on;
ax = gca;
set(gca,'FontSize',size, 'LineWidth',2);
ax.YTick = [0 100 200 300 400];
set(gca, 'Layer','top')



axes('xlim', [-4 4], 'ylim', [1 400], 'color', 'none',...
'YTick',[ 100 200 300  ],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[-2 0 2],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')

% h=gcf
% set(h, 'PaperPositionMode', 'auto');
% %set(h,'PaperOrientation','landscape');
% set(h,'Position',[50 50 900 550]);
% %print(h, '-dpdf', 'Si_scattering.pdf')
% print(h,'Si_scattering.png', '-dpng', '-r300');

h=gcf
set(h,'PaperUnits','inches','PaperPosition',[0 0 7 4])
print(h,'Si_scattering2.jpg', '-djpeg', '-r400');



% h=gcf
% set(h, 'PaperPositionMode', 'auto');
% set(h,'PaperOrientation','landscape');
% set(h,'Position',[50 50 700 450]);
% print(h, '-dpdf', 'Si_scattering2.pdf')





