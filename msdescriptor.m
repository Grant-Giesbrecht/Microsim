classdef msdescriptor < handle
% MSDESCRIPTOR This class replaces the 'desc' struct in rfmat and
% generalizes the input data to create and describe a mselement object.
%
	properties
		classifier % STR    Desciption such as 'SERIES_ELEMENT', etc
		abcd       % <num>  ABCD parameters of this element alone
		freqs      % <num>  Frequencies over which ABCD are defined
		node1      % num    Name of port 1 node (Will change when combined with other elements)
		node2      % num    Name of port 2 node (will change when combined with other elements)
		
		% Optional parameters
		params     % struct Struct with fields describing parameters used to create this object
				   %   Examples:
				   %                      R
				   %	  Z0              L
				   %      theta_rad       C

	end
	
	methods
		function obj = msdescriptor(classifier)
			obj.classifier = classifier;
			obj.abcd = [];
			obj.freqs = [];
			obj.node1 = 1;
			obj.node2 = 2;
			
			obj.params = struct();
		end
		
		function set_abcd(obj, abcd, freqs)
			% Used to set the ABCD matrix and frequency arrays. Required
			% for complete initialization
			
			obj.abcd = abcd;
			obj.freqs = freqs;
		end
		
		function tf = verify(obj)
			
			tf = true;
			
			% Find classifier
			if strcmp(obj.classifier, 'SER_ELMT')
				
				% Get fields
				keys = ccell2mat(fields(obj.params));
				
				% Throw error if unrecongized fields exist
				if numel(keys) > 0
					warning("Unrecongnized fields in 'params'!");
					tf = false;
					return;
				end
			elseif strcmp(obj.classifier, 'SER_CAP') || strcmp(obj.classifier, 'PAL_CAP')
				
				% Get fields
				keys = ccell2mat(fields(obj.params));
				
				% Check that expected fields are present
				tf = tf && any(keys == "C");
				
				% Throw error if unrecongized fields exist
				if numel(keys) > 1
					warning("Unrecongnized fields in 'params'!");
					tf = false;
					return;
				end
			elseif strcmp(obj.classifier, 'SER_IND') || strcmp(obj.classifier, 'PAL_IND')
				
				% Get fields
				keys = ccell2mat(fields(obj.params));
				
				% Check that expected fields are present
				tf = tf && any(keys == "L");
				
				% Throw error if unrecongized fields exist
				if numel(keys) > 1
					warning("Unrecongnized fields in 'params'!");
					tf = false;
					return;
				end
			elseif strcmp(obj.classifier, 'SER_RES') || strcmp(obj.classifier, 'PAL_RES')
				
				% Get fields
				keys = ccell2mat(fields(obj.params));
				
				% Check that expected fields are present
				tf = tf && any(keys == "R");
				
				% Throw error if unrecongized fields exist
				if numel(keys) > 1
					warning("Unrecongnized fields in 'params'!");
					tf = false;
					return;
				end
			elseif strcmp(obj.classifier, 'TLIN')
				
				% Get fields
				keys = ccell2mat(fields(obj.params));
				
				% Check that expected fields are present
				tf = tf && any(keys == "Z0");
				tf = tf && any(keys == "theta_rad");
				
				% Throw error if unrecongized fields exist
				if numel(keys) > 2
					warning("Unrecongnized fields in 'params'!");
					tf = false;
					return;
				end
			else
				
				% Unrecognized classifier - throw warning
				warning(strcat("Unrecognized classifier: ", obj.classifier));
				tf = false;
			end
			
		end
	end
end