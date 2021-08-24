%% Run Kalman filter and evaluate frequency response function 


%% Clear workspace 

clear
close all
iris.required(20210802)

load mat/createModel.mat m
load mat/readDataFromFred.mat h startHist endHist
histRange = startHist : endHist;


%% Model based Kalman filter 

[~, f] = filter( ...
    m, h, histRange ...
    , "initUnit", "approxDiffuse" ...
    , "meanOnly", true ...
);


%% Plot GDP trend estimate 

figure();

subplot(2, 2, 1);
plot(histRange, [f.l_gdp, f.l_gdp_tnd]);
title("Trend component estimate in l_gdp");

subplot(2, 2, 2);
plot(histRange, [f.rrs_tnd, f.obs_rrs_ex]);
title("Trend component estimate in rrs");


%% Plot filter frequency response function 

freq = transpose(0.01 : 0.01 : pi);
Y = ffrf(m, freq);
Y1 = select(Y, "l_gdp_tnd", "obs_l_gdp");
Y2 = select(Y, "rrs_tnd", "obs_rrs_ex");

subplot(2, 1, 2);
hold on
plot(freq, abs(Y1));
plot(freq, abs(Y2));
set(gca(), "xLim", [0, pi]);
title("Filter frequency response functions");

legend( ...
    "FFRF obs_l_gdp --> l_gdp_tnd" ...
    , "FFRF obs_rrs_ex --> rrs_tnd" ...
    , "interpreter", "none" ...
);

visual.highlight(2*pi./[40,4]);

