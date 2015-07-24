% Accurate measurements of regional to global scale vegetation
% dynamics (phenology) are required to improve models and understanding of
% inter-annual variability in terrestrial ecosystem carbon exchange and
% climate–biosphere interactions.
% Since the mid-1980s, satellite data have been used to study these processes.
% Here, a some methodology to monitor global vegetation phenology from time 
% series of satellite data is presented.
% The method uses series of piecewise logistic (smoothing_fun) functions,
% which are fit to remotely sensed vegetation index (VI) data, to represent
% intra-annual vegetation dynamics.

% The simplest sigmoid-based method, hereafter called the simple sigmoid,
% has been widely used in the remote sensing community

% In smoothing_fun_a_b represents the modeled value of a vegetation
% index such as EVI, at time t . d defines the dormant season
% baseline value of greenness, c is the amplitude of increase or
% decrease in greenness, a controls the timing of increase or decrease,
% and b controls the rate of increase or decrease. smoothing_fun_a_b uses
% to separately fit to spring and fall data for each site
% year to account for independent green-up and green-down
% dynamics, using the Matlab function nlinfit or lsqnonlin.

function y = smoothing_fun_a_b(beta,x, c, d)

a=beta(1);
b=beta(2);

y = c./(1+exp(a+b*x))+d;