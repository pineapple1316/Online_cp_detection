%1974-2024
%begining each el nino event happens last month in 3 consequtive months
plot(Dates,S_new1,'Color',[sixteen2ten('#0072BD')]/255, 'LineWidth', 1.3)
%set(gca, 'Fontname', 'Times New Roman','FontSize',18);
xlim([datetime("1974-01-07") datetime("2024-12-28")])
xtickformat("yyyy")
%set(gca,'XTickLabelRotation',46)
x1 = datetime(1974,1,7): calyears(1):datetime(2024,12,28);
xticks(x1);
x2 = datetime(1974,1,7): calyears(3):datetime(2024,12,28);
labels = cell(1,length(x1));
for i = 1:length(x1)
    if ismember(x1(i),x2)
        labels{i} = num2str(year(x1(i)));
    else
        labels{i} = '';
    end
end
xticklabels(labels);
xlabel('year','fontsize',18)
ylabel('$S_t$','Interpreter','latex','fontsize',18)
title("$1974-2024 \quad El \quad Ni\tilde{n}o \quad happens$",'Interpreter','latex','fontsize',20)
line([datetime(1976,10,7) datetime(1976,10,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#EDB120')]/255,  'LineWidth', 1.3);
line([datetime(1977,3,7) datetime(1977,3,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(1977,10,7) datetime(1977,10,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#EDB120')]/255,  'LineWidth', 1.3);
line([datetime(1978,2,7) datetime(1978,2,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(1979,11,7) datetime(1979,11,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#EDB120')]/255,  'LineWidth', 1.3);
line([datetime(1980,3,7) datetime(1980,3,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(1982,5,7) datetime(1982,5,7)],[0 600],'linestyle','--', 'Color',[sixteen2ten('#EDB120')]/255, 'LineWidth', 1.3);
line([datetime(1983,7,7) datetime(1983,7,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(1986,10,7) datetime(1986,10,7)],[0 600],'linestyle','--', 'Color',[sixteen2ten('#EDB120')]/255, 'LineWidth', 1.3);
line([datetime(1988,3,7) datetime(1988,3,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(1991,6,7) datetime(1991,6,7)],[0 600],'linestyle','--', 'Color',[sixteen2ten('#EDB120')]/255, 'LineWidth', 1.3);
line([datetime(1992,7,7) datetime(1992,7,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(1994,10,7) datetime(1994,10,7)],[0 600],'linestyle','--', 'Color',[sixteen2ten('#EDB120')]/255, 'LineWidth', 1.3);
line([datetime(1995,4,7) datetime(1995,4,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(1997,6,7) datetime(1997,6,7)],[0 600],'linestyle','--', 'Color',[sixteen2ten('#EDB120')]/255, 'LineWidth', 1.3);
line([datetime(1998,6,7) datetime(1998,6,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(2002,7,7) datetime(2002,7,7)],[0 600],'linestyle','--', 'Color',[sixteen2ten('#EDB120')]/255, 'LineWidth', 1.3);
line([datetime(2003,3,7) datetime(2003,3,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(2004,8,7) datetime(2004,8,7)],[0 600],'linestyle','--', 'Color',[sixteen2ten('#EDB120')]/255, 'LineWidth', 1.3);
line([datetime(2005,5,7) datetime(2005,5,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(2006,10,7) datetime(2006,10,7)],[0 600],'linestyle','--', 'Color',[sixteen2ten('#EDB120')]/255, 'LineWidth', 1.3);
line([datetime(2007,2,7) datetime(2007,2,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(2009,8,7) datetime(2009,8,7)],[0 600],'linestyle','--', 'Color',[sixteen2ten('#EDB120')]/255, 'LineWidth', 1.3);
line([datetime(2010,4,7) datetime(2010,4,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(2014,12,7) datetime(2014,12,7)],[0 600],'linestyle','--', 'Color',[sixteen2ten('#EDB120')]/255, 'LineWidth', 1.3);
line([datetime(2016,5,7) datetime(2016,5,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(2018,11,7) datetime(2018,11,7)],[0 600],'linestyle','--', 'Color',[sixteen2ten('#EDB120')]/255, 'LineWidth', 1.3);
line([datetime(2019,7,7) datetime(2019,7,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(2023,6,7) datetime(2023,6,7)],[0 600],'linestyle','--', 'Color',[sixteen2ten('#EDB120')]/255, 'LineWidth', 1.3);
line([datetime(2024,5,7) datetime(2024,5,7)],[0 600],'linestyle','--','Color',[sixteen2ten('#77AC30')]/255,  'LineWidth', 0.5);

line([datetime(1974,1,7) datetime(2024,12,28)],[S_sign S_sign],'linestyle','--', 'Color',[sixteen2ten('#77AC30')]/255, 'LineWidth', 1.3);


