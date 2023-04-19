function mse = shuntRes(R, freqs)
% SERIESCAP Creates the ABCD matrix for a resistor in parallel.
%
% See also: shuntInd, shuntCap

	% Create mselement
	mse = shuntZ(R, freqs);
	
	% Modify descriptors for capacitor
	mse.desc.classifier = 'PAL_RES';
	mse.desc.params.R = R;
end