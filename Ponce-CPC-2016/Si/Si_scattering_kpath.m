% Plot electronic bandstructure


SpecfunID = fopen('linewidth.elself_6');
data = textscan(SpecfunID,'%f %f %f %f\n','CommentStyle','#','CollectOutput',true);
scattering_01 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('linewidth.elself_7');
data = textscan(SpecfunID,'%f %f %f %f\n','CommentStyle','#','CollectOutput',true);
scattering_02 = cell2mat(data);
fclose(SpecfunID);



size = 16

% CBM = 6.7531
fermi_coarse = 6.2988; % eV
%fermi = 6.367118;
fermi = 6.546396  ;
shift = 0.068
ry2ev = 13.605698066 ;
meV2ps = 4.13567;

% scattering = 2pi/hbar in meV ps
%meV2ps = 2*pi/0.6582119514
meV2ps = 2/0.6582119514

%CBM = 6.546396



scattering_01(:,3) = scattering_01(:,3);
scattering_01(:,4) = (scattering_01(:,4)*meV2ps); %goes from meV to ps-1
scattering_02(:,3) = scattering_02(:,3);
scattering_02(:,4) = (scattering_02(:,4)*meV2ps); %goes from meV to ps-1

scattering_CBM = zeros(1,501);
scattering_CBM2 = zeros(1,501);

ii = 1
jj = 1
while ii < 502 
    if (scattering_01(jj,2) > 4.9 & scattering_01(jj,2) < 5.1 )
      scattering_CBM(ii) =  scattering_01(jj,4);  
      scattering_CBM2(ii) =  scattering_02(jj,4);
      ii = ii +1 ; 
    end
    jj = jj +1 ;
end
 


x = linspace(0,0.2,501);    


% hold on;
% plot(NaN,'r.','markersize', 30);
% plot(NaN,'g.','markersize', 30);
% legend('0 K','300 K','Location','northwest');

h(1) =subplot(2,1,1)


plot(x,scattering_CBM,'r.','markersize', 10);
hold on;
plot(x,scattering_CBM2,'g.','markersize', 10);
hold on;
% plot(scattering_02(:,3)-shift,scattering_02(:,4),'g.','markersize', 10);
% hold on;

% 
% 
% 
% vert = 400*ones(100);
% horizontal = linspace(-4,4,100);
% plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
% hold on;
% vert = 4.0*ones(100);
% horizontal = linspace(0,400,100);
% plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
% hold on;

ylabel('Scattering rate (1/ps)','FontSize',size);

axis([0,0.2,0.0, 100]) % change axis limit


ax = gca;
set(gca,'FontSize',size, 'LineWidth',2);
% ax.YTick = [0 100 200 300 400];
set(gca, 'Layer','top')




h(2) =subplot(2,1,2)

semilogy(x,scattering_CBM,'r.','markersize', 10);
hold on;
semilogy(x,scattering_CBM2,'g.','markersize', 10);
hold on;






axis([0,0.2,0.01, 100]) % change axis limit





ylabel('Scattering rate (1/ps)','FontSize',size);
xlabel('Electron energy (eV)','FontSize',size);
% hold on;
ax = gca;
set(gca,'FontSize',size, 'LineWidth',2);
% ax.YTick = [0 100 200 300 400];
set(gca, 'Layer','top')
set(gca,'YTick',[0.01 0.1 1 10 100])

set(h, 'box', 'off');

pos1 = get(h(1),'Position');
pos2 = get(h(2),'Position');

set(h(1),'XTickLabel','');

pos2(2) = pos1(2) - pos2(4) - 0.03;
set(h(2),'Position',pos2);



%pbaspect([ratio1 ratio2 1])
% 
box off
axes('Position',pos1,'xlim', [0 0.2], 'ylim', [0 100], 'color', 'none',...
'YTick',[0 50 100],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 0.05 0.1 0.15 0.2],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')
axes('Position',pos2,'xlim', [0 0.2], 'ylim', [0.01 100], 'color', 'none',...
'YScale','log','YTick',[0.01 0.1 1 10 100],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 0.05 0.1 0.15 0.2],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')




% 
% 
% 
% axes('xlim', [0 1], 'ylim', [0 400], 'color', 'none',...
% 'YTick',[0 20 100 ],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
% 'XTick',[-2 0 2],...
% 'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')
% 
% h=gcf
% set(h, 'PaperPositionMode', 'auto');
% set(h,'PaperOrientation','landscape');
% set(h,'Position',[100 100 600 800]);
% print(h, '-dpdf', 'Si_scattering_zoom.pdf')

