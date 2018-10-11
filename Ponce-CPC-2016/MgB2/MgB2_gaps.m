% Plot anisotropic superconducting gaps

%  figure('Units', 'pixels', ...
%      'Position', [100 100 1300 950]);

SpecfunID = fopen('MgB2.imag_aniso_gap0_06.00');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap6 = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('MgB2.pade_aniso_gap0_08.00');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap8 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('MgB2.pade_aniso_gap0_10.00');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap10 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('MgB2.pade_aniso_gap0_15.56');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap15 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('MgB2.pade_aniso_gap0_21.11');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap21 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('MgB2.pade_aniso_gap0_26.67');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap26 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('MgB2.pade_aniso_gap0_32.22');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap32 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('MgB2.pade_aniso_gap0_37.78');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap37 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('MgB2.pade_aniso_gap0_43.33');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap43 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('MgB2.pade_aniso_gap0_48.89');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap48 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('MgB2.pade_aniso_gap0_50.00');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap50 = cell2mat(data);
fclose(SpecfunID);


size = 16
cm2mev = 0.12398 ;
Thz2meV = 4.13567;
ry2ev = 13.605698066 ;
meV2ry = (1.0/(ry2ev*1000))


% stretch by 1.5
stretch = 2;
rescale11 = (stretch*6)-6;
rescale10 = (stretch*8)-8;
rescale = (stretch*10)-10;
rescale2 = (stretch*15.56)-15.56;
rescale3 = (stretch*21.11)-21.11;
rescale4 = (stretch*26.67)-26.67;
rescale5 = (stretch*32.22)-32.22;
rescale6 = (stretch*37.78)-37.78;
rescale7 = (stretch*43.33)-43.33;
rescale8 = (stretch*48.89)-48.89;
rescale9 = (stretch*50)-50;

plot(gap6(:,1)*stretch-rescale11,gap6(:,2)*1000,'Color','blue','LineWidth',2);
hold on;
fill(gap6(:,1)*stretch-rescale11,gap6(:,2)*1000,'blue');
hold on;

plot(gap8(:,1)*stretch-rescale10,gap8(:,2)*1000,'Color','blue','LineWidth',2);
hold on;
fill(gap8(:,1)*stretch-rescale10,gap8(:,2)*1000,'blue');
hold on;

plot(gap10(:,1)*stretch-rescale,gap10(:,2)*1000,'Color','blue','LineWidth',2);
hold on;
fill(gap10(:,1)*stretch-rescale,gap10(:,2)*1000,'blue');
hold on;

plot(gap15(:,1)*stretch-rescale2,gap15(:,2)*1000,'Color','blue','LineWidth',2);
hold on;
fill(gap15(:,1)*stretch-rescale2,gap15(:,2)*1000,'blue');
hold on;

plot(gap21(:,1)*stretch-rescale3,gap21(:,2)*1000,'Color','blue','LineWidth',2);
hold on;
fill(gap21(:,1)*stretch-rescale3,gap21(:,2)*1000,'blue');
hold on;

plot(gap26(:,1)*stretch-rescale4,gap26(:,2)*1000,'Color','blue','LineWidth',2);
hold on;
fill(gap26(:,1)*stretch-rescale4,gap26(:,2)*1000,'blue');
hold on;

plot(gap32(:,1)*stretch-rescale5,gap32(:,2)*1000,'Color','blue','LineWidth',2);
hold on;
fill(gap32(:,1)*stretch-rescale5,gap32(:,2)*1000,'blue');
hold on;

plot(gap37(:,1)*stretch-rescale6,gap37(:,2)*1000,'Color','blue','LineWidth',2);
hold on;
fill(gap37(:,1)*stretch-rescale6,gap37(:,2)*1000,'blue');
hold on;

plot(gap43(:,1)*stretch-rescale7,gap43(:,2)*1000,'Color','blue','LineWidth',2);
hold on;
fill(gap43(:,1)*stretch-rescale7,gap43(:,2)*1000,'blue');
hold on;

plot(gap48(:,1)*stretch-rescale8,gap48(:,2)*1000,'Color','blue','LineWidth',2);
hold on;
fill(gap48(:,1)*stretch-rescale8,gap48(:,2)*1000,'blue');
hold on;

plot(gap50(:,1)*stretch-rescale9,gap50(:,2)*1000,'Color','blue','LineWidth',2);
hold on;
fill(gap50(:,1)*stretch-rescale9,gap50(:,2)*1000,'blue');
hold on;

% Extrapolation
x = [6,8   ,10,  15.56, 21.11, 26.67, 32.22,37.78, 43.33, 48.89, 50];
y = [8.67,8.66, 8.65, 8.58,  8.45,   8.1,  7.58, 6.55,   4.9, 2.2, 1.15];

xx = 4:0.1:55;
yy = interp1(x,y,xx,'spline');
plot(xx,yy,'--k','LineWidth',2);

% p = polyfit(x,y,4);
% xx = linspace(10,55,100);
% yy = polyval(p,xx);
% plot(xx,yy,'--k','LineWidth',2);


hold on;
x = [6,8  ,10,  15.56, 21.11, 26.67, 32.22,37.78, 43.33, 48.89, 50];
y = [1.71,1.695,1.67, 1.6, 1.45, 1.32, 1.2, 1.02, 0.77, 0.33, 0.25];

% xx = 10:0.1:55;
% yy = interp1(x,y,xx,'spline');
% plot(xx,yy,'--k','LineWidth',2);

p = polyfit(x,y,4);
xx = linspace(4,55,100);
yy = polyval(p,xx);
plot(xx,yy,'--k','LineWidth',2);


axis([0,55,0,10]) % change axis limit



xlabel('T (K)','FontSize',size);
ylabel('\Delta_{n\bf{k}}(\omega=0) (meV)','FontSize',size);


ax = gca;
set(gca,'FontSize',size, 'LineWidth',3);





h=gcf
set(h, 'PaperPositionMode', 'auto');
set(h,'PaperOrientation','landscape');
set(h,'Position',[100 100 800 400]);
print(h, '-dpdf', 'MgB2_gaps.pdf')


