%% Codes for AUT-Multimedia 2016 Course
% Lecture 5: Introduction to ASR
% 
% Taught by: Nima Mahmoudi -- nima_mahmoudi@aut.ac.ir
% 
% This code is released under the GPLv3 license for non-commercial
% use only. For other types of license please contact me.
%
% Fall 2016

%% Add paths for RastaMat
addpaths

%% Read and Play an Audio File
file_name = 'FAK_1B.08.wav';
[y, Fs] = audioread(file_name);

time = 1:length(y);
time = time / Fs;

player = audioplayer(y,Fs);
play(player);

figure(1);
plot(time, y);
title('Audio Signal');

pause(3);

close(1)

%% Perform Feature Extraction

% check http://www.ee.columbia.edu/ln/rosa/matlab/rastamat/ for more info
y_feats =  FE(y,Fs);

% see the difference in number of elements we need to remember
% BTW, numel is very useful, it shows you the NUMber of ELements, hence the
% name NUMEL
fprintf('y had %d elements but y_feats only has %d\n', numel(y), numel(y_feats));
fprintf('Reduction Ratio: %4.2f\n', numel(y) / numel(y_feats));

%% Display Results

% imagesc is just great for this kinds of stuff
figure(1);
imagesc(y_feats);
title('MFCC coefficients');
axis xy;
colorbar;

% Get Coefficients from 1 window
x = y_feats(:, 1);
figure(2);
plot(x);

%% GMM on 2-D data
% In this sections we will fit a GMM to a 2-D data, keep in mind that what
% I want from you in your homeworks is to fit a GMM on 13-D data extracted
% from MFCC coeffs. 2-D is just great for demonstration.
mu1 = [1 2];
Sigma1 = [2 0; 0 0.5];
mu2 = [-3 -5];
Sigma2 = [1 0;0 1];
rng(1); % For reproducibility
X = [mvnrnd(mu1,Sigma1,1000);mvnrnd(mu2,Sigma2,1000)];

GMModel = fitgmdist(X,2);

figure
y = [zeros(1000,1);ones(1000,1)];
h = gscatter(X(:,1),X(:,2),y);
hold on
ezcontour(@(x1,x2)pdf(GMModel,[x1 x2]),get(gca,{'XLim','YLim'}))
title('Scatter Plot and Fitted Gaussian Mixture Contours')
legend(h,'Model 0','Model1')
hold off

