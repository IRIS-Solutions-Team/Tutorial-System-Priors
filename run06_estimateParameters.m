%% Estimate parameters w/o and w/ system priors 


%% Clear workspace 

clear
close all
%#ok<*CLARRSTR> 

load mat/createModel.mat m
load mat/readDataFromFred.mat h startHist endHist

endHist = qq(2021,01);
histRange = startHist:endHist;


%% Estimate parameters w/o system priors 

%
% Create estimation struct with the list of parameters to be estimated,
% their initial values, lower bounds and upper bounds. Another, 4th,
% element in the cell array can be included to describe the prior
% distribution.
%

estimSpecs = struct();

estimSpecs.c0_l_gdp_gap = {0.6, 0.3, 0.9};
estimSpecs.c1_l_gdp_gap = {0.15, 0.05, 0.20};
estimSpecs.c0_dl_cpi = {0.4, 0.3, 0.9};
estimSpecs.c1_dl_cpi = {0.10, 0.02, 0.20};
estimSpecs.c0_rs = {0.7, 0.3, 0.95};
estimSpecs.c1_rs = {3, 1.5, 5};
estimSpecs.c2_rs = {0.5, 0, 1};

estimSpecs.std_eps_l_gdp_gap = {1, 0.01, 10};
estimSpecs.std_eps_dl_cpi = {1, 0.01, 10};
estimSpecs.std_eps_rs = {1, 0.01, 10};
estimSpecs.std_eps_dl_gdp_tnd = {0.1, 0.001, 10};
estimSpecs.std_eps_rrs_tnd = {0.1, 0.001, 10};

for n = databank.fieldNames(estimSpecs)
    estimSpecs.(n){4} = distribution.Normal.fromMeanStd(  m.(n), 0.2 );
end

%
% Maximize posterior mode which in this case consists of the data
% likelihood only
% 

filterOptions = {
    'relative'; false 
    'initUnit'; 'approxDiffuse' 
};

[summary1, pos1, ~, ~, mest1] = estimate( ...
    m, h, histRange, estimSpecs, [] ...
    , 'noSolution', 'penalty' ...
    , 'filter', filterOptions ...
);

summary1

%% Prepare system priors 

z = SystemPriorWrapper.forModel(m);

d = zerodb(m, 1:40);
d.eps_dl_cpi_targ(1) = -1;
d.cum_gap(0) = 0;
p1 = simulate(m, d, 1:40, 'deviation', true, 'systemProperty', 'S');

z.addSystemProperty(p1);

z.addSystemPrior('-S(cum_gap, 40)', distribution.Normal.fromMeanStd(0.6, 0.015));
z.addSystemPrior('S(cum_gap, 40)-min(S(cum_gap, :))', distribution.Normal.fromMeanStd(0, 0.01));
z.addSystemPrior('S(rs, 1)', distribution.Normal.fromMeanStd(0.25, 0.02));

cutoff = 40;
p2 = ffrf(m, 2*pi/cutoff, 'systemProperty', 'X');
z.addSystemProperty(p2);

z.addSystemPrior('abs(X(l_gdp_tnd, obs_l_gdp))', distribution.Normal.fromMeanStd(0.2, 0.01));
z.addSystemPrior('abs(X(rrs_tnd, obs_rrs_ex))', distribution.Normal.fromMeanStd(0.2, 0.01));

z.seal();


%% Estimate parameters subject to system priors 

%
% Maximize posterior mode which in this case consists of the data
% likelihood and the system priors
% 

[summary2, pos2, p2, ~, mest2] = estimate( ...
    m, h, histRange, estimSpecs, z ...
    , 'noSolution', 'penalty' ...
    , 'filter', filterOptions ...
    , 'evalData', 1 ...
    , 'evalIndiePriors', 1 ...
    , 'evalSystemPriors', 1 ...
);

summary2
s2 = summary2;


%% Run posterior simulator

%{
N = 5000;

[theta, logpost, ar, posFinal, scale, finalCov] = arwm( ...
    pos2, N ...
    , 'Progress=', true ...
    , 'AdaptScale=', 1/2 ...
    , 'AdaptProposalCov=', 1/2 ...
    , 'Gamma=', 0.51 ...
    , 'BurnIn=', 0.20 ...
);

s = stats(pos2, theta, logpost);
%}


%% Posterior distribution of sacrifice ratio

%{
mm = alter(m, 5000);
mm = assign(mm, s.chain);
mm = solve(mm);

d = zerodb(m, 1:40);
d.eps_dl_cpi_targ(1) = -1;
s = simulate(mm, d, 1:40, 'deviation', true);

figure();
histogram(s.cum_gap(40,:), normalization="pdf");
d=distribution.Normal.fromMeanStd(0.6, 0.015);
hold on
x=0.56:0.001:0.66;
plot(-x, pdf(d,x));
%}


%% Simulate disinflation 

mm = [m, mest1, mest2];

d = zerodb(mest1, 1:40);
d.eps_dl_cpi_targ(1) = -1;
s = simulate(mm, d, 1:40, 'deviation', true, 'prependInput', true);

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

[~, x] = filter(mm, h, histRange, "meanOnly", true, "initUnit", "approxDiffuse");

figure();

subplot(1, 2, 1);
plot([x.l_gdp_tnd, x.l_gdp{:, 1}]);
set(gca(), "xGrid", true, "yGrid", true, "yLimitMethod", "tight");

subplot(1, 2, 2);
plot([x.rrs_tnd, x.rrs_ex{:, 1}]);
set(gca(), "xGrid", true, "yGrid", true, "yLimitMethod", "tight");

visual.hlegend("bottom", "Data", "Estimated model with no priors", "Estimated model with system priors");

