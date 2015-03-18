function tr = calcFOS(tr,param)
%Calculate the frequency of seeing.
%tr: subtree of analysisTree (the root being the top of DataSet (=e.g.
%LightStep_20)
%   Detailed explanation goes here
    %construct template
    if nargin==0%test purpose
        global ANALYSIS_FOLDER
        fname = '022415Ac8.mat';
        load(fullfile(ANALYSIS_FOLDER,'analysisTrees',fname));
        tr = analysisTree;
        stimulus_type = 'LightStep_20';
        idx = find(tr.treefun(@(x)~isempty(strfind(x.name,stimulus_type))));
        tr = tr.subtree(idx);
        param.n_epoch_min = 30;%minimum # of trials required
        param.binwidth = 10;%Bin size for spike count histogram (in msec)
        param.twindow = 400;%msec
    end
    v2struct(param);
    tr = addSpikeCountHist(tr,param.binwidth);%calculate spike count histogramspc
    %% Calculate the mean spike count and save on the root-should this be in addSpikeCOuntHist?
    childID = tr.getchildren(1);
    spc_all = [];
    N_all = 0;
    for nc = 1:length(childID)
        cur_node = tr.get(childID(nc));
        cur_spc = cur_node.spikeCountHist.value;
        n_epoch = size(cur_spc,1);
        if nc==1
            spc_xval = cur_node.spikeCountHist.xvalue;
            stim_on = cur_node.stimOnset.value;
            stim_off = cur_node.stimOffset.value;
        end
        if n_epoch < n_epoch_min
            continue;
        else
            spc_all = [spc_all;cur_spc];
            N_all = N_all + n_epoch;
        end
        if any(cur_node.spikeCountHist.xvalue~=spc_xval)
           error(['xvalue for histgram is different for different node!']);
        end
        if cur_node.stimOnset.value ~= stim_on || cur_node.stimOffset.value ~= stim_off
           error(['stimulus duration is different for different node']);
        end
    end  
    cur_node = tr.get(1);
    cur_node.meanSpikeCountHist.value = mean(spc_all,1);
    cur_node.meanSpikeCountHist.Nepoch = N_all;
    cur_node.meanSpikeCountHist.xvalue = spc_xval;
    cur_node.meanSpikeCountHist.Nepoch_min = n_epoch_min;
    cur_node.stimOnset = stim_on;
    cur_node.stimOffset = stim_off;
    tr = tr.set(1, cur_node);
    
    %% Get template & go through each node to calculate inner product
    twindow = twindow/1000;%convert from msec to sec
    parent_node = tr.get(1);
    xvalue = parent_node.meanSpikeCountHist.xvalue;
    mean_spc = parent_node.meanSpikeCountHist.value;  
    %Note: In spike timings, 0 corresponds to stimuls onset
    %(calculated in getEpochResponses_CA_PAL)
    stim_on = 0;
    stim_off = parent_node.stimOffset-parent_node.stimOnset;
    idx_pre = stim_on-twindow <= xvalue  & xvalue < stim_on;
    idx_post =  stim_off <= xvalue  & xvalue < stim_off+twindow;
    if ~isempty(mean_spc)
        template_all = mean_spc(idx_post)-mean_spc(idx_pre);
    else
        return;
    end
    mean_pre_spc = mean(mean_spc(idx_pre));%mean pre firing rate
    childID = tr.getchildren(1);
    n_child = length(childID);
    FOS_corr = NaN*ones(n_child,1);
    FOS_incorr = FOS_corr;
    splitValue = FOS_corr;
    for nc = 1:n_child
        %% If one wants to exclude current epoch from the template
        %% need to go gack to mean_spc
        cur_node = tr.get(childID(nc));
        pre_stim = cur_node.spikeCountHist.value(:,idx_pre)-mean_pre_spc;
        if size(pre_stim,1) < n_epoch_min
            continue;
        end
        post_stim = cur_node.spikeCountHist.value(:,idx_post)-mean_pre_spc;
        dot_pre = pre_stim*template_all';
        dot_post = post_stim*template_all';
        FOS_corr(nc) = (sum(dot_pre < dot_post) + 0.5*sum(dot_post==dot_pre))/length(dot_pre);
        FOS_incorr(nc) =  (sum(dot_pre > dot_post) + 0.5*sum(dot_post==dot_pre))/length(dot_post);
        splitValue(nc) = cur_node.splitValue;
    end
    parent_node.FOS.value = FOS_corr(~isnan(FOS_corr));
    parent_node.FOS.xvalue = splitValue(~isnan(splitValue));
    parent_node.FOS.param = param;
    tr = tr.set(1, parent_node);
    %plot(parent_node.RstarMean, FOS_corr,'o-')
end
