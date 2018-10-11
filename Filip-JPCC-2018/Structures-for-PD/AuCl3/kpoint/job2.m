a = dlmread('cell_real.txt');

b = 2*pi*a^-1;

normb1 = (b(1,1)^2+b(1,2)^2+b(1,3)^2)^0.5;
normb2 = (b(2,1)^2+b(2,2)^2+b(2,3)^2)^0.5;
normb3 = (b(3,1)^2+b(3,2)^2+b(3,3)^2)^0.5;


% value in Angsrom^-1
deltak0 = 1;

ndelta=15;

fid = fopen("aucl31_kp.txt", "w");

for i=1:ndelta

	deltak = deltak0/i;

nk1 = round(normb1)/deltak;
nk2 = round(normb2)/deltak;
nk3 = round(normb3)/deltak;

fdisp(fid,[nk1,nk2,nk3, 0, 0, 0]);

end

fclose(fid);
