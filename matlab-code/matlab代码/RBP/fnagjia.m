clc
clear
% 
%% ����ṹ����
%��ȡ����
filename = 'housing.txt';
inputNames = {'CRIM','ZN','INDUS','CHAS','NOX','RM','AGE','DIS','RAD','TAX','PTRATIO','B','LSTAT'};
outputNames = {'MEDV'};
housingAttributes = [inputNames,outputNames];
%%Import Data 
formatSpec = '%8f%7f%8f%3f%8f%8f%7f%8f%4f%7f%7f%7f%7f%f%[^\n\r]'; 
fileID = fopen(filename,'r'); 
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'ReturnOnError', false); 
fclose(fileID); 
housing = table(dataArray{1:end-1}, 'VariableNames', {'VarName1','VarName2','VarName3','VarName4','VarName5','VarName6','VarName7','VarName8','VarName9','VarName10','VarName11','VarName12','VarName13','VarName14'})
%%Read into a Table 
housing.Properties.VariableNames = housingAttributes; 
features = housing{:,inputNames}; 
prices = housing{:,outputNames};
%�ڵ����
inputnum=13; %�����ڵ���
hiddennum=13;%������ڵ���
outputnum=1; %�����ڵ���
%ѵ�����ݺ�Ԥ������
len = length(prices);
index = randperm(len);%����1~len �������
%input_train = features(index(1:round(len*0.8)),:);%ѵ����������
%output_train = prices(index(1:round(len*0.8)),:);%ѵ���������
%input_test = features(index(round(len*0.8)+1:end),:);%������������
%output_test = prices(index(round(len*0.8)+1:end),:);%�����������
input_train=features(index(1:405),:)';
input_test=features(index(406:506),:)';
output_train=prices(index(1:405))';
output_test=prices(index(406:506))';
%ѡ����������������ݹ�һ��
[inputn,inputps]=mapminmax(input_train);
[outputn,outputps]=mapminmax(output_train);
 
%��������
net=newff(inputn,outputn,hiddennum);
 
%% �Ŵ��㷨������ʼ��
maxgen=100;                         %��������������������
sizepop=10;                         %��Ⱥ��ģ
pcross=[0.3];                       %�������ѡ��0��1֮��
pmutation=[0.1];                    %�������ѡ��0��1֮��
 
%�ڵ�����
numsum=inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum;
 
lenchrom=ones(1,numsum);        
bound=[-2*ones(numsum,1) 2*ones(numsum,1)];    %���ݷ�Χ
 
%--------------------------------------��Ⱥ��ʼ��--------------------------------------------------------
individuals=struct('fitness',zeros(1,sizepop), 'chrom',[]);  %����Ⱥ��Ϣ����Ϊһ���ṹ��
avgfitness=[];                      %ÿһ����Ⱥ��ƽ����Ӧ��
bestfitness=[];                     %ÿһ����Ⱥ�������Ӧ��
bestchrom=[];                       %��Ӧ����õ�Ⱦɫ��
%��ʼ����Ⱥ
for i=1:sizepop
    %�������һ����Ⱥ
    individuals.chrom(i,:)=Code(lenchrom,bound);    %���루binary��grey�ı�����Ϊһ��ʵ����float�ı�����Ϊһ��ʵ��������
    %Code�������ڱ��룬lenchrom��Ⱦɫ�峤�ȣ�bound�Ǳ�����ȡֵ��Χ
    x=individuals.chrom(i,:);
    %������Ӧ��
    individuals.fitness(i)=fun(x,inputnum,hiddennum,outputnum,net,inputn,outputn);   %Ⱦɫ�����Ӧ��
    %fun������BP������Ԥ�⣬��¼Ԥ����inputnΪѵ���������ݣ�outputnΪѵ��������ݣ�
end
 
%����õ�Ⱦɫ��
[bestfitness bestindex]=min(individuals.fitness);
bestchrom=individuals.chrom(bestindex,:);  %��õ�Ⱦɫ��
avgfitness=sum(individuals.fitness)/sizepop; %Ⱦɫ���ƽ����Ӧ��
% ��¼ÿһ����������õ���Ӧ�Ⱥ�ƽ����Ӧ��
trace=[avgfitness bestfitness]; 
 
%% ���������ѳ�ʼ��ֵ��Ȩֵ
% ������ʼ
for i=1:maxgen
    disp(['�Ŵ�������',num2str(i),'��'])
    % ѡ��
    individuals=Select(individuals,sizepop); 
    avgfitness=sum(individuals.fitness)/sizepop;
    %����
    individuals.chrom=Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
    % ����
    individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,i,maxgen,bound);
    
    % ������Ӧ�� 
    for j=1:sizepop
        x=individuals.chrom(j,:); %����
        individuals.fitness(j)=fun(x,inputnum,hiddennum,outputnum,net,inputn,outputn);   
    end
    
  %�ҵ���С�������Ӧ�ȵ�Ⱦɫ�弰��������Ⱥ�е�λ��
    [newbestfitness,newbestindex]=min(individuals.fitness);
    [worestfitness,worestindex]=max(individuals.fitness);
    % ������һ�ν�������õ�Ⱦɫ��
    if bestfitness>newbestfitness
        bestfitness=newbestfitness;
        bestchrom=individuals.chrom(newbestindex,:);
    end
    individuals.chrom(worestindex,:)=bestchrom;
    individuals.fitness(worestindex)=bestfitness;
    
    avgfitness=sum(individuals.fitness)/sizepop;
    
    trace=[trace;avgfitness bestfitness]; %��¼ÿһ����������õ���Ӧ�Ⱥ�ƽ����Ӧ��
 
end
%% �Ŵ��㷨������� 
 figure(1)
[r c]=size(trace);
plot([1:r]',trace(:,2),'b--');
title(['��Ӧ������  ' '��ֹ������' num2str(maxgen)]);
legend({'ƽ����Ӧ��','�����Ӧ��'});
xlabel('��������');
ylabel('��Ӧ��');
x=bestchrom;
%% �����ų�ʼ��ֵȨֵ��������Ԥ��
% %���Ŵ��㷨�Ż���BP�������ֵԤ��
w1=x(1:inputnum*hiddennum);
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);
w2=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);
B2=x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);
net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);
net.b{1}=reshape(B1,hiddennum,1);
net.b{2}=B2;
%% BP����ѵ��
%�����������
net.trainParam.epochs=20000;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00001;
%����ѵ��
[net,per2]=train(net,inputn,outputn);
%% BP����Ԥ��
%���ݹ�һ��
inputn_test=mapminmax('apply',input_test,inputps);
an=sim(net,inputn_test);
test_simu=mapminmax('reverse',an,outputps);
error=test_simu-output_test;
disp(['ƽ�����=',num2str(mean(error)) '     �������=',num2str(std(error))])
figure(2);
plot(output_test);
hold on;
plot(test_simu,'r');
xlim([1 length(output_test)]);
hold off;
legend({'Actual','Predicted'})
xlabel('Test Data point');
ylabel('Median house price');
