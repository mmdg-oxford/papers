% Plot phonon bandstructure of Lead
LASTN = maxNumCompThreads(1)
figure('Units', 'pixels', ...
    'Position', [100 100 1300 650]);
hold on;

size = 16

SpecfunID = fopen('MgB2.freq.gp');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS = cell2mat(data);
fclose(SpecfunID);


cm2mev = 0.12398 ;
Thz2meV = 4.13567

%%%%%%%%%%%%%
% Phonon BS %
%%%%%%%%%%%%%
v=subplot(1,2,1)

for ii = 2:10
  plot(BS(:,1),BS(:,ii)*cm2mev,'Color','black','LineWidth',1);
  hold on;
end



%%%%%%%%%%%%%%%%
% Experimental %
%%%%%%%%%%%%%%%%
% The phonon exp results are from Brockhouse Phys. Rev. 128, 1099 (1962) 
% and are obtained at 100K using neutron spectrometry.

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

%plot(exp(:,1)+1.0,exp(:,2),'.', 'markersize',15,'Color','black' );
% plot(3.414+exp2(:,1),exp2(:,2)*Thz2meV,'.', 'markersize',15,'Color','black' );
% plot(2.0+(1.414-exp3(:,1))*(1.322/1.414),exp3(:,2)*Thz2meV,'.', 'markersize',15,'Color','black' );
% plot(1.0+exp4(:,1)*1.0,exp4(:,2)*Thz2meV/(100*2*pi),'.', 'markersize',15,'Color','black' );

% Now plot horizontal line to show Fermi level
%vert = zeros(100);
%horizontal = linspace(0,max(BS(:,1)),100);
%plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '--');
%vert = 13*ones(100);
%plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
% Now plotvertical line

vert = linspace(min(BS(:,1))-2,max(BS(:,10))+2,100);
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

ylabel('Phonon frequency (meV)','FontSize',size);
ay = gca;
set(gca,'FontSize',size);
ay.YTick = [0 20 40 60 80 100];

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
set(gca,'FontSize',size);
ax.XTick = [0 0.66666 1.0 1.5774 2.0151 2.6818 3.0151 3.592502];
ax.XTickLabel = {'\Gamma','K','M','\Gamma','A','H','L','A','FontSize',size};


%title('Spectral function of B-doped diamond (meV^{-1})','FontSize',14)

% Now plot the DOS
SpecfunID = fopen('MgB2.phdos');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
dos = cell2mat(data);
fclose(SpecfunID);



% 
% 
h=subplot(1,2,2)
plot(dos(:,2),dos(:,1)*cm2mev,'Color','black','LineWidth',1);
fill(dos(:,2),dos(:,1)*cm2mev, [0.8 0.8 0.8])
hold on;
axis([0,0.07,0,110])  % change axis limit

set(gca,'YTickLabel',[]);
ax = gca;
set(gca,'FontSize',size);

ay = gca;
set(gca,'FontSize',size);
ay.YTick = [0 20 40 60 80];

get(h,'Position');
set(h,'position',[0.56 0.11 0.06 0.815]);

ax.XTick = [0.035];
ax.XTickLabel = {'DOS','FontSize',size};


% set(gcf, 'PaperPositionMode', 'auto');
% print -depsc2 MgB2_phonon_BS.eps
% print('MgB2_phonon_BS','-dpng')
% close;

