% a2F of Lead
LASTN = maxNumCompThreads(1) 

figure('Units', 'pixels', ...
    'Position', [100 100 700 1000]);
hold on;

size = 12

% Phonon smearing = 0.15 meV
% Electron smearing = 50 meV

% Pb homogeneous
col1 = [190,190,190]/255;
col2 = [96,96,96]/255;
col3 = [0,0,0];


%Pb Sobol blue
col4 = [160,160,255]/255;
col5 = [100,100,255]/255;
col6 = [0,0,1];

% %Pb +SO red
col7 = [255,160,160]/255;
col8 = [255,100,100]/255;
col9 = [1,0,0];

% col0 = [208,209,230]/255;
% col1 = [166,189,219]/255;
% col2 = [116,169,207]/255;
% col3 = [43,140,190]/255;
% col4 = [4,90,141]/255;
% col5 = [0,0,1];
% col6 = [0,0,0];


h(2) = subplot(4,2,2);

%Comparison HOMOGENEOUS k and q grid VERSUS Sobolk+RNDq for WO SOC PB

kpoints1 = [ 40^3,   60^3,  70^3,  80^3,  90^3, 100^3 ]; 
lambda1 = [  1.90520  , 1.1919, 1.246, 1.346,1.1796, 1.1146];% 27000 q-points
kpoints2 = [40^3,  60^3,  70^3,  80^3,  90^3, 100^3]; 
lambda2 = [ 1.32469 ,   1.4929,1.1637,1.1404,1.1973, 0.98923];% 64000 q-points
kpoints3 = [40^3,  60^3,  70^3,  80^3,  90^3, 100^3]; 
lambda3 = [  2.0397209,   1.5720,1.2373, 1.335,1.3133, 1.17325];% 125000 q-points

plot(kpoints1,lambda1,'Color',col1);
hold on;
s1 = scatter(kpoints1,lambda1,50,'filled','MarkerFaceColor',col1);
hold on;

plot(kpoints2,lambda2,'Color',col2);
hold on;
s2 = scatter(kpoints2,lambda2,50,'filled','MarkerFaceColor',col2);
hold on;

plot(kpoints3,lambda3,'Color',col3);
s3 = scatter(kpoints3,lambda3,50,'filled','MarkerFaceColor',col3);
hold on;

% USING SOBOL k + RND q for WO SOC

% 50000 q 
kpoints1 = [70000,150000,200000,300000,400000,500000, 700000];
lambda1 = [1.4329548,1.4068432, 1.2697608, 1.2953520, 1.24032395 , 1.161068500, 1.240178150 ];

% 100000 q 
kpoints2 = [70000,150000,200000,300000];
lambda2 = [1.4280050000,1.406843200, 1.26818366666, 1.295476900 ];


% 150000 q 
kpoints3 = [70000,150000,200000,300000];
lambda3 = [ 1.4229968666,1.4069027333, 1.26818366666, 1.294100533333 ];

% ----- Sobol k / Random q ------
% 0 Kelvin
% WITHOUT SO
% 50 meV broadening
%  70000k Sobol/ 50000 : 1.4329548 | 1.4329548
%              / 50000 : 1.4230552 | 1.4280050000
%              / 50000 : 1.4129806 | 1.4229968666666
% 150000k Sobol/ 50000 : 1.4068432 | 1.4068432
%              / 50000 : 1.4187064 | 1.406843200
%              / 50000 : 1.3951586 | 1.4069027333
% 200000k Sobol/ 50000 : 1.2697608 | 1.2697608
%              / 50000 : 1.2680043 | 1.2688825500
%              / 50000 : 1.2667859 | 1.268183666666667
% 300000k Sobol/ 50000 : 1.2953520 | 1.2953520
%              / 50000 : 1.2956018 | 1.295476900
%              / 50000 : 1.2913478 | 1.294100533333
% 400000k Sobol/ 25000 : 1.2364818 | 1.2364818  ( 25q)
%              / 25000 : 1.2441661 | 1.24032395 ( 50q)
%              / 25000 : 1.2386055 | 1.2397511333
% 500000k Sobol/ 20000 : 1.1610685 | 1.1610685
%              / 20000 : 1.1662825 | 
%              / 20000 : 1.1601203 | 1.161068500
% 700000k Sobol/ 25000 : 1.2432224 | 1.2432224
%              / 25000 : 1.2371339 | 1.240178150
%              / 25000 : 1.2408084 | 1.2403882333


plot(kpoints1,lambda1,'Color',col4);
hold on;
s4 = scatter(kpoints1,lambda1,50,'filled','MarkerFaceColor',col4);
hold on;

plot(kpoints2,lambda2,'Color',col5);
hold on;
s5 = scatter(kpoints2,lambda2,50,'filled','MarkerFaceColor',col5);
hold on;

plot(kpoints3,lambda3,'Color',col6);
s6 = scatter(kpoints3,lambda3,50,'filled','MarkerFaceColor',col6);
hold on;


get(gca,'position')

legend([s1,s2,s3],'30^3 q','40^3 q','50^3 q',... 
'Location','northeast');
hold on;
set(legend,'FontSize',10);
legend boxoff

% legend_str = [];
% legend_str = ['2.7\cdot10^4 q','6.4\cdot10^4 q','1.25\cdot10^5 q','50k q','100k q','150k q'];
% 
% columnlegend(2,legend_str,'Location','NorthEast');
% hold on;
% set(legend,'FontSize',10);
% legend boxoff


axis([0,730000,0.5,3.0])

ylabel('\lambda','FontSize',size);
set(gca,'FontSize',size);
set(gca,'LineWidth',2);
set(gca,'ytick',[1,2]);
set(gca,'YAxisLocation','right');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

h(1) = subplot(4,2,1);





SpecfunID = fopen('90k_50q_hom');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
s3 = plot(a2F(:,1),a2F(:,4),'-','Color',col3,'LineWidth',2);
hold on;

%Corrected SOBOL
SpecfunID = fopen('pb.a2f_500kSobol20q_01_woSOC');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
s4 =plot(a2F(:,1),a2F(:,4),'-','Color',col6,'LineWidth',2);
hold on;


%%%%%%%%%%%%%%%%
% Experimental %
%%%%%%%%%%%%%%%%
% The a2F pb data are from McMillan in Superconductivity Parks 1969
% and are from tunneling experiment. The a2F is obtained by fitting 
% Electronic density of states of Pb divided by BCS density of states
% The experiment is made at 1K so that T/Tc = 0.15

% SpecfunID = fopen('xyscan_a2F_Pb_Parks1969.txt');
% data = textscan(SpecfunID,'%f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
% exp = cell2mat(data);
% fclose(SpecfunID);
% s5 = plot(exp(:,1),exp(:,2),'.', 'markersize',15,'Color','black' );


legend([s3,s4,s5],'Homogeneous','Sobol+random','Location','northwest')

set(legend,'FontSize',10);

legend boxoff
set(gca,'FontSize',size);
set(gca,'LineWidth',2);
set(gca,'ytick',[1,2])
axis([0,10,0,2])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



h(4) = subplot(4,2,4);

% WITHOUT SO
%%%%%%%%
kpoints1 = [70000,150000,200000,300000,400000,500000, 700000];
lambda1 = [1.31749733333, 1.24050523, 1.22212453333, 1.2545843, 1.22538236, 1.14, 1.197932100  ];


% ----- Sobol k / Random q ------
% 0 Kelvin
% WITHOUT SO
% 10 meV broadening
%  70000k Sobol/ 50000 : 1.3200797 | 1.3200797
%              / 50000 : 1.3125860 | 
%              / 50000 : 1.3198263 | 1.31749733333
% 150000k Sobol/ 50000 : 1.2400996 | 1.2400996
%              / 50000 : 1.2416019 | 
%              / 50000 : 1.2398142 | 1.240505233333333
% 200000k Sobol/ 50000 : 1.2212091 | 1.2212091
%              / 50000 : 1.2106084 | 1.2159087500
%              / 50000 : 1.2345561 | 1.22212453333
% 300000k Sobol/ 50000 : 1.2538207 | 1.2538207
%              / 50000 : 1.2567292 | 
%              / 50000 : 1.2532030 | 1.2545843
% 400000k Sobol/ 25000 : 1.2330828 | 1.2330828  ( 25q)
%              / 25000 : 1.2164427 |     ( 50q)
%              / 25000 : 1.2266216 |      ( 75q)
% 500000k Sobol/ 20000 : 1.1399281 | 1.1399281
%              / 20000 : 1.1426738 | 
%              / 20000 :  | 
% 700000k Sobol/ 25000 : 1.2011276 | 1.2011276
%              / 25000 : 1.1973680 | 1.19924780
%              / 25000 : 1.1953007 | 1.197932100


kpoints2 = [70000,150000,200000,300000,400000,500000,700000];
lambda2 = [ 1.39594696666,1.337928433, 1.2743072, 1.2911068333, 1.240653433, 1.17,1.206256300 ];

% 20 meV broadening
%  70000k Sobol/ 50000 : 1.3924261 | 1.3924261
%              / 50000 : 1.4048256 | 
%              / 50000 : 1.3905892 | 1.39594696666
% 150000k Sobol/ 50000 : 1.3311908 | 1.3311908
%              / 50000 : 1.3401222 | 
%              / 50000 : 1.3424723 | 1.337928433
% 200000k Sobol/ 50000 : 1.2703751 | 1.27037511.4048256
%              / 50000 :  | 
%              / 50000 : 1.2743072 | 
% 300000k Sobol/ 50000 : 1.2942358 | 1.2942358 
%              / 50000 : 1.2973422 | 
%              / 50000 : 1.2817425 | 1.2911068333
% 400000k Sobol/ 25000 : 1.2273242 | 1.2273242  ( 25q)
%              / 25000 : 1.2488741 |      ( 50q)
%              / 25000 : 1.2457620 | 1.240653433
% 500000k Sobol/ 20000 : 1.1742577 | 1.1742577
%              / 20000 :  | 
%              / 20000 : 1.1792556 | 
% 700000k Sobol/ 25000 : 1.2092261 | 1.2092261 
%              / 25000 : 1.2027214 | 
%              / 25000 : 1.2068214 | 1.206256300

kpoints3 = [70000,150000,200000,300000,400000,500000, 700000];
lambda3 = [1.4229968666,1.4069027333, 1.268183666666, 1.294100533333,  1.2397511333,  1.161068500,1.2403882333 ];

% ----- Sobol k / Random q ------
% 0 Kelvin
% WITHOUT SO
% 50 meV broadening
%  70000k Sobol/ 50000 : 1.4329548 | 1.4329548
%              / 50000 : 1.4230552 | 1.4280050000
%              / 50000 : 1.4129806 | 1.4229968666666
% 150000k Sobol/ 50000 : 1.4068432 | 1.4068432
%              / 50000 : 1.4187064 | 
%              / 50000 : 1.3951586 | 1.4069027333
% 200000k Sobol/ 50000 : 1.2697608 | 1.2697608
%              / 50000 : 1.2680043 | 1.2688825500
%              / 50000 : 1.2667859 | 1.268183666666667
% 300000k Sobol/ 50000 : 1.2953520 | 1.2953520
%              / 50000 : 1.2956018 | 1.295476900
%              / 50000 : 1.2913478 | 1.294100533333
% 400000k Sobol/ 25000 : 1.2364818 | 1.2364818  ( 25q)
%              / 25000 : 1.2441661 |  ( 50q)
%              / 25000 : 1.2386055 | 1.2397511333
% 500000k Sobol/ 20000 : 1.1610685 | 1.1610685
%              / 20000 : 1.1662825 | 
%              / 20000 : 1.1601203 | 1.161068500
% 700000k Sobol/ 25000 : 1.2432224 | 1.2432224
%              / 25000 : 1.2371339 | 1.240178150
%              / 25000 : 1.2408084 | 1.2403882333

plot(kpoints1,lambda1,'Color',col4);
hold on;
s4 = scatter(kpoints1,lambda1,50,'filled','MarkerFaceColor',col4);
hold on;

plot(kpoints2,lambda2,'Color',col5);
hold on;
s5 = scatter(kpoints2,lambda2,50,'filled','MarkerFaceColor',col5);
hold on;

plot(kpoints3,lambda3,'Color',col6);
s6 = scatter(kpoints3,lambda3,50,'filled','MarkerFaceColor',col6);
hold on;



% WITH SO
%%%%%%%%

kpoints1 = [70000,150000,200000,300000,400000,500000,700000];
lambda1 = [1.75990245,1.75456, 1.7586173, 1.5994359, 1.6378, 1.6840,1.6163611666666 ];

% ----- Sobol k / Random q ------
% 0 Kelvin
% WITH SO
% 10 meV broadening
%  70000k Sobol/ 50000 : 1.7567291 | 1.7567291
%              / 50000 : 1.7630758 | 1.75990245
%              / 50000 :  | 
% 150000k Sobol/ 50000 : 1.7456    | 1.7456
%              / 50000 : 1.76169   | 1.75369
%              / 50000 : 1.7562477 | 1.75456
% 200000k Sobol/ 50000 : 1.7551155 | 1.7551155
%              / 50000 : 1.7586171 | 1.756866
%              / 50000 : 1.7621193 | 1.7586173
% 300000k Sobol/ 50000 : 1.5979625 | 1.5979625
%              / 50000 : 1.5980701 | 1.5980163
%              / 50000 : 1.6022752 | 1.5994359
% 400000k Sobol/ 50000 : 1.6377910 | 1.6377910 ( 50q)
%              / 50000 : 1.6395021 | 1.6386   (100q)
%              / 50000 : 1.6360996 | 1.6378   (150q) 
% 500000k Sobol/ 25000 : 1.6729995 | 1.6729995  ( 25q)
%              / 25000 : 1.6949476 | 1.6840     ( 50q)
% 700000k Sobol/ 20000 : 1.6126435 | 1.6126435
%              / 20000 : 1.6162720 |
%              / 20000 : 1.6201680 | 1.6163611666666


kpoints2 = [70000,150000,200000,300000,400000,500000,700000];
lambda2 = [1.8662034666, 1.78627933, 1.7892603, 1.60275076, 1.6274, 1.6769,1.61832730 ];

% 20 meV broadening
%  70000k Sobol/ 50000 : 1.8688286 | 1.8688286
%              / 50000 : 1.8805860 |
%              / 50000 : 1.8491958 | 1.8662034666
% 150000k Sobol/ 50000 : 1.7834613 | 1.7834613  ( 50q)
%              / 50000 : 1.7893296 | 1.78639545 (100q)
%              / 50000 : 1.7860471 | 1.78627933 (150q) 
% 200000k Sobol/ 50000 : 1.7854081 | 1.7854081  ( 50q)
%              / 50000 : 1.7947925 | 1.7901003  (100q)
%              / 50000 : 1.7875802 | 1.7892603  (150q)
% 300000k Sobol/ 50000 : 1.6079794 | 1.6079794  ( 50q)
%              / 50000 : 1.6046318 | 1.6063056  (100q)
%              / 50000 : 1.5956411 | 1.60275076 (150q) 
% 400000k Sobol/ 50000 : 1.6307553 | 1.6307553  ( 50q)
%              / 50000 : 1.6298875 | 1.6303     (100q)
%              / 50000 : 1.6216865 | 1.6274     (150q) 
% 500000k Sobol/ 25000 : 1.6742567 | 1.6742567  ( 25q)
%              / 25000 : 1.6795690 | 1.6769     ( 50q)
% 700000k Sobol/ 20000 : 1.6139508 | 1.6139508
%              / 20000 : 1.6248884 | 
%              / 20000 : 1.6161427 | 1.61832730

kpoints3 = [70000,150000,200000,300000,400000,500000,700000];
lambda3 = [ 2.07257126, 1.81997037, 1.85093917, 1.63371933, 1.5968, 1.6654, 1.622953233333  ];

% 50 meV broadening
%  70000k Sobol/ 50000 : 2.0705688 | 2.0705688
%              / 50000 : 2.0870196 |
%              / 50000 : 2.0601254 |  2.07257126
% 150000k Sobol/ 50000 : 1.8303286 | 1.83032860 ( 50q)
%              / 50000 : 1.8243029 | 1.82731575 (100q)
%              / 50000 : 1.8052796 | 1.81997037 (150q) 
% 200000k Sobol/ 50000 : 1.8677246 | 1.86772460 ( 50q)
%              / 50000 : 1.8401741 | 1.85394935 (100q)
%              / 50000 : 1.8449188 | 1.85093917 (150q) 
% 300000k Sobol/ 50000 : 1.6318601 | 1.6318601  ( 50q)
%              / 50000 : 1.6296545 | 1.6307573  (100q)
%              / 50000 : 1.6396434 | 1.63371933 (150q) 
% 400000k Sobol/ 50000 : 1.5979851 | 1.5979851  ( 50q)
%              / 50000 : 1.5965899 | 1.5973     (100q)
%              / 50000 : 1.5956898 | 1.5968     (150q)
% 500000k Sobol/ 25000 : 1.6582991 | 1.6582991  ( 25q)
%              / 25000 : 1.6725938 | 1.6654     ( 50q)
% 700000k Sobol/ 20000 : 1.6218190 | 1.6218190
%              / 20000 : 1.6266204 | 1.6242197000
%              / 20000 : 1.6204203 | 1.622953233333



plot(kpoints1,lambda1,'Color',col7);
hold on;
s1 = scatter(kpoints1,lambda1,50,'filled','MarkerFaceColor',col7);
hold on;
plot(kpoints2,lambda2,'Color',col8);
hold on;
s2 = scatter(kpoints2,lambda2,50,'filled','MarkerFaceColor',col8);
hold on;
plot(kpoints3,lambda3,'Color',col9);
s3 = scatter(kpoints3,lambda3,50,'filled','MarkerFaceColor',col9);

%%%%%%%%%%%%%%



legend([s1,s2,s3],'10 meV','20 meV','50 meV',... 
'Location','northEast')

set(legend,'FontSize',10);

legend boxoff
ylabel('\lambda','FontSize',size);
set(gca,'ytick',[1,2]);
set(gca,'YAxisLocation','right','FontSize',size);
set(gca,'LineWidth',2);
set(get(gca,'YLabel'),'Rotation',+90); 
axis([0,730000,0.5,3.0])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h(3) = subplot(4,2,3);

%Corrected SOBOL
% SpecfunID = fopen('30k_50000q_sobol');
% data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
% a2F = cell2mat(data);
% fclose(SpecfunID);
% plot(a2F(:,1),a2F(:,4),'-','Color',col1,'LineWidth',1);
% hold on;



%Corrected SOBOL
SpecfunID = fopen('pb.a2f_500kSobol20q_01_woSOC');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
plot(a2F(:,1),a2F(:,4),'-','Color',col6,'LineWidth',2);
hold on;

%Corrected SOBOL
SpecfunID = fopen('pb.a2f_500kSobol25q_01_wSOC');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
a2F = cell2mat(data);
fclose(SpecfunID);
plot(a2F(:,1),a2F(:,4),'-','Color',col9,'LineWidth',2);
hold on;


SpecfunID = fopen('xyscan_a2F_Pb_Parks1969.txt');
data = textscan(SpecfunID,'%f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
exp = cell2mat(data);
fclose(SpecfunID);

plot(exp(:,1),exp(:,2),'.', 'markersize',15,'Color','black' );

legend('Without SOC',...
'With SOC',...
'Exp','Location','northwest')

set(legend,'FontSize',10);
legend boxoff
set(gca,'LineWidth',2);
set(gca,'FontSize',size);
set(gca,'ytick',[1,2])
axis([0,10,0,2])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% ----- Random k/q ------

% WITH SO
% 20 meV broadening
% 100000k/ 100000q ==> 1.7003144 [new] or with other rnd 1.8173834 or 1.9291368. I rm the archer file ...  
% 150000k/ 100000q ==> 1.6758591, 1.6961513, 1.7732279

% 50 meV broadening
% 100000k/ 100000q ==> 1.7421141 [new] or with other rnd 1.7637974 or 1.8715478 I rm the archer file ...  
% 150000k/ 100000q ==> 1.702682, 1.7513527, 1.8409175 


% WITHOUT SO
% 300000k/150000q ==> 1.2991006 [new]
% 300000k/200000q ==> 1.1968693 [new]

% 400000k/100000q ==> 1.1224181
% 400000k/150000q ==> 1.1681747
% 400000k/200000q ==> 1.2562289
% 400000k/250000q ==> 1.1814625

% 500000k/ 150000q ==>  1.0993040
% 500000k/ 200000q ==>  1.2109697
% 500000k/ 250000q ==>  1.1265345

% 600000k/ 200000q ==>  1.0928090
% 600000k/ 250000q ==>  1.0753818

% 700000k/ 200000q ==>  1.1156241

% 800000k/ 250000q ==>   [new]

% 900000k/ 200000q ==>  1.1043788 [new]

% 1000000k/ 150000q ==> (1.0732844 + 0.9905621)/2 = 1.03192325


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% SOBOL
% WITH SO
% 20 meV broadening
% 150000k/ 150000q ==> 1.7900403  [new]
% 150000k/ 200000q ==>   [new]

% 50 meV broadening
% 150000k/ 150000q ==>



% WITOUT SO
% 50 meV broadening
% 200000k/ 150000q ==>  1.2693148 [new]
% 200000k/ 200000q ==>  1.2692768 [new]

% 300000k/ 150000q ==>  1.2967606 [new]
% 300000k/ 200000q ==>  1.2951296 [new]

% 400000k/ 150000q ==>  1.2362117 [new]
% 400000k/ 200000q ==>  1.2341535 [new]
% 400000k/ 300000q ==>  1.1058459

% 500000k/ 150000q ==>  1.1579395 [new]
% 500000k/ 200000q ==>  1.1595308 [new]

% 600000k/ 150000q ==>  1.1398742 [new]
% 600000k/ 200000q ==>  1.1368649 [new]

% 700000k/ 150000q ==>  1.2481414 [new]
% 700000k/ 200000q ==>  1.2483856 [new]

% 800000k/ 150000q ==>  1.2311465 [new]
% 800000k/ 200000q ==>  1.2278390 [new]

% 900000k/ 150000q ==>  1.2567131 [new]
% 900000k/ 200000q ==>  1.2584204 [new]

% 1000000k/ 150000q ==>  (1.0300659 + 1.0901429)/2 = 1.0601044  
% 1000000k/ 200000q ==>  (1.0316897 + 1.0934248)/2 = 1.06255725


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%# find current position [x,y,width,height]
pos1 = get(h(1),'Position');
pos2 = get(h(2),'Position');
pos3 = get(h(3),'Position');
pos4 = get(h(4),'Position');


pos2(1) = pos2(1) - 0.08;
pos2(3) = pos2(3) - 0.1;
set(h(2),'Position',pos2);

set(h(1),'XTickLabel','');
pos3(2) = pos1(2) - pos3(4);
set(h(3),'Position',pos3);

set(h(2),'XTickLabel','');
pos4(2) = pos2(2) - pos4(4);
set(h(4),'Position',pos4);

pos4(1) = pos4(1) - 0.08;
pos4(3) = pos4(3) - 0.1;
set(h(4),'Position',pos4);


xlabel(h(3),'\omega (meV)','FontSize',size);
xlabel(h(4),'k-point grid','FontSize',size);
ylabel(h(1),'\alpha^2 F','FontSize',size);
ylabel(h(3),'\alpha^2 F','FontSize',size);



 a = 0.1;
 b = 0.15;
 text(pos1(1)+a,pos1(3)-b,['(',char(1+96),') '],...
     'color','k','fontw','b','Parent', h(1));
 text(pos3(1)+a,pos3(3)-b,['(',char(3+96),') '],...
     'color','k','fontw','b','Parent', h(3));

% 
%   text(10.95,0.16,['(',char(2+96),') '],...
%      'color','k','fontw','b','Parent', h(1));
   text(10.95,0.16,['(',char(2+96),') '],...
     'color','k','fontw','b','Parent', h(1));
   text(10.95,0.16,['(',char(4+96),') '],...
     'color','k','fontw','b','Parent', h(3));



% title(h(1),'Pb a2F wo SOC conv [ph smearing = 0.15 meV and el smearing = 50 meV]')
% set(gcf, 'PaperPositionMode', 'auto');
% print -depsc2 Pb_a2F_conv5.eps
% print('Pb_a2F_conv5','-dpng')
% close;

% h=gcf
% set(h, 'PaperPositionMode', 'auto');
% set(h,'PaperOrientation','landscape');
% set(h,'Position',[100 100 1000 1000]);
% print(h, '-dpdf', 'Pb_a2F_conv7.pdf')

