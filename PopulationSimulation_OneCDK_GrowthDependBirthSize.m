% ONE TRANSITION MODEL OF THE CELL CYCLE WITH RGR DEPENDENT ON CELL SIZE

% Script to run a simulation using a population of 100 asynchronous cells
% Use with classdef CellOneCDK_GrowthDependBirthSize
% Section 1 creates an asynchronous population of 100 cells
% Section 2 runs the test simulation in which parameters may be altered

%--------------------------------------------------------------%
clear all
clear classes

% 1. INITIATE A TISSUE CONSISTING OF 100 ASYNCHRONOUS CELLS
% We advise using the stated values to produce a well distributed
% population.

% Set the number of steps to be taken during the simulation
Steps = 500;
% Select the model type
pDependency = 1; % enter 1 for model with production of CDK dependent on size, enter 0 for production of CDK independent of Size.
tDependency = 0; % enter 1 for model with CDK Threshold dependent on 1/size, enter 0 for CDK threshold independent of Size.
% Set parameter values for simulation
pCDK = 3.4;
Threshold_D = 2200;
meanDiv = 2;
sdDiv = 0.2;
Size = 20;

% Prepare an array of division ratios based on the input values
Ratios = [zeros, 10000];
for k = 1:10000
    Ratios(k) = normrnd(meanDiv, sdDiv);
end

% Prepare an array of variation values for daughter 1
Daughter1RGRvar = [zeros, 10000];
for i = 1:10000
    Daughter1RGRvar(i) = normrnd(0, 0.0018);
end

% Prepare an array of variation values for daughter 2
Daughter2RGRvar = [zeros, 10000];
for i = 1:10000
    Daughter2RGRvar(i) = normrnd(0, 0.0018);
end

% Initialize an array of empty CellOneCDK_GrowthDependBirthSize objects
tissue = CellOneCDK_GrowthDependBirthSize.empty(0, 10000);
% Fill properties of first cell
tissue(1) =  CellOneCDK_GrowthDependBirthSize(0,pCDK,Size, 0, Threshold_D,0,0,Size,0,0);
% Initialize an array to record cell size in
SizeRecord = zeros(400, 5000);
% Initialize an array to record cell cycle and phase length
LengthRecord = zeros(10000, 3);
% Initialize an array to record birth size and cycle length of individual
% cells
SizeLengthRecord = zeros(10000, 2);
% Prepare the axes
figure();
hold on;
% Set time to 0
t = 0;
% Start simulation
tissue = GrowthIteration(tissue, Steps, t, pDependency, tDependency, SizeRecord, LengthRecord, SizeLengthRecord, Ratios, pCDK, Threshold_D, Daughter1RGRvar, Daughter2RGRvar);
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
pDependency = 1; % enter 1 for model with production of CDKs dependent on Size, enter for 0 production of CDK independent of Size.
tDependency = 0; % enter 1 for model with Division Threshold dependent on 1/Size, enter 0 for Division Threshold independent of Size.


% Set parameter values for simulation
pCDK = 3.4;           % Enter a value for the rate of production of CDK activity
Threshold_D = 2200;  % Enter a value for the CDK activity threshold for division
meanDiv = 2;        % Mean division ratio should be fixed at 2
sdDiv = 0.2;        % Enter a value for the standard deviation of division ratio

% Prepare an array of division ratios based on the input values
Ratios = [zeros, 10000];
for k = 1:10000
    Ratios(k) = normrnd(meanDiv, sdDiv);
end

% Prepare an array of variation values for daughter 1
Daughter1RGRvar = [zeros, 10000];
for i = 1:10000
    Daughter1RGRvar(i) = normrnd(0, 0.0018);
end

% Prepare an array of variation values for daughter 2
Daughter2RGRvar = [zeros, 10000];
for i = 1:10000
    Daughter2RGRvar(i) = normrnd(0, 0.0018);
end

% Initialize a cell array to record cell size in
SizeRecord = zeros(400, 5000);

% Initialize a cell array to record cell cycle and phase length
LengthRecord = zeros(10000, 3);

% Initialize a cella array to record birth size and division size of
% individual cells
SizeLengthRecord = zeros(10000, 2);

% Prepare the axes
figure();
hold on;

% Set time to 0
t = 0;

% Start simulation
tissue = GrowthIteration(tissue, Steps, t, pDependency, tDependency, SizeRecord, LengthRecord, SizeLengthRecord, Ratios, pCDK, Threshold_D, Daughter1RGRvar, Daughter2RGRvar);
title('Model simulation')  
xlabel('Time (hr)')
ylabel('Cell Area (um^2)')
hold off

