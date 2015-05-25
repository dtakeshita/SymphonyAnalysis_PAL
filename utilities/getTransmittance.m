function trans = getTransmittance( para, rigname )
%Calculate transmittance based on NDF
%   Detailed explanation goes here
    if isstruct(para)
        if ~isfield(para,'NDF1')
            trans = 1;
            return;
        end
        nNDFs = 3;%# of fields defined (at the moment 3)
        opt = 'struct';
    elseif iscell(para) 
        nNDFs = length(para);
        opt = 'cell';
    elseif isempty(para)
        trans = 1;
        return;
    end
    OD = zeros(nNDFs,1);
    for n=1:nNDFs
        if strcmp(opt,'struct')
            OD_str = getfield(para,sprintf('NDF%d',n));
        else
            OD_str = para{n};
        end
        OD_str = lower(OD_str);
        if ~isempty(OD_str) && ~strcmp(OD_str,'nan') && OD_str(1)<'a'
           OD_str = [rigname,OD_str];
        end
        OD(n) = NDF_ODlist(OD_str);%ODs are hard-coded in this file!!
    end
    trans = 10^sum(-OD);
end

