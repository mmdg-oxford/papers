% Electron and phonon linewidths of Diamond

figure('Units', 'pixels', ...
    'Position', [100 100 700 900]);
hold on;

size = 16

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Colour scheme

col1 = [208,209,230]/255;
col2 = [166,189,219]/255;
col3 = [116,169,207]/255;
col4 = [43,140,190]/255;
col5 = [4,90,141]/255;
col6 = [0,0,0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Phonon smearing = 0.15 meV
% Electron smearing = 50 meV
title('Electron linewidths ')

yaxis = linspace(0,120,100);

h1 = subplot(3,2,1);
p = get(h1, 'pos');
p(3) = p(3) + 0.05;
p(4) = p(4) + 0.05;
set(h1, 'pos', p);

SpecfunID = fopen('el-40000q-rnd-0.01');
data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
Xtmp = linewidth(:,1);
X = zeros(501,1);
X(1:251) = linspace(0,0.43333,251);
X(251:501) = linspace(0.43333,1.0,251);
plot(X(142:320,1),linewidth(142:320,4),'-','Color',col1,'LineWidth',2);
hold on;

% SpecfunID = fopen('el-60000q-rnd-0.01');
% data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
% linewidth = cell2mat(data);
% fclose(SpecfunID);
% plot(X(142:320,1),linewidth(142:320,4),'-','Color',col2,'LineWidth',1);
% hold on;

SpecfunID = fopen('el-100000q-rnd-0.01');
data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(142:320,1),linewidth(142:320,4),'-','Color',col3,'LineWidth',2);
hold on;

% SpecfunID = fopen('el-200000q-rnd-0.01');
% data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
% linewidth = cell2mat(data);
% fclose(SpecfunID);
% plot(X(142:320,1),linewidth(142:320,4),'-','Color',col4,'LineWidth',1);
% hold on;

SpecfunID = fopen('el-500000q-rnd-0.01');
data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(142:320,1),linewidth(142:320,4),'-','Color',col5,'LineWidth',2);
hold on;

SpecfunID = fopen('el-1000000q-rnd-0.01');
data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(142:320,1),linewidth(142:320,4),'-','Color',col6,'LineWidth',2);
hold on;


ylabel('Linewidth (meV)','FontSize',size);

% Now plotvertical line at Gamma
vertical = 0.43333*ones(100);
plot(vertical,yaxis,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');


x = linspace(0,1,100);
y = 0.0*ones(100);
plot(x,y,'Color','black','LineWidth',2);
y = 120*ones(100);
plot(x,y,'Color','black','LineWidth',2);
x = 0.0*ones(100);
y = linspace(0,120,100);
plot(x,y,'Color','black','LineWidth',2);
x = 1.0*ones(100);
plot(x,y,'Color','black','LineWidth',2);



set(gca,'xtick',[0.0 0.43333 1.0],'XTickLabel',[],'LineWidth',2)

axis([0,1,0,120]);
set(gca,'ytick',[0,50,100], 'FontSize',size, 'LineWidth',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xl = xlim(h1); 
xPos = xl(1) + diff(xl) / 20; 
yl = ylim(h1); 
yPos = yl(1) + diff(yl) / 1.2; 
t = text(xPos, yPos, sprintf('%s\n%s\n', '10 meV'), 'Parent', h1);
set(t, 'HorizontalAlignment', 'left','FontSize',size);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% box off
% axes('xlim', [0 1], 'ylim', [0 120], 'color', 'none',...
% 'YTick',[50 100],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
% 'XTick',[0 0.66666 1.0 ],...
% 'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')

%legend('4\cdot10^4 q','6\cdot10^4 q','1\cdot10^5 q','2\cdot10^5 q',...
%    '5\cdot10^5 q','1\cdot10^6 q','Location', [0.37 0.865 0.1 0.05])
legend('4\cdot10^4 q','1\cdot10^5 q',...
    '5\cdot10^5 q','1\cdot10^6 q','Location', [0.36 0.88 0.1 0.05])
set(legend,'FontSize',size);

legend boxoff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
size_ph = [110:365];

h2 = subplot(3,2,2);
p = get(h2, 'pos');
p(3) = p(3) + 0.05;
p(4) = p(4) + 0.05;
set(h2, 'pos', p);

SpecfunID = fopen('ph-40000k-rnd-0.01');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
Xtmp = linewidth(:,1);
X = zeros(501,1);
X(1:251) = linspace(0,0.43333,251);
X(251:501) = linspace(0.43333,1.0,251);
plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col1,'LineWidth',2);
hold on;

% SpecfunID = fopen('ph-60000k-rnd-0.01');
% data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
% linewidth = cell2mat(data);
% fclose(SpecfunID);
% plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col2,'LineWidth',1);
% hold on;

SpecfunID = fopen('ph-100000k-rnd-0.01');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col3,'LineWidth',2);
hold on;
% 
% SpecfunID = fopen('ph-200000k-rnd-0.01');
% data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
% linewidth = cell2mat(data);
% fclose(SpecfunID);
% plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col4,'LineWidth',1);
% hold on;

SpecfunID = fopen('ph-500000k-rnd-0.01');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col5,'LineWidth',2);
hold on;

SpecfunID = fopen('ph-1000000k-rnd-0.01');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col6,'LineWidth',2);
hold on;

% ylabel('Linewidth (meV)','FontSize',14);
set(gca,'YAxisLocation','right','FontSize',size);

% Now plotvertical line at Gamma
vertical = 0.43333*ones(100);
plot(vertical,yaxis,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');


x = linspace(0,1,100);
y = 0.0*ones(100);
plot(x,y,'Color','black','LineWidth',2);
y = 20*ones(100);
plot(x,y,'Color','black','LineWidth',2);
x = 0.0*ones(100);
y = linspace(0,20,100);
plot(x,y,'Color','black','LineWidth',2);
x = 1.0*ones(100);
plot(x,y,'Color','black','LineWidth',2);


set(gca,'xtick',[],'FontSize',size, 'LineWidth',2)

axis([0,1,0,20]);
set(gca,'ytick',[0,5,10,15,20],'FontSize',size, 'LineWidth',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xl = xlim(h2); 
xPos = xl(1) + diff(xl) / 20; 
yl = ylim(h2); 
yPos = yl(1) + diff(yl) / 1.2; 
t = text(xPos, yPos, sprintf('%s\n%s\n', '10 meV'), 'Parent', h2);
set(t, 'HorizontalAlignment', 'left','FontSize',size);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

legend(h2,'4\cdot10^4 k','1\cdot10^5 k',...
    '5\cdot10^5 k','1\cdot10^6 k','Location', [0.795 0.88 0.1 0.05])

set(legend,'FontSize',size);
legend boxoff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



h3 = subplot(3,2,3);
p = get(h3, 'pos');
p(3) = p(3) + 0.05;
p(4) = p(4) + 0.05;
set(h3, 'pos', p);


SpecfunID = fopen('el-40000q-rnd-0.05');
data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
Xtmp = linewidth(:,1);
X = zeros(501,1);
X(1:251) = linspace(0,0.43333,251);
X(251:501) = linspace(0.43333,1.0,251);
plot(X(142:320,1),linewidth(142:320,4),'-','Color',col1,'LineWidth',2);
hold on;

% SpecfunID = fopen('el-60000q-rnd-0.05');
% data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
% linewidth = cell2mat(data);
% fclose(SpecfunID);
% plot(X(142:320,1),linewidth(142:320,4),'-','Color',col2,'LineWidth',1);
% hold on;

SpecfunID = fopen('el-100000q-rnd-0.05');
data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(142:320,1),linewidth(142:320,4),'-','Color',col3,'LineWidth',2);
hold on;

% SpecfunID = fopen('el-200000q-rnd-0.05');
% data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
% linewidth = cell2mat(data);
% fclose(SpecfunID);
% plot(X(142:320,1),linewidth(142:320,4),'-','Color',col4,'LineWidth',1);
% hold on;

SpecfunID = fopen('el-500000q-rnd-0.05');
data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(142:320,1),linewidth(142:320,4),'-','Color',col5,'LineWidth',2);
hold on;

SpecfunID = fopen('el-1000000q-rnd-0.05');
data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(142:320,1),linewidth(142:320,4),'-','Color',col6,'LineWidth',2);
hold on;

ylabel('Linewidth (meV)','FontSize',size);

% Now plotvertical line at Gamma
vertical = 0.43333*ones(100);
plot(vertical,yaxis,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');


x = linspace(0,1,100);
y = 0.0*ones(100);
plot(x,y,'Color','black','LineWidth',2);
y = 120*ones(100);
plot(x,y,'Color','black','LineWidth',2);
x = 0.0*ones(100);
y = linspace(0,120,100);
plot(x,y,'Color','black','LineWidth',2);
x = 1.0*ones(100);
plot(x,y,'Color','black','LineWidth',2);


set(gca,'xtick',[],'FontSize',size, 'LineWidth',2)

axis([0,1,0,120]);
set(gca,'ytick',[0,50,100],'FontSize',size, 'LineWidth',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xl = xlim(h3); 
xPos = xl(1) + diff(xl) / 20; 
yl = ylim(h3); 
yPos = yl(1) + diff(yl) / 1.2; 
t = text(xPos, yPos, sprintf('%s\n%s\n', '50 meV'), 'Parent', h3);
set(t, 'HorizontalAlignment', 'left','FontSize',size);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h4 = subplot(3,2,4);
p = get(h4, 'pos');
p(3) = p(3) + 0.05;
p(4) = p(4) + 0.05;
set(h4, 'pos', p);



SpecfunID = fopen('ph-40000k-rnd-0.05');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col1,'LineWidth',2);
hold on;

% SpecfunID = fopen('ph-60000k-rnd-0.05');
% data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
% linewidth = cell2mat(data);
% fclose(SpecfunID);
% plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col2,'LineWidth',1);
% hold on;

SpecfunID = fopen('ph-100000k-rnd-0.05');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col3,'LineWidth',2);
hold on;

% SpecfunID = fopen('ph-200000k-rnd-0.05');
% data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
% linewidth = cell2mat(data);
% fclose(SpecfunID);
% plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col4,'LineWidth',1);
% hold on;

SpecfunID = fopen('ph-500000k-rnd-0.05');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col5,'LineWidth',2);
hold on;

SpecfunID = fopen('ph-1000000k-rnd-0.05');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col6,'LineWidth',2);
hold on;

% ylabel('Linewidth (meV)','FontSize',14);
 set(gca,'YAxisLocation','right');

% Now plotvertical line at Gamma
vertical = 0.43333*ones(100);
plot(vertical,yaxis,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');

set(gca,'xtick',[],'FontSize',size, 'LineWidth',2)

axis([0,1,0,20]);
set(gca,'ytick',[0,5,10,15],'FontSize',size, 'LineWidth',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xl = xlim(h4); 
xPos = xl(1) + diff(xl) / 20; 
yl = ylim(h4); 
yPos = yl(1) + diff(yl) / 1.2; 
t = text(xPos, yPos, sprintf('%s\n%s\n', '50 meV'), 'Parent', h4);
set(t, 'HorizontalAlignment', 'left','FontSize',size);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h5 = subplot(3,2,5);
p = get(h5, 'pos');
p(3) = p(3) + 0.05;
p(4) = p(4) + 0.05;
set(h5, 'pos', p);

SpecfunID = fopen('el-40000q-rnd-0.1');
data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(142:320,1),linewidth(142:320,4),'-','Color',col1,'LineWidth',2);
hold on;

% SpecfunID = fopen('el-60000q-rnd-0.1');
% data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
% linewidth = cell2mat(data);
% fclose(SpecfunID);
% plot(X(142:320,1),linewidth(142:320,4),'-','Color',col2,'LineWidth',1);
% hold on;

SpecfunID = fopen('el-100000q-rnd-0.1');
data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(142:320,1),linewidth(142:320,4),'-','Color',col3,'LineWidth',2);
hold on;

% SpecfunID = fopen('el-200000q-rnd-0.1');
% data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
% linewidth = cell2mat(data);
% fclose(SpecfunID);
% plot(X(142:320,1),linewidth(142:320,4),'-','Color',col4,'LineWidth',1);
% hold on;

SpecfunID = fopen('el-500000q-rnd-0.1');
data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(142:320,1),linewidth(142:320,4),'-','Color',col5,'LineWidth',2);
hold on;

SpecfunID = fopen('el-1000000q-rnd-0.1');
data = textscan(SpecfunID,'%f %f %f %f \n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(142:320,1),linewidth(142:320,4),'-','Color',col6,'LineWidth',2);
hold on;


ylabel('Linewidth (meV)','FontSize',size);

% Now plotvertical line at Gamma
vertical = 0.4333*ones(100);
plot(vertical,yaxis,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');

ax = gca;
set(gca,'FontSize',size);
ax.XTick = [0 0.4333 1.0];
ax.XTickLabel = {'L','\Gamma','X','FontSize',size};

axis([0,1,0,120]);
set(gca,'ytick',[0,50,100],'FontSize',size, 'LineWidth',2)

%a=4000
%plot(X(142:320,1),a*(X(142:320,1)-0.433).^(2)+30)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xl = xlim(h5); 
xPos = xl(1) + diff(xl) / 20; 
yl = ylim(h5); 
yPos = yl(1) + diff(yl) / 1.2; 
t = text(xPos, yPos, sprintf('%s\n%s\n', '100 meV'), 'Parent', h5);
set(t, 'HorizontalAlignment', 'left','FontSize',size);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h6 = subplot(3,2,6);
p = get(h6, 'pos');
p(3) = p(3) + 0.05;
p(4) = p(4) + 0.05;
set(h6, 'pos', p);

SpecfunID = fopen('ph-40000k-rnd-0.1');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col1,'LineWidth',2);
hold on;

% SpecfunID = fopen('ph-60000k-rnd-0.1');
% data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
% linewidth = cell2mat(data);
% fclose(SpecfunID);
% plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col2,'LineWidth',1);
% hold on;

SpecfunID = fopen('ph-100000k-rnd-0.1');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col3,'LineWidth',2);
hold on;

% SpecfunID = fopen('ph-200000k-rnd-0.1');
% data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
% linewidth = cell2mat(data);
% fclose(SpecfunID);
% plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col4,'LineWidth',2);
% hold on;

SpecfunID = fopen('ph-500000k-rnd-0.1');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col5,'LineWidth',2);
hold on;

SpecfunID = fopen('ph-1000000k-rnd-0.1');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
linewidth = cell2mat(data);
fclose(SpecfunID);
plot(X(size_ph,1),linewidth(size_ph,7),'-','Color',col6,'LineWidth',2);
hold on;

% ylabel('Linewidth (meV)','FontSize',14);
set(gca,'YAxisLocation','right','FontSize',size);

% Now plotvertical line at Gamma
vertical = 0.43333*ones(100);
plot(vertical,yaxis,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');

ax = gca;
set(gca,'FontSize',size);
ax.XTick = [0 0.4333 1.0];
ax.XTickLabel = {'L','\Gamma','X','FontSize',size};

axis([0,1,0,20]);
set(gca,'ytick',[0,5,10,15],'FontSize',size, 'LineWidth',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xl = xlim(h6); 
xPos = xl(1) + diff(xl) / 20; 
yl = ylim(h6); 
yPos = yl(1) + diff(yl) / 1.2; 
t = text(xPos, yPos, sprintf('%s\n%s\n', '100 meV'), 'Parent', h6);
set(t, 'HorizontalAlignment', 'left','FontSize',size);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


pos1 = get(h1,'Position');
pos2 = get(h2,'Position');
pos3 = get(h3,'Position');
pos4 = get(h4,'Position');
pos5 = get(h5,'Position');
pos6 = get(h6,'Position');


set(h1,'XTickLabel','');
pos3(2) = pos1(2) - pos3(4);
set(h3,'Position',pos3);

set(h2,'XTickLabel','');
pos4(2) = pos2(2) - pos4(4);
set(h4,'Position',pos4);

set(h3,'XTickLabel','');
pos5(2) = pos3(2) - pos5(4);
set(h5,'Position',pos5);

set(h4,'XTickLabel','');
pos6(2) = pos4(2) - pos6(4);
set(h6,'Position',pos6);


 a = 0.03;
 b = 9;
 text(a,b,['(',char(1+96),') '],...
     'FontSize',size,'color','k','Parent', h1);
 text(a,b,['(',char(3+96),') '],...
     'FontSize',size,'color','k','Parent', h3);
 text(a,b,['(',char(5+96),') '],...
     'FontSize',size,'color','k','Parent', h5);
 
 a = 0.03;
 b = 1.4;
%  text(a,b,['(',char(2+96),') '],...
%      'color','k','fontw','b','Parent', h2);
%  text(a,b,['(',char(4+96),') '],...
%      'color','k','fontw','b','Parent', h4);
%  text(a,b,['(',char(6+96),') '],...
%      'color','k','fontw','b','Parent', h6);
  text(a,b,['(',char(2+96),') '],...
     'FontSize',size,'color','k','Parent', h2);
 text(a,b,['(',char(4+96),') '],...
     'FontSize',size,'color','k','Parent', h4);
 text(a,b,['(',char(6+96),') '],...
     'FontSize',size,'color','k','Parent', h6);
 


%set(gcf, 'PaperPositionMode', 'auto');
%print -depsc2 C_linewidths.eps
%print('C_linewidths','-dpng')
%close;

