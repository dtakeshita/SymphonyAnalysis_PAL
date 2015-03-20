function epochs = addLEDVoltages( epochs )
%Add LED pulse and bakcground voltages to Symphony data (only those with
%old version)
    %% Test purpose
    global ANALYSIS_FOLDER
    if nargin == 0
        load(fullfile(ANALYSIS_FOLDER,'cellData', '031715Ac7'));
        %load('/Users/dtakeshi/Documents/Data/PatchRigData/testfiles/LEDFactorPulse_TestEpochs.mat');%s is loaded
        epochs = cellData.epochs;%epochs is an array of EpochData instances
    end
    %% function main
    [idx_st, idx_ed] = divideSingleEpochGroup(epochs);
    for n=1:length(idx_st)
        tmp = epochs(idx_st(n):idx_ed(n));
        props = checkSameStim(tmp);
        if ~any(strcmp(keys(tmp(1).attributes),'pulseAmplitude'))
            [Vol_LED, V_back, msg] = getLEDstimparams(props,length(tmp));
            for m = idx_st(n):idx_ed(n)
                epochs(m).attributes('backgroundAmplitude') = V_back;
                epochs(m).attributes('pulseAmplitude') = Vol_LED(m-idx_st(n)+1);
                epochs(m).attributes('addedLEDamps') = msg;
            end
            if ~strcmp(msg,'OK')
               warning('Epochs %d to %d: %s',idx_st(n),idx_ed(n),msg);
            end
        end
    end
end


function [idx_st, idx_ed] = divideSingleEpochGroup(epochs)
% Divide the date into each epoch group based on time. 
% Calculate time difference between ending of previous stim and
% beginning of the following stimlus
    if length(epochs) == 1
        idx_st = 1; idx_ed = 1;
        return;
    end
    d_time = 2;%threshold (in sec)
    t_start = get2(epochs,'epochStartTime');
    dur_stim = ( get2(epochs,'preTime') + get2(epochs,'stimTime')...
               + get2(epochs,'tailTime') )/1000;% in second
    try
        time_diff = diff(t_start)-dur_stim(1:end-1);
    catch
        error('problem with dividing epochs into a epoch group');
    end
    idx_st = [1 find(time_diff > d_time)+1];
    idx_ed = [find(time_diff > d_time) length(t_start)];
    %out = arrayfun(@(i1,i2)epochs(i1:i2),idx_st,idx_ed,'uniformoutput',false);
end

function out = checkSameStim(epochs)
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
