function ret=Mutation(pmutation,lenchrom,individuals,sizepop,num,maxgen,bound)
% ��������ɱ������
% pcorss                input  : �������
% lenchrom              input  : Ⱦɫ�峤��
% individuals.chrom     input  : Ⱦɫ��
% sizepop               input  : ��Ⱥ��ģ
% opts                  input  : ���췽����ѡ��
% pop                   input  : ��ǰ��Ⱥ�Ľ������������Ľ���������Ϣ
% bound                 input  : ÿ��������Ͻ���½�
% maxgen                input  ������������
% num                   input  : ��ǰ��������
% ret                   output : ������Ⱦɫ��

for i=1:sizepop   %ÿһ��forѭ���У����ܻ����һ�α��������Ⱦɫ�������ѡ��ģ�����λ��Ҳ�����ѡ��ģ�
    %������forѭ�����Ƿ���б���������ɱ�����ʾ�����continue���ƣ�
    % ���ѡ��һ��Ⱦɫ����б���
    pick=rand;
    while pick==0
        pick=rand;
    end
    index=ceil(pick*sizepop);
    % ������ʾ�������ѭ���Ƿ���б���
    pick=rand;
    if pick>pmutation
        continue;
    end
    flag=0;
    while flag==0
        % ����λ��
        pick=rand;
        while pick==0     
            pick=rand;
        end
        pos=ceil(pick*sum(lenchrom));  %���ѡ����Ⱦɫ������λ�ã���ѡ���˵�pos���������б���
        pick=rand; %���쿪ʼ    
        fg=(pick*(1-num/maxgen))^2;
        if pick>0.5
            individuals.chrom(index,pos)=individuals.chrom(index,pos)+(bound(pos,2)-individuals.chrom(index,pos))*fg;
        else
            individuals.chrom(index,pos)=individuals.chrom(index,pos)-(individuals.chrom(index,pos)-bound(pos,1))*fg;
        end   %�������
        flag=test(individuals.chrom(index,:));  %����Ⱦɫ��Ŀ�����
    end
end

ret=individuals.chrom;