function S = my_rmfiled( S, S_fields )
%Check a field exist before try to remove.
%   Detailed explanation goes here
    if ischar(S_fields)
        S_fields = {S_fields};
    end
    for n=1:length(S_fields)
       f = S_fields{n};
       if isfield(S,f)
           S = rmfield(S,f);
       end
    end
end

