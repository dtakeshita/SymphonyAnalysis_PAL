% [s,{s_bf,s_af}]=pick_str(s,s1,s2,{opt_st, opt_ed,st_ind,ed_ind})
% from s, pick a part of the string
% between s1 and s2
% If opt_st (opt_ed) =1, s1 (s2) is not included in the output
% In case that there are more than one place of s1 (s2), st_ind (ed_ind)
% specifies the place to be chosen.
% Example: 
% s='a3_a2_b3_c5_f7_f8';
% [a,b,c]=pick_str(s,'a','_f',0,0)
% returns: a = a3_a2_b3_c5_, b =  Empty string:1-by-0, c = f7_f8
% [a,b,c]=pick_str(s,'a','_f',0,0,2,1)
% returns: a = 'a2_b3_c5_f', b = 'a3_', c = '7_f8'
% [a,b,c]=pick_str(s,'a','_f',0,0,2,2)
% returns: a = 'a2_b3_c5_f7_f', b ='a3_', c = '8'

function [s_out, varargout]=pick_str(s,s1,s2,varargin)
    if nargin>=4
        opt_st=varargin{1};
    else
        opt_st=0;
    end
    if nargin>=5
        opt_ed=varargin{2};
    else
        opt_ed=0;
    end
    if nargin>=6
        st_ind=varargin{3};
    else
        st_ind=1;
    end
    if nargin>=7
        ed_ind=varargin{4};
    else
        ed_ind=1;
    end
    if ~iscell(s)
        [s_out, s_fr, s_ed] = pickup_str(s,s1,s2,opt_st,opt_ed,st_ind,ed_ind);
    else
        [s_out, s_fr, s_ed] = cellfun(@(x)pick_str(x,s1,s2,opt_st,opt_ed,st_ind,ed_ind),...
            s,'uniformoutput',false);
    end
    varargout{1} = s_fr;
    varargout{2} = s_ed;
end

function [s_out, varargout] = pickup_str(s,s1,s2,opt_st,opt_ed,st_ind,ed_ind)
    ind1=strfind(s,s1);
    ind2=strfind(s,s2);
    if length(ind1)>=2
    %     ind1=ind1(end);%Changed on Nov 06, 2009
        if st_ind > length(ind1)
            st_ind = length(ind1);
        end
        ind1=ind1(st_ind);
    end
    if length(ind2)>=2
    %    ind2=ind2(min(find(ind2>ind1)));%Changed on Nov 06, 2009
        ind2=ind2(find(ind2>ind1));
        if ed_ind > length(ind2)
            ed_ind = length(ind2);
        end
        ind2=ind2(ed_ind);
    end
    if opt_st
        ind1=ind1+length(s1);
    end
    if opt_ed
        ind2=ind2-1;
    else
        ind2=ind2+length(s2)-1;
    end
    s_out=s(ind1:ind2);
    s_fr=s(1:ind1-1);
    s_ed=s(ind2+1:end);
    varargout{1}=s_fr;
    varargout{2}=s_ed;
end