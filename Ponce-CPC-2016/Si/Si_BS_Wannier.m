% Plot electronic bandstructure

figure('Units', 'pixels', ...
    'Position', [100 100 1300 650]);
hold on;


SpecfunID = fopen('sibands.dat.gnu');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS = cell2mat(data);
fclose(SpecfunID);


SpecfunID = fopen('si_band.dat');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS_W = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('si_band2.dat');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS_wannier = cell2mat(data);
fclose(SpecfunID);

size = 16

% CBM = 6.7531
%fermi = 6.2988; % eV
fermi = 0.0; % eV
ry2ev = 13.605698066 ;

BS(:,2) = BS(:,2)*ry2ev - fermi;
BS_wannier(:,2:8) = BS_wannier(:,2:8) - fermi;
BS_wannier(:,1) = BS_wannier(:,1)*1.866/2.1790182;
BS_W(:,2) = BS_W(:,2) - fermi;
BS_W(:,1) = BS_W(:,1)*1.866/2.1790182;

%%%%%%%%%
% KS BS %
%%%%%%%%%
plot(BS(:,1),BS(:,2),'Color','black','LineWidth',1);
hold on;
plot(BS_W(:,1),BS_W(:,2),'b.');
hold on;
% plot(BS_wannier(:,1),BS_wannier(:,2),'Color','red','LineWidth',1);
% plot(BS_wannier(:,1),BS_wannier(:,3),'Color','red','LineWidth',1);
% plot(BS_wannier(:,1),BS_wannier(:,4),'Color','red','LineWidth',1);
% plot(BS_wannier(:,1),BS_wannier(:,5),'Color','red','LineWidth',1);
% plot(BS_wannier(:,1),BS_wannier(:,6),'Color','red','LineWidth',1);
% plot(BS_wannier(:,1),BS_wannier(:,7),'Color','red','LineWidth',1);
% plot(BS_wannier(:,1),BS_wannier(:,8),'Color','red','LineWidth',1);
% hold on;


% Now plot horizontal line to show Fermi level
vert = zeros(100);
horizontal = linspace(0,max(BS(:,1)),100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '--');
vert = 13*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
% Now plotvertical line
vert = linspace(min(BS(:,2))-2,max(BS(:,2))+2,100);
horizontal = 0.0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 0.8666*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
horizontal = 1.866*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');


% The n-doping (0.3eV above)

vert =  (6.7531+0.3-fermi)*ones(100);
horizontal = linspace(1.2,max(BS(:,1)),100);
plot(horizontal,vert,'Color','red','LineWidth',1, 'LineStyle', '--');



axis([0,max(BS(:,1)),2,9]) % change axis limit

ylabel('E-E_F (eV)','FontSize',size);


ax = gca;
set(gca,'FontSize',size);
ax.XTick = [0 0.8666  1.866];
ax.XTickLabel = {'L','\Gamma','X','FontSize',size};



set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 Si_BS_wannier.eps
print('Si_BS_wannier','-dpng')
close;

