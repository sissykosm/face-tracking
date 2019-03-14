addpath(genpath('GreekSignLanguage'));

%% Part 1 - Skin Detection

load('skinSamplesRGB.mat');                                          %load the skin samples
I_train = im2double(skinSamplesRGB);                                 %normalization of the RGB image
I_train = rgb2ycbcr(I_train);

cb_train = I_train(:,:,2).';
cr_train = I_train(:,:,3).';
c_train = [cb_train(:) cr_train(:)];
mu = mean(c_train);
covariance = cov(cb_train,cr_train);

I1 = imread('1.png');
I1 = im2double(I1); 
boundingBox1 = fd(I1,mu,covariance);

%% Part 2 - Face Detection

%% 2.1 - Lucas-Kanade implementation

%% 2.2 - Calculate the face translation using the optical flow field
rho = 3;                                                            
epsilon = .1;                         
M = 15;
type = 0;
figure(6);
total_displ(boundingBox1,rho,epsilon,M,type);

%run LK for the alternative criterion for loops
M = 0;
type = 0;
figure(7);
total_displ(boundingBox1,rho,epsilon,M,type);

%run LK for the alternative criterion for Energy
M = 15;
type = 1;
figure(8);
total_displ(boundingBox1,rho,epsilon,M,type);

%% 2.3 - Multi-scale Optical Flow Estimation
N = 4;
rho = 5;                                                             
epsilon = .05;                                                       
M = 5;
type = 0;
figure(9);
multiscale_total_displ(boundingBox1,N,rho,epsilon,M,type);