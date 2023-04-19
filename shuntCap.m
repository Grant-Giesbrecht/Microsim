function mse = shuntCap(C, freqs)
% SERIESCAP Creates the ABCD matrix for a capacitor in parallel.
%
% See also: shuntInd, shuntRes

	% Create mselement
	mse = shuntZ(Zc(C, freqs), freqs);
	
	% Modify descriptors for capacitor
	mse.desc.classifier = 'PAL_CAP';
	mse.desc.params.C = C;
end