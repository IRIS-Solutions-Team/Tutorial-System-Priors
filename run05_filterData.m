%% Run Kalman filter and evaluate frequency response function 


%% Clear workspace 

clear
close all

load mat/createModel.mat m
load mat/readDataFromFred.mat h startHist endHist lastObs
histRange = startHist : lastObs;


%% Model based Kalman filter 

f0 = kalmanFilter( ...
    m, h, histRange ...
    , "unitRootInitial", "approxDiffuse" ...
    , "meanOnly", true ...
);

m1 = m;
m1.sw = 1;
m1 = solve(m1);
over = struct();
over.std_eps_dl_gdp_tnd_temp = Series(qq(2019,4):qq(2021,3), 5);

f1 = kalmanFilter( ...
    m1, h, histRange ...
    , "unitRootInitial", "approxDiffuse" ...
    , "meanOnly", true ...
    , "override", over ...
);

m2 = m;
m2.std_eps_dl_gdp_tnd_temp = 5;
m2 = solve(m2);
over = struct();
over.sw = Series(qq(2019,4):qq(2021,3), 1);

f2 = kalmanFilter( ...
    m2, h, histRange ...
    , "unitRootInitial", "approxDiffuse" ...
    , "meanOnly", true ...
    , "override", over ...
);
chartDb = databank.merge("horzcat", f0, f1, f2);

chartDb.dl_gdp_tnd

%% Plot GDP trend estimate 

figure();

% subplot(2, 2, 1);
plot(histRange, [f0.l_gdp, chartDb.l_gdp_tnd]);
title("Trend component estimate in l_gdp", "interpreter", "none");

return

subplot(2, 2, 2);
plot(histRange, [f0.rrs_tnd, chartDb.obs_rrs_ex]);
title("Trend component estimate in rrs");

return


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

h = legend( ...
    "FFRF obs_l_gdp --> l_gdp_tnd" ...
    , "FFRF obs_rrs_ex --> rrs_tnd" ...
    , "interpreter", "none" ...
);

visual.highlight(2*pi./[40,4]);

