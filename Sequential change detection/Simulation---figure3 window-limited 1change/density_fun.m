function out = density_fun(x,mu,sigma)
p = length(x);
const = sqrt((2*pi)^p * det(sigma) );
expo = -1/2 * (x - mu')' * inv(sigma) * (x - mu') ;
out = 1/const * exp(expo);
end
