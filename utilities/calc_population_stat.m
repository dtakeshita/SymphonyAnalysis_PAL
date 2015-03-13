function popu_stat = calc_population_stat( s )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %mean
    popu_stat.mean = sum(s.N.*s.mean)/sum(s.N);
    popu_stat.var = sum(s.N.*s.SD.^2)/sum(s.N);% Estimated as sum(N*Var)/sum(N)-check! 
    popu_stat.SD = sqrt(popu_stat.var);
end

