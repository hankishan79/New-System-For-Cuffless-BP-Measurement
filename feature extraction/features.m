function [entr,coeffs,delta,deltaDelta,loc]=features(audioIn,fs)
         t=[];
         x=[];
         y=[];
         u=9;
         s=audioIn;
% normalization*******************
%          maks=max(abs(s));
%          s=s/maks;
        %*****************************
         % max values
         L=length(s(1:(fs/50)));
         maxx=max(s(1:L));
         minn=min(s(1:L)); 
         for k=0:L:(floor(length(s)/4800)-2)*L,  
           maxx2=max(s(L+k+1:2*L+k));
           min2=min(s(L+k+1:2*L+k));
           x=[x exp(-(maxx-maxx2))]; %#ok<AGROW> 
           y=[y exp(-(minn-min2))];%#ok<AGROW>                      
         end

           %MFCC 
%            [mmx,aspc] = melfcc(x*3.3752, fs, 'maxfreq',...
%                             8000, 'numcep', 20, 'nbands', 22, 'fbtype', 'fcmel',...
%                             'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
%            [mmy,aspc] = melfcc(y*3.3752, fs, 'maxfreq',...
%                             8000, 'numcep', 20, 'nbands', 22, 'fbtype', 'fcmel',...
%                             'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);             
%         
        [coeffs,delta,deltaDelta,loc] = mfcc(s,fs);                                               
                        %*************************************************          
        k=boundary(x',y',1);
        t=polyarea(x(k),y(k));%#ok<AGROW>
        [in,on]=inpolygon(x,y,x(k),y(k));
        dist=mahal(y',x')';
        dist2=dist(1:u);
        div=t./numel(x(in));
        g_x=gradient(x(1:u));
        g_y=gradient(y(1:u));
        skew=skewness(g_x);
        kurt=kurtosis(g_y);
        cffs=[mean(coeffs(:,2)) mean(coeffs(:,3)) mean(coeffs(:,4)) mean(coeffs(:,5))...
            mean(coeffs(:,6)) mean(coeffs(:,7)) mean(coeffs(:,8)) mean(coeffs(:,9))...
            mean(coeffs(:,10)) mean(coeffs(:,11)) mean(coeffs(:,12)) mean(coeffs(:,13))];
        entr=[cffs t skew kurt dist2 div entropy(x) entropy(y) max(x) min(x) max(y) min(y) g_x g_y]; 
        