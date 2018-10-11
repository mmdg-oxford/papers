% Plot spectral function

figure('Units', 'pixels', ...
    'Position', [100 100 1400 675]);
hold on;


SpecfunID = fopen('specfun-40000q-rnd-0.05');
data = textscan(SpecfunID,'%f %f %f\n','CommentStyle','#','CollectOutput',true);
A_all = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('specfun_sup-40000q-rnd-0.05');
data = textscan(SpecfunID,'%f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
A_sup = cell2mat(data);
fclose(SpecfunID);


X1 = linspace(0,0.43333333,251);
X2 = linspace(0.43333333,1,250);
X = [X1,X2];
Y = linspace(-4,1,1000);
Z = zeros(length(Y),length(X));

for i=1:length(X),
    for j=1:length(Y),
        Z(j,i)= A_all(i*length(Y)+j-length(Y),3);
    end 
end
        

surf(X, Y, Z,'EdgeColor', 'None', 'facecolor', 'interp');
%colorbar;

hold on;


axis([0.259998,0.660001,-0.3,0.6]); % change axis limit

ylabel('\omega (eV)','FontSize',14);

annotation('textbox',...
    [0.73 0.8 0.1 0.1],...
    'String',{'T = 300 K ','i\delta = 50 meV','4\cdot10^4 q'},...
    'FontSize',14,...
    'FontName','Arial',...
    'LineStyle','-',...
    'EdgeColor',[0 0 0],...
    'LineWidth',1,...
    'BackgroundColor',[0.9  0.9 0.9],...
    'Color',[0 0 0]);



%title('Spectral function of B-doped diamond (meV^{-1})','FontSize',14)



ax = gca;
set(gca,'FontSize',14)
ax.XTick = [0.259998 0.4333333 0.660001];
ax.XTickLabel = {'0.2L','\Gamma','0.2X','FontSize',14};

%view(2);

set(gcf, 'PaperPositionMode', 'auto');
%print -depsc2 C_spectral.eps
%print('C_spectral','-dpng')
%close;

