% a2F of Lead

figure('Units', 'pixels', ...
    'Position', [100 100 1300 650]);
hold on;


SpecfunID = fopen('pb.a2f.01_30');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);

plot(a2F(:,1),a2F(:,5),'Color','black','LineWidth',1);
hold on;


SpecfunID = fopen('pb.a2f_nc.01');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);

plot(a2F(:,1),a2F(:,5),'Color','red','LineWidth',1);
hold on;

%%%%%%%%%%%%%%%%
% Experimental %
%%%%%%%%%%%%%%%%
% The a2F pb data are from McMillan in Superconductivity Parks 1969
% and are from tunneling experiment. The a2F is obtained by fitting 
% Electronic density of states of Pb divided by BCS density of states
% The experiment is made at 1K so that T/Tc = 0.15


SpecfunID = fopen('xyscan_a2F_Pb_Parks1969.txt');
data = textscan(SpecfunID,'%f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
exp = cell2mat(data);
fclose(SpecfunID);


plot(exp(:,1),exp(:,2),'.', 'markersize',15,'Color','black' );




%axis([0,4.2802,0,10]) % change axis limit

ylabel('\alpha^2 F','FontSize',12);
xlabel('Frequency (meV)','FontSize',12);




set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 Pb_a2F.eps
print('Pb_a2F','-dpng')
close;

