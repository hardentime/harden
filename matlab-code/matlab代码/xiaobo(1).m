clc;
clear;
% 1981 - 2019
sst = ncread('sst.mnmean.nc','sst');
lat = ncread('sst.mnmean.nc','lat');
lon = ncread('sst.mnmean.nc','lon');
figure;
% negara = gshhs('gshhs_l.b',[-90 90], [-180 180]);
% geoshow(negara);
hold on;
ave = [];
ave1 = [];
ave2 = [];
mytemp = zeros(360,180);
for i = 1:445
    % 0: 11; 1: 12; 2: 1 ... 11:10; 
      temp = sst(:,:,i);
    index1 = find(lat<0);
    index2 = find(lat>=0);
    ave = [ave mean(mean(temp))];
    ave1 = [ave1 mean(mean(temp(:,index1,:)))];
    ave2 = [ave2 mean(mean(temp(:,index2,:)))];
end

%% anual mean
for i = 1:37
    anu_av(i) = mean(ave((i-1)*12+1:i*12));
    anu_av1(i) = mean(ave1((i-1)*12+1:i*12));
    anu_av2(i) = mean(ave2((i-1)*12+1:i*12));

end
year = 1982:2018;
figure;
hold on;
plot(year,anu_av,'-r','linewidth',2);
plot(year,anu_av1,'-b','linewidth',2);
plot(year,anu_av2,'-k','linewidth',2);
box on;
%%
figure(1)
w=cwt(ave,[1:1:453],'morl');%?????marr????????morl morse amor bump
coefs=cwt(ave,[1:1:453],'mexh');
contourf(w);
figure;
contourf(coefs);

 


