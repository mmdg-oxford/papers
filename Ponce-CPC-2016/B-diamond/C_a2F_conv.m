% a2F of Diamond

figure('Units', 'pixels', ...
    'Position', [100 100 1300 650]);
hold on;

% Phonon smearing = 0.15 meV
% Electron smearing = 50 meV
title('Diamond a2F [ph smearing = 0.5 meV and el smearing = 100 meV]')

subplot(2,1,1);

SpecfunID = fopen('30000k_30000q-0.05');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
plot(a2F(:,1),a2F(:,11),'--','Color','red','LineWidth',1);
hold on;

SpecfunID = fopen('30000k_30000q-0.1');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
plot(a2F(:,1),a2F(:,11),'-','Color','red','LineWidth',1);
hold on;

SpecfunID = fopen('40000k_40000q-0.05');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
plot(a2F(:,1),a2F(:,11),'--','Color','blue','LineWidth',1);
hold on;

SpecfunID = fopen('40000k_40000q-0.1');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
plot(a2F(:,1),a2F(:,11),'-','Color','blue','LineWidth',1);
hold on;

SpecfunID = fopen('50000k_50000q-0.05');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
plot(a2F(:,1),a2F(:,11),'--','Color','magenta','LineWidth',1);
hold on;

SpecfunID = fopen('50000k_50000q-0.1');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
plot(a2F(:,1),a2F(:,11),'-','Color','black','LineWidth',1);
hold on;


legend('30000k/30000q-0.05 [\lambda = 0.253, 2h08m]','30000k/30000q-0.1 [\lambda = 0.2509, 2h11m]',...
'40000k/40000q-0.05 [\lambda = 0.252, 3h46m]', '40000k/40000q-0.1 [\lambda = 0.237, 3h48m]',...
'50000k/50000q-0.05 [\lambda = 0.244, 5h45m]', '50000k/50000q-0.1 [\lambda = 0.247, 5h51m]',...
    'Location','northwest')

set(legend,'FontSize',8);

axis([0,170,0,2.5])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2);

SpecfunID = fopen('30k_30q_hom-0.1');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
plot(a2F(:,1),a2F(:,11),'--','Color','red','LineWidth',1);
hold on;

SpecfunID = fopen('40k_40q_hom-0.05');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
plot(a2F(:,1),a2F(:,11),'--','Color','blue','LineWidth',1);
hold on;

SpecfunID = fopen('40k_40q_hom-0.1');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
plot(a2F(:,1),a2F(:,11),'-','Color','blue','LineWidth',1);
hold on;

SpecfunID = fopen('50k_50q_hom-0.1');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
plot(a2F(:,1),a2F(:,11),'-','Color','magenta','LineWidth',1);
hold on;


%axis([0,4.2802,0,10]) % change axis limit

ylabel('\alpha^2 F','FontSize',12);
xlabel('Frequency (meV)','FontSize',12);


legend('30k/30q-0.1 [\lambda = 0.187, 1h49m]',...
'40k/40q-0.05 [\lambda = 0.225, 9h31m]','40k/40q-0.1 [\lambda = 0.235, 9h31m]',...
'50k/50q-0.1 [\lambda = 0.249, 18h15x2]',...
'Location','northwest')

set(legend,'FontSize',8);

axis([0,170,0,2.5])

set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 C_a2F_conv.eps
print('C_a2F_conv','-dpng')
close;

