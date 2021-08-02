%% Simulate disinflation and sacrifice ratio 


%% Clear workspace 

clear
close all

load mat/createModel.mat m


%% Simulate permanent reduction in inflation target 

d = zerodb(m, 1:40);
d.eps_dl_cpi_targ(1) = -1;
d.cum_gap(0) = 0;
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

