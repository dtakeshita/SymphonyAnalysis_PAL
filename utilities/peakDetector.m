%Spike detection
%DT-The code is originally written possibly by Greg Schwartz
%spt:spike timing in second (note that the previous version spits out indices rather
%than timing of spikes)
function [spt, spikeAmps, minSpikePeakInd, maxNoisePeakTime,...
    violation_ind, spike_polarity, Dhighpass] = SpikeDetector_DT(D)
HighPassCut_drift = 70; %Hz, in order to remove drift and 60Hz noise
HighPassCut_spikes = 500; %Hz, in order to remove everything but spikes
SampleInterval = 1E-4;
ref_period = 1E-3; %s i.e = 2 ms
searchInterval = 5E-4; %s
%make parameter for direction detection, or try both if not too slow

ref_period_points = round(ref_period./SampleInterval);
searchInterval_points = round(searchInterval./SampleInterval);
%Transpose data if necessary
if (size(D,1)>size(D,2))
    D = D';
    dat_transpose = true;
else
    dat_transpose = false;
end
[Ntraces,L] = size(D);
try
D_noSpikes = BandPassFilter(D,HighPassCut_drift,HighPassCut_spikes,SampleInterval);
catch
   2; 
end
Dhighpass = HighPassFilter(D,HighPassCut_spikes,SampleInterval);

spt = cell(Ntraces,1);
spikeAmps = cell(Ntraces,1);
violation_ind = cell(Ntraces,1);
minSpikePeakInd = zeros(Ntraces,1);
maxNoisePeakTime = zeros(Ntraces,1);

for i=1:Ntraces
    %get the trace and noise_std
    trace = Dhighpass(i,:);
    trace(1:20) = D(i,1:20) - mean(D(i,1:20));
    
%     plot(trace);
%     pause;
    trace_noise = D_noSpikes(i,:);
    noise_std = std(trace_noise);
    
    %% DT-Get peaks with larger deflection (=decide to go with either positive or negative peaks)
    [peaks,peak_times, spike_polarity] = detectLargerPeaks( trace );
    %% DT-to be consistent with getRecounds, when positive peaks are larger, flip the sign of the trace
    if strcmp(spike_polarity, 'positive')
        trace = -trace;
        peaks = -peaks;
    end
        
%     %get peaks
%     [peaks,peak_times] = getPeaks(trace,-1); %-1 for negative peaks
%     peak_times = peak_times(peaks<0); %only negative deflections
%     peaks = trace(peak_times);    
    
    %basically another filtering step:
    %remove single sample peaks, don't know if this helps
    trace_res_even = trace(2:2:end);
    trace_res_odd = trace(1:2:end);
    [null,peak_times_res_even] = getPeaks(trace_res_even,-1);
    [null,peak_times_res_odd] = getPeaks(trace_res_odd,-1);
    peak_times_res_even = peak_times_res_even*2;
    peak_times_res_odd = 2*peak_times_res_odd-1;
    peak_times = intersect(peak_times,[peak_times_res_even,peak_times_res_odd]);
    peaks = trace(peak_times);
    
    %add a check for rebounds on the other side
    %DT- looks like calculating peak to peak amplitude by adding r to peaks
    %DT- note that this part of code assumes negative peaks are used for
    %detection
    r = getRebounds(peak_times,trace,searchInterval_points);
    peaks = abs(peaks);
    peakAmps = peaks+r;
    peakAmps = peakAmps(:);%DT--Change to column vector-for k-means clustering
    if ~isempty(peaks) && max(D(i,:)) > min(D(i,:)) %make sure we don't have bad/empty trace
        options = statset('MaxIter',10000);
        [Ind,centroid_amps] = kmeans(peakAmps,2,'start',[median(peakAmps);max(peakAmps)],'Options',options);
        
        %other clustering approaches that I dedcided not to use
        %[Ind,centroid_amps] = kmeans(sqrt(peakAmps),2,'start',sqrt([median(peakAmps);maxpeak]),'Options',options);        
        %obj = gmdistribution.fit(sqrt(peakAmps'),2,'Options',options);
        %Ind = cluster(obj,sqrt(peakAmps'));
       
        [m,m_ind] = max(centroid_amps);
        spike_ind_log = (Ind==m_ind);
        %spike_ind_log is logical, length of peaks
        
        %distribution separation check
        spike_peaks = peakAmps(spike_ind_log);
        nonspike_peaks = peakAmps(~spike_ind_log);
        nonspike_Ind = find(~spike_ind_log);
        spike_Ind = find(spike_ind_log);
        [m,sigma,m_ci,sigma_ci] = normfit(sqrt(nonspike_peaks));
        mistakes = find(sqrt(nonspike_peaks)>m+5*sigma);
                               
        
        %no spikes check - still not real happy with how sensitive this is
        if mean(sqrt(spike_peaks)) < mean(sqrt(nonspike_peaks)) + 4*sigma; %no spikes
            disp(['Epoch ' num2str(i) ': no spikes']);
            spt{i} = [];
            spikeAmps{i} = [];
            
        else %spikes found
            overlaps = length(find(spike_peaks < max(nonspike_peaks)));%this check will not do anything
            if overlaps > 0
                disp(['warning: ' num2str(overlaps) ' spikes amplitudes overlapping tail of noise distribution']);
            end
            %sp{i} = peak_times(spike_ind_log);
            t = (0:(length(trace)-1))*SampleInterval;
            spt{i} = t(peak_times(spike_ind_log));
            spikeAmps{i} = peakAmps(spike_ind_log)./noise_std;
            
            [minSpikePeak,minSpikePeakInd(i)] = min(spike_peaks);
            [maxNoisePeak,maxNoisePeakInd] = max(nonspike_peaks);
            maxNoisePeakTime(i) = peak_times(nonspike_Ind(maxNoisePeakInd));
            
            %check for violations again, just for warning this time
            %violation_ind{i} = find(diff(sp{i})<ref_period_points) + 1;
            violation_ind{i} = find(diff(spt{i})<ref_period) + 1;%spt is time in sec
            ref_violations = length(violation_ind{i});
            if ref_violations>0
                %find(diff(spt{i})<ref_period_points)
                disp(['warning, trial '  num2str(i) ': ' num2str(ref_violations) ' refractory violations']);
            end
        end %if spikes found
    end %end if not bad trace
end
if dat_transpose
    Dhighpass = Dhighpass';
end


