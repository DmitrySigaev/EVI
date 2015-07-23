function y = k_fun(beta,x)

a=beta(1);
b=beta(2);
c=beta(3);
%d=beta(4);

z = exp(a+b.*x);                             
da = b.^2.*c.*z.*(1-z).*((1+z).^3);
% where a is the angle (in radians) of the unit tangent
% vector at time t along a differentiable curve,
ds=(((1+z).^4)+((b.*c.*z).^2)).^(1.5);
% where s is the unit length of the curve.

y =(-1).*da./ds; 			
