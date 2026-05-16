%产生一次数据X，进行q次变化，q=1000,每次根据window和step计算统计量。
function [threshold_smote,threshold_knock,threshold_norm]=thresh(p,M,H,window,gamma,q);
  p1=p*(p-1)/2;
  mu=zeros(1,p);
  R1=eye(p); 
  
  ref_x = mvnrnd(mu,R1,H)';
  ref_x_mean=mean(ref_x,2);
  ref_x_sd=std(ref_x,0,2);
  ref_x_dot=zeros(p,H);
  for i=1:p
       ref_x_dot(i,:)=(ref_x(i,:)-ref_x_mean(i))/ref_x_sd(i);
  end

   vecho_matrix1=0;
   for i=1:H
       vecho_matrix1 = vecho_matrix1 + vecho(ref_x_dot(:,i)* ref_x_dot(:,i)');
   end
   vecho_matrix1 = vecho_matrix1/H;
  
   X=mvnrnd(mu,R1,M)';

Stat_smote = 0; Stat_knock = 0; Stat_norm = 0;
for iq=1:q    
   iq
   x_star=(binornd(1,0.5,p,M)*2-1).*X;  
   S_smote = 0;S_knock = 0;S_norm = 0;
   for m = 2:M
       if m < window
           x0 = x_star(:,1:m);
       else
           x0 = x_star(:,(m-window+1):m);
       end
       [~, T]= size(x0); 
       
       %smote
       x_smote0 = x0;
       [~, Ts0]= size(x_smote0) ; 
       class_min = (1:Ts0);
       x_smote1 = zeros(p,1);
       for j1 = 1 : Ts0
           distance = 0;
           for jj = 1 : Ts0
                  distance(jj) = norm(x_smote0(:,j1) - x_smote0(:,jj));
           end   
           [a  b] =  sort(distance);
           if length(b) >= 6
                   nearest5 = b(1:6);
                   nearest5  = setdiff(nearest5,j1);
           else 
                   nearest5 = b ;
                   nearest5  = setdiff(nearest5,j1);
           end
           x_rand = nearest5(randperm(length(nearest5)));
           x_rand = x_rand(1);
           u = rand ;
           x_smote1(:,j1) = u * x_smote0(:,x_rand) + (1-u) * x_smote0(:,j1);
      end

       x_smote = [x_smote0 x_smote1]; 
       [~,T_smote] = size(x_smote);
       
       S_tp_smote = zeros(1,T-1); %S_tp for S_t'
       for is = 1:(T-1) 
           x = x_smote(:,is:T_smote);
           [~, Ts]= size(x) ; 
           x_mean=mean(x,2);
           x_sd=std(x,0,2);
           x_dot=zeros(p,Ts);
           for i=1:p
              x_dot(i,:)=(x(i,:)-x_mean(i))/x_sd(i);
           end

           vecho_matrix2=0;
           for i=1:Ts
              vecho_matrix2 = vecho_matrix2 + vecho(x_dot(:,i)*x_dot(:,i)');
           end
           vecho_matrix2 = vecho_matrix2/(Ts);
           S_tp_smote(is) = (H*(Ts-T))/(H+(Ts-T)) * norm(vecho_matrix1 - vecho_matrix2,2)^2;
       end
       
      %fixed-x knockoff
      x_knock0 = x0;
      [~,Tk0] = size(x_knock0);
      x_knock1 = fixed_equi(x_knock0);

      x_knock = zeros(p, 2*Tk0);
      x_knock(:, 1:Tk0) = x_knock0;
      x_knock(:,(Tk0+1):end) = x_knock1; 
      [~,T_k] = size(x_knock);
      
      S_tp_knock = zeros(1,T-1);
      for is = 1:(T-1)
         x = x_knock(:,is:T_k);
         [~, Tk]= size(x) ; 
         x_mean=mean(x,2);
         x_sd=std(x,0,2);
         x_dot=zeros(p,Tk);
         for i=1:p
              x_dot(i,:)=(x(i,:)-x_mean(i))/x_sd(i);
         end

           vecho_matrix2=0;
           for i=1:Tk
              vecho_matrix2 = vecho_matrix2 + vecho(x_dot(:,i)*x_dot(:,i)');
           end
           vecho_matrix2 = vecho_matrix2/(Tk);
           S_tp_knock(is) = (H*(Tk-T))/(H+(Tk-T)) *norm(vecho_matrix1 - vecho_matrix2,2)^2;
      end

     %l2 norm
     S_tp_norm = zeros(1,T-1);
     for is = 1:(T-1)      
           x = x0(:,is:T);
           [~, Tn]= size(x) ; 
           x_mean=mean(x,2);
           x_sd=std(x,0,2);
           x_dot=zeros(p,Tn);
           for i=1:p
               x_dot(i,:)=(x(i,:)-x_mean(i))/x_sd(i);
           end

           vecho_matrix2=0;
           for i=1:Tn
               vecho_matrix2 = vecho_matrix2 + vecho(x_dot(:,i)*x_dot(:,i)');
           end
           vecho_matrix2 = vecho_matrix2/(Tn);
           S_tp_norm(is) = (H*Tn)/(H+Tn) * norm(vecho_matrix1 - vecho_matrix2,2)^2;
       end
       S_smote(m) = max(S_tp_smote);
       S_knock(m) = max(S_tp_knock); 
       S_norm(m) = max(S_tp_norm);
end
 Stat_smote(iq) = max(S_smote);
 Stat_knock(iq) = max(S_knock);
 Stat_norm(iq) = max(S_norm);
end
threshold_smote = quantile(Stat_smote, [exp(-M ./gamma)]);
threshold_knock = quantile(Stat_knock, [exp(-M ./gamma)]);
threshold_norm = quantile(Stat_norm, [exp(-M ./gamma)]);
end
   