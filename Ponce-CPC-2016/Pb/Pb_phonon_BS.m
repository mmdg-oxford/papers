% Plot phonon bandstructure of Lead

% figure('Units', 'pixels', ...
%     'Position', [100 100 1300 650]);


size = 16

SpecfunID = fopen('pb.freq.gp');
data = textscan(SpecfunID,'%f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('pb.freq2.gp');
data = textscan(SpecfunID,'%f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS2 = cell2mat(data);
fclose(SpecfunID);




SpecfunID = fopen('pb_nc.freq.gp');
data = textscan(SpecfunID,'%f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS_noncol = cell2mat(data);
fclose(SpecfunID);

% degauss = 0.05
% scf k-point: 8 8 8 1 1 1
% q-grid: 10x10x10 
SpecfunID = fopen('pb_nc_10.freq.gp');
data = textscan(SpecfunID,'%f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS_noncol_10 = cell2mat(data);
fclose(SpecfunID);


% degauss = 0.01
% scf k-point: 16 16 16 1 1 1
% q-grid: 10x10x10 
SpecfunID = fopen('pb_nc_10_conv.freq.gp');
data = textscan(SpecfunID,'%f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS_noncol_10_conv = cell2mat(data);
fclose(SpecfunID);

% degauss = 0.025
% scf k-point: 14 14 14 1 1 1
% q-grid: 10x10x10 
SpecfunID = fopen('pb_nc_10_conv2.freq.gp');
data = textscan(SpecfunID,'%f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS_noncol_10_conv2 = cell2mat(data);
fclose(SpecfunID);


cm2mev = 0.12398 ;
Thz2meV = 4.13567

%%%%%%%%%%%%%
% Phonon BS %
%%%%%%%%%%%%%
v=subplot(1,2,1)
plot(BS_noncol_10_conv(:,1),BS_noncol_10_conv2(:,2)*cm2mev,'Color','red','LineWidth',2);
hold on;
plot(BS_noncol_10_conv(:,1),BS_noncol_10_conv2(:,3)*cm2mev,'Color','red','LineWidth',2);
hold on;
plot(BS_noncol_10_conv(:,1),BS_noncol_10_conv2(:,4)*cm2mev,'Color','red','LineWidth',2);
hold on;
% plot(BS_noncol_10_conv(:,1),BS_noncol_10_conv(:,2)*cm2mev,'Color','yellow','LineWidth',2);
% hold on;
% plot(BS_noncol_10_conv(:,1),BS_noncol_10_conv(:,3)*cm2mev,'Color','yellow','LineWidth',2);
% hold on;
% plot(BS_noncol_10_conv(:,1),BS_noncol_10_conv(:,4)*cm2mev,'Color','yellow','LineWidth',2);
% hold on;
% plot(BS_noncol_10(:,1),BS_noncol_10(:,2)*cm2mev,'Color','blue','LineWidth',2);
% hold on;
% plot(BS_noncol_10(:,1),BS_noncol_10(:,3)*cm2mev,'Color','blue','LineWidth',2);
% hold on;
% plot(BS_noncol_10(:,1),BS_noncol_10(:,4)*cm2mev,'Color','blue','LineWidth',2);
% hold on;
plot(BS2(:,1),BS2(:,2)*cm2mev,'Color','blue','LineWidth',2);
hold on;
plot(BS2(:,1),BS2(:,3)*cm2mev,'Color','blue','LineWidth',2);
hold on;
plot(BS2(:,1),BS2(:,4)*cm2mev,'Color','blue','LineWidth',2);
hold on;
% plot(BS(:,1),BS(:,2)*cm2mev,'Color','blue','LineWidth',2);
% hold on;
% plot(BS(:,1),BS(:,3)*cm2mev,'Color','blue','LineWidth',2);
% hold on;
% plot(BS(:,1),BS(:,4)*cm2mev,'Color','blue','LineWidth',2);
% hold on;
% plot(BS_noncol(:,1),BS_noncol(:,2)*cm2mev,'Color','green','LineWidth',1);
% hold on;
% plot(BS_noncol(:,1),BS_noncol(:,3)*cm2mev,'Color','green','LineWidth',1);
% hold on;
% plot(BS_noncol(:,1),BS_noncol(:,4)*cm2mev,'Color','green','LineWidth',1);
% hold on;



%%%%%%%%%%%%%%%%
% Experimental %
%%%%%%%%%%%%%%%%
% The phonon exp results are from Brockhouse Phys. Rev. 128, 1099 (1962) 
% and are obtained at 100K using neutron spectrometry.

% G-X line
exp = [
% T line    
[0.2,0.47];
[0.3,0.73];
[0.40,0.9];
[0.45,0.96];
[0.50,1.04];
[0.60,1.115];
[0.70,1.10];
[0.80,1.03];
[0.90,0.95];
[1.00,0.98];
% L line
[0.20,0.87];
[0.30,1.27];
[0.40,1.61];
[0.45,1.71];
[0.50,1.83];
[0.55,1.91];
[0.60,2.00];
[0.65,2.07];
[0.70,2.14];
[0.75,2.16];
[0.80,2.15];
[0.85,2.14];
[0.90,2.05];
[0.95,1.94];
[1.00,1.86];
]

% G-L line
exp2 = [
% T line    
[0.19,0.35];
[0.26,0.44];
[0.35,0.55];
[0.40,0.61];
[0.45,0.66];
[0.50,0.73];
[0.55,0.77];
[0.60,0.79];
[0.65,0.805];
[0.70,0.835];
[0.75,0.86];
[0.80,0.88];
[0.866,0.89];
% L line
[0.143,0.82];
[0.25,1.24];
[0.332,1.51];
[0.433,1.76];
[0.519,1.91];
[0.563,1.97];
[0.606,2.00];
[0.649,2.05];
[0.693,2.085];
[0.736,2.09];
[0.779,2.08];
[0.823,2.16];
[0.866,2.185];
]

% G-X' line
exp3 = [
% Longitudinal line    
[0.212,0.99];
[0.284,1.26];
[0.325,1.40];
[0.350,1.48];
[0.375,1.545];
[0.400,1.605];
[0.425,1.64];
[0.450,1.665];
[0.475,1.675];
[0.500,1.715];
[0.525,1.76];
[0.550,1.795];
[0.600,1.85];
[0.650,1.92];
[0.700,2.01];
[0.778,2.10];
[0.850,2.09];
[0.900,2.04];
[0.990,1.925];
[1.061,1.75];
[1.132,1.54];
[1.173,1.39];
[1.215,1.30];
[1.244,1.24];
[1.272,1.185];
[1.314,1.07];
[1.373,0.885];
[1.414,0.89];
% T2 mode
[0.20,0.53];
[0.30,0.75];
[0.40,0.95];
[0.50,1.17];
[0.60,1.37];
[0.70,1.57];
[0.814,1.78];
[0.914,1.92];
[1.00,2.02];
[1.12,2.02];
[1.214,2.02];
[1.314,1.93];
[1.414,1.86];
% T1 mode
[0.141,0.21];
[0.283,0.41];
[0.424,0.56];
[0.566,0.76];
[0.707,0.91];
[0.848,1.12];
[0.959,1.20];
[1.056,1.25];
[1.17,1.15];
[1.241,1.06];
[1.281,0.96];
[1.414,0.89];
]

% X-W-X'
exp4 = [
% Longitudinal line    
[0.0,1184];
[0.0,576];
[0.0,576];
[0.1,1240];
[0.1,667];
[0.1,623];
[0.2,1322];
[0.2,806];
[0.2,711];
[0.3,1310];
[0.3,894];
[0.3,806];
[0.4,1215];
[0.4,926];
[0.4,919];
[0.5,1089];
[0.5,1089];
[0.5,926];
[0.6,1215];
[0.6,926];
[0.6,919];
[0.7,1310];
[0.7,894];
[0.7,806];
[0.8,1322];
[0.8,806];
[0.8,711];
[0.9,1240];
[0.9,667];
[0.9,623];
[1.0,1184];
[1.0,576];
[1.0,576];
]

%10^10 rad/s = Thz2meV/(100*2*pi)


plot(exp(:,1)*1.0,exp(:,2)*Thz2meV,'.', 'markersize',15,'Color','black' );
plot(3.414+exp2(:,1),exp2(:,2)*Thz2meV,'.', 'markersize',15,'Color','black' );
plot(2.0+(1.414-exp3(:,1))*(1.322/1.414),exp3(:,2)*Thz2meV,'.', 'markersize',15,'Color','black' );
plot(1.0+exp4(:,1)*1.0,exp4(:,2)*Thz2meV/(100*2*pi),'.', 'markersize',15,'Color','black' );

% Now plot horizontal line to show Fermi level
vert = zeros(100);
horizontal = linspace(0,max(BS(:,1)),100);
%plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
vert = 13*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
% Now plotvertical line
horizontal = 1*ones(100);
vert = linspace(min(BS(:,2))-2,max(BS(:,2))+2,100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
horizontal = 0.0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
horizontal = 1.5*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
horizontal = 2.0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
horizontal = 2.4413*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
horizontal = 3.414*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
horizontal = 4.2802*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');


axis([0,4.2802,0,10]) % change axis limit

ylabel('Phonon frequency (meV)','FontSize',size);
ay = gca;
set(gca,'FontSize',size,'LineWidth',2);
ay.YTick = [0 2 4 6 8 10];

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
ax.XTick = [0 1.0 1.5 2.0 2.4413 3.414 4.2802];
ax.XTickLabel = {'\Gamma','X','W','X','K','\Gamma','L','FontSize',size};


%title('Spectral function of B-doped diamond (meV^{-1})','FontSize',14)

% Now plot the DOS
SpecfunID = fopen('pb.phdos');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
dos = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('pb2.phdos');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
dos2 = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('pb_nc2.phdos');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
dos_noncol = cell2mat(data);
fclose(SpecfunID);

% 
% 
h=subplot(1,2,2)
plot(dos_noncol(:,2),dos_noncol(:,1)*cm2mev,'Color','red','LineWidth',2);
hold on;
plot(dos2(:,2),dos2(:,1)*cm2mev,'Color','blue','LineWidth',2);
hold on;
axis([0,0.2,0,10]) % change axis limit
vert = zeros(100);
horizontal = linspace(0,1,100);
%plot(horizontal,vert,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
set(gca,'YTickLabel',[]);
ax = gca;
set(gca,'FontSize',size);

ay = gca;
set(gca,'FontSize',size,'LineWidth',2);
ay.YTick = [0 2 4 6 8 10];



get(h,'Position');
set(h,'position',[0.54 0.11 0.08 0.815]);
set(gca,'xticklabel',{[]}) 
xlabel('DOS','FontSize',size);

h=gcf
set(h, 'PaperPositionMode', 'auto');
set(h,'PaperOrientation','landscape');
set(h,'Position',[50 50 1000 600]);

print(h, '-dpdf', 'Pb_phonon_BS4.pdf')
%print -depsc2 Pb_phonon_BS3.eps
%print('Pb_phonon_BS3','-dpng')
%close;

