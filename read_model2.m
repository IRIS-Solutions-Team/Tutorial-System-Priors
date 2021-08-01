

clear
close all

m = model('simple.model', 'Std=', 1);

m.A1 = 0.7;
m.A2 = 0.1;
m.B1 = 0.6;
m.B2 = 0.1;
m.C1 = 0.7;
m.C2 = 3;
m.C3 = 0.5;

m.pi = 2.25;
m.rho = 1.5;
m.alpha = 2;

m.std_eps_dl_gdp_tnd = 0.1;
m.std_eps_rrs_tnd = 0.2;
m.std_eps_dl_cpi_targ = 0.01;

m = sstate(m, 'Growth=', true);
m = solve(m);

save read_model2.mat m  