function y = k_fun(beta,x)

a=beta(1);
b=beta(2);
c=beta(3);
%d=beta(4);

z = exp(a+b*x);                             %part of denominator
 r1=3.*z.*(1-z).*(1+z).^3.*(2.*(1+z).^3+b.^2.*c.^2.*z)./((1+z).^4+(b.*c.*z).^2).^(5/2);
 r2=(1+z).^2.*(1+2.*z-5.*z.^2)./((1+z).^4+(b.*c.*z).^2).^(3/2);
y =b.^3.*c.*z.*(r1-r2); 			%rate of change in curvature to id transition dates
