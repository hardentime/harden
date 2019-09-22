%Matlab程序读取olr数据(散热)： 
clear all
clc

oid='air.mon.anom.error.nc'

%value of olr, Size:360x181x408    Dimensions: lon,lat,time
air=double(ncread(oid,'air'));
% lat
nlat=double(ncread(oid,'lat'));
% lon
nlon=double(ncread(oid,'lon'));

mv=ncreadatt(oid,'/air','missing_value');
air(find(air==mv))=NaN;

% init date, start from 1980-01-01
date_year_init = 1999;
date_mon_init = 1;
date_day_init = 1;   

fid=fopen('anomaly_temp_error_data.csv', 'wt');           %打开文件

%tmp_olr = 1;
for tmp_time=1801:1860
    if rem(tmp_time,12) == 1
        date_year_init = date_year_init + 1;     
    end  
    if rem(tmp_time,12) == 0
        date_mon_init = 12; 
    else
        date_mon_init = rem(tmp_time,12);
    end  
    % 遍历所有lon
    for tmp_lon=1:72
        % 遍历所有lat
        for tmp_lat=1:36
          format long g
          fprintf(fid, '%d, %d, %d, %.2f, %.2f, %.2f \n', date_year_init,...
              date_mon_init,date_day_init, nlon(tmp_lon), nlat(tmp_lat),...
              air(tmp_lon, tmp_lat, tmp_time));
          %tmp_olr = tmp_olr + 1;
        end
    end   
end