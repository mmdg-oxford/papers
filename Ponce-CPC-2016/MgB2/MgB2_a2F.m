% Plot electronic bandstructure

%  figure('Units', 'pixels', ...
%      'Position', [100 100 1300 950]);

SpecfunID = fopen('MgB2.a2f');
data = textscan(SpecfunID,'%f %f %f %f %f %f %f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS = cell2mat(data);
fclose(SpecfunID);


size = 16
cm2mev = 0.12398 ;
Thz2meV = 4.13567;
ry2ev = 13.605698066 ;
meV2ry = (1.0/(ry2ev*1000))



plot(BS(:,1),BS(:,5),'Color','blue','LineWidth',2);
hold on;


% Integrated lambda

step = (1.0/500)*max(BS(:,1));

integrated = zeros(500,1);
prog = zeros(500,1);
for ii=2:500
    integrated(ii) =   BS(ii,5)*step*2*(1.0/(BS(ii,1)));
    prog(ii) = prog(ii-1) + integrated(ii);
end

total = sum(integrated)

text(95,0.85,'\lambda','FontSize',20)

plot(BS(:,1),prog(:),'--','Color','black','LineWidth',2);
hold on;



axis([0,100,0,1.5]) % change axis limit



xlabel('\omega (meV)','FontSize',size);
ylabel('\alpha^2 F (\omega)','FontSize',size);


ax = gca;
set(gca,'FontSize',size, 'LineWidth',3);





h=gcf
set(h, 'PaperPositionMode', 'auto');
set(h,'PaperOrientation','landscape');
set(h,'Position',[100 100 800 400]);
print(h, '-dpdf', 'MgB2_a2F.pdf')


