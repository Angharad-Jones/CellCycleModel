% Model of the cell cycle with two Transitions

classdef CellTwoCDK
    properties
        g
        pCDKs 
        pCDKm 
        Size
        CDKs = 0
        CDKm = 0
        ThresholdG1S
        ThresholdG2M
        CycleLength = 0
        G1Length = 0
        SG2MLength = 0
        Phase = 0
        DaughterSize1
        DaughterSize2
    end
    
    methods
        function obj = CellTwoCDK(g, pCDKs, pCDKm, Size, CDKs, CDKm, ThresholdG1S, ThresholdG2M, CycleLength, G1Length, SG2MLength, Phase, DaughterSize1, DaughterSize2)
            if(nargin > 0)
                obj.g = g;
                obj.pCDKs = pCDKs;
                obj.pCDKm = pCDKm;
                obj.Size = Size;
                obj.CDKs = CDKs;
                obj.CDKm = CDKm;
                obj.ThresholdG1S = ThresholdG1S;
                obj.ThresholdG2M = ThresholdG2M;
                obj.CycleLength = CycleLength;
                obj.G1Length = G1Length;
                obj.SG2MLength = SG2MLength;
                obj.Phase = Phase; % 0 = G1; 1=SG2; 2 = M; 3 = Divided - exclude from simulation
                obj.DaughterSize1 = DaughterSize1;
                obj.DaughterSize2 = DaughterSize2;
            
            end
        end
           
        function tissue = GrowthIteration(tissue, Steps, t, G1pDependency, G2pDependency, G1tDependency, G2tDependency, SizeRecord, LengthRecord, Ratios, RGRsDaughter1, RGRsDaughter2, pCDKs, pCDKm, ThresholdG1S, ThresholdG2M)
            for j = 1:Steps
                t = t + 1
                n = length(tissue);
                m = 0;
                ActiveCells = [];
                for i = 1:n
                  if tissue(i).Phase < 3;
                     m = m + 1;
                     ActiveCells(m) = i;
                     tissue(i).Size = tissue(i).Size + (tissue(i).Size * tissue(i).g * 1);  % Simulation is run at 1 hour intervals - to change this alter the value 1 accordingly
                     tissue(i).CDKs = tissue(i).CDKs + (pCDKs * (1 + tissue(i).Phase) * tissue(i).Size * G1pDependency * 1) + (pCDKs * (1 + tissue(i).Phase) * (1 - G1pDependency) * 1);  % Simulation is run at 1 hour intervals - to change this alter the value 1 accordingly
                     tissue(i).CDKm = tissue(i).CDKm + (pCDKm * (tissue(i).Phase) * tissue(i).Size * G2pDependency * 1) + (pCDKm * (tissue(i).Phase) * (1 - G2pDependency) * 1);
                     tissue(i).CycleLength = tissue(i).CycleLength + 1;
                     SizeRecord(t, m)= tissue(i).Size;
                     plot(t, tissue(i).Size)
                     if tissue(i).Phase == 0
                        tissue(i).G1Length = tissue(i).G1Length + 1;
                        if tissue(i).CDKs >= (tissue(i).ThresholdG1S * (1 - G1tDependency)) + (tissue(i).ThresholdG1S * (1/tissue(i).Size) * G1tDependency)
                           tissue(i).Phase = tissue(i).Phase + 1;
                        else
                        end
                    elseif tissue(i).Phase == 1
                        tissue(i).SG2MLength = tissue(i).SG2MLength + 1;
                        if tissue(i).CDKm >= (tissue(i).ThresholdG2M * (1 - G2tDependency)) + (tissue(i).ThresholdG2M * (1/tissue(i).Size) * G2tDependency)
                            tissue(i).Phase = tissue(i).Phase + 1;
                        else
                        end
                    elseif tissue(i).Phase == 2
                        tissue(i).SG2MLength = tissue(i).SG2MLength + 1;
                        tissue(i).DaughterSize1 = tissue(i).Size/Ratios(i);
                        tissue(i).DaughterSize2 = tissue(i).Size - tissue(i).DaughterSize1;
                        tissue(i).Phase = tissue(i).Phase + 1;
                        tissue(length(tissue) + 1) = CellTwoCDK(RGRsDaughter1(i), pCDKs, pCDKm, tissue(i).DaughterSize1, 0, 0, ThresholdG1S, ThresholdG2M, 0, 0, 0, 0, 0, 0); 
                        tissue(length(tissue) + 1) = CellTwoCDK(RGRsDaughter2(i), pCDKs, pCDKm, tissue(i).DaughterSize2, 0, 0, ThresholdG1S, ThresholdG2M, 0, 0, 0, 0, 0, 0);
                        LengthRecord(i,1) = tissue(i).G1Length;
                        LengthRecord(i,2) = tissue(i).SG2MLength;
                        LengthRecord(i,3) = tissue(i).CycleLength;
                     else
                     end 
                  end  
                end
                ActiveCells;
            while length(ActiveCells) > 100         % this value determines the number of cells in the simulation
                shortstraw = randi([1, length(ActiveCells)], 1, 1);
                id = ActiveCells(shortstraw);
                tissue(id).Phase = 4;
                ActiveCells(shortstraw) = [];
            end
            end
        % csvwrite('C:\.csv', SizeRecord)                 % to save data on cell size, enter a valid file path
        % csvwrite('C:\.csv', LengthRecord)   % to save data on cell cycle length, enter a valid file path here
        end
    end
end