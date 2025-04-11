function [S_new, threshold] = online_cp_detection(reference_data, data, window, q, quantile_num);
%p: data dimension. 
%T0: time series length. T_ref: length of reference data.
[p,T0] = size(data);
T = T0 - window;
p1 = p*(p-1)/2;

[~,T_ref] = size(reference_data);

vecho_matrix1 = 0;
reference_data_mean=mean(reference_data,2);
reference_data_sd=std(reference_data,0,2);
reference_data_dot=zeros(p,T_ref);
for ip=1:p
    reference_data_dot(ip,:)=(reference_data(ip,:) - reference_data_mean(ip))/ reference_data_sd(ip);
end
    
for it=1:T_ref
    vecho_matrix1 = vecho_matrix1 + vecho(reference_data_dot(:,it)* reference_data_dot(:,it)');
end

vecho_matrix1 = vecho_matrix1 / T_ref;



S_new = zeros(1,T); 
for j = 1:T
    j;
    x0 = data(:,1+j:j+window);
    
    vecho_matrix2 = 0;
    [p,T_new] = size(x0);

    x0_mean=mean(x0,2);
    x0_sd=std(x0,0,2);
    x0_dot=zeros(p,T_new);
        
    for ip=1:p
        x0_dot(ip,:)=(x0(ip,:) - x0_mean(ip))/ x0_sd(ip);
    end

    for it=1:T_new
        vecho_matrix2 = vecho_matrix2 + vecho( x0_dot(:,it)* x0_dot(:,it)');
    end
    vecho_matrix2 = vecho_matrix2/T_new;

    
    S_new(j) = max((vecho_matrix1 - vecho_matrix2).*(vecho_matrix1 - vecho_matrix2));  %max-type statistics
    %S_new(j) = norm(vecho_matrix1 - vecho_matrix2,2)^2; %sum-type statistics
end


%signflip select threshold----------------------------------------------------------------------
S_new_signflip = zeros(q,T);

for sign = 1:q
    sign
  
    data_star=(binornd(1,0.5,p,(T+window))*2-1).*data; 
    reference_data_sign =(binornd(1,0.5,p,T_ref)*2-1).*reference_data; 

    
    vecho_matrix1_sign = 0; 

    reference_data_sign_mean=mean(reference_data_sign,2);
    reference_data_sign_sd=std(reference_data_sign,0,2);
    reference_data_sign_dot=zeros(p,T_ref);
    for ip=1:p
        reference_data_sign_dot(ip,:)=(reference_data_sign(ip,:) - reference_data_sign_mean(ip))/ reference_data_sign_sd(ip);
    end

    for it=1:T_ref
         vecho_matrix1_sign = vecho_matrix1_sign + vecho( reference_data_sign_dot(:,it) * reference_data_sign_dot(:,it)');
    end
    vecho_matrix1_sign = vecho_matrix1_sign / T_ref;

    for j = 1:T
        j;
        x0 = data_star(:,j+1 :j+window);

        vecho_matrix2_sign = 0;
        [p,T_new] = size(x0);
        x0_mean=mean(x0,2);
        x0_sd=std(x0,0,2);
        x0_dot=zeros(p,T_new);

        for ip=1:p
            x0_dot(ip,:)=(x0(ip,:)-x0_mean(ip))/x0_sd(ip);
        end

        for it=1:T_new
             vecho_matrix2_sign = vecho_matrix2_sign + vecho( x0_dot(:,it)* x0_dot(:,it)');
        end
        vecho_matrix2_sign = vecho_matrix2_sign/T_new;
        
        S_new_signflip(sign,j) = max((vecho_matrix1_sign - vecho_matrix2_sign).*(vecho_matrix1_sign - vecho_matrix2_sign));  %max-type signflipped statistics
       % S_new_signflip(sign,j) = norm(vecho_matrix1_sign - vecho_matrix2_sign,2)^2;  %sum-type signflipped statistics

    end
end

threshold_matrix = zeros(length(quantile_num),floor(T/window));
for i = 1:length(quantile_num)
    for j = 1:floor(T/window)
        sub_window_S_new =  S_new_signflip(:,window*(j-1)+1:window*j);
        threshold_matrix(i,j) = quantile(sub_window_S_new(:),quantile_num(i));
    end
end
threshold = mean(threshold_matrix,2);