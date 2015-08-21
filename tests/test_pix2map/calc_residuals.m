function [out] = calc_residuals(ps_config)
if(~exist('ps_config'))
    load 'ps_config.mat';
end  

roi_i = ps_config.roi_index; % [2, 3, 4,6, 7, 8, 13, 14, 17, 22, 25, 27, 40, 48, 49, 68, 69, 73];
if (iscell(roi_i))
    sc = size(roi_i, 1);
    roi_i = ps_config.roi_index{1,1};
    p = ps_config.pdot(1,1);
else
    sc = 1;
    [tf, loc] = ismember(ps_config.code_roi_selected, ps_config.code_roi_all);
    roi_i = loc;
    p = ps_config.pdot;
end

sDate = ps_config.date; %'S'
nDate = ps_config.ndate; %'S -1'
nDate2 = ps_config.ndate2;
c_s = ps_config.case_signal;% '_bad_signal'
deposition = ps_config.deposition;
MDS_GMSD = ps_config.MDS_GMSD;
TM_GMSD = ps_config.TM_GMSD;


for sc_i = 1:sc
    
if (sc > 1)
    [tf, loc] = ismember(ps_config.code_roi_selected{sc_i,1}, ps_config.code_roi_all);
    roi_i = loc;
    p = ps_config.pdot(sc_i,1);
end

if(nDate2)
    Y = MDS_GMSD(:,nDate) - MDS_GMSD(:,nDate2);
    X = TM_GMSD(:,nDate) - TM_GMSD(:,nDate2);
else
    Y = MDS_GMSD(:,nDate);
    X = TM_GMSD(:,nDate);
end

Z1 = (1:size(MDS_GMSD,1))';
if(deposition)
    r1 =  8.*rand(81,1);
    r2 =  8.*rand(81,1);
    x = X+r1;
    y = Y+r2;
else
    x = X;
    y = Y;
end


for i = loc
 xp = x(i);
 yp = y(i);
 zp = num2str(ps_config.code_roi_all(i), '%03.f');
 Z(i, :) = zp;
end
x = x(loc);
y = y(loc);
Z1 = Z(loc, :);

rgx = [0 max(x)];
rgy = [0 max(y)];
Xi = x;
Yi = y;

out.p1x = x;
out.p1y = y;
out.p1z_text = Z1;


out.ylim = [0 max(max(Xi),max(Yi))*1.1];
out.xlim = [0 max(max(Xi),max(Yi))*1.1];
%% Ordinary Linear Regression 
% http://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
%x1 - G from LN
%y1 - G from MDS

A = [Xi.^0, Xi]; 
[beta,SIGMA,RESID,COVB]  = mvregress(A, Yi); % 1st method

stats_olr = regstats(Yi, Xi); % 2nd method

out.stats_olr = stats_olr;
%fn_structdisp(stats_olr);

[b,bint,r_1,rint,stats] = regress(Yi, A); % 3td method

%% http://en.wikipedia.org/wiki/Linear_regression

A = [Xi.^0, Xi];        % create matrix
                      % x - (m,1)-vector, ó - (m,1)-vector
w = (A'*A)\(A'*Yi);    % solve the normal equations  4-th method

w = pinv(A'*A)*(A'*Yi);% other way or 5-th method
Y = w(1)+w(2)*Xi;     % w equals to b   Y = yfit
   
% SST = ?i to n (Yi - Ymean)2
% The scatter shows a reasonable correlation between fitted and observed responses, and this is confirmed by the R2 statistic:
SST = sum((Yi-mean(Yi)).^2);
ESS = sum((Y-mean(Yi)).^2);
SSR = sum((Yi-Y).^2);
Rsquared = 1 - SSR/SST;
Rsquared2 = ESS/SST;

matrix_olr.sst = SST;
matrix_olr.ess = ESS;
matrix_olr.ssr = SSR;
matrix_olr.r2 = Rsquared;
matrix_olr.r2_2 = Rsquared2;

out.matrix_olr = matrix_olr;

r = Yi-Y;             %returns an n-by-1 vector r of residuals (r_1 - the same)
r0 = r_1 - r;
                      % Matrix expression for the OLS residual sum of squares
SSE = r'*r;           % the OLS residual sum of squares

w1 = polyval([w(2) w(1)], rgx);


out.p2x = rgx;
out.p2y = w1;

OLSm1 = ['m = ' num2str(w(2))];
OLSq1  = ['q = ' num2str(w(1))]; 
OLSrmse1  = ['R^2  = ' num2str(stats_olr.rsquare)];
out.m_olr = w(2);
out.q_olr = w(1);
 

%% RMA (Reduced Major Axis) regression 
% https://www.mathworks.com/matlabcentral/fileexchange/27918-gmregress
%x1 - G from LN
%y1 - G from MDS

[b,bintr,bintjm, stats_rma] = gmregress1(Xi,Yi);
%disp([sDate ': ' ' stats_rma.sse = ' num2str(stats_rma.sse) '; stats_olr.fstat.sse = ' num2str(stats_olr.fstat.sse) ])
%disp([sDate ': ' ' stats_rma.mse = ' num2str(stats_rma.mse) '; stats_olr.mse = ' num2str(stats_olr.mse) ])

f2 = polyval([b(2) b(1)],rgx);

out.p3x = rgx;
out.p3y = f2;

%grid on
RMAm = ['m = ' num2str(b(2))];
RMAq  = ['q = ' num2str(b(1))]; 
RMArmse  = ['R^2  = ' num2str(stats_rma.rsquared)]; 
%QW: How to get RMSE from gmregress?
out.m_rma = b(2);
out.q_rma = b(1);

end
