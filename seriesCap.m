function mse = seriesCap(C, freqs)
% SERIESCAP Creates the ABCD matrix for a capacitor in series.
%
% See also: seriesInd, seriesRes

	% Create mselement
	mse = seriesZ(Zc(C, freqs), freqs);
	
	% Modify descriptors for capacitor
	mse.desc.classifier = 'SER_CAP';
	mse.desc.params.C = C;
end