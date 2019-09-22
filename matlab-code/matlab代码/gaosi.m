clear all;
close all;
clc;

k=15;           %����ϵ��,����ƽ��
lambda=0.15;    %����ƽ��
N=20;           %��������
img=double(imread('1.jpg'));
imshow(img,[]);
[m n]=size(img);

imgn=zeros(m,n);
for i=1:N

    for p=2:m-1
        for q=2:n-1
            %��ǰ���ص�ɢ�ȣ����ĸ�����ֱ���ƫ�����ֲ���ͬ�����ϵı仯����
            %����仯�϶࣬��֤���Ǳ߽磬�뷽�������߽�
            NI=img(p-1,q)-img(p,q);
            SI=img(p+1,q)-img(p,q);
            EI=img(p,q-1)-img(p,q);
            WI=img(p,q+1)-img(p,q);
            
            %�ĸ������ϵĵ���ϵ�����÷���仯Խ����õ�ֵԽС���Ӷ��ﵽ�����߽��Ŀ��
            cN=exp(-NI^2/(k*k));
            cS=exp(-SI^2/(k*k));
            cE=exp(-EI^2/(k*k));
            cW=exp(-WI^2/(k*k));
            
            imgn(p,q)=img(p,q)+lambda*(cN*NI+cS*SI+cE*EI+cW*WI);  %��ɢ�����ֵ      
        end
    end
    
    img=imgn;       %����ͼ����ɢ��ϣ�������ɢͼ���������ɢ��
end

figure;
imshow(imgn,[]);