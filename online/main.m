clear all;   
%data is p*T, p is data dimension, T is length of time series.

%The online_cp_detection function use max statistic by default, you need to
%change it if you want to use other statistics, for example, sum type
%statistics.

load("X_1980_2024_week_iod_all_grid_2_5_261nodes.mat");
data = X_num.';
window=48; %one year
ref_x = data(:,[(48*7+1):(48*11)]); 
%Ref 1987.1.7-1990.12.28
q=200;
quantile_num =  [0.95,0.98,0.99,1];

[St, threshold] = online_cp_detection(ref_x, data, window, q, quantile_num);



for year = 1981:2024
      for mon = 1:12
        t1 = datetime(year,mon,7);
        t2 = datetime(year,mon,29);
        t = t1:caldays(7):t2;
        Dates((year-1981)*48+(mon-1)*4+1:(year-1981)*48+(mon-1)*4+4) = t;
      end
end


plot(Dates,St)
%line([datetime(2004,1,1) datetime(2024,12,31)],[threshold threshold],'linestyle','-', 'Color','k', 'LineWidth', 0.8);
line([Dates(1) Dates(end)],[threshold threshold],'linestyle','-', 'Color','k', 'LineWidth', 0.8);


%try different quantiles and calculate the hit rate and false alarm.
%Cross-validation can be used to choose a threshold properly.

