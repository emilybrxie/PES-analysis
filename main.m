%Get Trial Level Data

datadir='./Complete_02-16-2019/Individual_Measures/'; %If file not found, switch all / to \

tasks={'attention_network_task','dot_pattern_expectancy','go_nogo','local_global_letter',...
    'threebytwo','simon','stop_signal','stroop','shape_matching',...
    'stim_selective_stop_signal','motor_selective_stop_signal','choice_reaction_time'};

TaskStore=cell(length(tasks),1); %Store Tasks tables here


for i=1:length(tasks)
    TaskStore{i,1}=readtable([datadir,char(tasks(i)),'.csv']);
end

%% Run PES analysis on task "stroop"

%Pick A Task
tasknum=8;
CurrentTask=TaskStore{tasknum,1};

% Get the total number of subjects
sub_list = unique(CurrentTask{:,'worker_id'});


% Remove all practice trials
prac_rows = strcmp(CurrentTask{:,'exp_stage'}, 'practice');
CurrentTask(prac_rows,:) = [];


% What columns to use in function
cols = {'correct', 'rt', 'condition'};

% Run PES calculation on each subject
for i = 1:length(sub_list)
    [PES_ut, PES_ru, PES_tc, PES_rc, pe_acc, pc_acc] = PES_analysis(CurrentTask(strcmp(CurrentTask{:,'worker_id'},sub_list{i}),:), cols);
end