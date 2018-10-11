% Plot anisotropic tunelling DOS

%  figure('Units', 'pixels', ...
%      'Position', [100 100 1300 950]);

SpecfunID = fopen('MgB2.qdos_10.00');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap10 = cell2mat(data);
fclose(SpecfunID);


SpecfunID = fopen('MgB2.qdos_37.78');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap37 = cell2mat(data);
fclose(SpecfunID);

SpecfunID = fopen('MgB2.qdos_43.33');
data = textscan(SpecfunID,'%f %f \n','CommentStyle','#','CollectOutput',true);
gap43 = cell2mat(data);
fclose(SpecfunID);



size = 16;
cm2mev = 0.12398 ;
Thz2meV = 4.13567;
ry2ev = 13.605698066 ;
meV2ry = (1.0/(ry2ev*1000));

% I multiply by the high freq limit so that it is one
factor = 1.0/0.3485

plot(gap10(:,1)*1000,gap10(:,2)*factor,'Color','blue','LineWidth',2);
hold on;


plot(gap37(:,1)*1000,gap37(:,2)*factor,'--','Color','green','LineWidth',2);
hold on;

plot(gap43(:,1)*1000,gap43(:,2)*factor,':','Color','red','LineWidth',2);
hold on;

drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} )  
x1 = [0 2.2];
y1 = [0.7 0.7];
drawArrow(x1,y1,'MaxHeadSize',0.35,'Color','k','LineWidth',3); hold on;

text(0.1,0.85,'\Delta_\pi = 2.5 meV','FontSize',size-2)

x1 = [0 9.1];
y1 = [1.5 1.5];
drawArrow(x1,y1,'-','MaxHeadSize',0.08,'linewidth',3,'color','k');

text(4.5,1.65,'\Delta_\sigma = 9 meV','FontSize',size-2)



hold on;
plot(NaN,'b.','markersize', 30);
plot(NaN,'g.','markersize', 30);
plot(NaN,'r.','markersize', 30);
legend('10K','38K','43K','Location','northwest');



% Now plot the normal DOS
fermi = 7.4273; % eV
SpecfunID = fopen('MgB2.dos');
data = textscan(SpecfunID,'%f %f %f\n','CommentStyle','#','CollectOutput',true);
dos = cell2mat(data);
fclose(SpecfunID);

% We scale the DOS to be 1
factor = 1.426

plot((dos(:,1)-fermi)*1000,dos(:,2)*factor,'--','Color','black','LineWidth',2);
hold on;


axis([0,10,0,2]) % change axis limit


xlabel('\omega (meV)','FontSize',size);
ylabel('$N_s(\omega)/N(\varepsilon_F$)','Interpreter','latex','FontSize',size);


ax = gca;
set(gca,'FontSize',size, 'LineWidth',3);


h=gcf
set(h, 'PaperPositionMode', 'auto');
set(h,'PaperOrientation','landscape');
set(h,'Position',[100 100 800 400]);
print(h, '-dpdf', 'MgB2_tunnel.pdf')


