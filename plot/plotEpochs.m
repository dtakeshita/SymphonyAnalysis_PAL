function [FH, ngph] = plotEpochs( tr, idx_parent, cellData, FHoffset, fig_para )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        % Plot raw signals (check sorting)
    analysis_class = 'LightStep';
    %fig_para.FHoffset = FHoffset;
    fig_para.nrow = 5;
    fig_para.ncol = 4;
    fig_para.nTotalGraphs = Inf; 
    params.deviceName = tr.Node{1}.device;
    dataSetName = pick_str(tr.Node{idx_parent}.name,analysis_class,':',0,1);
    %temporary solution
    analysisClass = LightStepAnalysis(cellData, dataSetName, params);
    device = params.deviceName;
    childID = tr.getchildren(idx_parent);
    nchild = length(childID);
    ngph = 1;
    for n=1:nchild
        currNode = tr.subtree(childID(n));
        nodeData = currNode.get(1);
        n_epoch = length(nodeData.epochID);
        inc = ceil(n_epoch/fig_para.max_ngrph_per_node);
        for idx=1:inc:n_epoch
            dat =v2struct(analysisClass, currNode, cellData, device, idx);
            [ngph, FH, AH, LH] = tile_graph( dat, fig_para, @plotEpochData, ngph, FHoffset);
            h_ttl = get(AH,'title');
            str_ttl = sprintf('R*%4.2g,epch%d,%d/%d',nodeData.splitValue,...
                nodeData.epochID(idx), idx, n_epoch);
            set(h_ttl,'String',str_ttl);
            %temp hack-assume longest data set is voltage/current trace
            [~,idx_trace] = max(arrayfun(@(x)length(x.XData),LH));
            ymin = min(LH(idx_trace).YData); ymax = max(LH(idx_trace).YData);
            set(gca,'xlim',[0 0.2], 'ylim',[ymin ymax]);
        end
    end
    
end

