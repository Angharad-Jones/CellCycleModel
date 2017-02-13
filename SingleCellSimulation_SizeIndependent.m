% One CDK Model - cell cycle progression Size Independent

% Initiate the recording arrays - SizeRecord, CDKRecords,BirthSizeRecord, 
% DivisionSizeRecord, CellCycleLengthRecord and PhaseRecord
SizeRecord = [];
CDKRecord = [];
BirthSizeRecord = [];
DivisionSizeRecord = [];
CellCycleLengthRecord = [];

% Input the starting values: Cell Size (size), Molecules CDK (CDK), 
% % Input the starting rates: RGR Cell (g), rate of 
% CDKs prodution (pCDK).
% Input the Thresholds: Threshold of CDKs for entry into S-Phase
% (SPhaseThreshold), Threshold of CDKm for entry into M-Phase
% (MitosisThreshold).
Size = 20
CDK = 0
g = 0.018
pCDK = 57.14
Threshold_division = 2200 

% Initialise Counters ; i as 2, j as 1 and CellCycleLength as 0
i = 2;
j = 1;
CellCycleLength = 0;


% Set the Phase as G1 (Where G1 = 0 and S-G2-M = 1)
Phase = 0;

% Set the initial number of cells
CellNo = 1;

% Enter two values (The starting values twice)into Records that will be 
% filled as i is counted up: BirthSizeRecord, DivisionSizeRecord,
% CellCycleLengthRecord.
% Enter one value (the starting values) into Records that will filled as j
% is counted up:  SizeRecord, CDKsRecord, CDKmRecord, PhaseRecord.
BirthSizeRecord(1) = 0;
BirthSizeRecord(2) = Size;
DivisionSizeRecord(1) = 0;
DivisionSizeRecord(2) = 0;
CellCycleLengthRecord(1) = 0;
CellCycleLengthRecord(2) = 0;
SizeRecord(1) = Size;
CDKRecord(1) = CDK;
PhaseRecord(1) = Phase;
G1LengthRecord(1) = 0;
G1LengthRecord(2) = 0;
G2SMLengthRecord(1) = 0;
G2SMLengthRecord(2) = 0;
TissueAreaRecord(1) = 0;
TissueAreaRecord(2) = 0;

% While BirthSizeRecord(i) =/= BirthSizeRecord(i-1) and there have been
% less than 25 divsion iterations -> go through a cell division
% iteration.

for i = 0:25
    i = i + 1;
    CellCycleLength = 0;
    
% S-Phase Growth Loop
% While cells are in G1 phase (Phase = 0) go through one iteration of growth and one
% iteration of CDK production. CDKm production is kept at 0 by multiplying 
% by Phase = 0  
    while Phase == 0;
         j = j + 1;
         Size = Size + ( Size * 1 );  % Model simulates 1 hour time intervals
         CDK = CDK + (Size * pCDK * 1);
         CellCycleLength = CellCycleLength + 1;
                  

% Enter the new value of Size and CDK into the SizeRecord and CDKRecords 
         SizeRecord(j) = Size;
         CDKRecord(j) = CDK;
         
% Check which phase of the cell cycle the cell is in and record it in
% PhaseRecord
        if CDK < Threshold_division;
            Phase = 0;          
        else if CDK >= Threshold_division;
                Phase = 1;
             end
        end
    end                 
      
    % Divide the cell. Calculate Birthsize as Size/2 and add to BirthSizeRecord
    Size = Size/2;
    BirthSize = Size;
    BirthSizeRecord(i) = BirthSize;
    CellNo = CellNo * 2;
    
    % Reset the CDK values and the Phase
    CDK = 0;
    Phase = 0;
    PhaseSpecificGrowth = 0;
    
    % Increase time increment by 1
    % Record Size, CDKs, CDKm, Phase, G2SM Length, CellCycleLength
    j = j + 1;
    SizeRecord(j)= Size;
    CDKRecord(j)= CDK;
        
    % end division loop
end


% Define time axis
t = length(SizeRecord);
tArray = 0:t-1;

% Plot Size against tArray
figure();
hold on;
plot (tArray,SizeRecord, 'r', 'LineWidth', 1.5)
xlabel('Time (hr)', 'FontSize', 12)
ylabel('Cell Are (um^2)', 'FontSize', 12)
hold off

% Plot CDK against tArray
figure();
hold on;
plot (tArray,CDKRecord, 'b', 'LineWidth', 1.5)
xlabel('Time Iterations (j)', 'FontSize', 12)
hold off


