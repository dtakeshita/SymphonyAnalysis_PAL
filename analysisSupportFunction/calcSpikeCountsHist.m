
function  tr = addSpikeCountsHist( tr, binwidth)
%UNTITLED Summary of this function goes here
% tr: analysisTree(has to be the root of DataSet (=e.g. LightStep_20)
%   Detailed explanation goes here
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
        [cur_node.spikeCountHist.value, cur_node.spikeCountHist.xvalue] = calcSpikeCountHist(cur_node, binwidth);
        tr = tr.set(childID(nc), cur_node);
    end  
end

function [spc_hist, t] = calcSpikeCountHist(node, binwidth)
    binwidth = binwidth/1000;%convert to sec
    spt_set = node.spikeTimes_all.value;
    
    rec_on =  node.recordingOnset.value;
    rec_off = node.recordingOffset.value;
    t = rec_on:binwidth:rec_off;
    spc_set = cellfun(@(spt)hist(spt,t),spt_set,'UniformOutput',false);
    spc_hist = cell2mat(spc_set');
    %test purpose
%     figure;
%     plot(t,mean(spc_hist,1))
%     title(node.name)
%     2;
end