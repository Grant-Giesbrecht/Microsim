function mse = shuntInd(L, freqs)
% SERIESCAP Creates the ABCD matrix for a inductor in parallel.
%
% See also: shuntCap, shuntRes

	% Create mselement
	mse = shuntZ(Zl(L, freqs), freqs);
	
	% Modify descriptors for capacitor
	mse.desc.classifier = 'PAL_IND';
	mse.desc.params.L = L;
end