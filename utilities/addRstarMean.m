function addRstarMean( epochs, file_name)
%Add LED pulse and bakcground voltages to Symphony data (only those with
%old version)
    %% Test purpose
    if nargin == 0
        clear; close all;
        load('/Users/dtakeshi/Documents/Data/RigA/testfiles/LEDFactorPulse_TestEpochs.mat');%s is loaded
        epochs = s.epochs;%epochs is an array of EpochData instances
        rig_name = 'a';exp_yr = '2015'; exp_date = '0127';
    else
        [rig_name, exp_yr, exp_date] = fname2info( fname );
    end
    %% function main
    %read NDFs
    [t_NDF, NDFs] = readNDF_log(rig_name, exp_yr, exp_date);
    OD_list = readNDFcalibration();
    % Load linearity correction table
    t_stim_set = unique(get2(epochs,'stimTime'));
    ch_LED_set = unique(get2(epochs,'StimulusLED'));
    tableMap = readLinearityCorrection(rig_name, ch_LED_set, t_stim_set);
    % Do!!--Get reference voltage & intensity and calculate R* value!!
    intensity2Rstar();
    
    for n=1:length(epochs)
        t_data = epochs(n).attributes('inputTime');
        namesNDF = getNDFnames(t_data, t_NDF, NDFs); 
        trans = getTransmittance(namesNDF,rig_name);
        ch_LED = epochs(n).attributes('StimulusLED');
        vol = epochs(n).attributes('pulseAmplitude');
        t_stim = epochs(n).attributes('stimTime');
        namesNDF = getNDFnames(t_data, t_NDF, NDFs);
        trans = getTransmittance(namesNDF,rig_name);
        table_key = sprintf('%s-%dms',ch_LED,t_stim);
        table = tableMap(table_key);
        %Do!!--convert voltage to R*!!!
        %R*_V = R*Vref * C(V)/C(Vref)
        
        
    end
end


function namesNDF = getNDFnames(t_data, t_NDF, NDFs)
    t_data = datenum(t_data)-floor(datenum(t_data));
    idx = find(t_data > t_NDF,1,'last');
    nNDFs = size(NDFs,2);
    if isempty(idx)
        namesNDF = '';
    else
        namesNDF = NDFs(idx,:);
    end
end

function out = create(epochs)
    list_properties = {'LEDbackground','StimulusLED','displayName','initialPulseAmplitude',...
             'numberOfIntensities','numberOfRepeats',...
             'preTime','scalingFactor','stimTime','tailTime'};
    vals = cell( list_properties);
    for n=1:length(list_properties)
        props = get2(epochs, list_properties{n});
        if ~is_allequal(props);
            error(['Dividing into epoch groups is not correctly done!'])
        else
            if iscell(props)
                vals{n} = props{1};
            else
                vals{n} =  unique(props);
            end
        end
    end
    out = cell2struct(vals, list_properties,2);
end

function out = is_allequal(v)
    if iscell(v) 
        if ischar(v{1})
            out = all(strcmp(v(:),v(1)));
        elseif isnumeric(v{1})
            out = all(cellfun(@(x)all(eq(x,v{1})),v,'uniformoutput',true));
        end
    elseif isnumeric(v)
        out = all(v(:)==v(1));
    else
        out = false;
    end
end
