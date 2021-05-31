
close all
clear

% {
fred = databank.fromFred(["GDPC1->GDP", "CPILEGSL->CPI", "TB3MS->RS", "GS10->R10Y"]);
save mat/fred.mat fred
% }
%load mat/fred.mat fred

fredQuarterly = dbfun(@(x) convert(x, 4, 'IgnoreNaN=', false), fred);

startHist = qq(1995,1);
endHist = qq(2017,3);
histRange = startHist : endHist;

h = struct( );
h.obs_l_gdp = 100*log(fredQuarterly.GDP);
h.obs_dl_cpi = 400*diff(log(fredQuarterly.CPI));
h.obs_rs = fredQuarterly.RS;
h.obs_dl_cpi_targ = Series(getRange(h.obs_dl_cpi), 2.25);
h.obs_rrs_ex = h.obs_rs - h.obs_dl_cpi;

save mat/readDataFromFred.mat h startHist endHist histRange

