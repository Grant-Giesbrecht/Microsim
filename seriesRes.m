function mse = seriesRes(R, freqs)
% SERIESRES Creates the ABCD matrix for a resistor in series.
%
% See also: seriesCap, seriesInd

	% Create mselement
	mse = seriesZ(R, freqs);
	
	% Modify descriptors for capacitor
	mse.desc.classifier = 'SER_RES';
	mse.desc.params.R = R;
end