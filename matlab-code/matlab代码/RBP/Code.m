function ret=Code(lenchrom,bound)
%�����������������Ⱦɫ�壬���������ʼ��һ����Ⱥ
% lenchrom   input : Ⱦɫ�峤��
% bound      input : ������ȡֵ��Χ
% ret        output: Ⱦɫ��ı���ֵ
    pick=rand(1,length(lenchrom));

    ret=bound(:,1)'+(bound(:,2)-bound(:,1))'.*pick; %���Բ�ֵ����������ʵ����������ret��