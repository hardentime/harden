function flag=test(chrom)
%�˺��������ж�individuals.chrom����ֵ�Ƿ񳬹��߽�bound
%bound��main�ﶨ��Ϊ��-3:3��
%flag       output     Ⱦɫ����У�δ���磩outputΪ1 ��������Ϊ0
f1=isempty(find(chrom>3));
f2=isempty(find(chrom<-3));
if f1*f2==0
    flag=0;
else
    flag=1;
end