function mse = seriesInd(L, freqs)
% SERIESIND Creates the ABCD matrix for an inductor in series.
%
% See also: seriesCap, seriesRes

	% Create mselement
	mse = seriesZ(Zl(L, freqs), freqs);
	
	% Modify descriptors for capacitor
	mse.desc.classifier = 'SER_IND';
	mse.desc.params.L = L;
end