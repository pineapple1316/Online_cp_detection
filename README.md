# Online_cp_detection
online change point detection in large dimensional correlation matrix


The '3m_dmi_JAM_1985_2024.csv' is the three month running average of DMI index from JAMSTEC institute from year 1985 to 2024.

'X_1980_2024_week_iod_all_grid_2_5_261nodes.mat' is the 1980-2024 1000hPa daily data(at time 00:00) on the 7th,14th,21st and 28th days of each month from ERA5 reanalysis in the IOD region, when grid size is 2.5*2.5, there's 261 nodes in total. 

'ref500 max ref87-90 261nodes 1980-2024 iod.mat' is the result when we use q=500 signflip times, max statisitc and 261nodes.

'main.m' gives you a whole picture of how to use the function to detect change points sequentially in a real dataset.

'plot_st_dmi' is the final plot code.

'online_cp_detection.m' is a function file to calculate test statistics and threhsolds.

'sixteen2ten.m' is used for plot, 'vecho.m' and 'vk00.m' are functions used in 'online_cp_detection.m'.


Note:
We recommend using different quantiles of signflipped statistics as thrseholds, a prefered one is chosen by cross validation.
