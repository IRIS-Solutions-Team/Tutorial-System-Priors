
close all
clear

hp = model('hp.model', 'Linear=', true);
hp = solve(hp);

hp.std_shock_gap = 40;

d.x = Series(qq(2010,1), cumsum(randn(40,1)));

[~, f] = filter(hp, d, get(d.x, 'Range'), 'MeanOnly=', ~true, 'InitUnit=', 'ApproxDiffuse');
[~, f2] = filter(hp, d, get(d.x, 'Range'), 'MeanOnly=', ~true);

d.hpf_trend = hpf(d.x, 'Lambda=', @auto);

freq = 0.01:0.001:pi;
per = 2*pi./freq;
q = ffrf(hp, freq);

trendGain = abs(q('trend', 'x', :));
trendGain = reshape(trendGain, 1, [ ]);

plot(freq, trendGain);
xline( 2*pi/10, 'Color', 'black', 'LineWidth', 1, 'Label', '10per');

