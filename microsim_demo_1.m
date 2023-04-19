freqs = linspace(1e9, 10e9, 11);

%% Series Element Demo

% Create two series elements
cap = seriesZ(Zc(1e-12, freqs), freqs);
ind = seriesZ(Zl(1e-6, freqs), freqs);

% Create a network that is the two of them in series, without modifying
% either:
net = copyh(cap);
net.series(ind);

% Do the same thing but in one line:
net2 = msser(cap, ind);

% Now add another element in series, this time modifying one of the
% elements
net2.series(cap);

%% Series and Parallel Demo

res = seriesZ(20, freqs); % 20 Ohm resistor

% Make one path that is 2 inductors in series
pallchain1 = msser(ind, ind);
displ("Path 1:");
displ(pallchain1.table());

% Make a second path that is res-cap-res
net = msser(res, cap);
net.series(res);
displ("Path 2:");
displ(net.table());

%Add them in parallel
net.parallel(pallchain1);
displ("Total:");
displ(net.table());

%% Use Descriptive Creators
%
% This will have identical mathematical results, but using descriptive
% creators allows you to have a more readable netlist.

% Repeat the last example with descriptive creators
cap = seriesCap(1e-12, freqs);
ind = seriesInd(1e-6, freqs);
res = seriesRes(20, freqs);

pc1 = msser(ind, ind);
net = msser(res, cap);
net.series(res);
net.parallel(pc1);

displ("Descriptive Network:");
displ(net.table());
