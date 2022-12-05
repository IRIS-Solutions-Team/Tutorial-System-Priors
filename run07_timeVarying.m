%% Run Kalman filter and estimation with time-varying parameters


%% Clear workspace 

clear
close all

load mat/createModel.mat m
load mat/readDataFromFred.mat h startHist endHist lastObs
histRange = startHist : lastObs;


%% Kalman filter 

f0 = kalmanFilter( ...
    m, h, histRange ...
    , "unitRootInitial", "approxDiffuse" ...
    , "meanOnly", ~true ...
);

m1 = m;
over1 = struct();
over1.std_eps_dl_gdp_tnd = Series(qq(2019,1):qq(2020,4), 5);

f1 = kalmanFilter( ...
    m1, h, histRange ...
    , "meanOnly", ~true ...
    , "override", over1 ...
);


m2 = m;
m2.std_eps_dl_gdp_tnd_temp = 5;

over2 = struct();
over2.sw = Series(qq(2019,1):qq(2020,4), 1);

f2 = kalmanFilter( ...
    m2, h, histRange ...
    , "meanOnly", ~true ...
    , "override", over2 ...
);

f = databank.merge("horzcat", f0.Mean, f1.Mean, f2.Mean);

figure();
x = plot(histRange, [f0.Mean.l_gdp, f.l_gdp_tnd]);
x(3).Marker = "s";
x(3).MarkerSize = 16;
x(4).Marker = "v";

title("Trend component estimate in l_gdp", "interpreter", "none");
visual.highlight(qq(2019,1):qq(2020,4));

figure();
plot(histRange, f.l_gdp_gap);
title("Output gap estimates", "interpreter", "none");
visual.highlight(qq(2019,1):qq(2020,4));
legend("Constant", "Time varying std error of potential output shocks", "Time varying autoregression in output gap");

figure();
plot(histRange, [f0.Std.l_gdp_tnd, f1.Std.l_gdp_tnd]);
visual.highlight(qq(2019,1):qq(2020,4));


%% Estimation

estimSpecs = struct();
estimSpecs.std_eps_dl_gdp_tnd = {0.1, 0.0001, 10, distribution.Normal.fromMeanStd(0.1, 0.05)};
estimSpecs.std_eps_dl_gdp_tnd_temp = {5, 0.0001, 100, distribution.Normal.fromMeanStd(5, 5)};

filterOptions = {"override", over2};

m2.c_to_gdp = 0.4;

[summary, pos, ~, ~, mest] = estimate( ...
    m2, h, histRange, estimSpecs, [] ...
    , 'noSolution', 'penalty' ...
    , 'filter', filterOptions ...
    , 'steady', {"exogenize", ["c_to_gdp"], "endogenize", ["gamma"] } ...
);

summary

return

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

