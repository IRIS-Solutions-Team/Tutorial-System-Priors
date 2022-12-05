%% Create and calibrate model object 


%% Clear workspace 

close all
clear


if ~exist("mat", "dir")
    mkdir mat
end


%% Read model source file 

m = Model.fromFile( ...
    "model-source/simple.model" ...
    , "linear", true ...
    , "growth", true ...
);


%% Calibrate model parameters

m.ss_dl_cpi = 2.25;
m.ss_rrs = 1.5;
m.ss_dl_gdp = 2;

m.c0_l_gdp_gap = 0.7;
m.c1_l_gdp_gap = 0.1;
m.c0_dl_cpi = 0.6;
m.c1_dl_cpi = 0.1;
m.c0_rs = 0.7;
m.c1_rs = 3;
m.c2_rs = 0.5;

m.std_eps_dl_gdp_tnd = 0.1;
m.std_eps_rrs_tnd = 0.2;
m.std_eps_dl_cpi_targ = 0.01;

m.sw = 0;
m.std_eps_dl_gdp_tnd_temp = 0;

%% Calculate steady state and first-order solution 

m = set(m, "linear", false);
m = steady(m);
checkSteady(m);
m = set(m, "linear", true);

m = solve(m);


%% Print steady state table 

table(m, ["steadyLevel", "steadyChange", "description"], "round", 8)


%% Save model to mat 

save mat/createModel.mat m

