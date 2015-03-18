
function  tr = addSpikeCountHist( tr, binwidth)
%Go through a tree and add spike count histogram to each tree
% tr: analysisTree(this has to be the root of DataSet (=e.g. LightStep_20))
%Note: This function should eventually be replaced with something like
%treeFunction

%     global ANALYSIS_FOLDER
%     if nargin == 0 %test
%         fname = '022415Ac4.mat';
%         load(fullfile(ANALYSIS_FOLDER,'analysisTrees',fname));
%     end
    % make template-Do!! get single spike counts from all the trial from
    %binwidth = 10;%msec
    % spike timing
    %parent_node = tr.Node{1};
    %parent_node = tr.get(1);%Parent node of each DataSet (=LightStep_20)
    childID = tr.getchildren(1);
    for nc = 1:length(childID)
        cur_node = tr.get(childID(nc));
        try
        [cur_node.spikeCountHist.value, cur_node.spikeCountHist.xvalue] = calcSpikeCountHist(cur_node, binwidth);
        catch
            2;
        end
        tr = tr.set(childID(nc), cur_node);
    end  
end

function [spc_hist, t] = calcSpikeCountHist(node, binwidth)
    %Note: In spike timings, 0 corresponds to the stimulus onset 
    %caluclated in getEpochResponses_CA_PAL)
    binwidth = binwidth/1000;%convert to sec
    spt_set = node.spikeTimes_all.value;
    rec_on =  node.recordingOnset.value;
    rec_off = node.recordingOffset.value;
    %t = rec_on:binwidth:rec_off;
    t_right = 0:binwidth:rec_off;
    t_left = -binwidth:-binwidth:rec_on;
    t = [t_left(end:-1:1) t_right];
    spc_set = cellfun(@(spt)hist(spt,t),spt_set,'UniformOutput',false);
    spc_hist = cell2mat(spc_set');
    %test purpose
%     figure;
%     plot(t,mean(spc_hist,1))
%     title(node.name)
%     2;
end