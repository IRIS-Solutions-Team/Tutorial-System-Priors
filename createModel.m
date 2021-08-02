%% Create and calibrate model object 


%% Clear workspace 

close all
clear

if ~exist("mat", "dir")
    mkdir mat
end


%% Read model source file 

m = Model.fromFile( ...
    "simple.model" ...
    , "linear", true ...
    , "growth", true ...
);


%% Calibrate model parameters

m.ss_dl_cpi = 2.25;
m.ss_rrs = 1.5;
m.ss_dl_gdp = 2;

m.A1 = 0.7;
m.A2 = 0.1;
m.B1 = 0.6;
m.B2 = 0.1;
m.C1 = 0.7;
m.C2 = 3;
m.C3 = 0.5;

m.std_eps_dl_gdp_tnd = 0.1;
m.std_eps_rrs_tnd = 0.2;
m.std_eps_dl_cpi_targ = 0.01;


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

