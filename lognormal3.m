clc; clear all;

sebou_data = load('sebou_data.txt');
x = sebou_data(:,3); % flows, cms
i = 1:length(x);
n = length(x);

% 3-parameter lognormal
% Quantile lower bound estimator (LB 7.81)
that = (min(x)*max(x) - median(x)^2)/(min(x) + max(x) - 2*median(x));

disp('3-parameter lognormal distribution, Log-space estimates');
mhat = mean(log(x-that));
vhat = mean((log(x-that) - mhat).^2);
disp(['m = ' num2str(mhat) ', s2 = ' num2str(vhat)  ', t = ' num2str(that) ' (s = ' num2str(sqrt(vhat)) ')']);
disp(['1%: ' num2str(logninv(.01,mhat,sqrt(vhat))+that) ', 99%: ' num2str(logninv(.99,mhat,sqrt(vhat))+that) ' m^3/s']);
q = logninv( (i-3/8)/(n+1/4) , mhat,sqrt(vhat))+that;
r = corrcoef(sort(x),q);
disp(['PPCC: ' num2str(r(1,2))]);
disp(' ');

% Real-space estimates (LB 7.82)
disp('3-parameter lognormal distribution, Real-space estimates');
mhat = log((mean(x) - that)/sqrt(1 + var(x)/((mean(x)-that)^2)));
vhat = log(1 + var(x)/((mean(x)-that)^2));
disp(['m = ' num2str(mhat) ', s2 = ' num2str(vhat)  ', t = ' num2str(that) ' (s = ' num2str(sqrt(vhat)) ')']);
disp(['1%: ' num2str(logninv(.01,mhat,sqrt(vhat))+that) ', 99%: ' num2str(logninv(.99,mhat,sqrt(vhat))+that) ' m^3/s']);
q = logninv( (i-3/8)/(n+1/4) , mhat,sqrt(vhat))+that;
r = corrcoef(sort(x),q);
disp(['PPCC: ' num2str(r(1,2))]);
disp(' ');

ub = logninv( (i-1)/n + 0.127, mhat,sqrt(vhat))+that;
lb = logninv( (i)/n - 0.127, mhat,sqrt(vhat))+that;
probplot(q,x,lb,ub,'Lognormal-3','cms');