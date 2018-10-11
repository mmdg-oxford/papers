% Plot a2F

%  figure('Units', 'pixels', ...
%      'Position', [100 100 1300 950]);

SpecfunID = fopen('MgB2.imag_aniso_gap_FS_15.00');
data = textscan(SpecfunID,'%f %f %f %f %f %f\n','CommentStyle','#','CollectOutput',true);
BS = cell2mat(data);
fclose(SpecfunID);

x1=[];
y1=[];
z1=[];
d1=[];
x2=[];
y2=[];
z2=[];
d2=[];

for ii = 1:length(BS(:,1))
    % First band
    if (BS(ii,4)) == 1
        x1 = [x1 BS(ii,1)];
        y1 = [y1 BS(ii,2)];
        z1 = [z1 BS(ii,3)];
        d1 = [d1 BS(ii,6)];
    end
    if BS(ii,4) == 2
        x2 = [x2 BS(ii,1)];
        y2 = [y2 BS(ii,2)];
        z2 = [z2 BS(ii,3)];
        d2 = [d2 BS(ii,6)];
    end
end


data = zeros(60,60,60);

tol = 0.00000000000005;
a = 1;

for ii=1:60
    for jj=1:60
        for kk=1:60
            if (((x1(a) - ii/60) < tol) & ((y1(a) - jj*1.73205/60) < tol) & ((z1(a) - kk*0.87558/60) < tol))
                data(ii,jj,kk) = d1(a);
                a = a+1;
            end
        end
    end
end


% Plot
hold on;
tri = delaunay(x2,z2);
h = trisurf(tri, x2, y2, z2,d2);

% Make it pretty
% view(-45,30);
view(3);
axis vis3d;
lighting phong;
shading interp;

% hold on;







%scatter3(x1,y1,z1,5,d1)




% 
% 
% %rng(9,'twister')
% data = smooth3(data.*5000,'box',9);
% patch(isocaps(data,.5),...
%    'FaceColor','interp','EdgeColor','none');
% p1 = patch(isosurface(data,.5),...
%    'FaceColor','blue','EdgeColor','none');
% isonormals(data,p1)
% view(3); 
% axis vis3d tight
% camlight left; 
% colormap jet
% lighting gouraud
% 
% set(gca,'DataAspectRatio',[1 1.7 0.8],...
%         'PlotBoxAspectRatio',[1 1 1],...
%         'XLim',[0 70],...
%         'YLim',[0 70],...
%         'ZLim',[0 70])

% pbaspect([1 1.73205 0.87558])

% 
% h=gcf
% set(h, 'PaperPositionMode', 'auto');
% set(h,'PaperOrientation','landscape');
% set(h,'Position',[100 100 1200 650]);
% print(h, '-dpdf', 'MgB2_Fermi.pdf')


