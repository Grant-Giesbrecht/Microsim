function mse = seriesZ(Zser, freqs)
% SERIESZ Creates the ABCD matrix for a generic impedance in series
%
% Taken from seriesf in 'Enceladus'. 

	% Create matrix class
	mse = mselement(freqs);
	
	msd = msdescriptor('SER_ELMT');
	%msd.params.() = EDIT PARAMS FIELD HERE

	if numel(Zser) == 1
		count = 0;
		for f = freqs
			count = count + 1;
			mse.abcd(:,:,count) = [1, Zser; 0, 1];
		end
	elseif numel(Zser) == numel(freqs)
		count = 0;
		for f = freqs
			count = count + 1;
			mse.abcd(:,:,count) = [1, Zser(count); 0, 1];
		end
	end
	
	% Add descriptor to MSE
	mse.set_desc(msd);
end