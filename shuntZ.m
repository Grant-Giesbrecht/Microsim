function mse = shuntZ(Z, freqs)
% SHUNTZ Creates the ABCD matrix for a generic impedance in parallel
%
% Taken from termf in 'Enceladus'. 

	% Create matrix class
	mse = mselement(freqs);
	
	msd = msdescriptor('PAL_ELMT');
	%msd.params.() = EDIT PARAMS FIELD HERE

	if numel(Z) == 1
		count = 0;
		for f = freqs
			count = count + 1;
			mse.abcd(:,:,count) = [1, 0; 1/Z, 1];
		end
	elseif numel(Z) == numel(freqs)
		count = 0;
		for f = freqs
			count = count + 1;
			mse.abcd(:,:,count) = [1, 0; 1/Z(count), 1];
		end
	end
	
	% Add descriptor to MSE
	mse.set_desc(msd);
end