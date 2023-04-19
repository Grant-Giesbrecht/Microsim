classdef mselement < handle
% MSELEMENT This class represents one or more RF circuit elements in matrix
% form.
%
% This class was taken from rfmat in 'Eneceladus' and borrows elements from
% 'rfnet' in 'Eneceladus' as well.
%
	properties
		abcd  % ABCD matrix for entire element
		freqs % Frequencies over which ABCD exists
		desc  % Description of how this element was generated. TODO: Reform
	end
	
	methods
		function obj = mselement(freqs)
			obj.abcd = zeros(2, 2, numel(freqs));
			obj.freqs = freqs;
			obj.desc = [];
		end
		
		function set_desc(obj, desc)
			% Initializes the MSE with a descriptor object and updates that
			% descriptor object to have the correct ABCD matrix and freq
			% list. This should only be called if the MSE does not have
			% sub-components
			
			% Check that desc is empty
			if numel(obj.desc) > 0
				warning("Inappropriate call to set_desc()!");
			end
			
			% Update ABCD and Freq parameters
			desc.abcd = obj.abcd;
			desc.freqs = obj.freqs;
			
			% Add to list
			obj.desc = desc;
		end
		
		function series(obj, mse)
			
			% Check freqs match
			if obj.freqs ~= mse.freqs
				error("Cannot multiply mselements with dissimilar frequency points.");
			end
			
			% Update object description ---------------------------------
			
			% Get last node from current description list
			add_node = obj.desc(end).node2 - 1;
			
			% Check that new element starts with node 1
			if mse.desc.node1 ~= 1
				warning("Failed to add element. Provided element has invalid netlist (node list must start at 1).");
				return;
			end
			
			% Loop over provided element's descriptors, adding 1 at a time
			for de = mse.desc
				
				% Add element
				obj.desc(end+1) = copyh(de);
				
				% Update node naming
				obj.desc(end).node1 = obj.desc(end).node1 + add_node;
				obj.desc(end).node2 = obj.desc(end).node2 + add_node;

			end
			
			% Update ABCD with Chained matricies
			for iter = 1:numel(obj.freqs)
				obj.abcd(:,:, iter) = obj.abcd(:,:,iter) * mse.abcd(:,:, iter);
			end
			
		end
		
		function parallel(obj, mse)
			
			% Check freqs match
			if obj.freqs ~= mse.freqs
				error("Cannot multiply mselements with dissimilar frequency points.");
			end
			
			% Update object description ---------------------------------
			
			% Get last node from current description list
			add_node = obj.desc(end).node2 - 2; % Add this to each of mse's nodes EXCEPT the first, which is unmodified
			last_node = obj.desc(end).node2 - 1 + numel(mse.desc); % Last node number (To verify)
			
			% Check that new element starts with node 1
			if mse.desc(1).node1 ~= 1
				warning("Failed to add element. Provided element has invalid netlist (node list must start at 1).");
				return;
			end
			
			% Modify node2 of last original element
			obj.desc(end).node2 = last_node;
			
			% Loop over provided element's descriptors, adding 1 at a time
			for de = mse.desc
				
				% Add element
				obj.desc(end+1) = copyh(de);
				
				% Update node naming
				if obj.desc(end).node1 ~= 1
					obj.desc(end).node1 = obj.desc(end).node1 + add_node;
				end
				if obj.desc(end).node2 ~= 1
					obj.desc(end).node2 = obj.desc(end).node2 + add_node;
				end

			end
			
			% Update ABCD with Chained matricies --------------------------
			
			% Calculate parallel Elements
			Apall = (obj.abcd(1,1,:).*mse.abcd(1,2,:) + mse.abcd(1,1,:).*obj.abcd(1,2,:))./(obj.abcd(1,2,:) + mse.abcd(1,2,:));
			Bpall = obj.abcd(1, 2, :) .* mse.abcd(1, 2, :) ./ ( obj.abcd(1, 2, :) + mse.abcd(1, 2, :) );
			Cpall = obj.abcd(2, 1, :) + mse.abcd(2, 1, :) + (mse.abcd(2, 2, :) - obj.abcd(2, 2, :) ).*( obj.abcd(1, 1, :) -  mse.abcd(1, 1, :) )./(obj.abcd(1, 2, :) + mse.abcd(1, 2, :));
			Dpall = (obj.abcd(2,2,:).*mse.abcd(1,2,:) + mse.abcd(2,2,:).*obj.abcd(1,2,:))./(obj.abcd(1,2,:) + mse.abcd(1,2,:));
			
			% Add to element
			obj.abcd(1, 1, :) = Apall;
			obj.abcd(1, 2, :) = Bpall;
			obj.abcd(2, 1, :) = Cpall;
			obj.abcd(2, 2, :) = Dpall;
			
		end
		
		function [tstr, mt] = table(obj)
			
			mt = MTable();
			mt.row(["Class", "Node 1", "Node 2"]);
			
			for d = obj.desc
				mt.row([d.classifier, num2fstr(d.node1), num2fstr(d.node2)]);
			end

			tstr = mt.str();
		end
	end
end


