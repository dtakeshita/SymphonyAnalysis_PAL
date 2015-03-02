function summaryAnalysis()
    close all;
    global ANALYSIS_FOLDER
    save_path = fullfile(ANALYSIS_FOLDER,'SummaryPlots');
    cellName_set = uigetfile([ANALYSIS_FOLDER,'analysisTrees' filesep],'MultiSelect','on');
    if ~iscell(cellName_set)
       cellName_set = {cellName_set}; 
    end
    
    for ncell = 1:length(cellName_set)
        %cellName = '012715Ac1';%012715c1:OFF, c2:ON
        try
        cellName = rm_ext(cellName_set{ncell});
        catch
            2;
        end
        load([ANALYSIS_FOLDER 'analysisTrees' filesep cellName]);%analysisTree is loaded
        tr = analysisTree;
        load([ANALYSIS_FOLDER 'cellData' filesep cellName]);%cellData is loaded
        cdat = cellData;
        analysis_class = 'LightStep';
        %idx = find(tr.treefun(@(x)~isempty(strfind(x.name,analysis_class))));
        idx = find(tr.treefun(@(x)~isempty(strfind(x.name,'LightStep_20'))));
        FH_prv = 0;
        for n=1:length(idx)
            %% Analysis over leaves (e.g. response vs R*, etc.) should be done here!
            cur_parent = tr.Node{idx(n)};
            [FH, ngph,fig_para, OFFcell] = plot_responses( cur_parent, FH_prv );
            [FH, ngph,fig_para, OFFcell] = plot_PSTHs( cur_parent, FH-1, ngph-1, fig_para, OFFcell, 0 ); %no smoothing
            clear fig_para.axis_prop;
            [FH, ngph,fig_para, OFFcell] = plot_PSTHs( cur_parent, FH-1, ngph-1, fig_para, OFFcell, 50 ); %Smoothing 50ms window (=5 data pts)
            %% Analysis for each leaf (raster, etc.)
            childID = tr.getchildren(idx(n));
            n_child = length(childID);
            %% plot raster-move to a function
            FH_prv = FH;
            LineFormat.color = [0 0 0];
            nrow = 4; ncol = 2;
            ngph_fig = nrow*ncol;
            nTotalGraphs = n_child;
            ngph = 1;
            ann_txt = tr.Node{idx(n)}.name;
            for nc = 1:n_child
                cur_node = tr.Node{childID(nc)};
                [FH,GH]=get_subplot_id(nrow,ncol,ngph);
                FH = FH + FH_prv;
                figure(FH)
                set(FH,'visible','off');
                subplot(nrow,ncol,GH)
                %% Get epoch interval from the tree analysis!!!
                plotSpikeRaster(cur_node.spikeTimes_all.value,...
                    'PlotType','vertline','LineFormat',LineFormat,...
                    'VertSpikeHeight',0.8,'XLimForCell',...
                    [cur_node.recordingOnset.value cur_node.recordingOffset.value],...
                    'FigHandle',FH);
                title(cur_node.name);
                ngph = enlargeFigure(ngph, ngph_fig, nTotalGraphs,FH,ann_txt);
            end
            %% Reset counters for a new set of graphs
            FH_prv = FH;
            ngph = 1;
            %% plot base firing rate stat
            nrow = 4; ncol = 3;
            for nc = 1:n_child
                cur_node = tr.Node{childID(nc)};
                %Leave this for amplitude
                [FH,GH]=get_subplot_id(nrow,ncol,ngph);
                FH = FH + FH_prv;
                figure(FH)
                set(FH,'visible','off');
                subplot(nrow,ncol,GH)
                % Plot data here!
                txt_ttl = sprintf('%s-amplitude',cur_node.name);
                title(txt_ttl)
                ngph = enlargeFigure(ngph, ngph_fig, nTotalGraphs,FH,ann_txt);
                %plot pre firing rate
                [FH,GH]=get_subplot_id(nrow,ncol,ngph);
                FH = FH + FH_prv;
                figure(FH)
                %set(FH,'visible','off');
                subplot(nrow,ncol,GH)
                plot(cur_node.baselineRate.value,'o-');
                hold on
                statlines = [cur_node.baselineRate.mean;...
                    (cur_node.baselineRate.mean -cur_node.baselineRate.SD);...
                    (cur_node.baselineRate.mean +cur_node.baselineRate.SD)];
                hlines(statlines);

                title('Pre firing rate')
                xlabel('Epoch'); ylabel('Firing rate (Hz)');
                txt_ttl = sprintf('%s-pre firing rate',cur_node.name);
                title(txt_ttl)
                ngph = enlargeFigure(ngph, ngph_fig, nTotalGraphs,FH,ann_txt);
                %plot post firing rate
                [FH,GH]=get_subplot_id(nrow,ncol,ngph);
                FH = FH + FH_prv;
                figure(FH)
                set(FH,'visible','off');
                subplot(nrow,ncol,GH)
                plot(cur_node.poststimRate.value,'o-');
                hold on
                statlines = [cur_node.poststimRate.mean;...
                    (cur_node.poststimRate.mean -cur_node.poststimRate.SD);...
                    (cur_node.poststimRate.mean +cur_node.poststimRate.SD)];
                hlines(statlines);
                title('Post firing rate')
                xlabel('Epoch'); ylabel('Firing rate (Hz)');
                txt_ttl = sprintf('%s-post firing rate',cur_node.name);
                title(txt_ttl)
                ngph = enlargeFigure(ngph, ngph_fig, nTotalGraphs,FH,ann_txt);
            end
            %% Reset counters for a new set of graphs
            FH_prv = FH;
            %% plot epoch data and spike timing
            epochs_para.max_ngrph_per_node = 15;epochs_para.fig_prop.Visible = 'off';
            plotEpochs( tr, idx(n), cellData, FH_prv, epochs_para );
        end
        sname = sprintf('SummaryPlot_%s.pdf',cellName);
        Y = 20.984;X = 29.6774;
        xMargin = 1;               %# left/right margins from page borders
        yMargin = 1;               %# bottom/top margins from page borders
        xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
        ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)
        hFig = findobj('type','figure');
        set(hFig, 'PaperUnits','centimeters')
        set(hFig, 'PaperSize',[X Y])
        set(hFig, 'PaperPosition',[xMargin yMargin xSize ySize])
        set(hFig, 'PaperOrientation','Portrait')

        save_figs('', sname,save_path,'saveas');
    end
end