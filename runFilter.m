clear
close all

load mat/createModel.mat m
load mat/readDataFromFred.mat h histRange


%% Model based Kalman filter

[~, f] = filter(m, h, histRange, 'initUnit', 'approxDiffuse', 'meanOnly', true);


%% GDP trend estimate

figure( );
subplot(2, 1, 1);
plot(histRange, [f.l_gdp, f.l_gdp_tnd]);


%% Frequency response function 

subplot(2, 1, 2);
freq = 0.01 : 0.01 : pi;
Y = ffrf(m, freq);
Y1 = select(Y, 'l_gdp_tnd', 'obs_l_gdp');
plot(freq, abs(Y1));

