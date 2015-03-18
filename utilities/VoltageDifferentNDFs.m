function Vout = VoltageDifferentNDFs( Vin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    if nargin==0
       Vin = [2000]; 
    end
    rig ='a'; LED_ch = 'ch1';t_stim = 20;
    ODin = 6.4890;%NDFa2a+a4a
    ODout = 7.7754;%NDFa3a+a4a
    %ODout = 6.3318;%NDFa4a+a1a+a1.3a
    trans_in = 10^-ODin;
    trans_out = 10^-ODout;
    tableMap = readLinearityCorrection(rig, {LED_ch}, t_stim);
    table = tableMap('ch1-20ms');
    Cout = interp1(table.Voltage,table.Mean,Vin)*trans_in/trans_out;
    Vout = interp1(table.Mean, table.Voltage, Cout)
    2;
end

