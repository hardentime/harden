%bp.m?

%????

clear

close all

data = importdata('F:\建模\建模文档\全球变暖\数据\数据\第二问数据\1-CO2.xlsx');%CO2.txt

%time = data(:,4);
co2 = data(:,1);
N=length(co2);
%time = rand(1:N);
%%
%pause

% x = time(1:400);
% y = time(1:400);
x = co2';
lag=3;    % ?????
iinput=x;    % x??????????
n=length(iinput);
%?????????
inputs=zeros(lag,n-lag);
for i=1:n-lag
    inputs(:,i)=iinput(i:i+lag-1)';
end
targets=x(lag+1:end);
 
%????
hiddenLayerSize = 10; %????????
net = fitnet(hiddenLayerSize);
 
% ?????????????????????
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
 
%????
[net,tr] = train(net,inputs,targets);
%% ??????????
yn=net(inputs);
errors=targets-yn;
figure, ploterrcorr(errors)                      %???????????20lags?
figure, parcorr(errors)                          %???????
%[h,pValue,stat,cValue]= lbqtest(errors)         %Ljung?Box Q???20lags?
figure,plotresponse(con2seq(targets),con2seq(yn))   %??????????
figure, ploterrhist(errors)                      %?????
figure, plotperform(tr)                          %?????
 
 
%% ?????????????
fn=25;  %?????fn
 
f_in=iinput(n-lag+1:end)';
f_out=zeros(1,fn);  %????
% ?????????????????????
for i=1:fn
    f_out(i)=net(f_in);
    f_in=[f_in(2:end);f_out(i)];
end

fid=fopen('7.txt','wt');
fprintf(fid,'%g\n',f_out);
fclose(fid);
%figure,plot(iinput,'b',2013:2038,[iinput(end),f_out],'r')

