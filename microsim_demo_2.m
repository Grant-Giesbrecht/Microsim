Zterm = 100; % Ohm
L_ = 1e-6; % H/m
C_ = 121e-12; % F/m
N = 30;

freqs = linspace(1e9, 10e9, 11);

cap = shuntCap(C_/N/2, freqs);
ind = seriesInd(L_/N, freqs);

%% Create network with termination baked into ABCD parameters

% Initialize with termination
net_term = shuntRes(Zterm, freqs);

% Add each segment
for i = 1:N
	net_term.series(cap);
	net_term.series(ind);
	net_term.series(cap);
end

displ("Network with Termination: ")
displ("  Zin = ", net_term.Zin(1e6), " Ohms");
displ();

%% Create network with no termination

% Initialize with termination
net_noterm = shuntCap(C_/N/2, freqs);
net_noterm.series(ind);
net_noterm.series(cap);

% Add each segment
for i = 1:N-1
	net_noterm.series(cap);
	net_noterm.series(ind);
	net_noterm.series(cap);
end

displ("Network without Termination: ")
displ("  Zin = ", net_noterm.Zin(Zterm), " Ohms");

% msa_zin(net);
% 
% msa_s11(net);
% 
% ms_S21(net);