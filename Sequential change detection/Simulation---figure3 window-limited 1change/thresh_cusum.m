%产生N次新数据，计算统计量时根据window与step遍历
function threshold=thresh(p,M,N,r,gamma,row);
mu=zeros(1,p);
R1=eye(p); 
R2 = eye(p);
for i=1:row
    for j=1:row
        if i~=j
            R2(i,j) = r;
        end
    end
end


Stat = 0;
for j=1:N 
    j
    X = mvnrnd(mu,R1,M)';
    %cusum
    S = -inf; S1 = 0;
    for m=1:M
        f1 = density_fun(X(:,m),mu,R2);
        f0 = density_fun(X(:,m),mu,R1);
        likelihood_ratio1 = log(f1/f0);
         if S>0
              S = S + likelihood_ratio1;
         else
              S = likelihood_ratio1;
         end
    S1(m) = S;
    end
 Stat(j) = max(S1);
end
   threshold = quantile(Stat, [exp(-M ./gamma)]);
end
