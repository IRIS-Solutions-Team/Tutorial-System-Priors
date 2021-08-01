
clear
close all

load read_model2.mat m


d = sstatedb(m, 1:40);
d.eps_dl_cpi_targ(5) = -1;
s1 = simulate(m, d, 1:40, 'AppendPresample=', true);

d.eps_dl_cpi_targ(5) = -1;
s2 = simulate(m, d, 1:40, 'AppendPresample=', true, 'Anticipate=', false);

d.eps_dl_cpi_targ(5) = -0.5 + -0.5i;
s3 = simulate(m, d, 1:40, 'AppendPresample=', true);


d.eps_dl_cpi_targ(5) = -1 + 1i;
s4 = simulate(m, d, 1:40, 'AppendPresample=', true);

dbplot(s1 & s4, 0:40, get(m, 'XList'), 'Tight=', true);

