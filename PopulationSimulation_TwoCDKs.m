% TWO TRANSITION MODEL OF THE CELL CYCLE

% Script to run a simulation using a population of 100 asynchronous cells
% Use with classdef CellTwoCDK
% Section 1 creates an asynchronous population of 100 cells
% Section 2 runs the test simulation in which parameters may be altered

%-------------------------------------------------------------------------------------%

clear all
clear classes

% 1. INITIATE A TISSUE CONSISTING OF 100 ASYNCHRONOUS CELLS
% We advise using the stated values to produce a well distributed
% population.

% Set the number of steps to be taken during the simulation
Steps = 500;

% Select the model type
G1pDependency = 1; % enter 1 for model with production of CDKs dependent on size, enter 0 for independent.
G2pDependency = 1; % enter 1 for model with production of CDKm depednent on size, enter 0 for independent.
G1tDependency = 0; % enter 1 for model with Threshold_G1S dependent on size
G2tDependency = 0; % enter 1 for model with Threshold_G2M dependent on size

% Set parameter values for simulation
meanRGR = 0.018;
sdRGR = 0.0018;
pCDKs = 2.8;
pCDKm = 4;
ThresholdG1S = 1600;
ThresholdG2M = 2200;
meanDiv = 2;
sdDiv = 0.2;
Size = 20;

% Select RGR for first cell from a distribution based on the mean and sd
% given above
RGR = normrnd(meanRGR, sdRGR)

% Prepare two arrays of RGR values from the distribution to be used to
% determine the RGR of new cells
RGRsDaughter1 = [zeros, 10000];
for i = 1:10000
    RGRsDaughter1(i) = normrnd(meanRGR, sdRGR);
end

RGRsDaughter2 = [zeros, 10000];
for j = 1:10000
    RGRsDaughter2(j) = normrnd(meanRGR, sdRGR);
end

% Prepare an array of division ratios based on the input values
Ratios = [zeros, 10000];
for k = 1:10000
    Ratios(k) = normrnd(meanDiv, sdDiv);
end

% Initialize an array of empty CellTwoCDK objects
tissue = CellTwoCDK.empty(0, 10000);
% Fill properties of first cell
tissue(1) =  CellTwoCDK(RGR,pCDKs,pCDKm, Size, 0, 0, ThresholdG1S, ThresholdG2M,0,0,0,0,0,0);
 
% Initialize a cell array to record cell size in
SizeRecord = zeros(400, 5000);

% Initialize a cell array to record cell cycle and phase length
LengthRecord = zeros(10000, 3);

% Prepare the axes
figure();
hold on;

% Set time to 0
t = 0;

% Start simulation
tissue = GrowthIteration(tissue, Steps, t, G1pDependency, G2pDependency, G1tDependency, G2tDependency, SizeRecord, LengthRecord, Ratios, RGRsDaughter1, RGRsDaughter2, pCDKs, pCDKm, ThresholdG1S, ThresholdG2M);
title('Generation of asynchronous population')
xlabel('Time (hr)')
ylabel('Cell Area (um^2)')
hold off;

%--------------------------------------------------------------%

% 2. RUNNING THE TEST SIMULATION

% Set the conditions for the test simulation

% Set the number of steps to be taken during the simulation
Steps = 1000;

% Select the model type
G1pDependency = 1; % enter 1 for model with production of CDKs dependent on size, enter 0 for independent.
G2pDependency = 1; % enter 1 for model with production of CDKm dependent on size, enter 0 for independent.
G1tDependency = 0; % enter 1 for model with S Phase Threshold dependent on size
G2tDependency = 0; % enter 1 for model with M Phase Threshold dependent on size

% Set parameter values for simulation
meanRGR = 0.018;
sdRGR = 0.0018;
pCDKs = 2.8;
pCDKm = 4;
ThresholdG1S = 1600;
ThresholdG2M = 2200;
meanDiv = 2;
sdDiv = 0.2;
Size = 20;

% Select RGR for first cell from a distribution based on the mean and sd
% given above
RGR = normrnd(meanRGR, sdRGR)

% Prepare two arrays of RGR values from the distribution to be used to
% determine the RGR of new cells
RGRsDaughter1 = [zeros, 10000];
for i = 1:10000
    RGRsDaughter1(i) = normrnd(meanRGR, sdRGR);
end

RGRsDaughter2 = [zeros, 10000];
for j = 1:10000
    RGRsDaughter2(j) = normrnd(meanRGR, sdRGR);
end

% Prepare an array of division ratios based on the input values
Ratios = [zeros, 10000];
for k = 1:10000
    Ratios(k) = normrnd(meanDiv, sdDiv);
end

% Initialize a cell array to record cell size in
SizeRecord = zeros(400, 5000);

% Initialize a cell array to record cell cycle and phase length
LengthRecord = zeros(10000, 3);

% Prepare the axes
figure();
hold on;

% Set time to 0
t = 0;

% Start simulation
tissue = GrowthIteration(tissue, Steps, t, G1pDependency, G2pDependency, G1tDependency, G2tDependency, SizeRecord, LengthRecord, Ratios, RGRsDaughter1, RGRsDaughter2, pCDKs, pCDKm, ThresholdG1S, ThresholdG2M);
title('Model Population Simulation')   
xlabel('Time (hr)')
ylabel('Ceall Area (um^2)')
hold off