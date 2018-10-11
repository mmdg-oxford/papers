% Plot Specific heat

%  figure('Units', 'pixels', ...
%      'Position', [100 100 1300 950]);
format long;
hold all;

kelvin2eV= 8.6173427909E-05;
size = 16;

T = [6,8,10,15.5556,21.1111,26.6667,32.2222,37.7778, 43.3333, 48.8889, 50.0000];

% This should be in eV
F = [-5.5367720036E-06,-5.3664395387E-06,-0.512844407889546E-05, -0.447117367740279E-05,-0.361380780860396E-05, -0.267128480378581E-05,...
    -0.172744756761750E-05, -0.886537034572661E-06, -0.262556842537375E-06, -0.116776119913726E-07, ...
    -0.175405737363820E-08, ];

%T = Tinit.*kelvin2eV

%1eV = 96.4869 kJ/mol
%1eV = 96486.9 J/mol
%1eV = 96486900 mJ/mol
ev2mJmol = 96486900;

for ii = 1:11
    %F(ii) = F(ii)*(T(ii)*kelvin2eV)*pi*ev2mJmol
    F(ii) = F(ii)*ev2mJmol
end



coeff = polyfit(T,F,5)

x = linspace(T(1),T(end),1001);

Y = polyval(coeff, x);





z = polyder(coeff);
zz = polyder(z);
zzz= polyval(zz, x);

plot(x./51,-zzz,'Color','blue','LineWidth',3);
hold on;

coeff = polyfit(T,F,6)
z = polyder(coeff);
zz = polyder(z);
zzz= polyval(zz, x);

plot(x./51,-zzz,'Color','red','LineWidth',3);
hold on;

coeff = polyfit(T,F,7)
z = polyder(coeff);
zz = polyder(z);
zzz= polyval(zz, x);

plot(x./51,-zzz,'Color','green','LineWidth',3);
hold on;

coeff = polyfit(T,F,8)
z = polyder(coeff);
zz = polyder(z);
zzz= polyval(zz, x);

plot(x./51,-zzz,'Color','cyan','LineWidth',3);
hold on;


T_second = [8, 15.55555, 21.1111, 26.6667, 32.2222, 37.7778, 43.3333, 48.8889]
F_second = [-1.632148155763673, -0.625534810628293, -0.266216689816305, -0.004108526144104,...
    0.321767587310822,0.678163686613226, 1.166381439982013, 0.753271251671982 ]

plot(T_second/51, F_second, '--ko','LineWidth',3 ) 


%hold on;

%coeff = polyfit(T,F,9)
%z = polyval([72*coeff(1),56*coeff(2),42*coeff(3),30*coeff(4),20*coeff(5),12*coeff(6),6*coeff(7),2*coeff(8)], x);
% plot(x,-z+2.26,'Color','green','LineWidth',2);


%Experimental data
SpecfunID = fopen('wang2001_specific_heat.txt');
data = textscan(SpecfunID,'%f %f %f %f %f %f \n','CommentStyle','#','CollectOutput',true);
Exp1 = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('Bouquets2001_specific_heat.txt');
data = textscan(SpecfunID,'%f %f %f %f %f %f \n','CommentStyle','#','CollectOutput',true);
Exp2 = cell2mat(data);
fclose(SpecfunID);


%The Wang data are expressed in gram-atom (gat). 1 cole of MgB2 is 1 gram-molecule of MgB2 but
% 3 gram-atoms of MgB2

plot(Exp1(:,1)./36.7,Exp1(:,2)*3,'.', 'markersize',15,'Color','black');

plot(Exp2(:,1)./38.7,Exp2(:,2)-2.6,'s', 'markersize',5,'Color','red','MarkerFaceColor','red');

%plot(T3,r3,'d', 'markersize',8,'Color','black','MarkerFaceColor','black');
%hold on;
%plot(T4,r4,'*', 'markersize',8,'Color','black','MarkerFaceColor','black');
%hold on;

%legend('Present work T_c = 51K','Wang et al. T_c = 36.7K','Bouqet et al. T_c = 38.7K','Location','northwest'); 


x = linspace(0,2,100);
y = zeros(100,1);
plot(x,y,'--','LineWidth',2);


axis([0,1.1,-3,4]);

xlabel('T/T_c (K)','FontSize',size);
ylabel('\Delta C / T  (mJ/mol K^2)','FontSize',size);


ax = gca;
set(gca,'FontSize',size, 'LineWidth',3);

pos1 = get(ax,'Position');
box off
axes('Position',pos1,'xlim', [0 55], 'ylim', [-3 4], 'color', 'none',...
'YTick',[-3 -2 -1 0 1 2 3 4 ],'YTickLabel',[],'LineWidth',3,'YAxisLocation','right',...
'XTick',[10,20,30,40,50],...
'XTickLabel',[],'LineWidth',3,'XAxisLocation','top')





h=gcf
set(h, 'PaperPositionMode', 'auto');
set(h,'PaperOrientation','landscape');
set(h,'Position',[100 100 800 400]);
print(h, '-dpdf', 'MgB2_specific_heat3.pdf')


