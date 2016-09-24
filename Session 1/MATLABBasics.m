%% Codes for AUT-Multimedia 2016 Course
% Lecture 2: MATLAB Basics
% 
% Taught by: Nima Mahmoudi
% 
% This code is released under the GPLv3 license for non-commercial
% use only. For other types of license please contact me.
% 

%% Creating matrices
A = [1 2 3; 4 5 6; 7 8 9]
%% Special Matrices
disp('zeros:');
zeros(3,3)
disp('ones:');
ones(3,3)
disp('eye:');
eye(3,3)
disp('rand:');
rand(3,3)
disp('randn:');
randn(3,3)
%% Matrix size and some manipulations in MATLAB
size(A)
sum(A)
sum(A,2)
sum(sum(A))

%% Find in Matrices and indexing
A
% There are 2 kinds of indexing: single dimension and multiple dimension
A(:)

idx = find(A < 4)
% you can even use arrays to index multiple files
A(idx)

% or even booleans
cond = A < 4;
A(cond)

%% Simple Loops
disp('Running a simple for loop');
for i = 1:10
    % fprintf is great, it writes to command window, or even COM Ports,
    % text files, etc. check out fopen examples in MATLAB Help.
    if i > 3
        fprintf('running for %dth time\n', i);
    elseif i == 2
        fprintf('running for 2nd time\n');
    elseif i == 1
        fprintf('running for 1st time\n');
    end
    
    % pause(seconds) just pauses you script
    % use it wisely
    pause(1);        
end