
close all
clear

hp = Model.fromFile("hp.model", "linear", true);
hp = solve(hp);

hp.std_shock_gap = 40;

d.x = Series(qq(2010,1), cumsum(randn(40,1)));

[~, f] = filter(hp, d, getRange(d.x), "meanOnly", ~true, "initUnit", "approxDiffuse");
[~, f2] = filter(hp, d, getRange(d.x), "meanOnly", ~true);

d.hpf_trend = hpf(d.x, "lambda", @auto);

freq = 0.01:0.001:pi;
per = 2*pi./freq;
q = ffrf(hp, freq);

trendGain = abs(q("trend", "x", :));
trendGain = reshape(trendGain, 1, [ ]);

plot(freq, trendGain);
xline( 2*pi/10, "color", "black", "lineWidth", 1, "label", "10per");

