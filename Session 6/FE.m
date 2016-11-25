%% Homework 3 for Robust Speech Processing (RSP) course
% 
% Taught by: Dr. Ahadi
% 
% Written by: Nima Mahmoudi, Std. No. 93123144
% 
% Semester: Spring 2015


function [mm] =  FE(y,Fs,method)
%FE Feature Extracts the signal y using the method specified
if nargin<3
    method = 2;
end

mm = [];

if ~isempty(y)
    [mm,~] = melfcc(y, Fs, 'maxfreq', Fs/2, 'numcep', 13 ...
        , 'nbands', 13, 'fbtype', 'fcmel', 'dcttype', 1, ... 
        'usecmp', 1, 'wintime', 0.025, 'hoptime', 0.010, ... 
        'preemph', 0, 'dither', 1);
    if method==2
        % Performing CMVN
        
    end
    if method == 3
        % Add derivative of signal
        
    end
end

% mm = mm(1:2,:);
end