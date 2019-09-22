%Matlab程序读取sst数据： 
clear all
clc

oid='CT2007B.molefrac.nc'

%value of olr, Size:360x181x408    Dimensions: lon,lat,time
co2=double(ncread(oid,'co2'));
% lat
nlat=double(ncread(oid,'lat'));
% lon
nlon=double(ncread(oid,'lon'));

mv=ncreadatt(oid,'/co2','missing_value');
co2(find(co2==mv))=NaN;

% init date, start from 1985-01-01
date_year_init = 2000;
date_mon_init = 1;
date_day_init = 1;   

fid=fopen('co2_data.csv', 'wt');           %打开文件

%tmp_sst = 1985;
for tmp_time=1:29:1796
    %if rem(tmp_time,12) == 1
    %    date_year_init = date_year_init + 1;     
    %end  
    %if rem(tmp_time,12) == 0
    %    date_mon_init = 12; 
    %else
    %    date_mon_init = rem(tmp_time,12);
    %end  
    % 遍历所有lon
    for tmp_lon=1:60
        % 遍历所有lat
        for tmp_lat=1:45
          format long g
          fprintf(fid, '%d, %d, %d, %.2f, %.2f, %.2f \n', date_year_init,...
              date_mon_init,date_day_init, nlon(tmp_lon), nlat(tmp_lat),...
              co2(tmp_lon, tmp_lat, 10, tmp_time));
          %tmp_sst = tmp_sst - 1;
        end
    end 
    if date_mon_init==12
        date_year_init = date_year_init + 1;
        date_mon_init = 1;
    else
        date_mon_init = date_mon_init + 1;
    end  
end

fclose(fid);  %关闭文件！