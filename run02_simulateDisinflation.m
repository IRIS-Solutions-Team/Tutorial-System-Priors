%% Simulate disinflation and sacrifice ratio 
%
% The disinflation simulation is later used as a basis for some of the
% system priors.
%


%% Clear workspace 

clear
close all
%#ok<*CLARRSTR> 
%#ok<*EV2IN> 
iris.required(20210802)

load mat/createModel.mat m

%% Simulate permanent reduction in inflation target 

d = zerodb(m, 1:40);
d.eps_dl_cpi_targ(1) = -1;
s = simulate( ...
    m, d, 1:40 ...
    , "deviation", true ...
    , "prependInput", true ...
);


%% Plot results

ch = databank.Chartpack();
ch.Range = 0:40;
ch.Round = 8;
ch.AxesExtras = {@(h) yline(h, 0, "lineWidth", 1)};
ch.PlotSettings = {"marker", "s"};
ch.AxesSettings = {"yLimitMethod", "tight"}; 
ch.ShowFormulas = true;

ch < ["GDP gap: l_gdp_gap", "Cumulative gap: cum_gap"];
ch < ["Inflation Q/Q: dl_cpi", "Inflation Y/Y: d4l_cpi", "Inflation target: dl_cpi_targ"];
ch < "Policy rate: rs";
draw(ch, s);


%% System prior objects 

% Create a SystemProperty object using one of functions {simulate, acf,
% xsf, ffrf}

d = zerodb(m, 1:40);
d.eps_dl_cpi_targ(1) = -1;
p = simulate( ...
    m, d, 1:40 ...
    , "deviation", true ...
    , "systemProperty", "S" ...
);

% Create a SystemPriorWrapper to do two things:
%
% 1. Collect all SystemProperty object on which you want to impose system
% priors
%
% 2. Create a prior on a particular data point from a registered system
% property
%

z = SystemPriorWrapper.forModel(m);

addSystemProperty(z, p);

d = distribution.Normal.fromMeanStd(0.5, 0.01);
addSystemPrior(z, "-S(cum_gap, 40)", d, "lowerBound", 0);

seal(z);

[minusLogPrior, contrib, value] = eval(z, m);

figure();
hold on
x = 0 : 0.001 : 1;
plot(x, -logPdf(d, x));
plot(value(1), -logPdf(d, value(1)), "lineStyle", "none", "marker", "s", "lineWidth", 5);




