function popu_stat = calc_population_stat( s )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %mean
    popu_stat.mean = (s.N.*s.mean)/sum(s.N);
    popu_stat.var = (s.N.*s.SD.^2)/sum(s.N);% Estimated as sum(N*Var)/sum(N)-check! 
end

