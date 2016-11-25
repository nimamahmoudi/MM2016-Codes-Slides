%% Codes for AUT-Multimedia 2016 Course
% Lecture 5: Introduction to ASR
% 
% Taught by: Nima Mahmoudi -- nima_mahmoudi@aut.ac.ir
% 
% This code is released under the GPLv3 license for non-commercial
% use only. For other types of license please contact me.
%
% Fall 2016
clear all, clc, close all;
rng(1);
%% Add paths for RastaMat
addpaths

%% Read Datasets
dataset_dir_yes = 'Dataset_Train_Final/Yes/';
dataset_dir_no = 'Dataset_Train_Final/No/';

yes_files_dir = dir([dataset_dir_yes '*.wav']);
no_files_dir = dir([dataset_dir_no '*.wav']);

yes_files_list = {yes_files_dir.name};
no_files_list = {no_files_dir.name};

%% Perform Feature Extraction for yes files
all_yes_feats = [];
% for all files
for i = 1:round(length(yes_files_list) / 2)
    file_name = [dataset_dir_yes yes_files_list{i}];
    [y, Fs] = audioread(file_name);
    % read sterio signals like mono
    y = y(:,1);
    
    y_feats =  FE(y,Fs);
    y_feats = y_feats';
    
    all_yes_feats = [all_yes_feats; y_feats];
end

%% Perform Feature Extraction for no files
all_no_feats = [];
% for all files
for i = 1:round(length(no_files_list) / 2)
    file_name = [dataset_dir_no no_files_list{i}];
    [y, Fs] = audioread(file_name);
    % read sterio signals like mono
    y = y(:,1);
    
    y_feats =  FE(y,Fs);
    y_feats = y_feats';
    
    all_no_feats = [all_no_feats; y_feats];
end

%% Fit GMM Models
options = statset('MaxIter',1000, 'Display','final');

yes_feats = all_yes_feats(1:1:end, :);
no_feats = all_no_feats(1:1:end, :);

regularization = .05;

GMModelYes = fitgmdist(yes_feats, 30, 'options', options, 'CovarianceType', 'full', 'RegularizationValue', regularization);
GMModelNo = fitgmdist(no_feats, 30, 'options', options, 'CovarianceType', 'full', 'RegularizationValue', regularization);

all_feats = [all_yes_feats; all_no_feats];
threshold = 10;
%% Test GMM Models
% yes_norm = pdf(GMModelYes, all_feats);
% no_norm = pdf(GMModelNo, all_feats);
% 
% yes_norm = mean(yes_norm(yes_norm < threshold));
% no_norm = mean(no_norm(no_norm < threshold));
% yes_norm
% no_norm
%%
mistake_files = [];

predictions = zeros(1, length(no_files_list));
% for all files
for i = round(length(yes_files_list) / 2):length(yes_files_list)
    file_name = [dataset_dir_yes yes_files_list{i}];
    [y, Fs] = audioread(file_name);
    % read sterio signals like mono
    y = y(:,1);
    
    y_feats =  FE(y,Fs);
    y_feats = y_feats';
    
    no_probs = pdf(GMModelNo, y_feats);
    yes_probs = pdf(GMModelYes, y_feats);
    
    no_prob = mean(log(no_probs(no_probs < threshold)));
    yes_prob = mean(log(yes_probs(yes_probs < threshold)));

    if yes_prob > no_prob
        predictions(i) = 1;
    else
        mistake_files{end+1} = file_name;
        predictions(i) = 2;
        
%         player = audioplayer(y,Fs);
%         playblocking(player);
    end
end

num_true_yes = sum(predictions == 1);
num_false_yes = sum(predictions == 2);

fprintf('Yes: True: %d, False: %d, accuracy:%4.2f\n', num_true_yes, num_false_yes, (num_true_yes / (num_true_yes + num_false_yes)));

predictions = zeros(1, length(no_files_list));
% for all files
for i = round(length(no_files_list) / 2):length(no_files_list)
    file_name = [dataset_dir_no no_files_list{i}];
    [y, Fs] = audioread(file_name);
    % read sterio signals like mono
    y = y(:,1);
    
    y_feats =  FE(y,Fs);
    y_feats = y_feats';
    
    no_probs = pdf(GMModelNo, y_feats);
    yes_probs = pdf(GMModelYes, y_feats);
    
    no_prob = mean(log(no_probs(no_probs < threshold)));
    yes_prob = mean(log(yes_probs(yes_probs < threshold)));
    
    if yes_prob > no_prob
        mistake_files{end+1} = file_name;
        predictions(i) = 1;
%         player = audioplayer(y,Fs);
%         playblocking(player);
    else
        predictions(i) = 2;
    end
end
num_true_no = sum(predictions == 2);
num_false_no = sum(predictions == 1);

fprintf('No: True: %d, False: %d, accuracy:%4.2f\n', num_true_no, num_false_no, (num_true_no / (num_true_no + num_false_no)));

num_true = num_true_yes + num_true_no;
num_false = num_false_no + num_false_yes;

disp('========================');
fprintf('Total: True: %d, False: %d, accuracy:%4.2f\n', num_true, num_false, (num_true / (num_true + num_false)));

disp('List of mistakes are available in mistake_files variable');