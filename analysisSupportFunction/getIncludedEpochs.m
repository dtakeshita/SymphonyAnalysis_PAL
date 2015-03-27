function [epoch_idx_in, epochID_in] = getIncludedEpochs( cur_node, varargin )
%[epoch_idx_in, epochs_in] = getIncludedEpochs( cur_node, {cellname or epochID_out} )
%Obtain epoch indices for the current node.
%   Detailed explanation goes here
    if nargin == 0 %test purpose
       cellname = '032415Ac11';
       epochID_out = getExcludedEpochs( cellname );
    end
    if nargin >=2
        var_in = varargin{1};
        if ischar(var_in) %assume it's cell name
            epochID_out = getExcludedEpochs( var_in );
        elseif isnumeric(var_in) %assume they are excluded epoch numbers
            epochID_out = varargin{1};
        end        
    end    
    [epochID_in, epoch_idx_in] = setdiff(cur_node.epochID, epochID_out);
end

