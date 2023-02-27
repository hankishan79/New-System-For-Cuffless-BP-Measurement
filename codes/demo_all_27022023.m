% Created by Haydar Ankishan 27/02/2023
% ankishan@ankara.edu.tr
clear all;
close all;
clc;
sonuc=[];
addpath('..\matlab_data/'); 

s_sbp=[]
mae_sbp=[]
d_dbp=[]
mae_dbp=[]

SBP_P=[];
SBP_O=[];
DBP_P=[];
DBP_O=[];

m_dbp=[];
m_sbp=[];

m_sstd=[];
m_dstd=[];

for k=1:22,
f=load ('new_mm_1_min.txt');
fy=f;
rng('shuffle') % For reproducibility
rng('shuffle') % For reproducibility

grp1=[];
cnt1=[];
grp2=[];
cnt2=[];

egitim=[1:22]';
egitim(k)=[];

% test data group
test=[k];

egit=[];
tst=[];
idx_train=[];
idx_test=[];
for i=1:length(egitim),
    for j=1:length(f(:,1)),
        if(f(j,1)==egitim(i))
        egit=[egit;f(j,1) f(j,2:3) f(j,5:6) f(j,11) f(j,7) f(j,9) f(j,12) f(j,19) f(j,4) f(j,13) f(j,17)];
        idx_train=[idx_train;j];
        end
    end
end
for i=1:length(test),
    for j=1:length(f(:,1)),
        if(f(j,1)==test(i))
        tst=[tst;f(j,1) f(j,2:3) f(j,5:6) f(j,11) f(j,7) f(j,9) f(j,12) f(j,19) f(j,4) f(j,13) f(j,17)];
        idx_test=[idx_test;j];
        end
    end
end

% xdata=1:(size(f,1));
xdata=[egit(:,4:end)];
ydata=egit(:,2)';
f=xdata;
options = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt');
lb = [];
ub = [];
% ydata=x(1)exp(x(2)xdata)
% a0+sqrt(a1+a2*(1/ptt(1)^2))+(100*BPM+1000*sum(mean(f(i,12)+f(i,17))))/100
fun = @(x,xdata)x(1)*f(:,1)'+x(2)*f(:,2)'+x(3)*(1/f(:,3).^2)...
    +x(4)*f(:,4)'+x(5)*f(:,5)'+x(6)*f(:,6)'+x(7)*f(:,7)'+...
    x(8)*f(:,8)'+x(9)*f(:,9)'+x(10)*f(:,10)';
% fun = @(x,xdata)(x(1)*(1/f(:,11).^2)+x(2)*f(:,5)'+x(3)*f(:,6)'+x(4)*f(:,7)'+ x(5)*f(:,4)'+x(6)*f(:,9)');
x0=[3 70 1 5 1 1 1 1 1 1];
xsbp = lsqcurvefit(fun,x0,xdata,ydata,lb,ub,options);

SBP=zeros(size(tst(:,1)));
DBP=zeros(size(tst(:,1)));
a1=1;
a2=1;
for i=1:size(tst(:,1)),

SBP(i)=xsbp(1)*tst(i,4)'+xsbp(2)*tst(i,5)'+xsbp(3)*(1/tst(i,6).^2)...
    +xsbp(4)*tst(i,7)'+xsbp(5)*tst(i,8)'+xsbp(6)*tst(i,9)'+xsbp(7)*tst(i,10)'+...
    xsbp(8)*tst(i,11)'+xsbp(9)*tst(i,12)'+xsbp(10)*tst(i,13)';
end

SBP_P=[SBP_P;SBP];
SBP_O=[SBP_O;tst(:,2)];
R = corrcoef(SBP,tst(:,2));
s_sbp=[s_sbp;abs(R(2))];
mae_sbp=[mae_sbp;calMAE(tst(:,2),SBP)];
m_sbp=[m_sbp;mean(SBP)];
m_sstd=[m_sstd;std(SBP)];

end

for k=1:22,

f=load ('new_mm_1_min.txt');
fy=f;
rng('shuffle') % For reproducibility
rng('shuffle') % For reproducibility

grp1=[];
cnt1=[];
grp2=[];
cnt2=[];

egitim=[1:22]';
egitim(k)=[];

% test data group
test=[k];

egit=[];
tst=[];
idx_train=[];
idx_test=[];
for i=1:length(egitim),
    for j=1:length(f(:,1)),
        if(f(j,1)==egitim(i))
        egit=[egit;f(j,1) f(j,2:3) f(j,5:6) f(j,11) f(j,7) f(j,9) f(j,12) f(j,19) f(j,4) f(j,13) f(j,17)];
        idx_train=[idx_train;j];
        end
    end
end
for i=1:length(test),
    for j=1:length(f(:,1)),
        if(f(j,1)==test(i))
        tst=[tst;f(j,1) f(j,2:3) f(j,5:6) f(j,11) f(j,7) f(j,9) f(j,12) f(j,19) f(j,4) f(j,13) f(j,17)];
        idx_test=[idx_test;j];
        end
    end
end

% xdata=1:(size(f,1));
xdata=[egit(:,4:end)];
ydata=egit(:,3)';
f=xdata;
options = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt');
lb = [];
ub = [];
% ydata=x(1)exp(x(2)xdata)
% a0+sqrt(a1+a2*(1/ptt(1)^2))+(100*BPM+1000*sum(mean(f(i,12)+f(i,17))))/100
fun = @(x,xdata)x(1)*f(:,1)'+x(2)*f(:,2)'+x(3)*(1/f(:,3).^2)...
    +x(4)*f(:,4)'+x(5)*f(:,5)'+x(6)*f(:,6)'+x(7)*f(:,7)'+...
    x(8)*f(:,8)'+x(9)*f(:,9)'+x(10)*f(:,10)';
% fun = @(x,xdata)(x(1)*(1/f(:,11).^2)+x(2)*f(:,5)'+x(3)*f(:,6)'+x(4)*f(:,7)'+ x(5)*f(:,4)'+x(6)*f(:,9)');
x0=[3 70 1 5 1 1 1 1 1 1];
xsbp = lsqcurvefit(fun,x0,xdata,ydata,lb,ub,options);

SBP=zeros(size(tst(:,1)));
DBP=zeros(size(tst(:,1)));
a1=1;
a2=1;
for i=1:size(tst(:,1)),
DBP(i)=xsbp(1)*tst(i,4)'+xsbp(2)*tst(i,5)'+xsbp(3)*(1/tst(i,6).^2)...
    +xsbp(4)*tst(i,7)'+xsbp(5)*tst(i,8)'+xsbp(6)*tst(i,9)'+xsbp(7)*tst(i,10)'+...
    xsbp(8)*tst(i,11)'+xsbp(9)*tst(i,12)'+xsbp(10)*tst(i,13)';
end

DBP_P=[DBP_P;DBP];
DBP_O=[DBP_O;tst(:,3)];
R = corrcoef(DBP,tst(:,3));
d_dbp=[d_dbp;abs(R(2))];
mae_dbp=[mae_dbp;calMAE(tst(:,3),DBP)];
m_dbp=[m_dbp;mean(DBP)];
m_dstd=[m_dstd;std(DBP)];
end

mean(s_sbp)
mean(mae_sbp)
mean(d_dbp)
mean(mae_dbp)

% territories = {'LAD','LCx','RCA'};
% nterritories = length(territories);
% % % Patient states during measurement
% states = {'Omron M3','ALG'};
% tit = 'SBP'; % figure title
% gnames = {territories, states}; % names of groups in data {dimension 1 and 2}
% label = {'Estimate','Target','mmHg'}; % Names of data sets
% corrinfo = {'n','SSE','r2','eq'}; % stats to display of correlation scatter plot
% BAinfo = {'RPC(%)','ks'}; % stats to display on Bland-ALtman plot
% limits = 'auto'; % how to set the axes limits
% if 1 % colors for the data sets may be set as:
% 	colors = 'br';      % character codes
% else
% 	colors = [0 0 1;... % or RGB triplets
% 		      1 0 0];
% end
% 
% % Generate figure with symbols
% [crsbp, figsbp, statsStructsbp] = BlandAltman(SBP_P,SBP_O,label,tit,gnames,'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits,'colors',colors, 'showFitCI',' on');
% 
% 
% territories = {'LAD','LCx','RCA'};
% nterritories = length(territories);
% % % Patient states during measurement
% states = {'Omron M3','ALG'};
% tit = 'D'; % figure title
% gnames = {territories, states}; % names of groups in data {dimension 1 and 2}
% label = {'Estimate','Target','mmHg'}; % Names of data sets
% corrinfo = {'n','SSE','r2','eq'}; % stats to display of correlation scatter plot
% BAinfo = {'RPC(%)','ks'}; % stats to display on Bland-ALtman plot
% limits = 'auto'; % how to set the axes limits
% if 1 % colors for the data sets may be set as:
% 	colors = 'br';      % character codes
% else
% 	colors = [0 0 1;... % or RGB triplets
% 		      1 0 0];
% end
% 
% % Generate figure with symbols
% [crsbp, figsbp, statsStructsbp] = BlandAltman(DBP_P,DBP_O,label,tit,gnames,'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits,'colors',colors, 'showFitCI',' on');
