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

function y = smoothing_fun_a_b(beta,x, a, c, d)

b=beta(1);

y = c./(1+exp(a+b*x))+d;