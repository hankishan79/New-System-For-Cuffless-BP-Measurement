% Created by Haydar Ankishan 27022023
% ankishan@ ankara.edu.tr
clear all;
close all;
clc;
addpath('..\paper data and code\clean data');
nofiles={
      '20211130_161620967_a_1'   1;    %1
      '20211130_161620967_a_2'   1;     %1
      '20211202_141854774_a_1'   1;     %2
      '20211202_141854774_a_2'   1;     %2  
      '20211206_123830439_a_1'   1;     %3
      '20211206_123830439_a_2'   1;      %3
      '20211213_113027727_a_2'   1;     %4
      '20211213_113948492_a_1'   1;      %5
      '20211213_113948492_a_2'   1;     %5
       '20211213_114718751_a_2'   1;     %6
      '20211213_120305089_a_1'   1;     %7
      '20211213_120305089_a_2'   1;     %7
      '20211213_120942187_a_1'   1;     %8
      '20211213_120942187_a_2'   1;      %8
      '20211213_122648336_a_1'   1;     %9
      '20211213_122648336_a_2'   1;     %9
      '20211213_122648336_a_3'   1;     %9
      '20211213_123410736_a_1'   1;      %10
      '20211213_123410736_a_2'   1;        %10
      '20211213_123410736_a_3'   1;      %10
      '20211213_124013240_a_1'   1;     %11
      '20211213_124013240_a_2'   1;      %11
      '20211213_124904829_a_1'   1;     %12
      '20211213_124904829_a_2'   1;      %12
      '20211213_124904829_a_3'   1;     %12
      '20211213_130324043_a_1'   1;      %13
      '20211213_130324043_a_2'   1;     %13
      '20211213_131100617_a_1'   1;       %14
      '20211213_131100617_a_2' 1;       %14
      '20211213_131838037_a_1' 1;       %15
      '20211213_131838037_a_2'  1;      %15
      '20211213_131838037_a_3'  1;      %15
      '20211213_132554149_a_1'  1;      %16
      '20211213_132554149_a_2'  1;      %16
      '20211213_133148702_a_1'  1;      %17
      '20211213_133148702_a_2'  1;      %17
      '20211213_133148702_a_3'  1;      %17
      '20211213_133720253_a_2'  1;      %18
      '20211213_133720253_a_3'  1;      %18
      'e20211206_133858303_a_1'  1;     %19
      'e20211206_133858303_a_2'  1;     %19
      'e20211213_113027727_a_1'   1;    %20
      'e20211213_114718751_a_1'   1;    %21
      'e20211213_115602542_a_1'   1;    %22
      'e20211213_115602542_a_2'   1;      %22
      'e20211213_121925813_a_1'   1;    
      'e20211213_121925813_a_2'   1;      
      'e20211213_121925813_a_3'   1;
      'e20211213_125624641_a_1'   1;      
      'e20211213_125624641_a_2'   1;
      'e20211213_133720253_a_1'   1;            
    };
   
z=[];
t=[];
d=[];
x=[];
y=[];
m=[];
aa=[];
u=200;
count=0;
p=0;
fp=fopen('extracted_features.txt','wt');   % Create .txt file
for i=1:size(nofiles,1),  
    for j=1:cell2mat(nofiles(i,2)),
        tic
%       [s,fs]=audioread(['F:\Haydar_Flash_Disk_25_Aralik_2014\flash\scii\databases\S_H_B_Database\a Sounds 21112021\' char(nofiles(i,1)) '.WAV']); 
        data=load(['' char(nofiles(i,1)) '.mat']);
        i
        s=data.a_1;             % audio
        g=data.ecg1_a_1;        % ecg1
        g2=data.ecg2_a_1;       % ecg2
        gf=data.ir_a_1;         % raw_ir
        gf2=data.irFiltred_a_1; % ir_filtered
%% NORMALIZATION
        maks=max(abs(s));
        s=s/maks;
        L=length(s);
%% FEATURE EXTRACTION
        fs=48000;
        for k=3:48000:L-48000,  %% 200 ms segments have 9600 samples
            %%%islem yap
            %% audioIn          
            audioIn=s(1+k:48000+k,1);
            g_ecg1=g(1,1+p:33+p);
            g_ecg2=g2(1,1+p:33+p);
            g_raw_ir=gf(1,1+p:33+p);
            g_filt_ir=gf2(1,1+p:33+p);
  %% find peaks and estimate PTT **********************************    
%     ecg1_N = g_ecg2./max(g_ecg2); %normalization (VVVimp)
%     ecg1_N=gradient(ecg1_N);
%     Ir_N = g_filt_ir./max(g_filt_ir); %normalization (VVVimp)
%% normalization **********************************************************
  maks_ecg=max(g_ecg1);
     maks_ir=max(g_filt_ir);
%     Ir_N = g_filt_ir./max(g_filt_ir); %normalization (VVVimp)    
        minn=min(g_ecg1);
        if(minn>0)           
            ort=(maks_ecg+minn)/2;
            g_ecg1=g_ecg1-ort;            
        end
%         maks=max(abs(s));
     ecg1_N = g_ecg1./max(g_ecg1); %normalization (VVVimp)  
     
     minn=min(g_filt_ir);
        if(minn>0)           
            ort=(maks_ir+minn)/2;
            g_filt_ir=g_filt_ir-ort;            
        end
%         maks=max(abs(s));
    Ir_N = g_filt_ir./max(g_filt_ir); %normalization (VVVimp)  
%     ecg1_N=bandpass(ecg1_N,[5 1000],33);
%%*************************************************************************    
    t=1:size(ecg1_N,2);
    
   [~,locs_Rwave] = findpeaks(ecg1_N,'MinPeakHeight',0.25,...
                                    'MinPeakDistance',12);

   smoothIR= sgolayfilt(Ir_N,5,15);                                                                      
   [~,locs_IRwave] = findpeaks(smoothIR,'MinPeakHeight',0.33,...
                                    'MinPeakDistance',12);                             
   xxx=1:size(locs_IRwave,2);
   ptt=1:size(locs_IRwave,2);

            [entr,coeffs,delta,deltaDelta,loc]=features(audioIn,fs); 
            
            ftrs=[entr g_ecg1 g_ecg2 g_raw_ir g_filt_ir];
            fprintf(fp,'%s',[char(nofiles(i,1)) '_' num2str(j)]);
            fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[ftrs(1:40)]);
            fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[ftrs(41:80)]);
            fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[ftrs(81:120)]);
            fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[ftrs(121:160)]);
            fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[ftrs(161:181)]);
%         fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[entr(201:240)]);
%         fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[entr(241:280)]);
%         fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[entr(281:317)]);
%         fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[entr(321:360)]);
%         fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[entr(361:400)]);
%         fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[entr(401:440)]);
%         fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[entr(441:480)]);
%         fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[entr(481:520)]);
%         fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[entr(521:560)]);
%         fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[entr(561:600)]);
%         fprintf(fp,'\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f',[entr(601:618)]);
        fprintf(fp,'\n');
        p=p+33;
        end        
        clear g gf g2 gf2 data ftrs coeffs delta deltaDelta loc;
        toc
        p=0;
    end        
end
 fclose(fp);