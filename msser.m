function element = msser(mse1, mse2)
% MSSER Add two mselement objects in series
%
%	MSSER(MSE1, MSE2) Creates a new mselement object that includes MSE1 and
%	MSE2 in series.
%

	% Create a copy of one of the elements
	element = copyh(mse1);
	
	% Apply the series operation
	element.series(mse2);

end