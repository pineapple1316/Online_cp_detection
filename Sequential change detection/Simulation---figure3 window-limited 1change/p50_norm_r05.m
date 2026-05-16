clear all;
time=clock;
N = 1000;
M = 1000;
window=20;
p = 50 ; 
q = 1000;
gamma = linspace(log(1e2),log(1e5),10);
H = 100; %reference data length
r = 0.5; %off-diagnal element of R2
row = p;
Tmax = 1000;


% ---------- your thresholds ----------
[threshold_smote,threshold_knock,threshold_norm]=thresh_all(p,M,H,window,exp(gamma),q)
threshold_cusum = thresh_cusum(p,M,N,r,exp(gamma),row);

% ---------- B-statistic reference data ----------
mu = zeros(1,p);
R0 = eye(p);
reference_B = mvnrnd(mu, R0, max(500, 10*window))';   % you can enlarge this if needed

% bandwidth and variance for B-statistic
bandw_B = bandw1(reference_B);
S_var_B = est_var_online(reference_B, bandw_B, window, 5);   % here NB=5 is a common choice

% theoretical thresholds for B-statistic
threshold_B = zeros(length(gamma),1);
for i = 1:length(gamma)
    threshold_B(i) = find_thre(window, exp(gamma(i)));
end


% ---------- all methods on the same post-change stream ----------
%[hit_smote,delay_smote1,hit_knock,delay_knock1,hit_norm,delay_norm1,hit_cusum, delay_cusum1]=delay_all_shared_path(p,N,H,r,window,threshold_smote,threshold_knock,threshold_norm,threshold_cusum,row,Tmax)
[hit_smote, delay_smote1, ...
 hit_knock, delay_knock1, ...
 hit_norm,  delay_norm1, ...
 hit_cusum, delay_cusum1, ...
 hit_B,     delay_B1] = ...
    delay_all_shared_path1( ...
        p, N, H, r, window, ...
        threshold_smote, threshold_knock, threshold_norm, ...
        threshold_cusum, ...
        threshold_B, reference_B, bandw_B, S_var_B, 5, ...
        row, Tmax);

etime(clock,time) 
save 'p50 w20 r=0.5 change1 add B.mat'M N window p q gamma threshold_smote threshold_knock threshold_norm hit_smote delay_smote1 hit_knock delay_knock1 hit_norm delay_norm1 threshold_cusum delay_cusum1 hit_cusum hit_B delay_B1


plot(gamma,delay_smote1,'LineStyle','-','Marker','o','color','[0 0.4470 0.7410]','Linewidth',1.3)
hold on
plot(gamma,delay_knock1,'LineStyle',':','Marker','*','color','[0.9290 0.6940 0.1250]','Linewidth',1.3)
hold on
plot(gamma,delay_norm1,'LineStyle','-.','Marker','^','color','[0.8500 0.3250 0.0980]','Linewidth',1.3)
hold on
plot(gamma,delay_cusum1,'LineStyle','--','Marker','x','color','[0.4940 0.1840 0.5560]','Linewidth',1.3)
hold on
plot(gamma,delay_B1,'LineStyle','-','Marker','+','color','[0.2784 0.6392 0.5255]','Linewidth',1.3)
handle = legend("WL-Sum+Smote","WL-Sum+Knockoff","WL-Sum","CUSUM","Scan B stat")
%handle = legend("WL-Sum+Smote","WL-Sum+Knockoff","WL-Sum","CUSUM")
%ylim([0 12])
set(handle,'Interpreter','latex')
set(gca, 'Fontname', 'Times New Roman','FontSize',15);
xlabel('$log(\gamma)$','Interpreter','latex','fontsize',18)
ylabel('Average Detection Delay','fontsize',18)
title("$p$=50, $w$=20, $r$=0.5",'Interpreter','latex','fontsize',18)

