function summaryAnalysis()
    global ANALYSIS_FOLDER
    cellName = '012715Ac2';
    load([ANALYSIS_FOLDER 'analysisTrees' filesep cellName]);%analysisTree is loaded
    tr = analysisTree;
    idx = find(tr.treefun(@(x)~isempty(strfind(x.name,'LightStep_20'))));
    for n=1:length(idx)
        %First level analysis (response vs R*) should be done here!
        
        %Second level analysis (raster, etc.)
        childID = tr.getchildren(idx(n));
        n_child = length(childID);
        %% plot raster
        LineFormat.color = [0 0 0];
        nrow = 4; ncol = 2;
        ngph_fig = nrow*ncol;
        nTotalGraphs = n_child;
        ngph = 1;
        ann_txt = tr.Node{idx(1)}.name;
        for nc = 1:n_child
            cur_node = tr.Node{childID(nc)};
            [FH,GH]=get_subplot_id(nrow,ncol,ngph);
            figure(FH)
            subplot(nrow,ncol,GH)
            plotSpikeRaster(cur_node.spikeTimes_all.value,...
                'PlotType','vertline','LineFormat',LineFormat,...
                'VertSpikeHeight',0.8,'XLimForCell',[-0.5 0.52]);
            title(cur_node.name);
            ngph = enlargeFigure(ngph, ngph_fig, nTotalGraphs,FH,ann_txt);
        end
        %% plot base firing rate stat
        FH = FH+1;
        
        
    end
end