function tr = calcSpikeCountDiff(tr,param)
%Calculate the frequency of seeing.
%tr: subtree of analysisTree (the root being the top of DataSet (=e.g.
%LightStep_20)
%   Detailed explanation goes here
    %construct template
    if nargin==0%test purpose
        global ANALYSIS_FOLDER
        fname = '032415Ac11.mat';
        load(fullfile(ANALYSIS_FOLDER,'analysisTrees',fname));
        tr = analysisTree;
        stimulus_type = 'LightStep_20';
        idx = find(tr.treefun(@(x)~isempty(strfind(x.name,stimulus_type))));
        tr = tr.subtree(idx);
        param.n_epoch_min = 5;%minimum # of trials required
        %param.binwidth = 10;%Bin size for spike count histogram (in msec)
        param.twindow = 400;%msec
    end
    v2struct(param);
    %tr = addSpikeCountHist(tr,param.binwidth);%calculate spike count histogramspc
    %% Calculate the mean spike count and save on the root-should this be in addSpikeCOuntHist?
    childID = tr.getchildren(1);   
    %% Get template & go through each node to calculate inner product
    twindow = twindow/1000;%convert from msec to sec
    parent_node = tr.get(1);
    xvalue = parent_node.meanSpikeCountHist.xvalue;
%     mean_spc = parent_node.meanSpikeCountHist.value;  
    %Note: In spike timings, 0 corresponds to stimuls onset
    %(calculated in getEpochResponses_CA_PAL)
    stim_on = 0;
    stim_off = parent_node.stimOffset-parent_node.stimOnset;
    idx_pre = stim_on-twindow <= xvalue  & xvalue < stim_on;
    idx_post =  stim_off <= xvalue  & xvalue < stim_off+twindow;
%     if ~isempty(mean_spc)
%         template_all = mean_spc(idx_post)-mean_spc(idx_pre);
%     else
%         return;
%     end
    %mean_pre_spc = mean(mean_spc(idx_pre));%mean pre firing rate
    childID = tr.getchildren(1);
    n_child = length(childID);
    FOS_corr = NaN*ones(n_child,1);
    FOS_incorr = FOS_corr;
    splitValue = FOS_corr;
    nEpochSet = FOS_corr;
    for nc = 1:n_child
        %% If one wants to exclude current epoch from the template
        %% need to go gack to mean_spc
        cur_node = tr.get(childID(nc));
        [~, epoch_idx_in] = setdiff(cur_node.epochID, epochID_out);
        pre_stim = cur_node.spikeCountHist.value(epoch_idx_in ,idx_pre);
        n_epoch = size(pre_stim,1);
        if n_epoch < n_epoch_min
            continue;
        else
            nEpochSet(nc) = n_epoch;
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
    parent_node.FOS.Nepoch = nEpochSet(~isnan(nEpochSet));
    parent_node.FOS.param = param;
    tr = tr.set(1, parent_node);
    %plot(parent_node.RstarMean, FOS_corr,'o-')
end

