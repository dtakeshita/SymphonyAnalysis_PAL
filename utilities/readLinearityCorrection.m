function out = readLinearityCorrection( rig_name, ch_LED_set, t_stim_set )
%Read mat files for linearity correction. The file is generated with
%analyze_S450stream.
%   Detailed explanation goes here
     if nargin == 0 %test purpose
         rig_name = 'a';
         ch_LED_set = {'Ch1'};
         t_stim_set = [20 500 5000];
     end
     file_root = '/Users/dtakeshi/Documents/Data/StimulusCalibration/Photodiode/';
     file_folder = 'ForLinearityCorrection';
     rig_folder = ['Rig',upper(rig_name)];
     file_fullpath = fullfile(file_root,rig_folder,file_folder);
     out = containers.Map();
     for nc=1:length(ch_LED_set)
         for nt = 1:length(t_stim_set)
             ch_LED = ch_LED_set{nc};
             t_stim = t_stim_set(nt);
             % get a list of possible files
             flist = search_same_channel(ch_LED,file_fullpath);
             if length(flist) ==0%No match-give an error
                 error('No file found');
             elseif length(flist) > 1 %Select the best file
                flist = choose_bestmatch(flist,t_stim);
             end
             % load and store in a map
             Linearity= load_table(file_fullpath, flist, ch_LED, t_stim);
             str = sprintf('%s-%dms',ch_LED, t_stim);
             out(str) = Linearity;
         end
     end

end

function out = load_table(file_fullpath, flist, ch_LED, t_stim)
    %load file
    load(fullfile(file_fullpath, flist.name));%V, Cmean, Cstd are loaded
    Linearity.folder = file_fullpath;
    Linearity.fname = flist.name;
    Linearity.Voltage = V;
    Linearity.Mean = Cmean;
    Linearity.SD = Cstd;
    out = Linearity;

end

function flist = search_same_channel(ch_LED,file_path)
    fname = sprintf('ForLinearity*%s*.mat',ch_LED);
    flist = dir(fullfile(file_path,fname));
end

function out = choose_bestmatch(flist,t_stim)
    info = struct2cell(flist);
    fnames = info(1,:)
    [t_stim_list, idx_sort] = sort(cellfun(@(x)str2num(pick_str(x,'stim','ms',1,1)),fnames));%in ascending order
    idx = find(t_stim == t_stim_list);
    if isempty(idx)
        idx_larger = find(t_stim_list > t_stim,1,'first');
        if ~isempty(idx_larger)
            out = flist(idx_sort(idx_larger));
        else
            idx_smaller = find(t_stim_list < t_stim,1,'last');
            out = flist(idx_sort(idx_smaller));
        end
    elseif length(idx)==1
        out = flist(idx_sort(idx));
    elseif length(idx) > 1
        error(['too many files!!'])
    end
end

function search_files(ch_LED, t_stim_set)
    flist = search_single_file(ch_LED,t_stim);
end

function flist = search_single_file(ch_LED,t_stim)
    fname = sprintf('ForLinearity*%s*%dms*.mat',ch_LED,t_stim);
    flist = dir(fullfile(file_fullpath,fname));
end

