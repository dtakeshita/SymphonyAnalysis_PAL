function FH = plot_PSTHs( cur_node, FHoffset )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    fig_para.FHoffset = FHoffset;
    %% plot spike count vs R*
    fig_para.nrow = 3;
    fig_para.ncol = 3;
    fig_para.nTotalGraphs = 1; 
    
    fig_para.annotation.string = cur_node.name;
%     ngph_fig = nrow*ncol;
    dat.x = cur_node.RstarMean;
    dat.y = cur_node.spikeCount_poststim.mean;
    dat.y_error = cur_node.spikeCount_poststim.SEM;
    ngph = 1;
    fig_para.xlabel.string = 'Rstar'; 
    fig_para.ylabel.string = 'Spike Count';
    %fig_para.line_prop.marker = 'o';-this doesn't work so far
    
    %Linear plot
    fig_para.title.string = 'Linear scale';
    [ngph, ~, LH] = tile_graphs(dat,fig_para, @errorbar, ngph, FHoffset);

    
    %PSTH

end

