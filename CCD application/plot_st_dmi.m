load('result.mat');

S_sign_098_all = zeros(1,40);
for i=1:40
    S_signflip_truncated = S_signflip_1985_2024(:,48*(i-1)+1:48*(i-1)+48);
    S_sign_098_all(i) = quantile(S_signflip_truncated(:),0.98);
end
S_sign_098 = mean(S_sign_098_all);

for year = 1985:2024
      for mon = 1:12
        t1 = datetime(year,mon,7);
        t2 = datetime(year,mon,29);
        t = t1:caldays(7):t2;
        Dates_1985_2024((year-1985)*48+(mon-1)*4+1:(year-1985)*48+(mon-1)*4+4) = t;
      end
end
T = length(Dates_1985_2024);
S_1985_2024 = S_new(48*4+1:48*44);

%JAM_3m_dmi
filename = '3m_dmi_JAM_1985_2024.csv';
DMI_data = readtable(filename);
JAM_dmi_3m = DMI_data(:,3);
JAM_dmi_3m = table2array(JAM_dmi_3m)';
%JAM_dmi_3m = abs(JAM_dmi_3m);

startDate = datetime(1985,1,15);
endDate = datetime(2024,12,15);
dates_dmi_3m = startDate:calmonths(1):endDate;



idx_above_0_5 = JAM_dmi_3m >= 0.5;

diff_idx = diff([0,idx_above_0_5,0]);
start_idx = find(diff_idx == 1);
end_idx = find(diff_idx == -1);
%for i=1:length(end_idx)
%   if end_idx(i)>480
%       end_idx(i) = 480;
%   end
%end
end_idx = end_idx - 1;
segment_lengths = end_idx - start_idx + 1;
valid_segments = segment_lengths >= 3;

idx_lower_0_5 = JAM_dmi_3m <= -0.5;
diff_idx_lower = diff([0,idx_lower_0_5,0]);
start_idx_lower = find(diff_idx_lower == 1);
end_idx_lower = find(diff_idx_lower == -1);
end_idx_lower = end_idx_lower - 1;

segment_lengths_lower = end_idx_lower - start_idx_lower + 1;
valid_segments_lower = segment_lengths_lower >= 3;






figure;
subplot(2, 1, 1);
yyaxis left;
plot(Dates_1985_2024(1:912),S_1985_2024(1:912),'Color',[0.91 0.15 0.1], 'LineWidth', 1.3)
hold on

xlim([datetime("1985-01-07") datetime("2003-12-28")])
xtickformat("yyyy")
%set(gca,'XTickLabelRotation',46)
x1 = datetime(1985,1,1): calyears(1):datetime(2003,12,28);
xticks(x1);
%xlabel('year','fontsize',18)
ylabel('$S_t$','Interpreter','latex','fontsize',12,'Color',[sixteen2ten('#6495ED')]/255)
ymax = max(S_1985_2024);
ymin = min(S_1985_2024);
ylim([ymin ymax]); 


h3 = line([datetime(1985,1,1) datetime(2003,12,31)],[S_sign_098 S_sign_098],'linestyle','-', 'Color','k', 'LineWidth', 0.8);
%h4 = line([datetime(1985,1,1) datetime(2003,12,31)],[S_sign_097 S_sign_097],'linestyle','--', 'Color','k', 'LineWidth', 0.8);
%h5 = line([datetime(1985,1,1) datetime(2003,12,31)],[S_sign_099 S_sign_099],'linestyle','--', 'Color','k', 'LineWidth', 0.8);


hold on;
yyaxis right;

h2 = plot(dates_dmi_3m(1:228),abs(JAM_dmi_3m(1:228)),'Color', [0, 0, 1, 0], 'LineWidth', 1.3)
%h2 = plot(dates_dmi_3m(1:228),abs(JAM_dmi_3m(1:228)),'Color', [237/255, 177/255,0, 32/255], 'LineWidth', 1.3)

hold on
ylabel('$|$DMI$|$($^\circ$C)','Interpreter','latex','fontsize',12,'Color',[sixteen2ten('#EDB120')]/255)
ylim([-0.8 1.5]); 

ax = gca;
ax.YAxis(1).Color = [0.91 0.15 0.1];  % ◊Û≤‡ y ÷·—’…´
ax.YAxis(2).Color =[0 0 0];   % ”“≤‡ y ÷·—’…´

for i = find(valid_segments)
    idx_range = start_idx(i):end_idx(i);
    h7 = fill([dates_dmi_3m(idx_range), flip(dates_dmi_3m(idx_range))], ...
         [JAM_dmi_3m(idx_range), flip(0.5*ones(size(dates_dmi_3m(idx_range))))], ...
         [255 150 0]/255, 'FaceAlpha', 0.6, 'EdgeColor', 'none'); 
end


      
for i = find(valid_segments_lower)
    idx_range = start_idx_lower(i):end_idx_lower(i);
    h8 = fill([dates_dmi_3m(idx_range), flip(dates_dmi_3m(idx_range))], ...
         [abs(JAM_dmi_3m(idx_range)), flip(0.5*ones(size(dates_dmi_3m(idx_range))))], ...
        [135 206 250]/255, 'FaceAlpha', 0.8, 'EdgeColor', 'none'); 
end




subplot(2, 1, 2);
yyaxis left;
plot(Dates_1985_2024(913:end),S_1985_2024(913:end),'Color',[0.91 0.15 0.1], 'LineWidth', 1.3)
hold on

xlim([datetime("2004-01-07") datetime("2024-12-28")])
xtickformat("yyyy")
%set(gca,'XTickLabelRotation',46)
x1 = datetime(2004,1,1): calyears(1):datetime(2024,12,28);
xticks(x1);
%xlabel('year','fontsize',18)
ylabel('$S_t$','Interpreter','latex','fontsize',12,'Color',[sixteen2ten('#6495ED')]/255)
ymax = max(S_1985_2024);
ymin = min(S_1985_2024);
ylim([ymin ymax]); 


h3 = line([datetime(2004,1,1) datetime(2024,12,31)],[S_sign_098 S_sign_098],'linestyle','-', 'Color','k', 'LineWidth', 0.8);
%h4 = line([datetime(2004,1,1) datetime(2024,12,31)],[S_sign_097 S_sign_097],'linestyle','--', 'Color','k', 'LineWidth', 0.8);
%h5 = line([datetime(2004,1,1) datetime(2024,12,31)],[S_sign_099 S_sign_099],'linestyle','--', 'Color','k', 'LineWidth', 0.8);


hold on;
yyaxis right;

h2 = plot(dates_dmi_3m(229:end),abs(JAM_dmi_3m(229:end)),'Color', [0, 0, 1, 0], 'LineWidth', 1.3)
hold on
ylabel('$|$DMI$|$($^\circ$C)','Interpreter','latex','fontsize',12,'Color',[sixteen2ten('#EDB120')]/255)
ylim([-0.8 1.5]); 


for i = find(valid_segments)
    idx_range = start_idx(i):end_idx(i);
    h7 = fill([dates_dmi_3m(idx_range), flip(dates_dmi_3m(idx_range))], ...
         [JAM_dmi_3m(idx_range), flip(0.5*ones(size(dates_dmi_3m(idx_range))))], ...
         [255 150 0]/255, 'FaceAlpha', 0.6, 'EdgeColor', 'none'); 
end


      
for i = find(valid_segments_lower)
    idx_range = start_idx_lower(i):end_idx_lower(i);
    h8 = fill([dates_dmi_3m(idx_range), flip(dates_dmi_3m(idx_range))], ...
         [abs(JAM_dmi_3m(idx_range)), flip(0.5*ones(size(dates_dmi_3m(idx_range))))], ...
         [135 206 250]/255, 'FaceAlpha', 0.8, 'EdgeColor', 'none'); 
end

ax = gca;
ax.YAxis(1).Color = [0.91 0.15 0.1];  % ◊Û≤‡ y ÷·—’…´
ax.YAxis(2).Color =[0 0 0];   % ”“≤‡ y ÷·—’…´

