function [ output_args ] = plotEpochs( tr, idx_parent, cellData, FHoffset )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        % Plot raw signals (check sorting)
        analysis_class = 'LightStep';
        %fig_para.FHoffset = FHoffset;
        fig_para.nrow = 3;
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
            %temp.plotEpochData(node, cellData, device, epochIndex);
            %emp.plotEpochData(cur_node, cellData, params.deviceName, 1);
            dat =v2struct(analysisClass, currNode, cellData, device)
            [ngph, FH, LH] = tile_graph( dat, fig_para, @plotEpochData, ngph, FHoffset)
        end
end

