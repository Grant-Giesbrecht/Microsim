function [S, Z0] = ms_abcd2s(abcd, Z0)
% MS_ABCD2S Converts a 2x2xN ABCD matrix to S parameters.
% 
%   MS_ABCD2S(A) Converts the ABCD matrix 'A' to S parameters. This repeats
%   thefunctionality of abcd2s, without requiring the RF Toolbox.
%   Normalizes S parameters to 50 ohms.
%
%	MS_ABCD2S(A, Z0) Normalizes S parameters to Z0.
%
% See also: ms_s
	
	% Check optional arguments
	if ~exist('Z0', 'var')
		Z0 = 50;
	end

	% Check matrix dimensions
	[a, b, N] = size(abcd);
	if a ~= 2 || b ~= 2
		S = [];
		error("ABCD must be a 2x2xN matrix");
	end
	
	% Retrieve ABCD components
	A = abcd(1,1,:);
	B = abcd(1,2,:);
	C = abcd(2,1,:);
	D = abcd(2,2,:);
	
	% Create S matrix
	S = zeros(2,2,N);
	
	% Populate S matrix
	S(1,1,:) = (A + B./Z0 - C.*Z0 - D)./(A + B./Z0 + C.*Z0 + D);
	S(1,2,:) = 2.*(A.*D - B.*C)./(A + B./Z0 + C.*Z0 + D);
	S(2,1,:) = 2./(A + B./Z0 + C.*Z0 + D);
	S(2,2,:) = (-A + B./Z0 - C.*Z0 + D)./(A + B./Z0 + C.*Z0 + D);
	
	% Check result (while in testing)
	warning("Remove testing commands");
	S_verify = abcd2s(abcd, Z0);
	if S ~= S_verify
		assignin('base', 'S_Microsim', 'S_RFToolbox');
		error("Failed to pass verification!");
	else
		displ(" --> MS_ABCD2S Passed verification");
	end

end