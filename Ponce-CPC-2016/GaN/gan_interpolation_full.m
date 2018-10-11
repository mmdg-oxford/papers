% Interpolation full
LASTN = maxNumCompThreads(1)
% figure('Units', 'pixels', ...
%     'Position', [100 100 800 1200]);

FigHandle = figure('Position', [100, 100, 650, 1200]);


hold on;
% hold on;

size = 16
cm2mev = 0.12398 ;
Thz2meV = 4.13567;
ry2ev = 13.605698066 ;
ratio1 = 1.4 
ratio2 = 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Electronic bandstructure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


h(1) = subplot(3,1,1);

SpecfunID = fopen('ganbands2.dat.gnu');
data = textscan(SpecfunID,'%f %f\n','CommentStyle','#','CollectOutput',true);
BS = cell2mat(data);
fclose(SpecfunID);

fermi = 10.9375; % eV

BS(:,2) = BS(:,2)*ry2ev - fermi;

plot(BS(:,1),BS(:,2),'Color','blue','LineWidth',2);
hold on;
range = 31000:33308;
plot(BS(range,1),BS(range,2),'Color','red','LineWidth',3);
hold on;

% range = 33015:33309;
% plot(BS(range,1),BS(range,2),'Color','red','LineWidth',3);
% hold on;
% range = 31000:32510;
% plot(BS(range,1),BS(range,2),'Color','red','LineWidth',3);
% hold on;
% range = 29918:31200;
% plot(BS(range,1),BS(range,2),'Color','red','LineWidth',3);
% hold on;

% Now plot horizontal line to show Fermi level
vert = linspace(0,3.461428,100);
horizontal = 8*ones(100);
plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');


vert = zeros(100);
horizontal = linspace(0,max(BS(:,1)),100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '--');
vert = 13*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
% Now plotvertical line
horizontal = 1*ones(100);
vert = linspace(min(BS(:,2))-2,max(BS(:,2))+2,100);
horizontal = 0.0*ones(100);
plot(horizontal,vert,'Color',[0,0,0],'LineWidth',1, 'LineStyle', '-');
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


axis([0,max(BS(:,1)),-8,8]) % change axis limit


ay1 = gca
ay2 = gca

set(gca,'FontSize',size);
set(gca,'LineWidth',2);
set(ay1,'ytick',[ -6, -4, -2, 0, 2, 4, 6, 8])
set(gca,'xtick',[0, 0.66666, 1.0, 1.5774, 1.8841, 2.5508, 2.8841, 3.461428]);




% ax1 = gca; % current axes
% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none');









%pbaspect([ratio1 ratio2 1])

% box off
% axes('xlim', [0 3.461428], 'ylim', [-8 8], 'color', 'none',...
% 'YTick',[-8 -6 -4 -2 0 2 4 6 8],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
% 'XTick',[0 0.66666 1.0 1.5774 1.8841 2.5508 2.8841 3.461428],...
% 'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Phonon bandstructure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h(2) = subplot(3,1,2);

SpecfunID = fopen('gan_4.freq2.gp');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS4 = cell2mat(data);
fclose(SpecfunID);

for ii = 2:12
  plot(BS4(:,1),BS4(:,ii)*cm2mev,'Color','blue','LineWidth',2,'LineStyle', '-');
  hold on;
end


plot(BS4(:,1),BS4(:,13)*cm2mev,'Color','red','LineWidth',3);
hold on;


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


% References experimental from  [Siegle et al. (1997)]. 
%Gamma
x = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ];
y = [66.08357, 69.43115, 70.54701, 91.12838, 91.99627, 181.63684 ];
plot(x,y,'k^','Markersize',7,'MarkerFaceColor','black');
hold on; 
x = [1.5774, 1.5774, 1.5774, 1.5774, 1.5774, 1.5774 ];
y = [66.08357, 69.43115, 70.54701, 91.12838, 91.99627, 181.63684 ];
plot(x,y,'k^','Markersize',7,'MarkerFaceColor','black');
hold on; 


x = [0.11111,0.222222,0.3333333,0.44444,0.55555, 0.666666 ];
y = [6.94311,12.15045,16.73787, 21.07731,24.17692, 26.03668    ];
plot(x,y,'k.','Markersize',22');
hold on;
x = [0.3333333,0.44444,0.55555  ];
y = [29.26027, 29.75621,27.27652   ];
plot(x,y,'k.','Markersize',22');
hold on;

x = [0.0, 0.11111,0.22222, 0.3333333, 0.11111, 0.3333333, 0.666666  ];
y = [40.17088, 39.67494, 37.44323, 36.69932, 65.71162,  68.19131, 75.63036  ];
plot(x,y,'k.','Markersize',22');
hold on;

%K
x = [0.7778, 0.7778, 1.0,1.0,1.0,1.0,1.0 ];
y = [24.17692, 29.13629, 16.98583,22.44114, 23.80497, 29.63222   ,71.66286];
plot(x,y,'k.','Markersize',22');
hold on;

%M-G
x = [1.0962,   1.1925,   1.2887,   1.2887,     1.3849,  1.3849,   1.4812 , 1.4812,    1.4812, 1.5774  ];
y = [21.69723, 17.97771, 13.63826, 66.95146 ,  9.67077, 38.43510, 5.57929, 39.92291,  64.71975, 40.17088  ];
plot(x,y,'k.','Markersize',22);
hold on;

%G-A
x = [1.5979,  1.6388, 1.6388, 1.6388, 1.6388,  1.7206, 1.7206, 1.7206, 1.7206, 1.8023, 1.8023, 1.8023, 1.8432, 1.8432,1.8841,   1.8841];
y = [85.54909, 8.05897, 39.92291, 84.92917,90.26049, 15.86998, 37.81518, 87.40886, 89.88854, 21.69723, 34.09565, 88.40073, 25.78871, 31.61597, 28.51636, 88.27675       ];
plot(x,y,'k.','Markersize',22);
hold on;

% %H-L -- 18/18 [23-26]
% x = [2.6341, 2.7175, 2.8008, 2.8841  ];
% y = [20.507273, 15.332514, 11.012547, 7.595551  ];
% plot(x,y,'k.','Markersize',22);
% hold on;
% 
% %L-A -- 18/18 [27-29]
% x = [3.0284, 3.1728, 3.3171, 3.461428];
% y = [ 43.863049, 74.119478, 89.907825, 93.775854   ];
% plot(x,y,'k.','Markersize',22);
% hold on;
% 
% 








axis([0,3.461428,0,100]) % change axis limit

set(gca,'FontSize',size);
set(gca,'LineWidth',2);
set(gca,'ytick',[ 20, 40, 60, 80])
set(gca,'xtick',[0, 0.66666, 1.0, 1.5774, 1.8841, 2.5508, 2.8841, 3.461428]);


% box off
% axes('xlim', [0 3.461428], 'ylim', [1 100], 'color', 'none',...
% 'YTick',[0 20 40 60 80 100],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
% 'XTick',[0 0.66666 1.0 1.5774 1.8841 2.5508 2.8841 3.461428],...
% 'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')



%pbaspect([ratio1 ratio2 1])



%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolation
%%%%%%%%%%%%%%%%%%%%

h(3) = subplot(3,1,3);

SpecfunID = fopen('epw_path_4_wo_correction2');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','k','CollectOutput',true);
epw4wo = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('epw_path_6_wo_correction');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','k','CollectOutput',true);
epw6wo = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('epw_path_4_w_correction');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','k','CollectOutput',true);
epw4w = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('epw_path_6_w_correction');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f\n','CommentStyle','k','CollectOutput',true);
epw6w = cell2mat(data);
fclose(SpecfunID);

nq = 231

%1851 qpoints
epc = zeros(18,18,12,nq);

for jj = 1:nq
  for ii= 1:6*6*12
    kk = (jj-1)*6*6*12+ii;
    epc(epw4wo(kk,1), epw4wo(kk,2),epw4wo(kk,3),jj) = epw4wo(kk,7);
  end
end

epc6 = zeros(18,18,12,nq);

for jj = 1:nq
  for ii= 1:6*6*12
    kk = (jj-1)*6*6*12+ii;
    epc6(epw6wo(kk,1), epw6wo(kk,2),epw6wo(kk,3),jj) = epw6wo(kk,7);
  end
end

epc_w = zeros(18,18,12,nq);

for jj = 1:nq
  for ii= 1:6*6*12
    kk = (jj-1)*6*6*12+ii;
    epc_w(epw4w(kk,1), epw4w(kk,2),epw4w(kk,3),jj) = epw4w(kk,7);
  end
end
  
epc6_w = zeros(18,18,12,nq);

for jj = 1:nq
  for ii= 1:6*6*12
    kk = (jj-1)*6*6*12+ii;
    epc6_w(epw6w(kk,1), epw6w(kk,2),epw6w(kk,3),jj) = epw6w(kk,7);
  end
end


band = 18

x = linspace(0,3.461428,nq);
y =  zeros(nq);

for ii=1:8
    y(ii) =  epc(18,18,12,ii);
end
for ii=8:37
    y(ii) =  epc(18,18,12,ii);
end
for ii=37:41
    y(ii) =  epc(18,band,12,ii);
end
for ii=41:61
    y(ii) =  epc(18,band,12,ii);
end
for ii=61:101
    y(ii) =  epc(18,band,12,ii);
end
% Gamma -A
for ii=101:231
    y(ii) =  epc(18,18,12,ii);
end

% plot(linspace(0,0.6666666666,41),y(1:41),'Color','blue','LineWidth',2,'LineStyle', '-');
% hold on;
% plot(linspace(0.666666666,1.0,21),y(41:61),'Color','blue','LineWidth',2,'LineStyle', '-');
% hold on;
% plot(linspace(1.0,1.5774,41),y(61:101),'Color','blue','LineWidth',2,'LineStyle', '-');
% hold on;
% plot(linspace(1.5774,1.8841,41),y(101:141),'Color','blue','LineWidth',2,'LineStyle', '-');
% hold on;
% plot(linspace(1.8841,2.5508,41),y(141:181),'Color','blue','LineWidth',2,'LineStyle', '-');
% hold on;
% plot(linspace(2.5508,2.8841,31),y(181:211),'Color','blue','LineWidth',2,'LineStyle', '-');
% hold on;
% plot(linspace(2.8841,3.461428,21),y(211:231),'Color','blue','LineWidth',2,'LineStyle', '-');


% Without correction on 6x6x6 qgrid
x = linspace(0,3.461428,nq);
y =  zeros(nq);

for ii=1:37
    y(ii) =  epc6(18,18,12,ii);
end
for ii=37:101
    y(ii) =  epc6(18,band,12,ii);
end
for ii=101:231
    y(ii) =  epc6(18,18,12,ii);
end
plot(linspace(0,0.6666666666,41),y(1:41),'Color','blue','LineWidth',2,'LineStyle', '--');
hold on;
plot(linspace(0.666666666,1.0,21),y(41:61),'Color','blue','LineWidth',2,'LineStyle', '--');
hold on;
plot(linspace(1.0,1.5774,41),y(61:101),'Color','blue','LineWidth',2,'LineStyle', '--');
hold on;
plot(linspace(1.5774,1.8841,41),y(101:141),'Color','blue','LineWidth',2,'LineStyle', '--');
hold on;
plot(linspace(1.8841,2.5508,41),y(141:181),'Color','blue','LineWidth',2,'LineStyle', '--');
hold on;
plot(linspace(2.5508,2.8841,31),y(181:211),'Color','blue','LineWidth',2,'LineStyle', '--');
hold on;
plot(linspace(2.8841,3.461428,21),y(211:231),'Color','blue','LineWidth',2,'LineStyle', '--');



% With correction on 4x4x4 qgrid
% x = linspace(0,3.461428,nq);
% y =  zeros(nq);
% 
% for ii=1:37
%     y(ii) =  epc_w(18,18,12,ii);
% end
% for ii=37:101
%     y(ii) =  epc_w(18,band,12,ii);
% end
% for ii=101:231
%     y(ii) =  epc_w(18,18,12,ii);
% end
% plot(linspace(0,0.6666666666,41),y(1:41),'Color','green','LineWidth',2,'LineStyle', '-');
% hold on;
% plot(linspace(0.666666666,1.0,21),y(41:61),'Color','green','LineWidth',2,'LineStyle', '-');
% hold on;
% plot(linspace(1.0,1.5774,41),y(61:101),'Color','green','LineWidth',2,'LineStyle', '-');
% hold on;
% plot(linspace(1.5774,1.8841,41),y(101:141),'Color','green','LineWidth',2,'LineStyle', '-');
% hold on;
% plot(linspace(1.8841,2.5508,41),y(141:181),'Color','green','LineWidth',2,'LineStyle', '-');
% hold on;
% plot(linspace(2.5508,2.8841,31),y(181:211),'Color','green','LineWidth',2,'LineStyle', '-');
% hold on;
% plot(linspace(2.8841,3.461428,21),y(211:231),'Color','green','LineWidth',2,'LineStyle', '-');


% With correction on 6x6x6 qgrid
x = linspace(0,3.461428,nq);
y =  zeros(nq);

for ii=1:37
    y(ii) =  epc6_w(18,18,12,ii);
end
for ii=37:101
    y(ii) =  epc6_w(18,band,12,ii);
end
for ii=101:231
    y(ii) =  epc6_w(18,18,12,ii);
end
plot(linspace(0,0.6666666666,41),y(1:41),'Color','red','LineWidth',2,'LineStyle', '-');
hold on;
plot(linspace(0.666666666,1.0,21),y(41:61),'Color','red','LineWidth',2,'LineStyle', '-');
hold on;
plot(linspace(1.0,1.5774,41),y(61:101),'Color','red','LineWidth',2,'LineStyle', '-');
hold on;
plot(linspace(1.5774,1.8841,41),y(101:141),'Color','red','LineWidth',2,'LineStyle', '-');
hold on;
plot(linspace(1.8841,2.5508,41),y(141:181),'Color','red','LineWidth',2,'LineStyle', '-');
hold on;
plot(linspace(2.5508,2.8841,31),y(181:211),'Color','red','LineWidth',2,'LineStyle', '-');
hold on;
plot(linspace(2.8841,3.461428,21),y(211:231),'Color','red','LineWidth',2,'LineStyle', '-');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference g computed with PH %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Gamma-K [01-08]
x = [ 0,0.041666666666650, 0.0833333333333, 0.1666666666666, 0.25     , 0.3333333333333,  0.4166666666666 ,0.5,0.5833333333333, 0.6666666666666];
y = [ 0,976.738559, 495.664297     , 250.422663     , 18.299546, 17.071182      ,15.523634, 13.453154 ,9.054562, 0.0000 ];
plot(x,y,'k.','Markersize',22);
hold on; 
%K-M -- 18/17  [09-11+M]
x = [0.75, 0.833333, 0.9167, 1.0];
% 17
%y = [5.817192,6.264908, 13.819903, 15.759163  ];
% 18
y = [29.160737, 36.103072, 23.126501, 0.000000  ];
plot(x,y,'k.','Markersize',22);
hold on;

%M-G -- 18/17 [12-14+G]
x = [1.1443, 1.2887, 1.4331,1.505250000, 1.5774];
% 17
%y = [17.689301, 19.367429,  15.296462, 0.0   ];
% 18
y = [60.338621,124.497398, 281.256903 , 568.238828 , 0.0   ];
plot(x,y,'k.','Markersize',22);
hold on;

%G-A -- 18/18 [15-18]
x = [1.6541, 1.7308, 1.8074, 1.8841  ];
y = [ 561.258031, 282.648810, 185.685295,  93.775854 ];
plot(x,y,'k.','Markersize',22);
hold on;

%A-H -- 18/18 [19-22]
x = [ 2.0508, 2.2175, 2.3841, 2.5508  ];
y = [ 89.480630, 68.864991, 27.160196, 29.410410 ];
plot(x,y,'k.','Markersize',22);
hold on;

%H-L -- 18/18 [23-26]
x = [2.6341, 2.7175, 2.8008, 2.8841  ];
y = [20.507273, 15.332514, 11.012547, 7.595551  ];
plot(x,y,'k.','Markersize',22);
hold on;

%L-A -- 18/18 [27-29]
x = [3.0284, 3.1728, 3.3171, 3.461428];
y = [ 43.863049, 74.119478, 89.907825, 93.775854   ];
plot(x,y,'k.','Markersize',22);
hold on;



 top = 600;
 vert = linspace(0,3.461428,100);
 horizontal = top*ones(100);
 plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
 horizontal = 0*ones(100);
 plot(vert,horizontal,'Color',[0,0,0],'LineWidth',2, 'LineStyle', '-');
 
 vert = linspace(0,top,100);
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
 
 
 axis([0,3.461428,0,top]) % change axis limit



set(gca,'FontSize',size);
set(gca,'LineWidth',2);
set(gca,'ytick',[0, 100, 200, 300, 400, 500]);
set(gca,'xtick',[0, 0.66666, 1.0, 1.5774, 1.8841, 2.5508, 2.8841, 3.461428]);
set(gca,'xticklabel',{'\Gamma','K','M','\Gamma','A','H','L','A','FontSize',size});



set(h, 'box', 'off');

pos1 = get(h(1),'Position');
pos2 = get(h(2),'Position');
pos3 = get(h(3),'Position');


set(h(1),'XTickLabel','');

pos2(2) = pos1(2) - pos2(4);
set(h(2),'Position',pos2);

set(h(2),'XTickLabel','');

pos3(2) = pos2(2) - pos3(4);
set(h(3),'Position',pos3);

 a = 3;
 
 text(pos1(1)+a,pos1(3)-7.2,['(',char(1+96),') '],...
     'color','k','fontw','b','FontSize',size,'Parent', h(1));
 text(pos2(1)+a,pos2(3)+8,['(',char(2+96),') '],...
     'color','k','fontw','b','FontSize',size,'Parent', h(2));
  text(pos3(1)+a,pos3(3)+35,['(',char(3+96),') '],...
     'color','k','fontw','b','FontSize',size,'Parent', h(3));

%pbaspect([ratio1 ratio2 1])

box off
axes('Position',pos1,'xlim', [0 3.461428], 'ylim', [-8 8], 'color', 'none',...
'YTick',[-8 -6 -4 -2 0 2 4 6 8],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 0.66666 1.0 1.5774 1.8841 2.5508 2.8841 3.461428],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')
axes('Position',pos2,'xlim', [0 3.461428], 'ylim', [0 100], 'color', 'none',...
'YTick',[20, 40, 60, 80],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 0.66666 1.0 1.5774 1.8841 2.5508 2.8841 3.461428],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')
axes('Position',pos3,'xlim', [0 3.461428], 'ylim', [0 top], 'color', 'none',...
'YTick',[0, 100, 200, 300, 400, 500],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
'XTick',[0 0.66666 1.0 1.5774 1.8841 2.5508 2.8841 3.461428],...
'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')




ylabel(h(1),'E-E_F (eV)','FontSize',size);
ylabel(h(2),'\omega (meV)','FontSize',size);
ylabel(h(3),'|g_q| (meV)','FontSize',size);




% 
% box off
% axes('xlim', [0 3.461428], 'ylim', [1 100], 'color', 'none',...
% 'YTick',[0 20 40 60 80 100],'YTickLabel',[],'LineWidth',2,'YAxisLocation','right',...
% 'XTick',[0 0.66666 1.0 1.5774 1.8841 2.5508 2.8841 3.461428],...
% 'XTickLabel',[],'LineWidth',2,'XAxisLocation','top')



%set(gcf, 'PaperPositionMode', 'auto');
%print -depsc2 GaN_interpol18.eps
%print('GaN_interpol18','-dpng')
%close;

