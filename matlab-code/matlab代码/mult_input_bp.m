%% ��ջ�������

clc

clear



%% ѵ������Ԥ��������ȡ����һ��

%���������������

%load data input output

data = importdata('data_BP.xlsx');%data_BP.xlsx
input =  data(:,:);
output = data(:,3);
N=length(output);

output = output';
N=length(output);
%��1��2000���������
%N=167400;
k=rand(1,N);

[m,n]=sort(k);

W=0.8;

%�ҳ�ѵ�����ݺ�Ԥ������

input_train=input(n(1:N*W),:)';

output_train=output(n(1:N*W));

input_test=input(n(N*W+1:N),:)';

output_test=output(n(N*W+1:N));



%ѡ����������������ݹ�һ��

[inputn,inputps]=mapminmax(input_train);

[outputn,outputps]=mapminmax(output_train);



%% BP����ѵ��

% %��ʼ������ṹ

net=newff(inputn,outputn,10);



net.trainParam.epochs=100;

net.trainParam.lr=0.1;

net.trainParam.goal=0.00004;



%����ѵ��

net=train(net,inputn,outputn);



%% BP����Ԥ��

%Ԥ�����ݹ�һ��

inputn_test=mapminmax('apply',input_test,inputps);



%����Ԥ�����

an=sim(net,inputn_test);



%�����������һ��

BPoutput=mapminmax('reverse',an,outputps);


%% �������



figure(1)

plot(BPoutput,':og')

hold on

plot(output_test,'-*');

legend('Ԥ�����','�������')

title('BP����Ԥ�����','fontsize',12)

ylabel('�¶�','fontsize',12)

xlabel('����','fontsize',12)

%Ԥ�����

error=BPoutput-output_test;





figure(2)

plot(error,'-*')

title('ģ��Ԥ�����','fontsize',12)

ylabel('���','fontsize',12)

xlabel('����','fontsize',12)



figure(3)

plot((output_test-BPoutput)./BPoutput,'-*');

title('ģ��Ԥ�����ٷֱ�')



errorsum=sum(abs(error));
