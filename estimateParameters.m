
clear
close all

load mat/createModel.mat m
load mat/readDataFromFred.mat h startHist endHist
histRange = startHist:endHist;


z = SystemPriorWrapper.forModel(m);

d = zerodb(m, 1:24);
d.eps_dl_cpi_targ(1) = -1;
p1 = simulate(m, d, 1:24, 'deviation', true, 'systemProperty', 'S');
z.addSystemProperty(p1);
z.addSystemPrior('-S(cum_gap, 24)', distribution.Normal.fromMeanStd(0.5, 0.01));

cutoff = 40;
p2 = ffrf(m, 2*pi/cutoff, 'systemProperty', 'X');
z.addSystemProperty(p2);

z.addSystemPrior('abs(X(l_gdp_tnd, obs_l_gdp))', distribution.Normal.fromMeanStd(0.2, 0.01));
z.addSystemPrior('abs(X(rrs_tnd, obs_rrs_ex))', distribution.Normal.fromMeanStd(0.2, 0.01));

z.seal( );

estimSpecs = struct( );

estimSpecs.A1 = {0.4, 0.3, 0.9};
estimSpecs.A2 = {0.15, 0.05, 0.20};
estimSpecs.B1 = {0.4, 0.3, 0.9};
estimSpecs.B2 = {0.10, 0.02, 0.20};
estimSpecs.C1 = {0.7, 0.3, 0.95};
estimSpecs.C2 = {3, 1.5, 5};
estimSpecs.C3 = {0.5, 0, 1};

estimSpecs.std_eps_l_gdp_gap = {1, 0, 50}; % distribution.Gamma.fromAlphaBeta(2, 1)};
estimSpecs.std_eps_dl_cpi = {1, 0.01, 50};
estimSpecs.std_eps_rs = {1, 0.01, 50};
estimSpecs.std_eps_dl_gdp_tnd = {0.1, 0.001, 50};
estimSpecs.std_eps_rrs_tnd = {0.1, 0.001, 50};

filterOptions = {
    'relative'; false
    'initUnit'; 'approxDiffuse' 
};

% Estimate with no priors
[summary1, pos1, ~, ~, mEst1] = estimate( ...
    m, h, histRange, estimSpecs, [], ...
    'evaluateData', true, ...
    'honorBounds', true, ...
    'noSolution', 'penalty', ...
    'filter', filterOptions, ...
    'summary', 'table' ...
);

summary1

% Posterior simulator
%{
rng(0)
N = 50000;
[theta, logpost, ar, posFinal, scale, finalCov] = arwm( ...
    pos1, N ...
    , 'Progress', true ...
    , 'AdaptScale', 0.75 ... 1/1 ...
    , 'AdaptProposalCov', 0.75 ... 1/1 ...
    , 'Gamma', 0.9 ...
    , 'BurnIn', 0.20 ...
);
%}


[~, f1] = filter( ...
    mEst1, h, histRange, ...
    'initUnit', 'approxDiffuse', ...
    'meanOnly', true ...
);


% Estimate with system priors
[summary2, pos2, ~, ~, mEst2] = estimate( ...
    m, h, histRange, estimSpecs, z, ...
    'noSolution', 'penalty', 'filter', filterOptions, ...
    'summary', 'table', 'evaluateData', true ...
);

summary2

[~, f1] = filter( ...
    mEst1, h, histRange, ...
    'initUnit', 'approxDiffuse', ...
    'meanOnly', true ...
);


%% Simulate disinflation 

d = zerodb(mEst1, 1:40);
d.eps_dl_cpi_targ(1) = -1;
s = simulate([mEst1, mEst2], d, 1:40, 'deviation', true, 'prependInput', true);

ch = databank.Chartpack();
ch.Range = 0:40;
ch.AxesExtras = {@(h) yline(h, 0, "lineWidth", 1)};
ch.PlotSettings = {"marker", "s"};
ch.AxesSettings = {"yLimitMethod", "tight"};
ch.ShowFormulas = true;

ch < ["GDP gap: l_gdp_gap", "Cumulative gap: cum_gap"];
ch < ["Inflation Q/Q: dl_cpi", "Inflation Y/Y: d4l_cpi", "Inflation target: dl_cpi_targ"];
ch < "Policy rate: rs";
draw(ch, s);

visual.hlegend("bottom", "Estimated model with no priors", "Estimated model with system priors");


%% Filter GDP trend 

[~, x] = filter([mEst1, mEst2], h, histRange, "meanOnly", true);

figure();
plot([x.l_gdp{:, 1}, x.l_gdp_tnd]);
set(gca(), "xGrid", true, "yGrid", true, "yLimitMethod", "tight");

visual.hlegend("bottom", "Data", "Estimated model with no priors", "Estimated model with system priors");

