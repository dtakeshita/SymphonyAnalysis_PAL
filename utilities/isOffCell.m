function [OFFcell, spc_diff] = isOffCell( spc_diff, varargin )
%Determine OFF cell or not. Flip the sign of spike count difference
%(post-pre) if it's OFF.
% [OFFcell, spc_diff] = isOffCell( spc_diff, {cellTypeName} )
% spc_diff: difference in spike counts between post and pre (post-pre)
% 
    if nargin >=2
        celltypeName = varargin{1};
    else
        celltypeName = '';
    end
    
    OFFcell = false;
    if ~isempty(celltypeName)%follows cell type if it exists
        if ~isempty(strfind(lower(celltypeName),'off'))
            OFFcell = true;
            spc_diff = -spc_diff;
        end
    elseif sum(spc_diff < 0) > sum(spc_diff > 0)
       spc_diff = -spc_diff;
       OFFcell = true;
    end

end

