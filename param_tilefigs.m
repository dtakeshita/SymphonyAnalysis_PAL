function param = param_tilefigs()
%Parameters for tiling graphs. One could use inputParser in the future
%   Detailed explanation goes here
    nrow = 3;
    ncol = 3;
    ngph = 1;
    FHoffset = 0;
    param = v2struct(nrow,ncol,ngph,FHoffset);        

end

