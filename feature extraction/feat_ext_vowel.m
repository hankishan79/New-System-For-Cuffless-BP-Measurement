% created by Haydar Ankishan
% ankishan@ankara.edu.tr
% hayank19@gmail.com
clear all;
close all;
clc;
addpath('..\MED_Monitor_DTB/Raw_Voices/'); % if any problem, change paths
addpath('..\MED_Monitor_DTB/Raw_Txt/'); 
addpath('..\first test/');
%% wav file load
[s,fs]=audioread(['VID_20230217_133905393.WAV']); 

%% physiological signal load

fid = fopen('RAW_20230217_133905393.txt');  %open file in binary mode
bytes = fread(fid, [1 Inf], 'uint8');        %read the whole lot as bytes
fclose(fid);

spo2=[]; ir_filtered=[];ir_raw=[];red_raw=[]; ecg_2=[]; ecg_1=[];ecg_3=[]; bpm=[]; axx=[];axy=[];axz=[];
% bytes=bytes(1200001:end);
for i=1:27:length(bytes)-27,   %#ok<NOCOL>
    if(bytes(i+1)==50 && bytes(i+2)==36)
        spo2=[spo2 bytes(i+13)];  %#ok<AGROW>
        ecg_1=[ecg_1 256.0 *bytes(3 + i)+ 1.0 *bytes(i + 4)]; %#ok<AGROW>
        ecg_2=[ecg_2 256.0 *bytes(5 + i)+ 1.0 *bytes(i + 6)]; %#ok<AGROW>
        ecg_3=[ecg_3 256.0 *bytes(7 + i)+ 1.0 *bytes(i + 8)]; %#ok<AGROW>
        ir_filtered=[ir_filtered 256.0 *bytes(9 + i)+ 1.0 *bytes(i + 10)];
%     ir_filtered=[ir_filtered bitor(bitshift(bytes(7 + i), -8), bytes(i + 8))];
        ir_raw=[ir_raw 65536.0* bytes(14 + i) + 256.0 * bytes(15 + i) + 1.0 * bytes(16 + i)];
        red_raw=[red_raw 65536.0*bytes(17 + i) + 256.0 *bytes(18 + i) + 1.0 *bytes(i + 19)];
%     ir_raw=[ir_raw bitor(bitshift(bytes(12 + i), -16), bitor(bitshift(bytes(13 + i), -8), bytes(i + 14)))];
%     red_raw=[red_raw bitor(bitshift(bytes(15 + i), -16), bitor(bitshift(bytes(16 + i), -8), bytes(i + 17)))];
        bpm=[bpm 256.0 *bytes(i+11)+ 1.0 *bytes(i + 12)];
        axx=[axx 256.0 *bytes(i+20)+ 1.0 *bytes(i + 21)];
        axy=[axy 256.0 *bytes(i+22)+ 1.0 *bytes(i + 23)];
        axz=[axz 256.0 *bytes(i+24)+ 1.0 *bytes(i + 25)];
    end
end

TotalTime = length(s)./fs;
t = 0:TotalTime/(length(s)):TotalTime-TotalTime/length(s); %#ok<BDSCI>
tt=length(ir_raw)./33;
t1=0:tt/(length(ir_raw)):tt-tt/length(ir_raw); %#ok<BDSCI>
% t1=(0:length(ir_raw)-1)/67;

figure;
subplot 311; plot(t,s); axis tight
subplot 312; plot(t1,ir_filtered); axis tight
subplot 313; plot(t1,ecg_1); axis tight
indx_wav=(ceil(48000*107.1):ceil(48000*109));
indx_phy=(ceil(33*107.1):ceil(33*109));
a_1=s(indx_wav,1);
red_a_1=red_raw(1,indx_phy);
ir_a_1=ir_raw(1,indx_phy);
ecg1_a_1=ecg_1(1,indx_phy);
ecg2_a_1=ecg_2(1,indx_phy);
ecg3_a_1=ecg_3(1,indx_phy);
irFiltred_a_1=ir_filtered(1,indx_phy);
ax_a_1=axx(1,indx_phy);
ay_a_1=axy(1,indx_phy);
az_a_1=axz(1,indx_phy);

figure;
subplot 711; plot(a_1); axis tight
subplot 712; plot(red_a_1); axis tight
subplot 713; plot(ir_a_1); axis tight
subplot 714; plot(ecg1_a_1); axis tight
subplot 715; plot(ecg2_a_1); axis tight
subplot 716; plot(ecg3_a_1); axis tight
subplot 717; plot(irFiltred_a_1); axis tight
