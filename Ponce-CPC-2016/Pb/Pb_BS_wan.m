% Plot electronic bandstructure

figure('Units', 'pixels', ...
    'Position', [100 100 1300 650]);
hold on;


SpecfunID = fopen('pbbands.dat.gnu');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('pb_band_wannier.dat');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS_wan = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('pb_band_wannier.dat2');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS_wan2 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('pb_band_wannier.dat3');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS_wan3 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('pb_band_wannier.dat4');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS_wan4 = cell2mat(data);
fclose(SpecfunID);



fermi = 11.6078; % eV
ry2ev = 13.605698066 ;

BS(:,2) = BS(:,2)*ry2ev - fermi;
ratio = 4.7462/6.1104070


%%%%%%%%%
% KS BS %
%%%%%%%%%
plot(BS(:,1),BS(:,2),'Color','black','LineWidth',1);
hold on;
plot(BS_wan(:,1)*ratio,BS_wan(:,2)-fermi,'Color','red','LineWidth',1,'LineStyle', '--');
hold on;
plot(BS_wan(:,1)*ratio,BS_wan2(:,2)-fermi,'Color','red','LineWidth',1,'LineStyle', '--');
hold on;
plot(BS_wan(:,1)*ratio,BS_wan3(:,2)-fermi,'Color','red','LineWidth',1,'LineStyle', '--');
hold on;
plot(BS_wan(:,1)*ratio,BS_wan4(:,2)-fermi,'Color','red','LineWidth',1,'LineStyle', '--');
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

ylabel('E-E_F (eV)','FontSize',12);


ax = gca;
set(gca,'FontSize',12);
ax.XTick = [0 1.0 1.5 2.2071 2.8195 3.8801 4.7462];
ax.XTickLabel = {'\Gamma','X','W','L','K','\Gamma','L','FontSize',12};



set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 Pb_BS_wan.eps
print('Pb_BS_wan','-dpng')
close;

