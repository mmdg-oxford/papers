% Plot phonon bandstructure of GaN
LASTN = maxNumCompThreads(1)
figure('Units', 'pixels', ...
    'Position', [100 100 600 600]);
hold on;

size = 16

% SpecfunID = fopen('gan_6.freq.gp');
% data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
% BS = cell2mat(data);
% fclose(SpecfunID);

SpecfunID = fopen('gan_4.freq2.gp');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS4 = cell2mat(data);
fclose(SpecfunID);



cm2mev = 0.12398 ;
Thz2meV = 4.13567

%%%%%%%%%%%%%
% Phonon BS %
%%%%%%%%%%%%%

for ii = 2:13
  plot(BS4(:,1),BS4(:,ii)*cm2mev,'Color','blue','LineWidth',2,'LineStyle', '-');
  hold on;
end


vert = linspace(0,3.461428,100);
horizontal = 100*ones(100);
plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
horizontal = 0*ones(100);
plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');

vert = linspace(min(BS4(:,1))-2,max(BS4(:,10))+2,100);
horizontal = 0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
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
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');


axis([0,3.461428,0,100]) % change axis limit

ylabel('Phonon frequency (meV)','FontSize',size);
ay = gca;
set(gca,'FontSize',size);
set(gca,'LineWidth',2);
ay.YTick = [0 20 40 60 80 100];


ax = gca;
set(gca,'FontSize',size);
set(gca,'LineWidth',2);
ax.XTick = [0 0.66666 1.0 1.5774 1.8841 2.5508 2.8841 3.461428];
ax.XTickLabel = {'\Gamma','K','M','\Gamma','A','H','L','A','FontSize',size};

box off
axes('xlim', [0 3.461428], 'ylim', [1 100], 'color', 'none',...
'YTick',[0 20 40 60 80 100],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 0.66666 1.0 1.5774 1.8841 2.5508 2.8841 3.461428],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')



set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 GaN_phonon_BS2.eps
print('GaN_phonon_BS2','-dpng')
close;

