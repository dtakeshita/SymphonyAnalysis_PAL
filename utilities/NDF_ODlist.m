function OD = NDF_ODlist( str )
%A list of optical densities of NDFs 
%   Detailed explanation goes here
    
    %Filters from Suction rig

% New measurements by Lina (Apr 27, 2015)
%     Ch1 (590nm)
% NDF c2A: OD = 1.913
% NDF c0.5C: OD = 0.418
% NDF c1A: OD = 0.915
% NDF c3A: OD = 3.114
% NDF c1B: OD = 0.964
% NDF c1C: OD = 0.983
% 
% Ch2 (660nm)
% NDF c2B: OD = 1.909
% NDF c0.5A: OD = 0.472
% NDF c1A: OD = 0.903
% 
% Ch3 (740nm)
% NDF c1B: OD = 0.887
% NDF c2C: OD = 1.801
% NDF c3A: OD = 2.812

    
    switch lower(str)
        case 'c0.5a'
            OD = 0.471;
        case 'c0.5b'
            OD = 0.464;
        case 'c0.5c'
            OD = 0.418;
        case 'c1a'
            OD = 0.905;
        case 'c1b'
            %OD = 0.967;%old measurment
            OD = 0.887;
        case 'c1c'
            OD = 0.983;
        case 'c2a'
            OD = 1.913;
        case 'c2b'
            OD = 1.916;
        case 'c2c'
            %OD = 2.002;%old measurement
            OD = 1.802
        case 'c3a'
            %OD = 3.135;
            OD = 2.812;
        case {'a1a','a1'}%patch rig
            OD = 0.91;
        case {'a2a','a2'}
            OD = 2.245;
        case {'a3a','a3'}
            OD = 3.4673; %2015_0307, others are from 2015_0131
        case {'a4a','a4'}
            OD = 4.343;
        case {'nan',''}
            OD = 0;
        otherwise
            error(['NDF ',str,' is UNKNOWN!']);
    end
end

