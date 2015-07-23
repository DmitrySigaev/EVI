function y = int_of_smooth_fun(beta,t)

% is indefinite integral of smooth function

a=beta(1);
b=beta(2);
c=beta(3);
d=beta(4);

y = t.*(c + d) - (c.*log(exp(a+b.*t) + 1))./b;