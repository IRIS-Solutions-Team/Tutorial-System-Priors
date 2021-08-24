%% Illustrate filter frequency response function using HP 


%% Clear workspace 

close all
clear
iris.required(20210802)


%% Read state space model of HP filter 

hp = Model.fromFile("model-source/hp.model", "linear", true);
hp = solve(hp);

% Parameterize lambda
hp.std_shock_trend = 1;
hp.std_shock_gap = 40;

hp = alter(hp, 2);
hp.std_shock_gap = [40, 1];


%% Run filter on random data 

d.x = Series(qq(2010,1), cumsum(randn(40,1)));

[~, f] = filter(hp, d, getRange(d.x), "meanOnly", true, "initUnit", "approxDiffuse");

plot([d.x, f.trend]);


%% Calculate filter frequency response function 


freq = 0.01:0.001:pi;
per = 2*pi./freq;
q = ffrf(hp, freq);

trendGain1 = abs(q("trend", "x", :, 1));
trendGain1 = reshape(trendGain1, 1, [ ]);

trendGain2 = abs(q("trend", "x", :, 2));
trendGain2 = reshape(trendGain2, 1, [ ]);

figure();
hold on
plot(freq, trendGain1);
plot(freq, trendGain2);
set(gca, 'xLim', [0, pi]);
% xline( 2*pi/10, "color", "black", "lineWidth", 1, "label", "10per");

