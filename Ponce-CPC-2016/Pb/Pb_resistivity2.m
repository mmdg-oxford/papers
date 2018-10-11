% Plot resistivity of Pb

%  figure('Units', 'pixels', ...
%      'Position', [100 100 1300 950]);

SpecfunID = fopen('pb.a2f_tr_300kSobol50q_woSOC_new');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f \n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);

kelvin2eV= 8.6173427909E-05;
kelvin2Ry = 6.333627859634130e-06;

rhoaum = 2.2999241E6;
meV2Ha = 0.000036749;
ohm2microohmcm = 1E4;
size = 16;
cm2mev = 0.12398 ;
Thz2meV = 4.13567;
ry2ev = 13.605698066 ;
meV2ry = (1.0/(ry2ev*1000));
meV2eV = 0.001;
kB = 6.333620222466232e-06 % Ry/K



% a2F_tr(1) = \omega in meV from 0-10 meV
% 4000000 k-point wo SOC with 25000 q-points RND and gaussian of 20meV

%integral
% meV to ev
a2F(:,1) = a2F(:,1).*meV2ry;

resistivity = [];
for tt=1:600
    T = tt*kelvin2Ry;
    n = 1.0./(exp(a2F(:,1)./T)-1);
    func = a2F(:,1).*a2F(:,2).*n.*(1+n);
    int = trapz(a2F(:,1),func);
    %resistivity = [resistivity (196.1075/82)*(pi/T)*int*(1/rhoaum)*1E8];
    resistivity = [resistivity (196.1075/2)*(pi/T)*int*(1/rhoaum)*1E8];
    %resistivity = [resistivity (1/(4*T*kB))*int];
end
    
%resistivity = (4*pi/(T*rhoaum))*int*ohm2microohmcm 


tt = [1:600];
plot(tt,resistivity,'Color','blue','LineWidth',3);
hold on;



SpecfunID = fopen('pb.a2f_tr_300kSobol50q_wSOC_new');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f \n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);

% meV to ev
a2F(:,1) = a2F(:,1).*meV2ry;

resistivity2 = [];
for tt=1:600
    T = tt*kelvin2Ry;
    n = 1.0./(exp(a2F(:,1)./T)-1);
    func = a2F(:,1).*a2F(:,2).*n.*(1+n);
    int = trapz(a2F(:,1),func);
    %resistivity = [resistivity (196.1075/82)*(pi/T)*int*(1/rhoaum)*1E8];
    resistivity2 = [resistivity2 (196.1075/2)*(pi/T)*int*(1/rhoaum)*1E8];
    %resistivity = [resistivity (1/(4*T*kB))*int];
end
   

tt = [1:600];
plot(tt,resistivity2,'Color','red','LineWidth',3);
hold on;


% Experimental data in micro Ohm per cm
% 63Al2 ref
T1 = [14,20.4,58,77.4,90.31];
r1 = [0.02,0.560,3.47,4.81,5.69];

% 73 Mo 1 corrected for thermal expansion
T2 = [80,100,120,140,160,180,200,220,240,260,280,300,320,340,360,380,400];
r2 = [4.92,6.349,7.78,9.222,10.678,12.152,13.639,15.143,16.661,18.196,19.758,21.35,22.985,24.656,26.358,28.073,29.824];

% 74 Co1
T3 = [260,273.15,300,350,400,450,500,550];
r3 = [18.173,19.196,21.308,25.336,29.506,33.832,38.336,43.031];

% 66 Le 1
T4 = [291.51,367.31,376.97,385.78,407.30,416.20,435.37,454.61,495.61,522.24,541.9,558.86,577.75,585.39,592.14,594.30];
r4 = [20.75,26.94,27.77,28.53,30.35,31.12,32.76,34.53,38.19,40.64,42.50,44.13,45.98,46.73,47.40,47.62];

%axis([8,55,0,10]) % change axis limit

plot(T1,r1,'.', 'markersize',20,'Color','black');
hold on;
plot(T2,r2,'s', 'markersize',5,'Color','red','MarkerFaceColor','red');
hold on;
plot(T3,r3,'d', 'markersize',5,'Color','green','MarkerFaceColor','green');
hold on;
plot(T4,r4,'*', 'markersize',5,'Color','cyan','MarkerFaceColor','cyan');
hold on;

legend('Present work without SOC','Present work with SOC','Hellwege et al.','Moore et al.','Cook et al.','Leadbetter et al.','Location','northwest'); 
yy = zeros(600,1);
plot(tt,yy,'Color','black','LineWidth',3);

xlabel('T (K)','FontSize',size);
ylabel('\rho(\mu\Omega cm)','FontSize',size);

ax = gca;
set(gca,'FontSize',size, 'LineWidth',3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Place second set of axes on same plot

handaxes2 = axes('position', [0.68 0.21 0.2 0.2]);
set(handaxes2, 'box', 'off');
% xlabel('T'); ylabel('(sin(t))^2');
% 
% % Adjust XY label font
% set(get(handaxes2, 'xlabel'))
% set(get(handaxes2, 'ylabel'))

plot(T1,r1,'.', 'markersize',30,'Color','black');
hold on;

tt = [1:25];
plot(tt,resistivity(1:25),'Color','blue','LineWidth',3);
hold on;
plot(tt,resistivity2(1:25),'Color','red','LineWidth',3);
hold on;

yy = zeros(25,1);
plot(tt,yy,'Color','black','LineWidth',3);
hold on;

axis([0,25,0,1]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ax = gca;
set(gca,'FontSize',size, 'LineWidth',3);

h=gcf
set(h, 'PaperPositionMode', 'auto');
set(h,'PaperOrientation','landscape');
set(h,'Position',[100 100 800 450]);
print(h, '-dpdf', 'Pb_resistivity.pdf')


