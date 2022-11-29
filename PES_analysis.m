function [PES_ut, PES_ru, PES_tc, PES_rc, pe_acc, pc_acc] = PES_analysis(tab, cols)
% PES_analysis
%
% Inputs:
%   tab: [n-by-m table] Table consisting of the relevant information for
%       analysis of a single subject.
%   cols: [1-by-c cell array] List of the names of columns to use for analysis, 
%       these should be in the order of {'correct/incorrect column', 'response time',
%       'congruent/incongruent'}. If there is no congruent/incongruent, then omit
%       it and only input a [1-by-2] cell array.

% Outputs:
%   PES_ut: [float] Calculated value of uncorrected traditional PES
%   PES_ur: [float] Calculated value of uncorrected robust PES
%   PES_ct: [float] Calculated value of corrected traditional PES
%   PSE_cr: [float] Calculated value of corrected robust PES

%   pe_acc: [float] Accuracy of post-error events. In other words, the rate
%       of successfully getting a correct answer after giving an incorrect
%       answer directly before.
%   pc_acc: [float] Accuracy of post-correct events.


    % Create a new table from tab and the columns specified by cols
    new_tab = tab(:,cols);
    disp(size(new_tab));
    [m,n] = size(new_tab);
    
    post_errors=[];
    post_corrects=[];
    pre_errors=[];
    incon_post_error=[];
    con_post_error=[];
    incon_post_correct=[];
    con_post_correct=[];
    incon_pre_error=[];
    con_pre_error=[];

    %finding all RTs for trials fitting specific criteria
    for i=2:m-1
        %post-error
        if new_tab(i,1)==correct && new_tab(i-1,1)==incorrect && new_tab(i+1,1)==correct
            post_errors(1,end+1)=new_tab(i,2);
            %if con/incon included
            if n==3
                if new_tab(i,3)==incongruent
                    incon_post_error(1,end+1)=new_tab(i,2);
                elseif new_tab(i,3)==congruent
                    con_post_error(1,end+1)=new_tab(i,2);
                end
            end
        end
        %pre-error
        if new_tab(i,1)==correct && new_tab(i-1,1)==correct && new_tab(i+1,1)==incorrect
            pre_errors(1,end+1)=new_tab(i,2);
            %if con/incon included
            if n==3
                if new_tab(i,3)==incongruent
                    incon_pre_error(1,end+1)=new_tab(i,2);
                elseif new_tab(i,3)==congruent
                    con_pre_error(1,end+1)=new_tab(i,2);
                end
            end
        end
    end
    for j=2:m
        %post-correct
        if new_tab(i,1)==correct && new_tab(i-1,1)=correct
            post_corrects(1,end+1)=new_tab(i,2);
            %if con/incon included
            if n==3
                if new_tab(i,3)==incongruent
                    incon_post_correct(1,end+1)=new_tab(i,2);
                elseif new_tab(i,3)==congruent
                    con_post_correct(1,end+1)=new_tab(i,2);
                end
            end
        end
    end
    

    %uncorrected traditional (PES_ut)
    PES_ut=mean(post_errors)-mean(post_corrects);
    %uncorrected robust (PES_ru)
    PES_ru=mean(post_errors)-mean(pre_errors);

    %corrected traditional (PES_tc)
    if n==3
        PES_tc=(mean(incon_post_error)+mean(con_post_error))/2 - 
        (mean(incon_post_correct)+mean(con_post_correct))/2;
    else
        PES_tc=0;
    end

    %corrected robust (PES_rc)
    if n==3
        PES_rc=(mean(incon_post_error)+mean(con_post_error))/2 - 
        (mean(incon_pre_error)+mean(con_pre_error))/2;
    else
        PES_rc=0;
    end

    
    %pe_acc & pc_acc
    count_pe=0;
    count_pc=0;
    for i=1:m-1
        if new_tab(i,1)==incorrect && new_tab(i+1,1)==correct
            count_pe=count_pe+1;
        elseif new_tab(i,1)==correct && new_tab(i+1,1)==correct
            count_pc=count_pc+1;
        end
    end
    pe_acc=count_pe/m;
    pc_acc=count_pc/m;

end