function mse = tlin(Z0, theta, freqs, use_degrees)
% TLIN Creates the ABCD matrix for a generic impedance in series
%
% Taken from seriesf in 'Enceladus'.

	% Check optional arguments
	if ~exist('use_degrees', 'var')
		use_degrees = false;
	end
	
	% Change theta to radians
	if use_degrees
		theta = theta.*pi./180;
	end

	% Create matrix class
	mse = mselement(freqs);
	msd = msdescriptor('TLIN');
	msd.params.Z0 = Z0;
	msd.params.theta_rad = theta;
	%msd.params.() = EDIT PARAMS FIELD HERE

	% Update ABCD matrix
	count = 0;
	theta_n = theta(1);
	Z0_n = Z0(1);
	for f = freqs
		count = count + 1;
		
		% Get theta, Z0 value
		if numel(theta) > 1
			theta_n = theta(count);
		end
		if numel(Z0) > 1
			Z0_n = Z0(count);
		end
		
		mse.abcd(:,:,count) = [cos(theta_n), sqrt(-1)*Z0_n*sin(theta_n);...
		1i/Z0_n*sin(theta_n), cos(theta_n)];
	end
	
	% Add descriptor to MSE
	mse.set_desc(msd);
end