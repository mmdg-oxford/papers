% Plot a2F vs a2F tr

%  figure('Units', 'pixels', ...
%      'Position', [100 100 1300 950]);

SpecfunID = fopen('pb.a2f_300kSobol50q_woSOC_new');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS1 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('pb.a2f_tr_300kSobol50q_woSOC_new');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS2 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('pb.a2f_300kSobol50q_wSOC_new');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS3 = cell2mat(data);
fclose(SpecfunID);
SpecfunID = fopen('pb.a2f_tr_300kSobol50q_wSOC_new');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS4 = cell2mat(data);
fclose(SpecfunID);




size = 16
cm2mev = 0.12398 ;
Thz2meV = 4.13567;
ry2ev = 13.605698066 ;
meV2ry = (1.0/(ry2ev*1000))



plot(BS1(:,1),BS1(:,2),'Color','blue','LineWidth',2);
hold on;
plot(BS2(:,1),BS2(:,2),'--','Color','blue','LineWidth',2);
hold on;
plot(BS3(:,1),BS3(:,2),'Color','red','LineWidth',2);
hold on;
plot(BS4(:,1),BS4(:,2),'--','Color','red','LineWidth',2);
hold on;


% Integrated lambda

step = (1.0/500)*max(BS1(:,1));

integrated = zeros(500,1);
prog = zeros(500,1);
for ii=2:500
    integrated(ii) =   BS1(ii,2)*step*2*(1.0/(BS1(ii,1)));
    prog(ii) = prog(ii-1) + integrated(ii);
end

total = sum(integrated)

text(95,0.85,'\lambda','FontSize',20)

plot(BS1(:,1),prog(:),'-','Color','blue','LineWidth',1);
hold on;
%%%%%%
step = (1.0/500)*max(BS2(:,1));

integrated = zeros(500,1);
prog = zeros(500,1);
for ii=2:500
    integrated(ii) =   BS2(ii,2)*step*2*(1.0/(BS2(ii,1)));
    prog(ii) = prog(ii-1) + integrated(ii);
end

total = sum(integrated)

text(95,0.85,'\lambda','FontSize',20)

plot(BS2(:,1),prog(:),'--','Color','blue','LineWidth',1);
hold on;
%%%%%%%%%

step = (1.0/501)*max(BS3(:,1));

integrated = zeros(501,1);
prog = zeros(501,1);
for ii=2:501
    integrated(ii) =   BS3(ii,2)*step*2*(1.0/(BS3(ii,1)));
    prog(ii) = prog(ii-1) + integrated(ii);
end

total = sum(integrated)

text(95,0.85,'\lambda','FontSize',20)

plot(BS3(:,1),prog(:),'-','Color','red','LineWidth',1);
hold on;

%%%%%%%%%

step = (1.0/501)*max(BS4(:,1));

integrated = zeros(501,1);
prog = zeros(501,1);
for ii=2:501
    integrated(ii) =   BS4(ii,2)*step*2*(1.0/(BS4(ii,1)));
    prog(ii) = prog(ii-1) + integrated(ii);
end

total = sum(integrated)

text(95,0.85,'\lambda','FontSize',20)

plot(BS4(:,1),prog(:),'--','Color','red','LineWidth',1);
hold on;


text(9.45,1.05,'\lambda_{tr}','FontSize',size);
text(9.45,1.35,'\lambda','FontSize',size);
text(9.45,1.60,'\lambda_{tr}','FontSize',size);
text(9.45,1.86,'\lambda','FontSize',size);


axis([0,10,0,2.7]) % change axis limit



legend('\alpha^2 F without SOC','\alpha_{tr}^2 F without SOC','\alpha^2 F with SOC',...
    '\alpha_{tr}^2 F with SOC','Location','northWest')
legend boxoff


xlabel('\omega (meV)','FontSize',size);
ylabel('\alpha^2 F (\omega)','FontSize',size);


ax = gca;
set(gca,'FontSize',size, 'LineWidth',3);





h=gcf
set(h, 'PaperPositionMode', 'auto');
set(h,'PaperOrientation','landscape');
set(h,'Position',[100 100 800 400]);
print(h, '-dpdf', 'Pb_a2Fvstr.pdf')


