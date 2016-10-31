%% Live Motion Detection Using Optical Flow
%
% This example shows how to create a video algorithm to detect motion using 
% optical flow technique.This example uses the Image Acquisition Toolbox(TM) System Object 
% along with Computer Vision System Toolbox(TM) System objects. 
%
% Copyright 2010-2012 The MathWorks, Inc.

%% Introduction
% This example streams images from an image acquisition device to detect motion 
% in the live video. It uses the optical flow estimation technique to
% estimate the motion vectors in each frame of the live video sequence.
% Once the motion vectors are determined, we draw it over the moving
% objects in the video sequence.

%% Initialization
% Create the Video Device System object.
cam = webcam(1)
cam.Resolution = '640x480';

% get an image for its width and heigh
im = snapshot(cam);
%% 
% Create a System object to estimate direction and speed of object motion
% from one video frame to another using optical flow.
optical = vision.OpticalFlow( ...
    'OutputValue', 'Horizontal and vertical components in complex form');

%% 
% Initialize the vector field lines.
maxWidth = size(im, 2);
maxHeight = size(im, 1);
shapes = vision.ShapeInserter;
shapes.Shape = 'Lines';
shapes.BorderColor = 'white';
r = 1:5:maxHeight;
c = 1:5:maxWidth;
[Y, X] = meshgrid(c,r);

%%
% Create VideoPlayer System objects to display the videos.
hVideoIn = vision.VideoPlayer;
hVideoIn.Name  = 'Original Video';
hVideoOut = vision.VideoPlayer;
hVideoOut.Name  = 'Motion Detected Video';

%% Stream Acquisition and Processing Loop
% Create a processing loop to perform motion detection in the input
% video. This loop uses the System objects you instantiated above.

% Set up for stream
nFrames = 0;
while (nFrames<100)     % Process for the first 100 frames.
    % Acquire single frame from imaging device.
    rgbData = im2double(snapshot(cam));
    
    % Compute the optical flow for that particular frame.
    tic;
    optFlow = step(optical,rgb2gray(rgbData));
    toc
    
    totalFlow = mean(mean(optFlow, 1), 2) * 10000;
    fprintf('%4.2f, %4.2f\n', real(totalFlow), imag(totalFlow));
    
    % Downsample optical flow field.
    optFlow_DS = optFlow(r, c);
    H = imag(optFlow_DS)*50;
    V = real(optFlow_DS)*50;
    
    % Draw lines on top of image
    lines = [Y(:)'; X(:)'; Y(:)'+V(:)'; X(:)'+H(:)'];
    rgb_Out = step(shapes, rgbData,  lines');
    
    % Send image data to video player
    % Display original video.
    step(hVideoIn, rgbData);
    % Display video along with motion vectors.
    step(hVideoOut, rgb_Out);

    % Increment frame count
    nFrames = nFrames + 1;
end

%% Summary
% In the Motion Detected Video window, you can see that the example detected the 
% motion of the notebook. The moving objects are represented using the
% vector field lines as seen in the video player. 

%% Release
% Here you call the release method on the System objects to close any open 
% files and devices.
clear cam;
release(hVideoIn);
release(hVideoOut);
